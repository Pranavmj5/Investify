package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/invest")
public class InvestmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int investorId = (int) session.getAttribute("user_id");
        String startupIdStr = request.getParameter("startupId");
        String amountStr = request.getParameter("amount");
        String message = request.getParameter("message");

        int startupId;
        double amount;
        try {
            startupId = Integer.parseInt(startupIdStr);
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("investor/browse_startups.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO investment_request (startup_id, investor_id, amount, message, status) VALUES (?, ?, ?, ?, 'pending')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, startupId);
            ps.setInt(2, investorId);
            ps.setDouble(3, amount);
            ps.setString(4, message);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/investor/portfolio");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("investor/browse_startups.jsp?error=investment_failed");
        }
    }
}
