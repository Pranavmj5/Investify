package com.investify.servlet;

import com.investify.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.*;

@WebServlet("/startups")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 25, // 25 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class StartupServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String view = request.getParameter("view");

        // ----- Founder: load MY startup -----
        if ("mine".equals(view)) {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user_id") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            int founderId = (int) session.getAttribute("user_id");
            Map<String, Object> startup = null;

            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM startup WHERE founder_id = ? ORDER BY created_at DESC LIMIT 1");
                ps.setInt(1, founderId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    startup = new HashMap<>();
                    startup.put("id", rs.getInt("id"));
                    startup.put("title", rs.getString("title"));
                    startup.put("domain", rs.getString("domain"));
                    startup.put("stage", rs.getString("stage"));
                    startup.put("tagline", rs.getString("tagline"));
                    startup.put("description", rs.getString("description"));
                    startup.put("fundingGoal", rs.getDouble("funding_goal"));
                    startup.put("fundingRaised", rs.getDouble("funding_raised"));
                    startup.put("equityOffered", rs.getDouble("equity_offered"));
                    startup.put("minTicket", rs.getDouble("min_ticket"));
                    startup.put("valuation", rs.getDouble("valuation"));
                    startup.put("riskLevel", rs.getString("risk_level"));
                    startup.put("logo", rs.getString("logo"));
                    startup.put("pitchVideo", rs.getString("pitch_video"));
                    startup.put("pitchDeck", rs.getString("pitch_deck"));
                    startup.put("website", rs.getString("website"));
                    startup.put("linkedin", rs.getString("linkedin"));
                    startup.put("hqLocation", rs.getString("hq_location"));
                    startup.put("foundedYear", rs.getInt("founded_year"));
                    startup.put("status", rs.getString("status"));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            request.setAttribute("startup", startup);
            request.getRequestDispatcher("/founder/create_profile.jsp").forward(request, response);
            return;
        }

        // ----- Browse approved startups (investor / founder browse) -----
        List<Map<String, Object>> startups = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT s.*, u.name as founder_name FROM startup s JOIN users u ON s.founder_id = u.id WHERE s.status = 'approved' ORDER BY s.created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> s = new HashMap<>();
                s.put("id", rs.getInt("id"));
                s.put("title", rs.getString("title"));
                s.put("domain", rs.getString("domain"));
                s.put("stage", rs.getString("stage"));
                s.put("tagline", rs.getString("tagline"));
                s.put("description", rs.getString("description"));
                s.put("fundingGoal", rs.getDouble("funding_goal"));
                s.put("fundingRaised", rs.getDouble("funding_raised"));
                s.put("equityOffered", rs.getDouble("equity_offered"));
                s.put("minTicket", rs.getDouble("min_ticket"));
                s.put("valuation", rs.getDouble("valuation"));
                s.put("riskLevel", rs.getString("risk_level"));
                s.put("logo", rs.getString("logo"));
                s.put("pitchVideo", rs.getString("pitch_video"));
                s.put("pitchDeck", rs.getString("pitch_deck"));
                s.put("founderName", rs.getString("founder_name"));
                s.put("status", rs.getString("status"));

                double goal = rs.getDouble("funding_goal");
                double raised = rs.getDouble("funding_raised");
                int pct = goal > 0 ? (int) Math.round((raised / goal) * 100) : 0;
                s.put("fundingPct", pct);
                s.put("raisedFormatted", formatCurrency(raised));
                s.put("goalFormatted", formatCurrency(goal));

                startups.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("startups", startups);

        if ("founder".equals(view)) {
            request.getRequestDispatcher("/founder/browse.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/investor/browse_startups.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            System.out.println("STARTUP SERVLET: No session found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int founderId = (int) session.getAttribute("user_id");
        System.out.println("STARTUP SERVLET: Processing POST for founder_id=" + founderId);

        String title = request.getParameter("title");
        if (title == null || title.trim().isEmpty())
            title = "Untitled Startup";
        String domain = request.getParameter("domain");
        String stage = request.getParameter("stage");
        String tagline = request.getParameter("tagline");
        String description = request.getParameter("description");
        String fundingGoalStr = request.getParameter("fundingGoal");
        String fundingRaisedStr = request.getParameter("fundingRaised");
        String equityStr = request.getParameter("equityOffered");
        String minTicketStr = request.getParameter("minTicket");
        String valuationStr = request.getParameter("valuation");
        String riskLevel = request.getParameter("riskLevel");
        String website = request.getParameter("website");
        String linkedin = request.getParameter("linkedin");
        String hqLocation = request.getParameter("hqLocation");
        String foundedYearStr = request.getParameter("foundedYear");

        double fundingGoal = parseDouble(fundingGoalStr);
        double fundingRaised = parseDouble(fundingRaisedStr);
        double equity = parseDouble(equityStr);
        double minTicket = parseDouble(minTicketStr);
        double valuation = parseDouble(valuationStr);
        int foundedYear = parseInt(foundedYearStr);

        // Handle file uploads
        String uploadDir = getServletContext().getRealPath("/uploads");
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists())
            uploadFolder.mkdirs();

        String logoPath = saveFile(request, "logo", uploadDir);
        String pitchDeckPath = saveFile(request, "pitchDeck", uploadDir);
        String pitchVideoPath = saveFile(request, "pitchVideo", uploadDir);
        String financialModelPath = saveFile(request, "financialModel", uploadDir);
        String capTablePath = saveFile(request, "capTable", uploadDir);

        try (Connection conn = DBConnection.getConnection()) {
            // Check if founder already has a startup
            PreparedStatement checkPs = conn.prepareStatement(
                    "SELECT id FROM startup WHERE founder_id = ? LIMIT 1");
            checkPs.setInt(1, founderId);
            ResultSet checkRs = checkPs.executeQuery();

            int startupId = 0;
            boolean isUpdate = false;

            if (checkRs.next()) {
                // UPDATE existing startup
                isUpdate = true;
                startupId = checkRs.getInt("id");

                StringBuilder updateSql = new StringBuilder(
                        "UPDATE startup SET title=?, domain=?, stage=?, tagline=?, description=?, " +
                                "funding_goal=?, funding_raised=?, equity_offered=?, min_ticket=?, valuation=?, " +
                                "risk_level=?, website=?, linkedin=?, hq_location=?, founded_year=?, status='pending'");

                // Only update file fields if new files were uploaded
                if (logoPath != null)
                    updateSql.append(", logo=?");
                if (pitchDeckPath != null)
                    updateSql.append(", pitch_deck=?");
                if (pitchVideoPath != null)
                    updateSql.append(", pitch_video=?");
                updateSql.append(" WHERE id=?");

                PreparedStatement ps = conn.prepareStatement(updateSql.toString());
                int idx = 1;
                ps.setString(idx++, title);
                ps.setString(idx++, domain);
                ps.setString(idx++, stage);
                ps.setString(idx++, tagline);
                ps.setString(idx++, description);
                ps.setDouble(idx++, fundingGoal);
                ps.setDouble(idx++, fundingRaised);
                ps.setDouble(idx++, equity);
                ps.setDouble(idx++, minTicket);
                ps.setDouble(idx++, valuation);
                ps.setString(idx++, riskLevel);
                ps.setString(idx++, website);
                ps.setString(idx++, linkedin);
                ps.setString(idx++, hqLocation);
                ps.setInt(idx++, foundedYear);
                if (logoPath != null)
                    ps.setString(idx++, logoPath);
                if (pitchDeckPath != null)
                    ps.setString(idx++, pitchDeckPath);
                if (pitchVideoPath != null)
                    ps.setString(idx++, pitchVideoPath);
                ps.setInt(idx++, startupId);
                ps.executeUpdate();

                System.out.println("STARTUP SERVLET: Updated existing startup id=" + startupId);
            } else {
                // INSERT new startup
                String sql = "INSERT INTO startup (founder_id, title, domain, stage, tagline, description, " +
                        "funding_goal, funding_raised, equity_offered, min_ticket, valuation, risk_level, " +
                        "logo, pitch_deck, pitch_video, website, linkedin, hq_location, founded_year, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')";
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, founderId);
                ps.setString(2, title);
                ps.setString(3, domain);
                ps.setString(4, stage);
                ps.setString(5, tagline);
                ps.setString(6, description);
                ps.setDouble(7, fundingGoal);
                ps.setDouble(8, fundingRaised);
                ps.setDouble(9, equity);
                ps.setDouble(10, minTicket);
                ps.setDouble(11, valuation);
                ps.setString(12, riskLevel);
                ps.setString(13, logoPath);
                ps.setString(14, pitchDeckPath);
                ps.setString(15, pitchVideoPath);
                ps.setString(16, website);
                ps.setString(17, linkedin);
                ps.setString(18, hqLocation);
                ps.setInt(19, foundedYear);
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    startupId = keys.getInt(1);
                }
                System.out.println("STARTUP SERVLET: Created new startup id=" + startupId);
            }

            // Save document records (for new uploads only)
            if (startupId > 0) {
                String docSql = "INSERT INTO documents (startup_id, file_path, type) VALUES (?, ?, ?)";
                if (pitchDeckPath != null) {
                    PreparedStatement docPs = conn.prepareStatement(docSql);
                    docPs.setInt(1, startupId);
                    docPs.setString(2, pitchDeckPath);
                    docPs.setString(3, "pitch_deck");
                    docPs.executeUpdate();
                }
                if (financialModelPath != null) {
                    PreparedStatement docPs = conn.prepareStatement(docSql);
                    docPs.setInt(1, startupId);
                    docPs.setString(2, financialModelPath);
                    docPs.setString(3, "financial_model");
                    docPs.executeUpdate();
                }
                if (capTablePath != null) {
                    PreparedStatement docPs = conn.prepareStatement(docSql);
                    docPs.setInt(1, startupId);
                    docPs.setString(2, capTablePath);
                    docPs.setString(3, "cap_table");
                    docPs.executeUpdate();
                }
            }

            response.sendRedirect(request.getContextPath() + "/founder/create_profile.jsp?success=1");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to save startup. Please try again.");
            request.getRequestDispatcher("/founder/create_profile.jsp").forward(request, response);
        }
    }

    private String saveFile(HttpServletRequest request, String fieldName, String uploadDir)
            throws IOException, ServletException {
        try {
            Part part = request.getPart(fieldName);
            if (part != null && part.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + getFileName(part);
                String filePath = uploadDir + File.separator + fileName;
                part.write(filePath);
                return "uploads/" + fileName;
            }
        } catch (Exception e) {
            // Field not present in form, ignore
        }
        return null;
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 2, token.length() - 1);
            }
        }
        return "unknown";
    }

    private String formatCurrency(double amount) {
        if (amount >= 1_000_000)
            return "$" + String.format("%.1fM", amount / 1_000_000);
        if (amount >= 1_000)
            return "$" + String.format("%.0fK", amount / 1_000);
        return "$" + String.format("%.0f", amount);
    }

    private double parseDouble(String s) {
        try {
            return Double.parseDouble(s);
        } catch (Exception e) {
            return 0;
        }
    }

    private int parseInt(String s) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return 0;
        }
    }
}
