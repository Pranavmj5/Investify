<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true"
    import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
        session.getAttribute("user_name"); 

        String sidParam = request.getParameter("id");
        if (sidParam != null && !sidParam.isEmpty()) {
            try (Connection cTracker = DBConnection.getConnection()) {
                PreparedStatement addView = cTracker.prepareStatement("UPDATE startup SET profile_views = profile_views + 1 WHERE id = ?");
                addView.setInt(1, Integer.parseInt(sidParam));
                addView.executeUpdate();
            } catch(Exception e) { e.printStackTrace(); }
        }
    %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
            <title id="page-title">Investify – Startup Detail</title>
            <meta name="description" content="Detailed startup investment profile on Investify." />
            <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet" />
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                rel="stylesheet" />
            <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
            <script>
                tailwind.config = {
                    darkMode: "class",
                    theme: {
                        extend: {
                            colors: {
                                primary: "#c6a65d", "primary-dark": "#b08d45", "primary-light": "#e3cea0",
                                "background-light": "#f8f7f6", "surface-light": "#ffffff",
                                "text-main": "#1e1b14", "text-muted": "#817a6a", "border-subtle": "#e6e2db"
                            },
                            fontFamily: { display: ["Public Sans", "sans-serif"] },
                            borderRadius: { DEFAULT: "1rem", lg: "2rem", xl: "3rem", full: "9999px" },
                            boxShadow: { soft: "0 4px 20px -2px rgba(198,166,93,.1)", glow: "0 0 15px rgba(198,166,93,.3)" }
                        }
                    }
                };
            </script>
            <style>
                .material-symbols-outlined {
                    font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24
                }

                .icon-fill {
                    font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24
                }

                @keyframes fadeUp {
                    from {
                        opacity: 0;
                        transform: translateY(20px)
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
                    animation-delay: .10s
                }

                .stagger-3 {
                    animation-delay: .15s
                }

                .stagger-4 {
                    animation-delay: .20s
                }

                /* Progress bar fill animation */
                .bar-fill {
                    width: 0;
                    transition: width 1.2s cubic-bezier(.25, .8, .25, 1)
                }

                /* Modal */
                #interest-modal {
                    transition: opacity .25s
                }

                /* Sticky CTA pulse */
                @keyframes glow {

                    0%,
                    100% {
                        box-shadow: 0 0 8px rgba(198, 166, 93, .3)
                    }

                    50% {
                        box-shadow: 0 0 20px rgba(198, 166, 93, .6)
                    }
                }

                .cta-pulse:hover {
                    animation: glow 1.5s infinite
                }
            </style>
        </head>

        <body class="bg-background-light font-display text-text-main antialiased min-h-screen flex flex-col">

            <!-- ═══════ NAVBAR ═══════ -->
            <header class="sticky top-0 z-50 w-full border-b border-border-subtle bg-surface-light/95 backdrop-blur-md">
                <div class="mx-auto flex h-18 max-w-7xl items-center justify-between px-6 py-4 lg:px-8">
                    <div class="flex items-center gap-8">
                        <a href="../index.jsp" class="flex items-center gap-3 group">
                            <div
                                class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white shadow-soft transition-transform group-hover:scale-105">
                                <span class="material-symbols-outlined text-xl">diamond</span>
                            </div>
                            <span class="text-xl font-bold tracking-tight">Investify</span>
                        </a>
                        <nav class="hidden md:flex items-center gap-8 pl-8 border-l border-border-subtle h-8">
                            <a href="dashboard.jsp"
                                class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
                            <a href="browse_startups.jsp"
                                class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Browse</a>
                            <a href="portfolio"
                                class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Portfolio</a>
                            <a href="watchlist.jsp"
                                class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Watchlist</a>
                            <a href="insights.jsp"
                                class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Insights</a>
                        </nav>
                    </div>
                    <div class="flex items-center gap-4">
                        <div
                            class="hidden lg:flex items-center rounded-full bg-background-light border border-border-subtle px-4 py-2 w-56 focus-within:border-primary focus-within:ring-1 focus-within:ring-primary/30 transition-all">
                            <span class="material-symbols-outlined text-text-muted text-[20px]">search</span>
                            <input
                                class="w-full border-none bg-transparent p-0 pl-3 text-sm placeholder:text-text-muted focus:ring-0"
                                placeholder="Search startups…" type="text" />
                        </div>
                        <button class="relative p-2 text-text-muted hover:text-primary transition-colors"
                            aria-label="Notifications">
                            <span class="material-symbols-outlined">notifications</span>
                            <span
                                class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span>
                        </button>
                        <button
                            class="h-9 w-9 rounded-full overflow-hidden ring-2 ring-transparent hover:ring-primary transition-all"
                            aria-label="User profile">
                            <div
                                class="h-9 w-9 rounded-full bg-primary text-white flex items-center justify-center font-bold text-xs uppercase">
                                <%= userName !=null && !userName.isEmpty() ? userName.substring(0,1) : "U" %>
                            </div>
                        </button>
                    </div>
                </div>
            </header>

            <!-- ═══════ MAIN ═══════ -->
            <main class="flex-grow">

                <!-- Breadcrumb + actions -->
                <div class="mx-auto max-w-7xl px-6 py-5 lg:px-8">
                    <div class="flex flex-wrap items-center justify-between gap-4">
                        <nav class="flex items-center gap-2 text-sm text-text-muted">
                            <a href="../index.jsp" class="hover:text-primary transition-colors">Home</a>
                            <span class="material-symbols-outlined text-xs">chevron_right</span>
                            <a href="browse_startups.jsp" class="hover:text-primary transition-colors">Startups</a>
                            <span class="material-symbols-outlined text-xs">chevron_right</span>
                            <span class="font-medium text-primary" id="breadcrumb-name">Loading…</span>
                        </nav>
                        <div class="flex gap-3">
                            <button id="save-btn" onclick="toggleSave()" aria-label="Save startup"
                                class="flex items-center gap-2 rounded-full border border-border-subtle bg-surface-light px-5 py-2 text-sm font-semibold text-text-main shadow-sm hover:bg-gray-50 transition-colors">
                                <span class="material-symbols-outlined text-[20px]" id="save-icon">bookmark</span>
                                <span id="save-label">Save</span>
                            </button>
                            <button onclick="shareStartup()"
                                class="flex items-center gap-2 rounded-full border border-border-subtle bg-surface-light px-5 py-2 text-sm font-semibold text-text-main shadow-sm hover:bg-gray-50 transition-colors">
                                <span class="material-symbols-outlined text-[20px]">share</span>
                                Share
                            </button>
                        </div>
                    </div>
                </div>

                <!-- ── Hero section ── -->
                <div class="mx-auto max-w-7xl px-6 pb-8 lg:px-8" id="hero-section">
                    <div class="grid gap-10 lg:grid-cols-[1fr_380px]">

                        <!-- Left: Info -->
                        <div class="flex flex-col gap-6 fade-up">
                            <!-- Logo + name -->
                            <div class="flex items-start gap-5">
                                <div
                                    class="h-20 w-20 shrink-0 overflow-hidden rounded-2xl border border-border-subtle bg-white p-2 shadow-soft">
                                    <img id="startup-logo" alt="Startup logo"
                                        class="h-full w-full object-contain rounded-xl" src="" />
                                </div>
                                <div>
                                    <h1 class="text-3xl md:text-4xl font-bold tracking-tight" id="startup-name">Loading…
                                    </h1>
                                    <p class="text-base text-text-muted mt-1" id="startup-tagline"></p>
                                </div>
                            </div>

                            <!-- Badges -->
                            <div class="flex flex-wrap gap-2" id="badges-row"></div>

                            <!-- Key stats -->
                            <div class="grid grid-cols-3 gap-5 py-5 border-y border-border-subtle">
                                <div>
                                    <p class="text-xs font-medium text-text-muted mb-1">Raised</p>
                                    <p class="text-2xl font-bold" id="stat-raised">—</p>
                                </div>
                                <div>
                                    <p class="text-xs font-medium text-text-muted mb-1">Valuation</p>
                                    <p class="text-2xl font-bold" id="stat-valuation">—</p>
                                </div>
                                <div>
                                    <p class="text-xs font-medium text-text-muted mb-1">Min Ticket</p>
                                    <p class="text-2xl font-bold" id="stat-min">—</p>
                                </div>
                            </div>

                            <!-- About -->
                            <div class="space-y-4">
                                <h2 class="text-xl font-semibold">About</h2>
                                <p class="text-text-muted leading-relaxed" id="startup-about"></p>

                                <!-- Progress bar: funding -->
                                <div class="mt-2">
                                    <div class="flex justify-between text-sm mb-1.5">
                                        <span class="text-text-muted font-medium">Funding Progress</span>
                                        <span class="font-bold text-primary" id="progress-pct">0%</span>
                                    </div>
                                    <div class="h-2.5 rounded-full bg-gray-100">
                                        <div id="progress-bar"
                                            class="h-full rounded-full bg-gradient-to-r from-primary-dark to-primary bar-fill">
                                        </div>
                                    </div>
                                    <div class="flex justify-between text-xs text-text-muted mt-1">
                                        <span id="progress-raised-label">Raised</span>
                                        <span id="progress-goal-label">Goal</span>
                                    </div>
                                </div>

                                <!-- CTA buttons -->
                                <div class="flex gap-4 pt-2">
                                    <a href="invest.jsp" id="cta-invest"
                                        class="flex-1 bg-primary hover:bg-primary-dark text-white font-semibold py-3 px-6 rounded-full shadow-lg cta-pulse transition-all duration-300 flex items-center justify-center gap-2">
                                        <span class="material-symbols-outlined text-[20px]">handshake</span>
                                        Invest Now
                                    </a>
                                    <button onclick="openModal()"
                                        class="px-6 py-3 rounded-full border border-primary text-primary font-semibold hover:bg-primary/5 transition-colors flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px]">send</span>
                                        Quick Interest
                                    </button>
                                    <a href="#" id="cta-deck" download
                                        class="px-6 py-3 rounded-full border border-border-subtle text-text-muted font-semibold hover:bg-background-light transition-colors flex items-center gap-2">
                                        <span class="material-symbols-outlined text-[20px]">download</span>
                                        Deck
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Right: Video pitch + Founder -->
                        <div class="relative fade-up stagger-2">
                            <div class="sticky top-24 flex flex-col gap-5">
                                <!-- Video -->
                                <div class="relative aspect-[4/3] w-full overflow-hidden rounded-2xl bg-black border-2 border-primary shadow-2xl cursor-pointer group"
                                    id="video-card" onclick="togglePlay()">
                                    <img id="video-thumb" src="" alt="Pitch video thumbnail"
                                        class="absolute inset-0 h-full w-full object-cover opacity-60 transition-transform duration-500 group-hover:scale-105" />
                                    <div class="absolute inset-0 flex items-center justify-center bg-black/20 group-hover:bg-black/10 transition-colors"
                                        id="play-overlay">
                                        <div
                                            class="flex h-18 w-18 items-center justify-center rounded-full bg-primary/90 text-white shadow-glow transition-transform group-hover:scale-110">
                                            <span class="material-symbols-outlined text-4xl icon-fill">play_arrow</span>
                                        </div>
                                    </div>
                                    <div
                                        class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-5">
                                        <div class="flex items-center justify-between text-white mb-2">
                                            <p class="font-medium text-sm">Pitch Presentation</p>
                                            <span class="text-xs opacity-70">3:45</span>
                                        </div>
                                        <div class="h-1 w-full rounded-full bg-white/20">
                                            <div class="h-full w-1/3 rounded-full bg-primary"></div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Founder card -->
                                <div class="rounded-2xl border border-border-subtle bg-surface-light p-5 shadow-sm">
                                    <h4 class="text-xs font-semibold uppercase tracking-wider text-text-muted mb-4">Lead
                                        Founder
                                    </h4>
                                    <div class="flex items-center gap-4">
                                        <img id="founder-avatar" src="" alt="Founder photo"
                                            class="h-14 w-14 rounded-full object-cover ring-2 ring-primary/20" />
                                        <div>
                                            <p class="font-bold" id="founder-name">—</p>
                                            <p class="text-sm text-text-muted" id="founder-title">—</p>
                                        </div>
                                        <a href="#"
                                            class="ml-auto flex h-10 w-10 items-center justify-center rounded-full bg-background-light text-text-muted hover:bg-primary hover:text-white transition-colors">
                                            <span class="material-symbols-outlined">link</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ── Detail cards grid ── -->
                <div class="mx-auto max-w-7xl px-6 pb-16 lg:px-8">
                    <div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">

                        <!-- Market Size -->
                        <div class="rounded-2xl bg-white p-7 shadow-sm ring-1 ring-border-subtle fade-up stagger-1">
                            <div
                                class="mb-4 flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                                <span class="material-symbols-outlined">pie_chart</span>
                            </div>
                            <h3 class="text-lg font-semibold mb-5">Market Size</h3>
                            <div class="space-y-4" id="market-bars">
                                <!-- filled by JS -->
                            </div>
                        </div>

                        <!-- Documents -->
                        <div class="rounded-2xl bg-white p-7 shadow-sm ring-1 ring-border-subtle fade-up stagger-2">
                            <div
                                class="mb-4 flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                                <span class="material-symbols-outlined">folder_open</span>
                            </div>
                            <h3 class="text-lg font-semibold mb-5">Documents</h3>
                            <div class="space-y-3" id="documents-list">
                                <!-- filled by JS -->
                            </div>
                        </div>

                        <!-- Traction -->
                        <div class="rounded-2xl bg-white p-7 shadow-sm ring-1 ring-border-subtle fade-up stagger-3">
                            <div
                                class="mb-4 flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                                <span class="material-symbols-outlined">rocket_launch</span>
                            </div>
                            <h3 class="text-lg font-semibold mb-5">Traction Highlights</h3>
                            <ul class="space-y-4" id="traction-list">
                                <!-- filled by JS -->
                            </ul>
                        </div>

                        <!-- Team -->
                        <div
                            class="rounded-2xl bg-white p-7 shadow-sm ring-1 ring-border-subtle fade-up stagger-1 md:col-span-2 lg:col-span-2">
                            <div
                                class="mb-4 flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                                <span class="material-symbols-outlined">group</span>
                            </div>
                            <h3 class="text-lg font-semibold mb-5">Core Team</h3>
                            <div class="grid grid-cols-2 sm:grid-cols-3 gap-4" id="team-list">
                                <!-- filled by JS -->
                            </div>
                        </div>

                        <!-- Investment Terms -->
                        <div class="rounded-2xl bg-white p-7 shadow-sm ring-1 ring-border-subtle fade-up stagger-2">
                            <div
                                class="mb-4 flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10 text-primary">
                                <span class="material-symbols-outlined">receipt_long</span>
                            </div>
                            <h3 class="text-lg font-semibold mb-5">Investment Terms</h3>
                            <div class="space-y-3" id="terms-list">
                                <!-- filled by JS -->
                            </div>
                        </div>
                    </div>

                    <!-- Back link -->
                    <div class="mt-12 flex justify-center">
                        <a href="browse_startups.jsp"
                            class="flex items-center gap-2 text-sm font-medium text-text-muted hover:text-primary transition-colors">
                            <span class="material-symbols-outlined text-[20px]">arrow_back</span>
                            Back to Browse Startups
                        </a>
                    </div>
                </div>
            </main>

            <!-- ═══════ EXPRESS INTEREST MODAL ═══════ -->
            <div id="interest-modal" class="fixed inset-0 z-50 hidden flex items-center justify-center">
                <div class="absolute inset-0 bg-black/50 backdrop-blur-sm" onclick="closeModal()"></div>
                <div class="relative z-10 w-full max-w-lg mx-4 bg-white rounded-2xl shadow-2xl p-8">
                    <button onclick="closeModal()"
                        class="absolute top-5 right-5 text-text-muted hover:text-red-500 transition-colors">
                        <span class="material-symbols-outlined text-2xl">close</span>
                    </button>
                    <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-primary/10 text-primary mb-4">
                        <span class="material-symbols-outlined text-2xl">handshake</span>
                    </div>
                    <h3 class="text-2xl font-bold mb-1">Express Interest</h3>
                    <p class="text-text-muted text-sm mb-6">Let the startup know you're interested. Our team will follow
                        up
                        within 48 hours.</p>
                    <form id="interest-form" action="../invest" method="POST" class="space-y-4">
                        <div>
                            <label class="block text-sm font-semibold mb-1.5">Investment Amount</label>
                            <div
                                class="flex items-center rounded-lg border border-border-subtle bg-background-light px-4 py-2.5 focus-within:border-primary focus-within:ring-1 focus-within:ring-primary/30 transition">
                                <span class="text-text-muted mr-2 font-semibold">$</span>
                                <input type="number" min="10000" step="5000" placeholder="50,000"
                                    class="flex-1 border-none bg-transparent p-0 text-sm focus:ring-0 text-text-main"
                                    required />
                            </div>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold mb-1.5">Message to Founder <span
                                    class="text-text-muted font-normal">(optional)</span></label>
                            <textarea rows="3" placeholder="Introduce yourself and share why you're interested…"
                                class="w-full rounded-lg border border-border-subtle bg-background-light px-4 py-3 text-sm text-text-main placeholder:text-text-muted focus:ring-1 focus:ring-primary/30 focus:border-primary transition resize-none"></textarea>
                        </div>
                        <div class="flex items-start gap-2 text-sm text-text-muted">
                            <input type="checkbox" id="nda-check" class="mt-0.5 accent-[#c6a65d]" required />
                            <label for="nda-check">I agree to the <a href="#" class="text-primary hover:underline">NDA
                                    terms</a>
                                and understand this is a non-binding expression of interest.</label>
                        </div>
                        <button type="submit"
                            class="w-full rounded-full bg-primary hover:bg-primary-dark text-white font-semibold py-3 transition-colors flex items-center justify-center gap-2 shadow-lg">
                            Send Interest
                            <span class="material-symbols-outlined text-[20px]">send</span>
                        </button>
                    </form>
                    <!-- Success state -->
                    <div id="modal-success" class="hidden text-center py-6">
                        <div
                            class="mx-auto h-16 w-16 flex items-center justify-center rounded-full bg-green-100 text-green-600 mb-4">
                            <span class="material-symbols-outlined text-3xl icon-fill">check_circle</span>
                        </div>
                        <h4 class="text-xl font-bold mb-2">Interest Sent!</h4>
                        <p class="text-text-muted text-sm">Our team will review and get back to you within 48 hours.</p>
                        <button onclick="closeModal()"
                            class="mt-6 rounded-full bg-primary px-8 py-2.5 text-sm font-semibold text-white hover:bg-primary-dark transition-colors">Done</button>
                    </div>
                </div>
            </div>

            <!-- ═══════ FOOTER ═══════ -->
            <footer class="border-t border-border-subtle bg-white py-10">
                <div
                    class="mx-auto flex max-w-7xl flex-col items-center justify-between gap-6 px-6 lg:flex-row lg:px-8">
                    <div class="flex items-center gap-2">
                        <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-white">
                            <span class="material-symbols-outlined text-lg">diamond</span>
                        </div>
                        <span class="text-lg font-bold">Investify</span>
                    </div>
                    <p class="text-sm text-text-muted">© 2024 Investify Platforms Inc. All rights reserved.</p>
                    <div class="flex gap-6 text-sm text-text-muted">
                        <a href="#" class="hover:text-primary transition-colors">Terms</a>
                        <a href="#" class="hover:text-primary transition-colors">Privacy</a>
                        <a href="#" class="hover:text-primary transition-colors">Support</a>
                    </div>
                </div>
            </footer>

            <!-- ═══════ SCRIPT ═══════ -->
            <script>
<%
                    // Build STARTUPS JS object from DB
                    StringBuilder startupsJson = new StringBuilder();
                startupsJson.append("const STARTUPS = {\n");
    boolean hasData = false;
                try (Connection conn = DBConnection.getConnection()) {
        PreparedStatement ps = conn.prepareStatement(
                    "SELECT s.*, u.name AS founder_name FROM startup s LEFT JOIN users u ON s.founder_id = u.id ORDER BY s.id");
        ResultSet rs = ps.executeQuery();
        boolean first = true;
                    while (rs.next()) {
                        hasData = true;
                        if (!first) startupsJson.append(",\n");
                        first = false;
            int sid = rs.getInt("id");
            String title = rs.getString("title").replace("\"", "\\\"").replace("'", "\\'");
            String desc = rs.getString("description") != null ? rs.getString("description").replace("\"", "\\\"").replace("\n", " ") : "";
            String domain = rs.getString("domain") != null ? rs.getString("domain").replace("\"", "\\\"") : "General";
            String stage = rs.getString("stage") != null ? rs.getString("stage").replace("\"", "\\\"") : "Seed";
            double fundingGoal = rs.getDouble("funding_goal");
            double fundingRaised = rs.getDouble("funding_raised");
            double equityOffered = rs.getDouble("equity_offered");
            String riskLevel = rs.getString("risk_level") != null ? rs.getString("risk_level") : "Medium";
            String founderName = rs.getString("founder_name") != null ? rs.getString("founder_name").replace("\"", "\\\"") : "Founder";
            String pitchVideo = rs.getString("pitch_video") != null ? rs.getString("pitch_video").replace("\"", "\\\"") : "";
            String pitchDeck = rs.getString("pitch_deck") != null ? rs.getString("pitch_deck").replace("\"", "\\\"").replace("\\", "/") : "";
            String defaultImg = "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600&auto=format&fit=crop";
            String defaultLogo = "https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=80&q=80&auto=format&fit=crop";

                        startupsJson.append("            ").append(sid).append(": { ");
                        startupsJson.append("name: \"").append(title).append("\", ");
                        startupsJson.append("tagline: \"").append(desc.length() > 80 ? desc.substring(0, 80) + "..." : desc).append("\", ");
                        startupsJson.append("stage: \"").append(stage).append("\", ");
                        startupsJson.append("domain: \"").append(domain).append("\", ");
                        startupsJson.append("risk: \"").append(riskLevel).append("\", ");
                        startupsJson.append("raised: ").append((long) fundingRaised).append(", ");
                        startupsJson.append("valuation: ").append((long)(fundingRaised / (equityOffered > 0 ? equityOffered / 100.0 : 0.1))).append(", ");
                        startupsJson.append("minTicket: 10000, ");
                        startupsJson.append("equity: \"").append(String.format("%.1f%%", equityOffered)).append("\", ");
                        startupsJson.append("goal: ").append((long) fundingGoal).append(", ");
                        startupsJson.append("badge: null, ");
                        startupsJson.append("about: \"").append(desc).append("\", ");
                        startupsJson.append("pitchDeck: \"").append(pitchDeck).append("\", ");
                        startupsJson.append("img: \"").append(defaultImg).append("\", ");
                        startupsJson.append("logo: \"").append(defaultLogo).append("\", ");
                        startupsJson.append("founder: { name: \"").append(founderName).append("\", title: \"CEO & Founder\", avatar: \"https://i.pravatar.cc/80?img=").append(sid + 10).append("\" }, ");
                        startupsJson.append("team: [{ name: \"Team Member\", title: \"CTO\", avatar: \"https://i.pravatar.cc/80?img=").append(sid + 20).append("\" }], ");
                        startupsJson.append("market: [{ label: \"TAM\", value: \"$10B\", pct: 100, opacity: \"bg-primary/30\" }, { label: \"SAM\", value: \"$2B\", pct: 40, opacity: \"bg-primary/60\" }, { label: \"SOM\", value: \"$500M\", pct: 15, opacity: \"bg-primary\" }], ");
                        startupsJson.append("traction: [\"Growing rapidly\", \"Strong team\", \"Market validated\"], ");
                        startupsJson.append("terms: [{ k: \"Equity Offered\", v: \"").append(String.format("%.1f%%", equityOffered)).append("\" }, ");
                        startupsJson.append("{ k: \"Min. Investment\", v: \"$10,000\" }] }");
                    }
                } catch (Exception e) { e.printStackTrace(); }

                if (!hasData) {
        // Fallback to mock data if DB is empty
%>
        const STARTUPS = {};
<%
    } else {
                    startupsJson.append("\n        };");
%>
        <%= startupsJson.toString() %>
<%
    }
%>

        // Fallback startup
        const DEFAULT_ID = 1;
                const params = new URLSearchParams(window.location.search);
                const id = parseInt(params.get("id")) || DEFAULT_ID;
                const s = STARTUPS[id] || STARTUPS[DEFAULT_ID];

                // ──── Helpers ────
                const $ = i => document.getElementById(i);
                const fmt = n => n >= 1e9 ? `$${(n / 1e9).toFixed(1)}B` : n >= 1e6 ? `$${(n / 1e6).toFixed(1)}M` : `$${(n / 1000).toFixed(0)}k`;
                const riskColor = r => ({ "Low": "text-green-600", "Medium": "text-orange-500", "High": "text-red-500" }[r] || "text-text-muted");
                const stageColor = st => ({ "Seed": "bg-green-600", "Series A": "bg-[#c6a65d]", "Series B": "bg-purple-600", "Pre-IPO": "bg-blue-600" }[st] || "bg-gray-500");

                // ──── Populate page ────
                function populate() {
                    document.title = `Investify – ${s.name}`;
                    $("page-title").textContent = `Investify – ${s.name}`;
                    $("breadcrumb-name").textContent = s.name;
                    $("startup-logo").src = s.logo;
                    $("startup-logo").alt = s.name + " logo";
                    $("startup-name").textContent = s.name;
                    $("startup-tagline").textContent = s.tagline;
                    $("startup-about").textContent = s.about;
                    $("stat-raised").textContent = fmt(s.raised);
                    $("stat-valuation").textContent = fmt(s.valuation);
                    $("stat-min").textContent = fmt(s.minTicket);

                    // Video thumb
                    $("video-thumb").src = s.img;

                    // Badges
                    const br = $("badges-row");
                    br.innerHTML = `<div class="flex items-center gap-2 rounded-full bg-primary/10 px-4 py-1.5 text-sm font-medium text-primary-dark"><span class="material-symbols-outlined text-[17px]">verified</span>${s.stage}</div>
    <div class="flex items-center gap-2 rounded-full bg-background-light px-4 py-1.5 text-sm font-medium text-text-muted border border-border-subtle"><span class="material-symbols-outlined text-[17px]">trending_up</span>${s.domain}</div>
    <div class="flex items-center gap-2 rounded-full ${riskColor(s.risk).replace("text-", "text-")} bg-background-light px-4 py-1.5 text-sm font-medium border border-border-subtle"><span class="material-symbols-outlined text-[17px]">shield</span>${s.risk} Risk</div>
    ${s.badge ? `<div class="flex items-center gap-2 rounded-full bg-background-light px-4 py-1.5 text-sm font-medium text-text-muted border border-border-subtle"><span class="material-symbols-outlined text-[17px]">${s.badgeIcon}</span>${s.badge}</div>` : ""}`;

                    // Progress
                    const pct = Math.round((s.raised / s.goal) * 100);
                    $("progress-pct").textContent = pct + "%";
                    $("progress-raised-label").textContent = fmt(s.raised) + " raised";
                    $("progress-goal-label").textContent = fmt(s.goal) + " goal";
                    setTimeout(() => { $("progress-bar").style.width = Math.min(pct, 100) + "%"; }, 300);

                    // Founder
                    $("founder-name").textContent = s.founder.name;
                    $("founder-title").textContent = s.founder.title;
                    $("founder-avatar").src = s.founder.avatar;

                    // Market bars
                    $("market-bars").innerHTML = s.market.map(m => `
    <div>
      <div class="flex justify-between text-sm mb-1"><span class="text-text-muted">${m.label}</span><span class="font-semibold">${m.value}</span></div>
      <div class="h-2 w-full rounded-full bg-gray-100"><div class="h-full rounded-full ${m.opacity} bar-fill" data-pct="${m.pct}"></div></div>
    </div>`).join("");

                    // Documents
                    const docs = [];
                    if (s.pitchDeck) {
                        docs.push({ name: "Pitch Deck", icon: "picture_as_pdf", color: "text-red-500", locked: false, url: "../" + s.pitchDeck });
                        $("cta-deck").href = "../" + s.pitchDeck;
                    } else {
                        docs.push({ name: "Pitch Deck (Not provided)", icon: "picture_as_pdf", color: "text-red-500", locked: true, url: "#" });
                    }
                    $("documents-list").innerHTML = docs.map(d => `
    <a href="${d.url}" ${d.locked ? '' : 'download'} class="flex items-center justify-between rounded-xl bg-background-light p-3 hover:bg-primary/5 group transition-colors">
      <div class="flex items-center gap-3">
        <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-white shadow-sm ${d.color}">
          <span class="material-symbols-outlined text-[18px]">${d.icon}</span>
        </div>
        <span class="text-sm font-medium">${d.name}</span>
      </div>
      <span class="material-symbols-outlined text-text-muted group-hover:text-primary transition-colors">${d.locked ? "lock" : "download"}</span>
    </a>`).join("");
    
                    // Setup cta links
                    $("cta-invest").href = "invest.jsp?id=" + id;

                    // Traction
                    $("traction-list").innerHTML = s.traction.map(t => `
    <li class="flex items-start gap-3">
      <span class="material-symbols-outlined text-primary mt-0.5 text-[19px] icon-fill">check_circle</span>
      <span class="text-sm text-text-muted leading-relaxed">${t}</span>
    </li>`).join("");

                    // Team
                    const teamMembers = [s.founder, ...s.team];
                    $("team-list").innerHTML = teamMembers.map(m => `
    <div class="flex items-center gap-3 rounded-xl bg-background-light p-3 hover:bg-primary/5 transition-colors">
      <img src="${m.avatar}" alt="${m.name}" class="h-12 w-12 rounded-full object-cover ring-2 ring-primary/20"/>
      <div><p class="font-semibold text-sm">${m.name}</p><p class="text-xs text-text-muted">${m.title}</p></div>
    </div>`).join("");

                    // Investment terms
                    $("terms-list").innerHTML = s.terms.map(t => `
    <div class="flex items-center justify-between py-2 border-b border-border-subtle last:border-0">
      <span class="text-sm text-text-muted">${t.k}</span>
      <span class="text-sm font-semibold">${t.v}</span>
    </div>`).join("");

                    // Animate market bars after render
                    setTimeout(() => {
                        document.querySelectorAll(".bar-fill[data-pct]").forEach(el => {
                            el.style.width = el.dataset.pct + "%";
                        });
                    }, 400);
                }

                // ──── Modal ────
                function openModal() {
                    $("modal-startup-id").value = id;
                    $("interest-modal").style.display = "";
                    $("interest-modal").classList.remove("hidden");
                    $("interest-form").classList.remove("hidden");
                    $("modal-success").classList.add("hidden");
                    document.body.style.overflow = "hidden";
                }
                function closeModal() {
                    $("interest-modal").classList.add("hidden");
                    document.body.style.overflow = "";
                }
                // ──── Save toggle ────
                let saved = false;
                function toggleSave() {
                    saved = !saved;
                    $("save-icon").textContent = saved ? "bookmark_added" : "bookmark";
                    $("save-label").textContent = saved ? "Saved" : "Save";
                    $("save-btn").classList.toggle("border-primary", saved);
                    $("save-btn").classList.toggle("text-primary", saved);
                }

                // ──── Share ────
                function shareStartup() {
                    if (navigator.share) {
                        navigator.share({ title: s.name, text: s.tagline, url: window.location.href });
                    } else {
                        navigator.clipboard.writeText(window.location.href).then(() => {
                            alert("Link copied to clipboard!");
                        });
                    }
                }

                // ──── Video play toggle ────
                function togglePlay() {
                    const overlay = $("play-overlay");
                    overlay.innerHTML = overlay.querySelector(".icon-fill").textContent === "play_arrow"
                        ? `<div class="flex h-18 w-18 items-center justify-center rounded-full bg-primary/90 text-white shadow-glow"><span class="material-symbols-outlined text-4xl icon-fill">pause</span></div>`
                        : `<div class="flex h-18 w-18 items-center justify-center rounded-full bg-primary/90 text-white shadow-glow transition-transform group-hover:scale-110"><span class="material-symbols-outlined text-4xl icon-fill">play_arrow</span></div>`;
                }

                // ──── Init ────
                populate();

                // Escape key closes modal
                document.addEventListener("keydown", e => { if (e.key === "Escape") closeModal(); });
            </script>
        </body>

        </html>
