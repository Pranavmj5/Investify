package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/admin/startups")
public class AdminStartupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Verify admin role
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        String idStr = request.getParameter("id");
        String action = request.getParameter("action");

        if (idStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/verification.jsp");
            return;
        }

        int startupId;
        try {
            startupId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/verification.jsp");
            return;
        }

        String newStatus;
        if ("approve".equals(action)) {
            newStatus = "approved";
        } else if ("reject".equals(action)) {
            newStatus = "rejected";
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/verification.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                    "UPDATE startup SET status = ? WHERE id = ?");
            ps.setString(1, newStatus);
            ps.setInt(2, startupId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/verification.jsp");
    }
}
