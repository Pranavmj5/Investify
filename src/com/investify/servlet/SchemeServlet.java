package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/government/schemes")
public class SchemeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!"government".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access+denied");
            return;
        }

        int userId = (int) session.getAttribute("user_id");
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("create_scheme".equals(action)) {
                String name = request.getParameter("schemeName");
                String sector = request.getParameter("targetSector");
                String budgetStr = request.getParameter("budget");
                String description = request.getParameter("description");
                String openDate = request.getParameter("openDate");
                String closeDate = request.getParameter("closeDate");

                double budget = 0;
                try {
                    budget = Double.parseDouble(budgetStr);
                } catch (Exception e) {
                }

                String sql = "INSERT INTO schemes (name, target_sector, budget, description, status, open_date, close_date, created_by) VALUES (?, ?, ?, ?, 'draft', ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, sector != null ? sector : "All Sectors");
                ps.setDouble(3, budget);
                ps.setString(4, description);
                if (openDate != null && !openDate.isEmpty()) {
                    ps.setDate(5, Date.valueOf(openDate));
                } else {
                    ps.setNull(5, Types.DATE);
                }
                if (closeDate != null && !closeDate.isEmpty()) {
                    ps.setDate(6, Date.valueOf(closeDate));
                } else {
                    ps.setNull(6, Types.DATE);
                }
                ps.setInt(7, userId);
                ps.executeUpdate();

                System.out.println("SCHEME SERVLET: Created new scheme: " + name);
                response.sendRedirect(request.getContextPath() + "/government/schemes.jsp?success=created");

            } else if ("update_scheme".equals(action)) {
                String idStr = request.getParameter("schemeId");
                String name = request.getParameter("schemeName");
                String description = request.getParameter("description");
                String budgetStr = request.getParameter("budget");
                String status = request.getParameter("status");

                int id = Integer.parseInt(idStr);
                double budget = 0;
                try {
                    budget = Double.parseDouble(budgetStr);
                } catch (Exception e) {
                }

                String sql = "UPDATE schemes SET name=?, description=?, budget=?, status=? WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, description);
                ps.setDouble(3, budget);
                ps.setString(4, status != null ? status.toLowerCase() : "draft");
                ps.setInt(5, id);
                ps.executeUpdate();

                System.out.println("SCHEME SERVLET: Updated scheme id=" + id);
                response.sendRedirect(request.getContextPath() + "/government/schemes.jsp?success=updated");

            } else if ("delete_scheme".equals(action)) {
                String idStr = request.getParameter("schemeId");
                int id = Integer.parseInt(idStr);

                String sql = "DELETE FROM schemes WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();

                System.out.println("SCHEME SERVLET: Deleted scheme id=" + id);
                response.sendRedirect(request.getContextPath() + "/government/schemes.jsp?success=deleted");
            } else if ("update_application_status".equals(action)) {
                String appIdStr = request.getParameter("applicationId");
                String status = request.getParameter("status");
                
                int appId = Integer.parseInt(appIdStr);
                
                String sql = "UPDATE scheme_applications SET status = ? WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, status);
                ps.setInt(2, appId);
                ps.executeUpdate();
                
                System.out.println("SCHEME SERVLET: Updated application id=" + appId + " to " + status);
                String schemeIdFilter = request.getParameter("schemeIdFilter");
                String redirectUrl = request.getContextPath() + "/government/applications.jsp?success=updated";
                if (schemeIdFilter != null && !schemeIdFilter.trim().isEmpty()) {
                    redirectUrl += "&schemeId=" + schemeIdFilter;
                }
                response.sendRedirect(redirectUrl);
                
            } else {
                response.sendRedirect(request.getContextPath() + "/government/schemes.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/government/schemes.jsp?error=Database+error");
        }
    }
}
