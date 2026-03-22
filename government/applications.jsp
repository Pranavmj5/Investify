<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?source=government_apps");
        return;
    }
    String role = (String) session.getAttribute("role");
    if (!"government".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Access+denied");
        return;
    }
    String userName = (String) session.getAttribute("user_name");

    List<Map<String, Object>> appsList = new ArrayList<>();
    String schemeIdParam = request.getParameter("schemeId");
    Integer specificSchemeId = null;
    if (schemeIdParam != null && !schemeIdParam.trim().isEmpty()) {
        try {
            specificSchemeId = Integer.parseInt(schemeIdParam);
        } catch (NumberFormatException e) {
            // Invalid scheme ID, ignore parameter
        }
    }

    try (Connection conn = DBConnection.getConnection()) {
        String query = 
            "SELECT sa.id AS app_id, sa.status, sa.created_at, " +
            "s.name AS scheme_name, s.budget, " +
            "st.title AS startup_name, st.domain " +
            "FROM scheme_applications sa " +
            "JOIN schemes s ON sa.scheme_id = s.id " +
            "JOIN startup st ON sa.startup_id = st.id ";
            
        if (specificSchemeId != null) {
            query += "WHERE sa.scheme_id = ? ";
        }
        query += "ORDER BY sa.created_at DESC";
            
        PreparedStatement ps = conn.prepareStatement(query);
        if (specificSchemeId != null) {
            ps.setInt(1, specificSchemeId);
        }
        
        ResultSet rs = ps.executeQuery();
        
        while(rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("appId", rs.getInt("app_id"));
            map.put("schemeName", rs.getString("scheme_name"));
            map.put("budget", rs.getDouble("budget"));
            map.put("startupName", rs.getString("startup_name"));
            map.put("domain", rs.getString("domain"));
            map.put("status", rs.getString("status"));
            map.put("date", rs.getTimestamp("created_at"));
            appsList.add(map);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Investify – Government Applications</title>
  <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: "#c6a65d",
            "primary-dark": "#b09045",
            "bg-light": "#f8f7f6",
            "surface": "#ffffff",
            "text-main": "#1e1b14",
            "text-muted": "#817a6a",
            "border-c": "#e3e2dd"
          },
          fontFamily: {
            display: ["Public Sans", "sans-serif"]
          }
        }
      }
    }
  </script>
  <style>
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24 }
  </style>
</head>
<body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
    <div class="flex flex-col min-h-screen">
        
        <!-- TOPBAR -->
        <header class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5 shadow-sm">
            <div class="flex items-center gap-8">
                <a href="../index.jsp" class="flex items-center gap-3">
                    <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                        <span class="material-symbols-outlined text-xl">diamond</span>
                    </div>
                    <span class="text-lg font-bold text-slate-800">Investify<span class="font-medium text-slate-500 text-sm ml-2">Government</span></span>
                </a>
            </div>
            <nav class="hidden lg:flex items-center gap-6">
				<a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
				<a href="schemes.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Schemes</a>
				<a href="applications.jsp" class="text-sm font-semibold text-primary border-b-2 border-primary pb-1">Applications</a>
				<a href="grants.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Grants</a>
				<a href="reports.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Reports</a>
			</nav>
            <div class="flex items-center gap-4">
                <a href="settings.jsp" class="h-9 w-9 rounded-full overflow-hidden ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary/20 text-primary-dark font-bold text-sm uppercase">
                    <%= userName != null && !userName.isEmpty() ? userName.substring(0,1) : "G" %>
                </a>
            </div>
        </header>

        <!-- MAIN -->
        <main class="flex-1 max-w-[1200px] mx-auto w-full px-6 py-8">
            <div class="mb-8 flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-black text-slate-800">Scheme Applications</h1>
                    <p class="text-slate-500 mt-2">Review and manage startup applications for active government schemes.</p>
                </div>
            </div>

            <% if ("updated".equals(request.getParameter("success"))) { %>
                <div class="bg-emerald-50 border border-emerald-200 text-emerald-800 px-6 py-4 rounded-xl mb-6 flex items-center gap-3">
                    <span class="material-symbols-outlined text-xl">check_circle</span>
                    <span class="text-sm font-semibold">Application status updated successfully.</span>
                </div>
            <% } %>
            <% if ("error".equals(request.getParameter("error"))) { %>
                <div class="bg-red-50 border border-red-200 text-red-800 px-6 py-4 rounded-xl mb-6 flex items-center gap-3">
                    <span class="material-symbols-outlined text-xl">error</span>
                    <span class="text-sm font-semibold">There was an error updating the application status. Please try again.</span>
                </div>
            <% } %>

            <div class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="bg-slate-50 text-xs font-bold uppercase tracking-wider text-slate-500 border-b border-border-c">
                            <tr>
                                <th class="px-6 py-4">Startup</th>
                                <th class="px-6 py-4">Scheme Applied</th>
                                <th class="px-6 py-4">Date</th>
                                <th class="px-6 py-4">Current Status</th>
                                <th class="px-6 py-4 text-right">Update Status</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-border-c text-sm">
                            <% if (appsList.isEmpty()) { %>
                                <tr>
                                    <td colspan="5" class="px-6 py-16 text-center text-slate-500">
                                        <span class="material-symbols-outlined text-4xl mb-2 text-slate-300">inbox</span>
                                        <p class="font-semibold text-slate-700">No applications found</p>
                                        <p class="text-sm mt-1">Startups haven't applied to any schemes yet.</p>
                                    </td>
                                </tr>
                            <% } else { %>
                                <% for (Map<String, Object> app : appsList) { 
                                    String status = (String)app.get("status");
                                    String statusColor = "bg-slate-100 text-slate-700 border-transparent";
                                    if(status.equals("approved") || status.equals("disbursed")) statusColor = "bg-emerald-50 text-emerald-700 border-emerald-200";
                                    else if(status.equals("under_review")) statusColor = "bg-amber-50 text-amber-700 border-amber-200";
                                    else if(status.equals("rejected")) statusColor = "bg-red-50 text-red-700 border-red-200";
                                %>
                                    <tr class="hover:bg-slate-50/50 transition-colors">
                                        <td class="px-6 py-4">
                                            <p class="font-bold text-slate-800"><%= app.get("startupName") %></p>
                                            <p class="text-xs text-slate-500"><%= app.get("domain") %></p>
                                        </td>
                                        <td class="px-6 py-4">
                                            <p class="font-semibold text-slate-700 max-w-[200px] truncate" title="<%= app.get("schemeName") %>"><%= app.get("schemeName") %></p>
                                            <p class="text-xs text-slate-500">Budget: <%= String.format("$%,.0f", app.get("budget")) %></p>
                                        </td>
                                        <td class="px-6 py-4 text-slate-600 font-medium">
                                            <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format((java.util.Date)app.get("date")) %>
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="px-2.5 py-1 rounded-full text-xs font-bold capitalize <%= statusColor %>"><%= status.replace("_", " ") %></span>
                                        </td>
                                        <td class="px-6 py-4 text-right">
                                            <form action="${pageContext.request.contextPath}/government/schemes" method="POST" class="flex items-center justify-end gap-2">
                                                <input type="hidden" name="action" value="update_application_status" />
                                                <input type="hidden" name="applicationId" value="<%= app.get("appId") %>" />
                                                <% if (specificSchemeId != null) { %>
                                                    <input type="hidden" name="schemeIdFilter" value="<%= specificSchemeId %>" />
                                                <% } %>
                                                <select name="status" class="text-sm border-border-c rounded-lg py-1.5 pl-3 pr-8 focus:ring-primary focus:border-primary bg-white font-medium text-slate-700">
                                                    <option value="pending" <%= status.equals("pending") ? "selected" : "" %>>Pending</option>
                                                    <option value="under_review" <%= status.equals("under_review") ? "selected" : "" %>>Under Review</option>
                                                    <option value="approved" <%= status.equals("approved") ? "selected" : "" %>>Approved</option>
                                                    <option value="disbursed" <%= status.equals("disbursed") ? "selected" : "" %>>Disbursed</option>
                                                    <option value="rejected" <%= status.equals("rejected") ? "selected" : "" %>>Rejected</option>
                                                </select>
                                                <button type="submit" class="bg-primary hover:bg-primary-dark text-white p-1.5 rounded-lg transition-colors" title="Save Status">
                                                    <span class="material-symbols-outlined text-[18px]">save</span>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
