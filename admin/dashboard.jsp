<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*, java.text.SimpleDateFormat" %>
<% 
   if (session.getAttribute("user_id") == null || !"admin".equals(session.getAttribute("role"))) { 
       response.sendRedirect(request.getContextPath() + "/login.jsp"); 
       return; 
   } 

   int totalUsers = 0;
   int activeStartups = 0;
   double totalVolume = 0;
   double platformRevenue = 0;
   
   int investors = 0, founders = 0, govt = 0, admins = 0;
   List<Map<String,Object>> recentSignups = new ArrayList<>();

   try (Connection conn = DBConnection.getConnection()) {
       ResultSet rs1 = conn.createStatement().executeQuery("SELECT role, COUNT(*) FROM users GROUP BY role");
       while(rs1.next()){
           String roleStr = rs1.getString(1);
           int cnt = rs1.getInt(2);
           totalUsers += cnt;
           if("investor".equals(roleStr)) investors = cnt;
           else if("founder".equals(roleStr)) founders = cnt;
           else if("government".equals(roleStr)) govt = cnt;
           else if("admin".equals(roleStr)) admins = cnt;
       }

       ResultSet rs2 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM startup WHERE status='approved'");
       if(rs2.next()) activeStartups = rs2.getInt(1);

       ResultSet rs3 = conn.createStatement().executeQuery("SELECT COALESCE(SUM(amount), 0) FROM investment_request WHERE status='accepted'");
       if(rs3.next()) {
           totalVolume = rs3.getDouble(1);
           platformRevenue = totalVolume * 0.05;
       }

       ResultSet rs4 = conn.createStatement().executeQuery("SELECT name, role, created_at FROM users ORDER BY created_at DESC LIMIT 5");
       while(rs4.next()){
           Map<String,Object> map = new HashMap<>();
           map.put("name", rs4.getString("name"));
           map.put("role", rs4.getString("role"));
           map.put("created_at", rs4.getTimestamp("created_at"));
           recentSignups.add(map);
       }
   } catch(Exception e) {
       e.printStackTrace();
   }

   String fmtVolume = totalVolume >= 1000000 ? String.format("$%.1fM", totalVolume / 1000000) : 
                      totalVolume >= 1000 ? String.format("$%.1fK", totalVolume / 1000) : 
                      String.format("$%,.0f", totalVolume);
   String fmtRevenue = platformRevenue >= 1000000 ? String.format("$%.1fM", platformRevenue / 1000000) : 
                       platformRevenue >= 1000 ? String.format("$%.1fK", platformRevenue / 1000) : 
                       String.format("$%,.0f", platformRevenue);

   int invPct = totalUsers > 0 ? Math.round((float)investors * 100 / totalUsers) : 0;
   int fndPct = totalUsers > 0 ? Math.round((float)founders * 100 / totalUsers) : 0;
   int govPct = totalUsers > 0 ? Math.round((float)govt * 100 / totalUsers) : 0;
   int admPct = totalUsers > 0 ? Math.round((float)admins * 100 / totalUsers) : 0;
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Investify – Admin Analytics</title>
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800;900&display=swap"
        rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script>tailwind.config = { theme: { extend: { colors: { primary: "#c6a65d", "primary-dark": "#b09045", "bg-light": "#f8f7f6", "surface": "#ffffff", "text-main": "#1e1b14", "text-muted": "#817a6a", "border-c": "#e3e2dd" }, fontFamily: { display: ["Public Sans", "sans-serif"] } } } }</script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24
        }

        .bar-fill {
            width: 0;
            transition: width 1s ease
        }
    </style>
</head>

<body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
    <header
        class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
        <div class="flex items-center gap-6"><a href="../index.jsp" class="flex items-center gap-3">
                <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                        class="material-symbols-outlined text-xl">diamond</span></div><span
                    class="text-lg font-bold">Investify</span>
            </a><span
                class="hidden md:block text-xs font-bold uppercase tracking-widest text-red-700 bg-red-50 rounded-full px-3 py-1">Admin
                Portal</span></div>
        <nav class="hidden lg:flex items-center gap-6">
                                    <a href="dashboard.jsp" class="text-sm font-semibold text-primary">Analytics</a>
                                    <a href="verification.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Verification</a>
                                    <a href="beneficiaries.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Beneficiaries</a>
                                </nav>
        <a href="../investor/profile.jsp"><img src="https://i.pravatar.cc/36?img=12"
                class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                alt="Admin" /></a>
    </header>
    <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-8">
        <div>
            <h1 class="text-3xl font-black">Platform Analytics</h1>
            <p class="text-text-muted mt-1">Real-time insights across the entire Investify ecosystem.</p>
        </div>

        <!-- Top KPIs -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-5 mb-8">
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <div class="flex justify-between items-center mb-3">
                    <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Total Users</p>
                    <div class="size-8 rounded-full bg-primary/10 text-primary flex items-center justify-center"><span class="material-symbols-outlined text-[18px]">people</span></div>
                </div>
                <p class="text-3xl font-black"><%= totalUsers %></p>
                <div class="h-1 bg-bg-light rounded-full mt-3">
                    <div class="h-full bg-primary rounded-full bar-fill" data-pct="100"></div>
                </div>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <div class="flex justify-between items-center mb-3">
                    <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Active Startups</p>
                    <div class="size-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center"><span class="material-symbols-outlined text-[18px]">rocket_launch</span></div>
                </div>
                <p class="text-3xl font-black"><%= activeStartups %></p>
                <div class="h-1 bg-bg-light rounded-full mt-3">
                    <div class="h-full bg-blue-500 rounded-full bar-fill" data-pct="<%= totalUsers > 0 ? Math.min(100, (activeStartups * 100 / totalUsers)) : 0 %>"></div>
                </div>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <div class="flex justify-between items-center mb-3">
                    <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Total Volume</p>
                    <div class="size-8 rounded-full bg-green-100 text-green-600 flex items-center justify-center"><span class="material-symbols-outlined text-[18px]">payments</span></div>
                </div>
                <p class="text-3xl font-black"><%= fmtVolume %></p>
                <div class="h-1 bg-bg-light rounded-full mt-3">
                    <div class="h-full bg-green-500 rounded-full bar-fill" data-pct="75"></div>
                </div>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <div class="flex justify-between items-center mb-3">
                    <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Platform Revenue</p>
                    <div class="size-8 rounded-full bg-amber-100 text-amber-600 flex items-center justify-center"><span class="material-symbols-outlined text-[18px]">monetization_on</span></div>
                </div>
                <p class="text-3xl font-black"><%= fmtRevenue %></p>
                <div class="h-1 bg-bg-light rounded-full mt-3">
                    <div class="h-full bg-amber-500 rounded-full bar-fill" data-pct="60"></div>
                </div>
            </div>
        </div>

        <div class="grid md:grid-cols-2 gap-6">
            <!-- User distribution -->
            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6">
                <h2 class="text-lg font-bold mb-5">User Distribution</h2>
                <div class="space-y-4">
                    <div>
                        <div class="flex justify-between text-sm mb-1.5"><span class="flex items-center gap-2">
                                <div class="size-3 rounded-sm bg-primary"></div>Investors
                            </span><span class="font-bold"><%= investors %> (<%= invPct %>%)</span></div>
                        <div class="h-2.5 bg-bg-light rounded-full">
                            <div class="h-full bg-primary rounded-full bar-fill" data-pct="<%= invPct %>"></div>
                        </div>
                    </div>
                    <div>
                        <div class="flex justify-between text-sm mb-1.5"><span class="flex items-center gap-2">
                                <div class="size-3 rounded-sm bg-blue-500"></div>Founders
                            </span><span class="font-bold"><%= founders %> (<%= fndPct %>%)</span></div>
                        <div class="h-2.5 bg-bg-light rounded-full">
                            <div class="h-full bg-blue-500 rounded-full bar-fill" data-pct="<%= fndPct %>"></div>
                        </div>
                    </div>
                    <div>
                        <div class="flex justify-between text-sm mb-1.5"><span class="flex items-center gap-2">
                                <div class="size-3 rounded-sm bg-purple-500"></div>Government
                            </span><span class="font-bold"><%= govt %> (<%= govPct %>%)</span></div>
                        <div class="h-2.5 bg-bg-light rounded-full">
                            <div class="h-full bg-purple-500 rounded-full bar-fill" data-pct="<%= govPct %>"></div>
                        </div>
                    </div>
                    <div>
                        <div class="flex justify-between text-sm mb-1.5"><span class="flex items-center gap-2">
                                <div class="size-3 rounded-sm bg-red-500"></div>Admins
                            </span><span class="font-bold"><%= admins %> (<%= admPct %>%)</span></div>
                        <div class="h-2.5 bg-bg-light rounded-full">
                            <div class="h-full bg-red-500 rounded-full bar-fill" data-pct="<%= admPct %>"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent signups table -->
            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 mb-6">
                <h2 class="text-lg font-bold mb-5">Recent Signups</h2>
                <div class="space-y-3">
                    <% if (recentSignups.isEmpty()) { %>
                    <div class="text-center py-8 text-text-muted">
                        <span class="material-symbols-outlined text-4xl mb-2 block">person_add</span>
                        <p class="text-sm font-semibold">No recent signups</p>
                        <p class="text-xs mt-1">New user registrations will appear here.</p>
                    </div>
                    <% } else { 
                        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                        for (Map<String,Object> map : recentSignups) { 
                            String rName = (String) map.get("name");
                            String rRole = (String) map.get("role");
                            String rDate = sdf.format((java.util.Date)map.get("created_at"));
                            rRole = rRole.substring(0,1).toUpperCase() + rRole.substring(1);
                    %>
                    <div class="flex items-center justify-between p-3 rounded-xl border border-border-c hover:bg-bg-light transition-colors">
                        <div class="flex items-center gap-3">
                            <div class="size-10 rounded-full bg-gradient-to-tr from-primary/20 to-primary/5 flex items-center justify-center text-primary font-bold">
                                <%= rName.substring(0,1).toUpperCase() %>
                            </div>
                            <div>
                                <p class="text-sm font-bold"><%= rName %></p>
                                <p class="text-xs text-text-muted"><%= rRole %> &middot; <%= rDate %></p>
                            </div>
                        </div>
                    </div>
                    <% } } %>
                </div>
            </div>
        </div>

        <!-- Quick nav to admin pages -->
        <div class="grid grid-cols-3 gap-4">
            <a href="verification.jsp"
                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                <div
                    class="size-12 rounded-full bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-colors">
                    <span class="material-symbols-outlined text-[22px]">verified_user</span>
                </div><span class="text-sm font-semibold text-center">Verification Portal</span>
            </a>
            <a href="beneficiaries.jsp"
                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                <div
                    class="size-12 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 group-hover:bg-blue-600 group-hover:text-white transition-colors">
                    <span class="material-symbols-outlined text-[22px]">group</span>
                </div><span class="text-sm font-semibold text-center">Beneficiary Tracking</span>
            </a>
            <a href="dashboard.jsp"
                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                <div
                    class="size-12 rounded-full bg-green-50 flex items-center justify-center text-green-600 group-hover:bg-green-600 group-hover:text-white transition-colors">
                    <span class="material-symbols-outlined text-[22px]">bar_chart</span>
                </div><span class="text-sm font-semibold text-center">Gov. Reports</span>
            </a>
        </div>
    </main>
    <script>setTimeout(() => { document.querySelectorAll('.bar-fill[data-pct]').forEach(el => { el.style.width = el.dataset.pct + '%'; }); }, 300);</script>
</body>

</html>