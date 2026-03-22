package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/government")
public class GovernmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"government".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String startupIdStr = request.getParameter("startupId");
        String schemeName = request.getParameter("schemeName");
        String grantAmountStr = request.getParameter("grantAmount");

        int startupId;
        try {
            startupId = Integer.parseInt(startupIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/government/dashboard.jsp");
            return;
        }

        String approvalStatus = "approve".equals(action) ? "approved" : "rejected";
        double grantAmount = 0;
        try {
            grantAmount = Double.parseDouble(grantAmountStr);
        } catch (Exception e) {
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Check if entry exists
            PreparedStatement check = conn.prepareStatement("SELECT id FROM government_status WHERE startup_id = ?");
            check.setInt(1, startupId);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                // Update existing
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE government_status SET approval_status = ?, scheme_name = ?, grant_amount = ? WHERE startup_id = ?");
                ps.setString(1, approvalStatus);
                ps.setString(2, schemeName);
                ps.setDouble(3, grantAmount);
                ps.setInt(4, startupId);
                ps.executeUpdate();
            } else {
                // Insert new
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO government_status (startup_id, approval_status, scheme_name, grant_amount) VALUES (?, ?, ?, ?)");
                ps.setInt(1, startupId);
                ps.setString(2, approvalStatus);
                ps.setString(3, schemeName);
                ps.setDouble(4, grantAmount);
                ps.executeUpdate();
            }

            response.sendRedirect(request.getContextPath() + "/government/dashboard.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/government/dashboard.jsp?error=true");
        }
    }
}
