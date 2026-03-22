<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?source=founder_schemes");
        return;
    }
    String userName = (String) session.getAttribute("user_name");
    int userId = (int) session.getAttribute("user_id");

    int startupId = -1;
    boolean hasProfile = false;
    List<Map<String, Object>> schemeList = new ArrayList<>();
    
    try (Connection conn = DBConnection.getConnection()) {
        // Find if founder has a startup profile
        PreparedStatement psStartup = conn.prepareStatement("SELECT id FROM startup WHERE founder_id = ? ORDER BY id DESC LIMIT 1");
        psStartup.setInt(1, userId);
        ResultSet rsStartup = psStartup.executeQuery();
        if (rsStartup.next()) {
            startupId = rsStartup.getInt("id");
            hasProfile = true;
        }

        // Fetch active schemes & check if applied
        PreparedStatement psSchemes = conn.prepareStatement(
            "SELECT s.id, s.name, s.target_sector, s.budget, s.description, s.open_date, s.close_date, " +
            "(SELECT status FROM scheme_applications sa WHERE sa.scheme_id = s.id AND sa.startup_id = ?) AS app_status " +
            "FROM schemes s WHERE s.status = 'active' ORDER BY s.created_at DESC"
        );
        psSchemes.setInt(1, startupId);
        ResultSet rs = psSchemes.executeQuery();
        
        while(rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("name", rs.getString("name"));
            map.put("sector", rs.getString("target_sector"));
            map.put("budget", rs.getDouble("budget"));
            map.put("description", rs.getString("description"));
            map.put("openDate", rs.getDate("open_date"));
            map.put("closeDate", rs.getDate("close_date"));
            map.put("appStatus", rs.getString("app_status")); // null if unapplied
            schemeList.add(map);
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
  <title>Investify – Government Schemes</title>
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
        <header class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
            <div class="flex items-center gap-8">
                <a href="../index.jsp" class="flex items-center gap-3">
                    <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                        <span class="material-symbols-outlined text-xl">diamond</span>
                    </div>
                    <span class="text-lg font-bold">Investify</span>
                </a>
            </div>
            <nav class="hidden lg:flex items-center gap-6">
            <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">My Startup</a>
            <a href="requests.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Requests</a>
            <a href="schemes.jsp" class="text-sm font-semibold text-primary">Schemes</a>
            <a href="messages.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Messages</a>
            <a href="settings.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Settings</a>
        </nav>
            <div class="flex items-center gap-4">
                <a href="profile.jsp" class="h-9 w-9 rounded-full overflow-hidden ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary text-white font-bold text-sm uppercase">
                    <%= userName != null && !userName.isEmpty() ? userName.substring(0,1) : "F" %>
                </a>
            </div>
        </header>

        <!-- MAIN -->
        <main class="flex-1 max-w-[1200px] mx-auto w-full px-6 py-8">
            <div class="mb-8 flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-black">Government Schemes</h1>
                    <p class="text-text-muted mt-2">Discover and apply for financial grants backed by the government.</p>
                </div>
            </div>

            <% if (!hasProfile) { %>
                <div class="bg-red-50 border border-red-200 text-red-700 px-6 py-4 rounded-xl mb-8 flex items-center gap-3">
                    <span class="material-symbols-outlined text-2xl">error</span>
                    <div>
                        <h3 class="font-bold">Startup Profile Required</h3>
                        <p class="text-sm">You must <a href="create_profile.jsp" class="underline font-semibold hover:text-red-900">create a startup profile</a> before you can apply for government schemes.</p>
                    </div>
                </div>
            <% } %>

            <% if ("applied".equals(request.getParameter("success"))) { %>
                <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-6 py-4 rounded-xl mb-6 flex items-center gap-3">
                    <span class="material-symbols-outlined text-xl">check_circle</span>
                    <span class="text-sm font-bold">Successfully applied for the scheme. You can track its status securely.</span>
                </div>
            <% } %>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <% if (schemeList.isEmpty()) { %>
                    <div class="col-span-full py-16 text-center text-text-muted bg-surface rounded-2xl border border-border-c">
                        <span class="material-symbols-outlined text-5xl mb-3">volunteer_activism</span>
                        <h3 class="text-lg font-bold text-text-main">No Active Schemes</h3>
                        <p>There are no active government schemes at the moment. Please check back later.</p>
                    </div>
                <% } else { %>
                    <% for (Map<String, Object> s : schemeList) { %>
                        <div class="bg-surface border border-border-c rounded-2xl p-6 flex flex-col hover:shadow-md transition-all">
                            <div class="flex items-start justify-between mb-4">
                                <div class="bg-primary/10 text-primary p-2.5 rounded-xl">
                                    <span class="material-symbols-outlined">account_balance</span>
                                </div>
                                <span class="text-xs font-bold px-2 py-1 bg-bg-light border border-border-c rounded text-text-muted"><%= s.get("sector") %></span>
                            </div>
                            
                            <h3 class="text-xl font-bold mb-2 line-clamp-1"><%= s.get("name") %></h3>
                            <p class="text-sm text-text-muted mb-6 flex-1 line-clamp-3"><%= s.get("description") %></p>
                            
                            <div class="space-y-3 mb-6">
                                <div class="flex justify-between items-center text-sm">
                                    <span class="text-text-muted">Budget Pool</span>
                                    <span class="font-bold"><%= String.format("$%,.0f", s.get("budget")) %></span>
                                </div>
                                <div class="flex justify-between items-center text-sm">
                                    <span class="text-text-muted">Deadline</span>
                                    <span class="font-bold"><%= s.get("closeDate") != null ? s.get("closeDate").toString() : "Ongoing" %></span>
                                </div>
                            </div>
                            
                            <hr class="border-border-c mb-5" />
                            
                            <% if (!hasProfile) { %>
                                <button disabled class="w-full py-2.5 rounded-full bg-gray-100 text-gray-400 font-bold text-sm text-center">Profile Required</button>
                            <% } else if (s.get("appStatus") != null) { %>
                                <% String status = (String)s.get("appStatus"); %>
                                <div class="w-full py-2.5 rounded-full bg-bg-light border border-border-c text-text-muted font-bold text-sm text-center flex items-center justify-center gap-2 capitalize">
                                    <span class="material-symbols-outlined text-[18px]">
                                        <%= status.equals("approved") ? "check_circle" : status.equals("rejected") ? "cancel" : "schedule" %>
                                    </span>
                                    <%= status.replace("_", " ") %>
                                </div>
                            <% } else { %>
                                <form action="${pageContext.request.contextPath}/founder/apply_scheme" method="POST" class="w-full">
                                    <input type="hidden" name="schemeId" value="<%= s.get("id") %>" />
                                    <input type="hidden" name="startupId" value="<%= startupId %>" />
                                    <button type="submit" class="w-full py-2.5 rounded-full bg-primary text-white font-bold text-sm hover:bg-primary-dark transition-colors flex justify-center items-center gap-2">
                                        Apply Now <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                    </button>
                                </form>
                            <% } %>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
