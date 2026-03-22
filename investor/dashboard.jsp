<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath()
        + "/login.jsp?source=dashboard" ); return; } int userId=(int) session.getAttribute("user_id"); String
        userName=(String) session.getAttribute("user_name"); %>

        <% if (userName==null) userName="Investor" ; int totalStartups=0; int myInvestments=0; double totalInvested=0;
            List<Map<String,Object>> recentStartups = new ArrayList<>();
            try (Connection conn=DBConnection.getConnection()) { ResultSet
            rs1=conn.createStatement().executeQuery( "SELECT COUNT(*) FROM startup WHERE status='approved'" ); if
            (rs1.next()) totalStartups=rs1.getInt(1); PreparedStatement
            ps=conn.prepareStatement( "SELECT COUNT(*), COALESCE(SUM(amount),0) FROM investment_request WHERE investor_id=?"
            ); ps.setInt(1, userId); ResultSet rs2=ps.executeQuery(); if (rs2.next()) { myInvestments=rs2.getInt(1);
            totalInvested=rs2.getDouble(2); } 
            ResultSet rs3 = conn.createStatement().executeQuery("SELECT id, title, domain, stage, risk_level FROM startup WHERE status='approved' ORDER BY created_at DESC LIMIT 5");
            while(rs3.next()) {
                Map<String,Object> map = new HashMap<>();
                map.put("id", rs3.getInt("id"));
                map.put("title", rs3.getString("title"));
                map.put("domain", rs3.getString("domain"));
                map.put("stage", rs3.getString("stage"));
                map.put("riskLevel", rs3.getString("risk_level"));
                recentStartups.add(map);
            }
            } catch (Exception e) { e.printStackTrace(); } String
            fmtInvested=totalInvested>= 1000000 ? String.format("$%.1fM", totalInvested / 1000000) :
            totalInvested >= 1000 ? String.format("$%.1fK", totalInvested / 1000) :
            String.format("$%.0f", totalInvested);
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Investify – Investor Dashboard</title>
                <link
                    href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800;900&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet" />
                <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
                <script>tailwind.config = { theme: { extend: { colors: { primary: "#c6a65d", "primary-dark": "#b09045", "bg-light": "#f8f7f6", "surface": "#ffffff", "text-main": "#1e1b14", "text-muted": "#817a6a", "border-c": "#e3e2dd" }, fontFamily: { display: ["Public Sans", "sans-serif"] } } } }</script>
                <style>
                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24
                    }

                    .icon-fill {
                        font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24
                    }

                    .bar-fill {
                        width: 0;
                        transition: width 1.1s cubic-bezier(.25, .8, .25, 1)
                    }

                    @keyframes fadeUp {
                        from {
                            opacity: 0;
                            transform: translateY(16px)
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0)
                        }
                    }

                    .fade-up {
                        animation: fadeUp .5s ease forwards
                    }

                    .stagger-1 {
                        animation-delay: .05s
                    }

                    .stagger-2 {
                        animation-delay: .1s
                    }

                    .stagger-3 {
                        animation-delay: .15s
                    }

                    .stagger-4 {
                        animation-delay: .2s
                    }
                </style>
            </head>

            <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
                <div class="flex flex-col min-h-screen">

                    <!-- TOPBAR -->
                    <header
                        class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                        <div class="flex items-center gap-8">
                            <a href="../index.jsp" class="flex items-center gap-3">
                                <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                                    <span class="material-symbols-outlined text-xl">diamond</span>
                                </div>
                                <span class="text-lg font-bold">Investify</span>
                            </a>
                            <div
                                class="hidden md:flex items-center rounded-xl bg-bg-light border border-border-c px-3 py-2 w-64 focus-within:border-primary transition-all">
                                <span class="material-symbols-outlined text-text-muted text-[18px]">search</span>
                                <input
                                    class="bg-transparent border-none p-0 pl-2 text-sm w-full focus:ring-0 placeholder:text-text-muted"
                                    placeholder="Search startups, sectors…" />
                            </div>
                        </div>
                        <nav class="hidden lg:flex items-center gap-6">
                            <a href="dashboard.jsp" class="text-sm font-semibold text-primary">Dashboard</a>
                            <a href="browse_startups.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Browse</a>
                            <a href="portfolio.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Portfolio</a>
                            <a href="watchlist.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Watchlist</a>
                            <a href="insights.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Insights</a>
                            <a href="notifications.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Notifications</a>
                        </nav>
                        <div class="flex items-center gap-4">
                            <a href="browse_startups.jsp"
                                class="hidden sm:flex h-9 px-5 rounded-full bg-primary text-white text-sm font-bold items-center gap-1.5 hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)]">
                                <span class="material-symbols-outlined text-[18px]">add</span>Invest Now
                            </a>
                            <a href="notifications.jsp"
                                class="relative p-2 text-text-muted hover:text-primary transition-colors">
                                <span class="material-symbols-outlined">notifications</span>
                                <span
                                    class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span>
                            </a>
                            <a href="profile.jsp"
                                class="h-9 w-9 rounded-full overflow-hidden ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary text-white font-bold text-sm uppercase">
                                <%= userName !=null && !userName.isEmpty() ? userName.substring(0,1) : "U" %>
                            </a>
                        </div>
                    </header>

                    <!-- MAIN -->
                    <main class="flex-1 max-w-[1200px] mx-auto w-full px-6 py-8 flex flex-col gap-8">

                        <!-- Header -->
                        <div
                            class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 fade-up">
                            <div>
                                <h1 class="text-3xl md:text-4xl font-black">Welcome, <%= userName %>
                                </h1>
                                <p class="text-text-muted mt-1">Track your investment landscape and discover new
                                    opportunities.</p>
                            </div>
                            <div
                                class="flex items-center gap-2 bg-surface rounded-full px-4 py-2 shadow-sm border border-border-c text-sm font-medium">
                                <span class="material-symbols-outlined text-primary text-[18px]">calendar_today</span>
                                Mar 3, 2026
                            </div>
                        </div>

                        <!-- Stat cards -->
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-5 fade-up stagger-1">
                            <div
                                class="bg-surface rounded-2xl p-6 border border-border-c shadow-sm hover:shadow-md transition-shadow">
                                <div class="flex justify-between items-center mb-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Total
                                        Startups
                                    </p>
                                    <div
                                        class="size-9 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                                        <span class="material-symbols-outlined text-[20px]">rocket_launch</span>
                                    </div>
                                </div>
                                <div class="flex items-baseline gap-3 mb-3">
                                    <p class="text-4xl font-black">
                                        <%= String.format("%,d", totalStartups) %>
                                    </p>
                                    <% if (totalStartups> 0) { %>
                                        <span
                                            class="flex items-center gap-1 text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full text-xs font-bold"><span
                                                class="material-symbols-outlined text-[13px]">trending_up</span>12%</span>
                                        <% } %>
                                </div>
                                <div class="h-1.5 bg-bg-light rounded-full">
                                    <div class="h-full bg-primary rounded-full bar-fill"
                                        data-pct="<%= totalStartups > 0 ? 75 : 0 %>"></div>
                                </div>
                            </div>
                            <div
                                class="bg-surface rounded-2xl p-6 border border-border-c shadow-sm hover:shadow-md transition-shadow">
                                <div class="flex justify-between items-center mb-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Portfolio
                                        Value</p>
                                    <div
                                        class="size-9 rounded-full bg-blue-500/10 flex items-center justify-center text-blue-600">
                                        <span
                                            class="material-symbols-outlined text-[20px]">account_balance_wallet</span>
                                    </div>
                                </div>
                                <div class="flex items-baseline gap-3 mb-3">
                                    <p class="text-4xl font-black">
                                        <%= fmtInvested %>
                                    </p>
                                    <% if (totalInvested> 0) { %>
                                        <span
                                            class="flex items-center gap-1 text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full text-xs font-bold"><span
                                                class="material-symbols-outlined text-[13px]">trending_up</span>18%</span>
                                        <% } %>
                                </div>
                                <div class="h-1.5 bg-bg-light rounded-full">
                                    <div class="h-full bg-blue-500 rounded-full bar-fill"
                                        data-pct="<%= totalInvested > 0 ? 60 : 0 %>"></div>
                                </div>
                            </div>
                            <div
                                class="bg-surface rounded-2xl p-6 border border-border-c shadow-sm hover:shadow-md transition-shadow">
                                <div class="flex justify-between items-center mb-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Active
                                        Investments</p>
                                    <div
                                        class="size-9 rounded-full bg-purple-500/10 flex items-center justify-center text-purple-600">
                                        <span class="material-symbols-outlined text-[20px]">pie_chart</span>
                                    </div>
                                </div>
                                <div class="flex items-baseline gap-3 mb-3">
                                    <p class="text-4xl font-black">
                                        <%= myInvestments %>
                                    </p>
                                    <% if (myInvestments> 0) { %>
                                        <span
                                            class="flex items-center gap-1 text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full text-xs font-bold"><span
                                                class="material-symbols-outlined text-[13px]">trending_up</span>2
                                            new</span>
                                        <% } %>
                                </div>
                                <div class="h-1.5 bg-bg-light rounded-full">
                                    <div class="h-full bg-purple-500 rounded-full bar-fill"
                                        data-pct="<%= myInvestments > 0 ? 45 : 0 %>"></div>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Startups Table -->
                        <div
                            class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden fade-up stagger-2">
                            <div class="flex items-center justify-between px-6 py-5 border-b border-border-c">
                                <h2 class="text-xl font-bold">Recent Startups</h2>
                                <a href="browse_startups.jsp"
                                    class="text-primary hover:text-primary-dark text-sm font-bold flex items-center gap-1 transition-colors">
                                    View All <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                                </a>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left">
                                    <thead
                                        class="bg-bg-light text-xs font-bold uppercase tracking-wider text-text-muted">
                                        <tr>
                                            <th class="px-6 py-3.5">Startup</th>
                                            <th class="px-6 py-3.5">Domain</th>
                                            <th class="px-6 py-3.5">Stage</th>
                                            <th class="px-6 py-3.5">Risk</th>
                                            <th class="px-6 py-3.5 text-right">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-border-c text-sm">
                                        <% if (recentStartups.isEmpty()) { %>
                                        <tr>
                                            <td colspan="5" class="px-6 py-16 text-center text-text-muted">
                                                <span class="material-symbols-outlined text-4xl mb-2 block"
                                                    style="font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 48">rocket_launch</span>
                                                <p class="font-semibold text-text-main">No startups yet</p>
                                                <p class="text-sm mt-1">Approved startups will appear here. <a
                                                        href="browse_startups.jsp"
                                                        class="text-primary hover:underline font-semibold">Browse
                                                        startups</a> to get started.</p>
                                            </td>
                                        </tr>
                                        <% } else { %>
                                            <% for(Map<String,Object> s : recentStartups) { %>
                                            <tr class="hover:bg-bg-light transition-colors">
                                                <td class="px-6 py-4 font-semibold"><div class="flex items-center gap-3"><div class="size-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center"><span class="material-symbols-outlined text-[18px]">rocket_launch</span></div><%= s.get("title") %></div></td>
                                                <td class="px-6 py-4 text-text-muted"><span class="bg-surface border border-border-c px-2 py-1 rounded-md text-xs font-medium"><%= s.get("domain") %></span></td>
                                                <td class="px-6 py-4 text-text-muted"><span class="bg-surface border border-border-c px-2 py-1 rounded-md text-xs font-medium"><%= s.get("stage") %></span></td>
                                                <td class="px-6 py-4"><span class="flex items-center gap-1.5 text-xs font-bold text-amber-700 bg-amber-50 px-2 py-1 rounded-full w-fit"><span class="material-symbols-outlined text-[14px]">shield</span><%= s.get("riskLevel") %> Risk</span></td>
                                                <td class="px-6 py-4 text-right"><a href="startup_detail.jsp?id=<%= s.get("id") %>" class="text-primary hover:text-primary-dark font-semibold text-sm">View Details →</a></td>
                                            </tr>
                                            <% } %>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 fade-up stagger-3">
                            <a href="browse_startups.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                                <div
                                    class="size-12 rounded-full bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-[24px]">explore</span>
                                </div>
                                <span class="text-sm font-semibold text-center">Browse Startups</span>
                            </a>
                            <a href="portfolio"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                                <div
                                    class="size-12 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 group-hover:bg-blue-600 group-hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-[24px]">pie_chart</span>
                                </div>
                                <span class="text-sm font-semibold text-center">My Portfolio</span>
                            </a>
                            <a href="notifications.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                                <div
                                    class="size-12 rounded-full bg-amber-50 flex items-center justify-center text-amber-600 group-hover:bg-amber-600 group-hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-[24px]">notifications</span>
                                </div>
                                <span class="text-sm font-semibold text-center">Notifications</span>
                            </a>
                            <a href="settings.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                                <div
                                    class="size-12 rounded-full bg-gray-100 flex items-center justify-center text-gray-600 group-hover:bg-gray-600 group-hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-[24px]">settings</span>
                                </div>
                                <span class="text-sm font-semibold text-center">Settings</span>
                            </a>
                        </div>
                    </main>
                </div>
                <script>
                    setTimeout(() => { document.querySelectorAll('.bar-fill[data-pct]').forEach(el => { el.style.width = el.dataset.pct + '%'; }); }, 300);
                </script>
            </body>

            </html>
