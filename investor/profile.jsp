<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*, com.investify.db.DBConnection" %>
        <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
            return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
            session.getAttribute("user_name"); String userEmail=(String) session.getAttribute("userEmail"); %>
            <% String phone="" ; String initials="U" ; if (userName !=null && !userName.isEmpty()) {
                initials=userName.substring(0, 1).toUpperCase(); } int activeDeals=0; double currentVal=0; double
                realizedGains=0; double invested=0; try (Connection conn=DBConnection.getConnection()) {
                PreparedStatement psUser=conn.prepareStatement("SELECT phone FROM users WHERE id=?"); psUser.setInt(1,
                userId); ResultSet rsUser=psUser.executeQuery(); if (rsUser.next()) { phone=rsUser.getString("phone")
                !=null ? rsUser.getString("phone") : "" ; } PreparedStatement psInv=conn.prepareStatement("SELECT COUNT(*), SUM(amount) FROM investment_request WHERE investor_id=? AND status='accepted'");
        psInv.setInt(1, userId);
        ResultSet rsInv = psInv.executeQuery();
        if (rsInv.next()) {
            activeDeals = rsInv.getInt(1);
            invested = rsInv.getDouble(2);
            currentVal = invested * 1.18;
            realizedGains = invested * 0.22;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang=" en">

                <head>
                    <meta charset="utf-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Investify – Profile</title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800&display=swap"
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
                    <header
                        class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                        <a href="../index.jsp" class="flex items-center gap-3">
                            <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                                    class="material-symbols-outlined text-xl">diamond</span></div><span
                                class="text-lg font-bold">Investify</span>
                        </a>
                        <nav class="hidden lg:flex items-center gap-6">
                            <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
                            <a href="browse_startups.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Browse</a>
                            <a href="portfolio.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Portfolio</a>
                            <a href="watchlist.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Watchlist</a>
                            <a href="insights.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Insights</a>
                            <a href="notifications.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Notifications</a>
                        </nav>
                        <a href="profile.jsp"
                            class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary text-white font-bold text-sm uppercase"
                            title="Profile">
                            <%= userName !=null && !userName.isEmpty() ? userName.substring(0,1) : "U" %>
                        </a>
                    </header>
                    <main class="max-w-4xl mx-auto px-6 py-8 flex flex-col gap-6"> <!-- Profile hero -->
                        <div class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden">
                            <div class="h-32 bg-gradient-to-r from-primary/20 to-primary/5"></div>
                            <div class="px-8 pb-8 -mt-12">
                                <div class="flex items-end gap-5 mb-5">
                                    <div class="relative">
                                        <div
                                            class="h-24 w-24 rounded-2xl border-4 border-white shadow-md bg-white flex items-center justify-center text-4xl font-black text-primary">
                                            <%= initials %>
                                        </div> <button
                                            class="absolute -bottom-2 -right-2 h-8 w-8 rounded-full bg-primary text-white flex items-center justify-center shadow-md hover:bg-primary-dark transition-colors"><span
                                                class="material-symbols-outlined text-[16px]">edit</span></button>
                                    </div>
                                    <div class="pb-2">
                                        <h1 class="text-2xl font-black">
                                            <%= userName %>
                                        </h1>
                                        <p class="text-text-muted text-sm">Angel Investor</p>
                                        <div class="flex items-center gap-2 mt-1"><span
                                                class="bg-primary/10 text-primary-dark text-xs font-bold px-2.5 py-0.5 rounded-full">Verified
                                                Investor</span><span
                                                class="bg-emerald-50 text-emerald-700 text-xs font-bold px-2.5 py-0.5 rounded-full">KYC
                                                Complete</span></div>
                                    </div> <a href="settings.jsp"
                                        class="ml-auto pb-2 flex items-center gap-2 h-10 px-5 rounded-full border border-border-c text-sm font-semibold hover:bg-bg-light transition-colors"><span
                                            class="material-symbols-outlined text-[18px]">edit</span>Edit Profile</a>
                                </div>
                                <p class="text-text-muted leading-relaxed max-w-2xl text-sm">Investor on Investify
                                    platform.</p>
                            </div>
                        </div>
                        <div class="grid md:grid-cols-3 gap-6"> <!-- Stats -->
                            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 space-y-5">
                                <h2 class="text-lg font-bold">Investment Summary</h2>
                                <div class="space-y-4">
                                    <div class="flex justify-between text-sm"><span class="text-text-muted">Total
                                            Invested</span><span class="font-bold">$<%= String.format("%,.0f", invested)
                                                %> </span></div>
                                    <div class="flex justify-between text-sm"><span class="text-text-muted">Current
                                            Value</span><span class="font-bold text-emerald-600">$<%=
                                                String.format("%,.0f", currentVal) %></span></div>
                                    <div class="flex justify-between text-sm"><span class="text-text-muted">Realized
                                            Gains</span><span class="font-bold text-emerald-600">$<%=
                                                String.format("%,.0f", realizedGains) %></span></div>
                                    <div class="flex justify-between text-sm"><span class="text-text-muted">Active
                                            Deals</span><span class="font-bold">
                                            <%= activeDeals %>
                                        </span></div>
                                    <div class="flex justify-between text-sm"><span class="text-text-muted">Successful
                                            Exits</span><span class="font-bold">0</span></div>
                                </div>
                            </div> <!-- Details -->
                            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 md:col-span-2">
                                <h2 class="text-lg font-bold mb-5">Personal Details</h2>
                                <div class="grid md:grid-cols-2 gap-4">
                                    <div><label
                                            class="block text-xs font-bold uppercase tracking-wider text-text-muted mb-1.5">Full
                                            Name</label><input type="text"
                                            value="<%= userName != null ? userName : "" %>"
                                            class="w-full rounded-xl border border-border-c bg-bg-light px-4 py-2.5 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                    </div>
                                    <div><label
                                            class="block text-xs font-bold uppercase tracking-wider text-text-muted mb-1.5">Email</label><input
                                            type="email" value="<%= userEmail != null ? userEmail : "" %>" disabled
                                            class="w-full rounded-xl border border-border-c bg-gray-100 px-4 py-2.5 text-sm cursor-not-allowed opacity-70" />
                                    </div>
                                    <div><label
                                            class="block text-xs font-bold uppercase tracking-wider text-text-muted mb-1.5">Phone</label><input
                                            type="tel" value="<%= phone != null ? phone : "" %>"
                                            class="w-full rounded-xl border border-border-c bg-bg-light px-4 py-2.5 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                    </div>
                                    <div><label
                                            class="block text-xs font-bold uppercase tracking-wider text-text-muted mb-1.5">Location</label><input
                                            type="text" value="" placeholder="Enter your location"
                                            class="w-full rounded-xl border border-border-c bg-bg-light px-4 py-2.5 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                    </div>
                                    <div><label
                                            class="block text-xs font-bold uppercase tracking-wider text-text-muted mb-1.5">Investment
                                            Focus</label><input type="text" value=""
                                            placeholder="e.g. FinTech, HealthTech"
                                            class="w-full rounded-xl border border-border-c bg-bg-light px-4 py-2.5 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                    </div>
                                    <div><label
                                            class="block text-xs font-bold uppercase tracking-wider text-text-muted mb-1.5">Min
                                            Ticket Size</label><input type="text" value="" placeholder="e.g. $10,000"
                                            class="w-full rounded-xl border border-border-c bg-bg-light px-4 py-2.5 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                    </div>
                                </div>
                                <button
                                    class="mt-6 h-10 px-6 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)]">Save
                                    Changes</button>
                            </div>
                        </div>

                        <!-- Quick links -->
                        <div class="grid grid-cols-3 gap-4"> <a href="portfolio"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all"><span
                                    class="material-symbols-outlined text-primary text-[22px]">pie_chart</span><span
                                    class="text-sm font-semibold">My Portfolio</span></a> <a href="notifications.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all"><span
                                    class="material-symbols-outlined text-primary text-[22px]">notifications</span><span
                                    class="text-sm font-semibold">Notifications</span></a> <a href="settings.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all"><span
                                    class="material-symbols-outlined text-primary text-[22px]">settings</span><span
                                    class="text-sm font-semibold">Settings</span></a>
                        </div>
                    </main>
                </body>

                </html>
