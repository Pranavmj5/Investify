package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT id, name, email, role FROM users WHERE email = ? AND password = ? AND role = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("user_id", rs.getInt("id"));
                session.setAttribute("user_name", rs.getString("name"));
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("role", rs.getString("role"));

                String redirectUrl;
                switch (role) {
                    case "founder":
                        redirectUrl = "founder/dashboard.jsp";
                        break;
                    case "investor":
                        redirectUrl = "investor/dashboard.jsp";
                        break;
                    case "government":
                        redirectUrl = "government/dashboard.jsp";
                        break;
                    case "admin":
                        redirectUrl = "admin/dashboard.jsp";
                        break;
                    default:
                        redirectUrl = "login.jsp";
                }
                response.sendRedirect(redirectUrl);
            } else {
                request.setAttribute("error", "Invalid email, password, or role. Please try again.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error. Please try again later.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
