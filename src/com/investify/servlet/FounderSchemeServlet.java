package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/founder/apply_scheme")
public class FounderSchemeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!"founder".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access+denied");
            return;
        }

        String schemeIdStr = request.getParameter("schemeId");
        String startupIdStr = request.getParameter("startupId");

        if (schemeIdStr == null || startupIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/founder/schemes.jsp?error=Missing+parameters");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int schemeId = Integer.parseInt(schemeIdStr);
            int startupId = Integer.parseInt(startupIdStr);

            // Check if already applied
            String checkSql = "SELECT id FROM scheme_applications WHERE scheme_id = ? AND startup_id = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, schemeId);
            checkPs.setInt(2, startupId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                 response.sendRedirect(request.getContextPath() + "/founder/schemes.jsp?error=Already+applied");
                 return;
            }

            // Insert new application
            String sql = "INSERT INTO scheme_applications (scheme_id, startup_id, status) VALUES (?, ?, 'pending')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, schemeId);
            ps.setInt(2, startupId);
            ps.executeUpdate();

            System.out.println("FOUNDERSCHEME SERVLET: Applied to scheme id=" + schemeId + " for startup id=" + startupId);
            response.sendRedirect(request.getContextPath() + "/founder/schemes.jsp?success=applied");

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/founder/schemes.jsp?error=Database+error");
        }
    }
}
