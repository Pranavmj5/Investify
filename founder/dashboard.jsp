<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
        <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
            return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
            session.getAttribute("user_name"); %>

            <%
                if (userName == null) userName = "Founder";
                int investorInterest = 0;
                double fundingGoal = 0;
                double fundingRaised = 0;
                double storedFundingRaised = 0;
                int fundingPercent = 0;
                int profileViews = 0;
                String startupName = "No Startup Registered";
                int primaryStartupId = -1;
                List<Map<String, String>> requestsList = new ArrayList<>();

                try (Connection conn = DBConnection.getConnection()) {

                    // ── 1. Find the startup for this founder that has investment requests (prefer one with requests) ──
                    PreparedStatement psFind = conn.prepareStatement(
                        "SELECT s.id, s.title, s.funding_goal, s.funding_raised, s.profile_views " +
                        "FROM startup s " +
                        "WHERE s.founder_id = ? " +
                        "ORDER BY (SELECT COUNT(*) FROM investment_request ir WHERE ir.startup_id = s.id) DESC, s.id ASC " +
                        "LIMIT 1");
                    psFind.setInt(1, userId);
                    ResultSet rsFind = psFind.executeQuery();
                    if (rsFind.next()) {
                        primaryStartupId    = rsFind.getInt("id");
                        startupName         = rsFind.getString("title");
                        fundingGoal         = rsFind.getDouble("funding_goal");
                        storedFundingRaised = rsFind.getDouble("funding_raised");
                        profileViews        = rsFind.getInt("profile_views");
                    }
                    rsFind.close(); psFind.close();

                    if (primaryStartupId != -1) {

                        // ── 2. Count all requests for this startup ──
                        PreparedStatement psCount = conn.prepareStatement(
                            "SELECT COUNT(*) FROM investment_request WHERE startup_id = ?");
                        psCount.setInt(1, primaryStartupId);
                        ResultSet rsCount = psCount.executeQuery();
                        if (rsCount.next()) investorInterest = rsCount.getInt(1);
                        rsCount.close(); psCount.close();

                        // ── 3. Sum accepted investment amounts dynamically ──
                        PreparedStatement psSum = conn.prepareStatement(
                            "SELECT COALESCE(SUM(amount), 0) FROM investment_request " +
                            "WHERE startup_id = ? AND LOWER(TRIM(status)) = 'accepted'");
                        psSum.setInt(1, primaryStartupId);
                        ResultSet rsSum = psSum.executeQuery();
                        if (rsSum.next()) fundingRaised = rsSum.getDouble(1);
                        rsSum.close(); psSum.close();

                        // Fall back to stored value only if no accepted requests exist
                        if (fundingRaised == 0) fundingRaised = storedFundingRaised;

                        if (fundingGoal > 0)
                            fundingPercent = (int)(fundingRaised / fundingGoal * 100);

                        // ── 4. Recent investor requests ──
                        PreparedStatement psReq = conn.prepareStatement(
                            "SELECT ir.id, ir.amount, ir.message, ir.status, ir.created_at, " +
                            "       u.name AS investor_name, u.email AS investor_email " +
                            "FROM investment_request ir " +
                            "JOIN users u ON ir.investor_id = u.id " +
                            "WHERE ir.startup_id = ? " +
                            "ORDER BY ir.created_at DESC LIMIT 5");
                        psReq.setInt(1, primaryStartupId);
                        ResultSet rsReq = psReq.executeQuery();
                        while (rsReq.next()) {
                            Map<String, String> req = new HashMap<>();
                            req.put("id",            String.valueOf(rsReq.getInt("id")));
                            req.put("investor_name", rsReq.getString("investor_name"));
                            req.put("amount",        String.valueOf(rsReq.getDouble("amount")));
                            req.put("message",       rsReq.getString("message"));
                            req.put("status",        rsReq.getString("status"));
                            req.put("created_at",    rsReq.getString("created_at"));
                            requestsList.add(req);
                        }
                        rsReq.close(); psReq.close();
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    startupName = "Error loading data: " + e.getMessage();
                }

                String fmtRaised = fundingRaised >= 1_000_000
                    ? String.format("$%.1fM", fundingRaised / 1_000_000)
                    : String.format("$%.0fK", fundingRaised / 1_000);
                String fmtGoal = fundingGoal >= 1_000_000
                    ? String.format("$%.1fM", fundingGoal / 1_000_000)
                    : String.format("$%.0fK", fundingGoal / 1_000);
                double strokeOffset = 251.2 - (251.2 * fundingPercent / 100.0);
            %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>Investify – Founder Dashboard</title>
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

                        .bar-fill {
                            width: 0;
                            transition: width 1.1s cubic-bezier(.25, .8, .25, 1)
                        }
                    </style>
                </head>

                <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
                    <header
                        class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                        <div class="flex items-center gap-8">
                            <a href="../index.jsp" class="flex items-center gap-3">
                                <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                                    <span class="material-symbols-outlined text-xl">diamond</span></div><span
                                    class="text-lg font-bold">Investify</span>
                            </a>
                            <span
                                class="hidden md:block text-xs font-bold uppercase tracking-widest text-primary bg-primary/10 rounded-full px-3 py-1">Founder
                                Portal</span>
                        </div>
                        <nav class="hidden lg:flex items-center gap-6">
            <a href="dashboard.jsp" class="text-sm font-semibold text-primary">My Startup</a>
            <a href="requests.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Requests</a>
            <a href="schemes.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Schemes</a>
            <a href="messages.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Messages</a>
            <a href="settings.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Settings</a>
        </nav>
                        <div class="flex items-center gap-4">
                            <a href="messages.jsp"
                                class="relative p-2 text-text-muted hover:text-primary transition-colors"><span
                                    class="material-symbols-outlined">notifications</span><span
                                    class="absolute top-2 right-2 h-2 w-2 rounded-full bg-primary ring-2 ring-white"></span></a>
                            <a href="create_profile.jsp">
                                <img src="https://i.pravatar.cc/36?img=25"
                                    class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                                    alt="Founder" />
                            </a>
                        </div>
                    </header>
                    <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-8">
                        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                            <div>
                                <h1 class="text-3xl font-black">Welcome, <%= userName %>
                                </h1>
                                <p class="text-text-muted mt-1">Manage your startup profile and investor interactions.
                                </p>
                            </div>
                            <a href="create_profile.jsp"
                                class="flex items-center gap-2 h-10 px-5 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)]">
                                <span class="material-symbols-outlined text-[18px]">edit</span>Edit Startup Profile
                            </a>
                        </div>

                        <!-- Stats -->
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-5">
                            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-2">Profile Views
                                </p>
                                <p class="text-3xl font-black"><%= profileViews %></p>
                                <p class="text-xs text-text-muted font-semibold mt-1">Analytics</p>
                            </div>
                            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-2">Investor
                                    Interest
                                </p>
                                <p class="text-3xl font-black">
                                    <%= investorInterest %>
                                </p>
                                <p class="text-xs text-emerald-600 font-semibold mt-1">total requests</p>
                            </div>
                            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-2">Funding
                                    Progress
                                </p>
                                <p class="text-3xl font-black">
                                    <%= fundingPercent %>%
                                </p>
                                <p class="text-xs text-text-muted font-semibold mt-1">
                                    <%= fmtRaised %> of <%= fmtGoal %>
                                </p>
                            </div>
                            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-2">Days
                                    Remaining
                                </p>
                                <p class="text-3xl font-black">�</p>
                                <p class="text-xs text-text-muted font-semibold mt-1">No active campaign</p>
                            </div>
                        </div>

                        <div class="grid md:grid-cols-3 gap-6">
                            <!-- Funding progress -->
                            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6">
                                <h2 class="text-lg font-bold mb-4">Funding Progress</h2>
                                <div class="text-center mb-5">
                                    <div class="relative w-28 h-28 mx-auto">
                                        <svg class="w-full h-full -rotate-90" viewBox="0 0 100 100">
                                            <circle cx="50" cy="50" r="40" fill="none" stroke="#f0efe9"
                                                stroke-width="12" />
                                            <circle cx="50" cy="50" r="40" fill="none" stroke="#c6a65d"
                                                stroke-width="12" stroke-dasharray="251.2"
                                                stroke-dashoffset="<%= String.format(" %.1f", strokeOffset) %>"
                                                stroke-linecap="round" />
                                        </svg>
                                        <div class="absolute inset-0 flex items-center justify-center flex-col">
                                            <span class="text-2xl font-black">
                                                <%= fundingPercent %>%
                                            </span>
                                            <span class="text-[10px] text-text-muted">funded</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="space-y-2 text-sm">
                                    <div class="flex justify-between"><span class="text-text-muted">Raised</span><span
                                            class="font-bold">
                                            <%= fmtRaised %>
                                        </span></div>
                                    <div class="flex justify-between"><span class="text-text-muted">Goal</span><span
                                            class="font-bold">
                                            <%= fmtGoal %>
                                        </span></div>
                                    <div class="flex justify-between"><span
                                            class="text-text-muted">Investors</span><span class="font-bold">
                                            <%= investorInterest %>
                                        </span></div>
                                </div>
                            </div>

                            <!-- Recent investor interest -->
                            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 md:col-span-2">
                                <div class="flex items-center justify-between mb-4">
                                    <h2 class="text-lg font-bold">Recent Investor Interest</h2>
                                    <span class="text-xs font-bold text-text-muted uppercase tracking-wider">Latest <%= requestsList.size() %> Requests</span>
                                </div>
                                <div class="space-y-3">
                                <% if (requestsList.isEmpty()) { %>
                                    <div class="text-center py-10 text-text-muted">
                                        <span class="material-symbols-outlined text-4xl mb-2 block"
                                            style="font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 48">group</span>
                                        <p class="font-semibold text-text-main">No investor interest yet</p>
                                        <p class="text-sm mt-1">Investor interest will appear here when investors show
                                            interest in your startup.</p>
                                    </div>
                                <% } else {
                                     for(Map<String, String> req : requestsList){
                                         String reqAmtStr = "$" + String.format("%,.0f", Double.parseDouble(req.get("amount")));
                                         String msg = req.get("message");
                                         if(msg == null || msg.trim().isEmpty()) { msg = "No message provided."; }
                                %>
                                    <div class="flex items-start gap-4 p-4 rounded-xl border border-border-c bg-bg-light">
                                        <div class="h-10 w-10 shrink-0 rounded-full bg-primary/10 text-primary flex items-center justify-center font-bold">
                                            <%= req.get("investor_name").substring(0,1).toUpperCase() %>
                                        </div>
                                        <div class="flex-1">
                                            <div class="flex justify-between items-start">
                                                <p class="font-bold"><%= req.get("investor_name") %></p>
                                                <span class="text-primary font-black"><%= reqAmtStr %></span>
                                            </div>
                                            <p class="text-sm text-text-muted mt-1"><%= msg %></p>
                                            <div class="mt-2 flex items-center justify-between gap-2">
                                                <% 
                                                    String status = req.get("status");
                                                    if (status != null) status = status.trim();
                                                    String badgeClass = "bg-amber-100 text-amber-800";
                                                    if ("accepted".equalsIgnoreCase(status)) badgeClass = "bg-green-100 text-green-800 border-green-200";
                                                    else if ("rejected".equalsIgnoreCase(status)) badgeClass = "bg-red-100 text-red-800 border-red-200";
                                                %>
                                                <span class="text-xs font-semibold px-2 py-1 rounded border <%= badgeClass %> uppercase tracking-wider"><%= status %></span>
                                                
                                                <% if ("pending".equalsIgnoreCase(status)) { %>
                                                <form action="<%= request.getContextPath() %>/founder/investment-decision" method="POST" class="flex items-center gap-2 m-0">
                                                    <input type="hidden" name="requestId" value="<%= req.get("id") %>">
                                                    <button type="submit" name="action" value="accept" class="px-3 py-1.5 rounded-md text-xs font-bold bg-green-600 text-white hover:bg-green-700 transition-colors shadow-sm">Accept</button>
                                                    <button type="submit" name="action" value="reject" class="px-3 py-1.5 rounded-md text-xs font-bold bg-red-600 text-white hover:bg-red-700 transition-colors shadow-sm">Reject</button>
                                                </form>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                <%   }
                                   } %>
                                </div>
                            </div>
                        </div>

                        <!-- Quick actions -->
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                            <a href="create_profile.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                                <div
                                    class="size-12 rounded-full bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-[22px]">edit_document</span>
                                </div>
                                <span class="text-sm font-semibold text-center">Edit Profile</span>
                            </a>
                            <a href="browse.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                                <div
                                    class="size-12 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 group-hover:bg-blue-600 group-hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-[22px]">explore</span>
                                </div>
                                <span class="text-sm font-semibold text-center">Browse Portal</span>
                            </a>
                            <a href="messages.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                                <div
                                    class="size-12 rounded-full bg-amber-50 flex items-center justify-center text-amber-600 group-hover:bg-amber-600 group-hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-[22px]">message</span>
                                </div>
                                <span class="text-sm font-semibold text-center">Messages</span>
                            </a>
                            <a href="settings.jsp"
                                class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                                <div
                                    class="size-12 rounded-full bg-gray-100 flex items-center justify-center text-gray-600 group-hover:bg-gray-600 group-hover:text-white transition-colors">
                                    <span class="material-symbols-outlined text-[22px]">settings</span>
                                </div>
                                <span class="text-sm font-semibold text-center">Settings</span>
                            </a>
                        </div>
                    </main>
                </body>

                </html>
