package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/investor/portfolio")
public class PortfolioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int investorId = (int) session.getAttribute("user_id");

        double totalInvested = 0;
        int activeDeals = 0;
        int pendingInterest = 0;
        
        List<Map<String, Object>> investments = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            
            // 1. Fetch pending requests count
            String pendingSql = "SELECT COUNT(*) FROM investment_request WHERE investor_id = ? AND status = 'pending'";
            try (PreparedStatement psPending = conn.prepareStatement(pendingSql)) {
                psPending.setInt(1, investorId);
                ResultSet rs = psPending.executeQuery();
                if (rs.next()) {
                    pendingInterest = rs.getInt(1);
                }
            }

            // 2. Fetch accepted investments and calculate totals
            String sql = "SELECT ir.id, ir.amount, ir.status, ir.created_at, " +
                         "s.title, s.stage, s.domain " +
                         "FROM investment_request ir " +
                         "JOIN startup s ON ir.startup_id = s.id " +
                         "WHERE ir.investor_id = ? AND ir.status = 'accepted' " +
                         "ORDER BY ir.created_at DESC";
                         
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, investorId);
                ResultSet rs = ps.executeQuery();
                
                while (rs.next()) {
                    Map<String, Object> inv = new HashMap<>();
                    double amount = rs.getDouble("amount");
                    inv.put("amount", amount);
                    inv.put("status", rs.getString("status"));
                    inv.put("created_at", rs.getTimestamp("created_at"));
                    inv.put("startupTitle", rs.getString("title"));
                    inv.put("stage", rs.getString("stage"));
                    inv.put("domain", rs.getString("domain"));

                    investments.add(inv);
                    
                    totalInvested += amount;
                    activeDeals++;
                }
            }
            
            request.setAttribute("investments", investments);
            request.setAttribute("totalInvested", totalInvested);
            request.setAttribute("activeDeals", activeDeals);
            request.setAttribute("pendingInterest", pendingInterest);

            request.getRequestDispatcher("/investor/portfolio.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/investor/dashboard.jsp?error=db_error");
        }
    }
}
