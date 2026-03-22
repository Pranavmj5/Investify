package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/founder/investment-decision")
public class InvestmentDecisionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int founderId = (int) session.getAttribute("user_id");
        String requestIdStr = request.getParameter("requestId");
        String action = request.getParameter("action");

        if (requestIdStr == null || action == null || 
           (!action.equals("accept") && !action.equals("reject"))) {
            response.sendRedirect(request.getContextPath() + "/founder/requests.jsp?error=invalid_request");
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(requestIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/founder/requests.jsp?error=invalid_id");
             return;
        }

        String newStatus = action.equals("accept") ? "accepted" : "rejected";

        try (Connection conn = DBConnection.getConnection()) {
            
            double amount = 0;
            int startupId = 0;
            String currentStatus = "";
            
            // Security Check: Verify that the requestId belongs to a startup owned by this founder
            String checkSql = "SELECT ir.id, ir.amount, ir.startup_id, ir.status FROM investment_request ir " +
                              "JOIN startup s ON ir.startup_id = s.id " +
                              "WHERE ir.id = ? AND s.founder_id = ?";
                              
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, requestId);
                psCheck.setInt(2, founderId);
                ResultSet rs = psCheck.executeQuery();
                
                if (!rs.next()) {
                    // Not authorized or invalid request
                    response.sendRedirect(request.getContextPath() + "/founder/requests.jsp?error=unauthorized");
                    return;
                }
                amount = rs.getDouble("amount");
                startupId = rs.getInt("startup_id");
                currentStatus = rs.getString("status");
            }
            
            // Proceed only if the request is currently 'pending'
            if (!"pending".equals(currentStatus)) {
                response.sendRedirect(request.getContextPath() + "/founder/requests.jsp?error=already_processed");
                return;
            }
            
            // Authorized and pending. Update the status.
            String updateSql = "UPDATE investment_request SET status = ? WHERE id = ?";
            try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                psUpdate.setString(1, newStatus);
                psUpdate.setInt(2, requestId);
                psUpdate.executeUpdate();
            }
            
            // If accepted, update the startup's funding_raised
            if ("accepted".equals(newStatus)) {
                String updateFundingSql = "UPDATE startup SET funding_raised = funding_raised + ? WHERE id = ?";
                try (PreparedStatement psFunding = conn.prepareStatement(updateFundingSql)) {
                    psFunding.setDouble(1, amount);
                    psFunding.setInt(2, startupId);
                    psFunding.executeUpdate();
                }
            }

            response.sendRedirect(request.getContextPath() + "/founder/requests.jsp?success=decision_saved");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/founder/requests.jsp?error=db_error");
        }
    }
}
