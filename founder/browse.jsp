<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
    <%@ page import="java.util.*, com.investify.db.DBConnection, java.sql.*" %>
        <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
            return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
            session.getAttribute("user_name"); %>

            <% // Fetch approved startups from DB 
List<Map<String, Object>> startups = new ArrayList<>();
                    try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT * FROM startup WHERE status = 'approved' ORDER BY created_at DESC";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                    Map<String, Object> s = new HashMap<>();
                            s.put("id", rs.getInt("id"));
                            s.put("title", rs.getString("title"));
                            s.put("domain", rs.getString("domain"));
                            s.put("stage", rs.getString("stage"));
                            s.put("fundingGoal", rs.getDouble("funding_goal"));
                            s.put("fundingRaised", rs.getDouble("funding_raised"));
                            s.put("riskLevel", rs.getString("risk_level"));
                            s.put("logo", rs.getString("logo"));
                            startups.add(s);
                            }
                            } catch (Exception e) {
                            e.printStackTrace();
                            }

                            // Build bg color map for logo icons
                            Map<String, String> bgMap = new HashMap<>();
                                    bgMap.put("currency_exchange", "bg-primary/10 text-primary");
                                    bgMap.put("biotech", "bg-green-100 text-green-600");
                                    bgMap.put("bolt", "bg-blue-100 text-blue-600");
                                    bgMap.put("precision_manufacturing", "bg-purple-100 text-purple-600");
                                    bgMap.put("agriculture", "bg-lime-100 text-lime-600");
                                    bgMap.put("candlestick_chart", "bg-teal-100 text-teal-600");
                                    %>
                                    <!DOCTYPE html>
                                    <html lang="en">

                                    <head>
                                        <meta charset="utf-8" />
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                                        <title>Investify – Browse Startups (Founder View)</title>
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
                                        </style>
                                    </head>

                                    <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">

                                        <!-- FOUNDER NAV -->
                                        <header
                                            class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                                            <div class="flex items-center gap-8">
                                                <a href="../index.jsp" class="flex items-center gap-3">
                                                    <div
                                                        class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                                                        <span class="material-symbols-outlined text-xl">diamond</span>
                                                    </div>
                                                    <span class="text-lg font-bold">Investify</span>
                                                </a>
                                                <span
                                                    class="hidden md:block text-xs font-bold uppercase tracking-widest text-primary bg-primary/10 rounded-full px-3 py-1">Founder
                                                    Portal</span>
                                            </div>
                                            <nav class="hidden lg:flex items-center gap-6">
            <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">My Startup</a>
            <a href="requests.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Requests</a>
            <a href="schemes.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Schemes</a>
            <a href="messages.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Messages</a>
            <a href="settings.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Settings</a>
        </nav>
                                            <div class="flex items-center gap-4">
                                                <a href="messages.jsp"
                                                    class="relative p-2 text-text-muted hover:text-primary transition-colors">
                                                    <span class="material-symbols-outlined">notifications</span>
                                                    <span
                                                        class="absolute top-2 right-2 h-2 w-2 rounded-full bg-primary ring-2 ring-white"></span>
                                                </a>
                                                <a href="create_profile.jsp">
                                                    <img src="https://i.pravatar.cc/36?img=25"
                                                        class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                                                        alt="Founder" />
                                                </a>
                                            </div>
                                        </header>

                                        <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-6">
                                            <!-- Info banner -->
                                            <div
                                                class="flex items-start gap-3 bg-primary/5 border border-primary/20 rounded-xl px-5 py-4">
                                                <span class="material-symbols-outlined text-primary mt-0.5">info</span>
                                                <div>
                                                    <p class="text-sm font-semibold">You are viewing as a Founder
                                                    </p>
                                                    <p class="text-xs text-text-muted mt-0.5">Browse the portal to
                                                        research
                                                        competitors, find collaborators,
                                                        or understand what investors are looking for. Your own
                                                        listing is
                                                        managed in <a href="create_profile.jsp"
                                                            class="text-primary hover:underline font-semibold">My
                                                            Startup</a>.
                                                    </p>
                                                </div>
                                            </div>

                                            <!-- Filters row -->
                                            <div class="flex flex-wrap gap-3 items-center justify-between">
                                                <div class="flex items-center gap-2 bg-surface border border-border-c rounded-xl p-0.5"
                                                    id="domain-tabs">
                                                    <button onclick="filterDomain('All',this)"
                                                        class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold">All</button>
                                                    <button onclick="filterDomain('Fintech',this)"
                                                        class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">Fintech</button>
                                                    <button onclick="filterDomain('Healthcare',this)"
                                                        class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">Healthcare</button>
                                                    <button onclick="filterDomain('AI',this)"
                                                        class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">AI
                                                        & Robotics</button>
                                                    <button onclick="filterDomain('Sustainability',this)"
                                                        class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">Sustainability</button>
                                                </div>
                                                <div class="relative">
                                                    <span
                                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-text-muted text-[18px]">search</span>
                                                    <input type="text" placeholder="Search startups…" id="search-input"
                                                        oninput="renderCards()"
                                                        class="pl-9 pr-4 py-2.5 rounded-xl border border-border-c bg-surface text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors w-56" />
                                                </div>
                                            </div>

                                            <!-- Cards grid -->
                                            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-5" id="cards-grid">
                                            </div>
                                        </main>

                                        <script>
                                            // Data injected from database via JSP
                                            const STARTUPS = [
        <% for (int i = 0; i < startups.size(); i++) {
                                                Map < String, Object > s = startups.get(i);
            String logo = (String) s.get("logo");
                                                if (logo == null) logo = "business";
            String bg = bgMap.getOrDefault(logo, "bg-gray-100 text-gray-600");
            double goal = (Double) s.get("fundingGoal");
            double raised = (Double) s.get("fundingRaised");
            int pct = goal > 0 ? (int) Math.round((raised / goal) * 100) : 0;
            String raisedFmt = raised >= 1000000 ? String.format("$%.1fM", raised / 1000000) : String.format("$%.0fK", raised / 1000);
            String goalFmt = goal >= 1000000 ? String.format("$%.1fM", goal / 1000000) : String.format("$%.0fK", goal / 1000);
        %>
                                                    { id: <%= s.get("id") %>, name: '<%= ((String)s.get("title")).replace("'", "\\'") %>', domain: '<%= s.get("domain") %>', stage: '<%= s.get("stage") %>', logo: '<%= logo %>', bg: '<%= bg %>', raised: '<%= raisedFmt %>', goal: '<%= goalFmt %>', pct: <%= pct %>, risk: '<%= s.get("riskLevel") %>'
                                            }<%= (i < startups.size() - 1) ? "," : "" %>
        <% } %>
        ];
                                            let domainFilter = 'All';
                                            function filterDomain(d, btn) {
                                                domainFilter = d;
                                                document.querySelectorAll('#domain-tabs button').forEach(b => b.className = 'px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors');
                                                btn.className = 'px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold';
                                                renderCards();
                                            }
                                            function renderCards() {
                                                const q = document.getElementById('search-input').value.toLowerCase();
                                                const filtered = STARTUPS.filter(s => (domainFilter === 'All' || s.domain === domainFilter || (domainFilter === 'AI' && s.domain === 'AI & Robotics')) && (s.name.toLowerCase().includes(q) || s.domain.toLowerCase().includes(q)));
                                                document.getElementById('cards-grid').innerHTML = filtered.map(s => `
    <div class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden hover:shadow-md transition-all">
      <div class="p-5 flex items-center gap-3 border-b border-border-c">
        <div class="size-11 rounded-xl <%="$"%>{s.bg} flex items-center justify-center"><span class="material-symbols-outlined text-[22px]"><%="$"%>{s.logo}</span></div>
        <div class="flex-1 min-w-0"><p class="font-bold text-sm truncate"><%="$"%>{s.name}</p><p class="text-xs text-text-muted"><%="$"%>{s.domain} · <%="$"%>{s.stage}</p></div>
        <span class="text-xs font-bold px-2.5 py-0.5 rounded-full <%="$"%>{s.risk === 'Low' ? 'bg-emerald-50 text-emerald-700' : s.risk === 'Medium' ? 'bg-amber-50 text-amber-700' : 'bg-red-50 text-red-600'}"><%="$"%>{s.risk} Risk</span>
      </div>
      <div class="p-5 flex flex-col gap-3">
        <div class="flex justify-between text-sm"><span class="text-text-muted">Raised</span><span class="font-bold"><%="$"%>{s.raised} / <%="$"%>{s.goal}</span></div>
        <div class="h-2 bg-bg-light rounded-full overflow-hidden"><div class="h-full bg-primary rounded-full" style="width:<%="$"%>{s.pct}%"></div></div>
        <p class="text-xs text-text-muted"><%="$"%>{s.pct}% of goal</p>
        <a href="startup_detail.jsp?id=<%="$"%>{s.id}" class="mt-1 h-9 rounded-full border border-border-c text-xs font-semibold flex items-center justify-center gap-1.5 hover:border-primary hover:text-primary transition-colors">
          <span class="material-symbols-outlined text-[16px]">open_in_new</span>View Listing
        </a>
      </div>
    </div>`).join('');
                                            }
                                            renderCards();
                                        </script>
                                    </body>

                                    </html>
