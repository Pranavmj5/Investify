<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String userName = (String) session.getAttribute("user_name");
    
    // Fetch attributes from PortfolioServlet
    List<Map<String, Object>> investments = (List<Map<String, Object>>) request.getAttribute("investments");
    Double totalInvested = (Double) request.getAttribute("totalInvested");
    Integer activeDeals = (Integer) request.getAttribute("activeDeals");
    Integer pendingInterest = (Integer) request.getAttribute("pendingInterest");
    
    // Default values if navigated directly (though they should use the servlet)
    if (investments == null) {
        response.sendRedirect(request.getContextPath() + "/investor/portfolio");
        return;
    }
    if (totalInvested == null) totalInvested = 0.0;
    if (activeDeals == null) activeDeals = 0;
    if (pendingInterest == null) pendingInterest = 0;
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Investify – My Portfolio</title>
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800&display=swap"
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
    </style>
</head>

<body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
    <!-- TOPBAR -->
    <header
        class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
        <div class="flex items-center gap-8">
            <a href="../index.jsp" class="flex items-center gap-3">
                <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                        class="material-symbols-outlined text-xl">diamond</span></div>
                <span class="text-lg font-bold">Investify</span>
            </a>
        </div>
        <nav class="hidden lg:flex items-center gap-6">
                            <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
                            <a href="browse_startups.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Browse</a>
                            <a href="portfolio.jsp" class="text-sm font-semibold text-primary">Portfolio</a>
                            <a href="watchlist.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Watchlist</a>
                            <a href="insights.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Insights</a>
                            <a href="notifications.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Notifications</a>
                        </nav>
        <div class="flex items-center gap-4">
            <a href="notifications.jsp"
                class="relative p-2 text-text-muted hover:text-primary transition-colors"><span
                    class="material-symbols-outlined">notifications</span><span
                    class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span></a>
            <a href="profile.jsp"
                class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary text-white font-bold text-sm uppercase"
                title="Profile">
                <%= userName !=null && !userName.isEmpty() ? userName.substring(0,1) : "U" %>
            </a>
        </div>
    </header>

    <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-8">
        <div>
            <h1 class="text-3xl font-black">My Portfolio</h1>
            <p class="text-text-muted mt-1">Track all your investments and returns in one place.</p>
        </div>

        <!-- Summary cards -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-5">
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-2">Total Invested</p>
                <p class="text-3xl font-black">$<%= String.format("%,.0f", totalInvested) %></p>
                <p class="text-xs text-text-muted font-semibold mt-1">Based on accepted deals</p>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-2">Current Value</p>
                <!-- For now, we assume value is equal to invested as there's no return calculation logic yet -->
                <p class="text-3xl font-black">$<%= String.format("%,.0f", totalInvested) %></p>
                <p class="text-xs text-text-muted font-semibold mt-1">Estimated</p>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-2">Active Deals</p>
                <p class="text-3xl font-black"><%= activeDeals %></p>
                <p class="text-xs text-text-muted font-semibold mt-1">Accepted Startups</p>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-2">Pending Interest</p>
                <p class="text-3xl font-black"><%= pendingInterest %></p>
                <p class="text-xs text-text-muted font-semibold mt-1">Awaiting approval</p>
            </div>
        </div>

        <!-- Portfolio table -->
        <div class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden">
            <div class="flex items-center justify-between px-6 py-5 border-b border-border-c">
                <h2 class="text-xl font-bold">Investment Holdings</h2>
                <a href="browse_startups.jsp"
                    class="text-sm font-bold text-primary hover:text-primary-dark flex items-center gap-1">Add
                    Investment <span class="material-symbols-outlined text-[18px]">add</span></a>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead class="bg-bg-light text-xs font-bold uppercase tracking-wider text-text-muted">
                        <tr>
                            <th class="px-6 py-3.5">Startup</th>
                            <th class="px-6 py-3.5">Invested</th>
                            <th class="px-6 py-3.5">Current Value</th>
                            <th class="px-6 py-3.5">Return</th>
                            <th class="px-6 py-3.5">Stage</th>
                            <th class="px-6 py-3.5">Status</th>
                            <th class="px-6 py-3.5">Date</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border-c">
                        <% if (investments.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="px-6 py-16 text-center text-text-muted">
                                <span class="material-symbols-outlined text-4xl mb-2 block"
                                    style="font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 48">account_balance_wallet</span>
                                <p class="font-semibold text-text-main">No investments yet</p>
                                <p class="text-sm mt-1">Your investment holdings will appear here. <a
                                        href="browse_startups.jsp"
                                        class="text-primary hover:underline font-semibold">Browse startups</a>
                                    to start investing.</p>
                            </td>
                        </tr>
                        <% } else {
                            for (Map<String, Object> inv : investments) {
                                double amount = (Double) inv.get("amount");
                        %>
                        <tr class="hover:bg-bg-light/50 transition-colors">
                            <td class="px-6 py-4 font-semibold"><%= inv.get("startupTitle") %></td>
                            <td class="px-6 py-4">$<%= String.format("%,.0f", amount) %></td>
                            <td class="px-6 py-4">$<%= String.format("%,.0f", amount) %></td> <!-- Placeholder -->
                            <td class="px-6 py-4 text-text-muted">-</td>
                            <td class="px-6 py-4"><span class="px-2.5 py-1 rounded-md text-xs font-bold bg-bg-light border border-border-c"><%= inv.get("stage") != null ? inv.get("stage") : "N/A" %></span></td>
                            <td class="px-6 py-4"><span class="px-2.5 py-1 rounded-md text-xs font-bold bg-green-50 text-green-700 border border-green-200">Accepted</span></td>
                            <td class="px-6 py-4 text-text-muted"><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(inv.get("created_at")) %></td>
                        </tr>
                        <%  } 
                           } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>

</html>
