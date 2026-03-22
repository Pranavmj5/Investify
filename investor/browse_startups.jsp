<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
  <%@ page import="java.util.*, com.investify.db.DBConnection, java.sql.*" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
      return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
      session.getAttribute("user_name"); %>
      <% List<Map<String, Object>> dbStartups = new ArrayList<>();
          Map<String, String> stageColorMap = new HashMap<>();
              stageColorMap.put("Seed", "bg-green-600");
              stageColorMap.put("Series A", "bg-primary");
              stageColorMap.put("Series B", "bg-purple-600");
              stageColorMap.put("Pre-IPO", "bg-blue-600");

              Map<String, String> imgMap = new HashMap<>();
                  imgMap.put("FinTech",
                  "https://images.unsplash.com/photo-1563986768609-322da13575f2?w=600&auto=format&fit=crop");
                  imgMap.put("HealthTech",
                  "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=600&auto=format&fit=crop");
                  imgMap.put("EdTech",
                  "https://images.unsplash.com/photo-1501504905252-473c47e087f8?w=600&auto=format&fit=crop");
                  imgMap.put("CleanTech",
                  "https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600&auto=format&fit=crop");
                  imgMap.put("AgriTech",
                  "https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=600&auto=format&fit=crop");
                  imgMap.put("SaaS",
                  "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600&auto=format&fit=crop");
                  imgMap.put("Logistics",
                  "https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=600&auto=format&fit=crop");
                  imgMap.put("FoodTech",
                  "https://images.unsplash.com/photo-1606787366850-de6330128bfc?w=600&auto=format&fit=crop");
                  imgMap.put("CyberSecurity",
                  "https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=600&auto=format&fit=crop");
                  imgMap.put("E-Commerce",
                  "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=600&auto=format&fit=crop");

                  Map<String, Integer> domainCounts = new LinkedHashMap<>();

                      try (Connection conn = DBConnection.getConnection()) {
                      PreparedStatement ps = conn.prepareStatement(
                      "SELECT * FROM startup WHERE status = 'approved' ORDER BY created_at DESC"
                      );
                      ResultSet rs = ps.executeQuery();
                      while (rs.next()) {
                      Map<String, Object> s = new HashMap<>();
                          s.put("id", rs.getInt("id"));
                          s.put("title", rs.getString("title") != null ? rs.getString("title") : "");
                          String domainVal = rs.getString("domain") != null ? rs.getString("domain") : "";
                          s.put("domain", domainVal);
                          s.put("stage", rs.getString("stage") != null ? rs.getString("stage") : "");
                          s.put("tagline", rs.getString("tagline") != null ? rs.getString("tagline") : "");
                          s.put("fundingGoal", rs.getDouble("funding_goal"));
                          s.put("equityOffered", rs.getDouble("equity_offered"));
                          s.put("riskLevel", rs.getString("risk_level") != null ? rs.getString("risk_level") :
                          "Medium");
                          dbStartups.add(s);
                          if (!domainVal.isEmpty()) {
                          domainCounts.put(domainVal, domainCounts.getOrDefault(domainVal, 0) + 1);
                          }
                          }
                          } catch (Exception e) {
                          e.printStackTrace();
                          }
                          %>
                          <!DOCTYPE html>
                          <html lang="en">

                          <head>
                            <meta charset="utf-8" />
                            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                            <title>Investify – Browse Startups</title>
                            <meta name="description"
                              content="Browse curated investment opportunities in high-growth startups vetted by Investify experts." />
                            <link href="https://fonts.googleapis.com" rel="preconnect" />
                            <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect" />
                            <link
                              href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700;800&display=swap"
                              rel="stylesheet" />
                            <link
                              href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                              rel="stylesheet" />
                            <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                            <script>
                              tailwind.config = {
                                darkMode: "class", theme: {
                                  extend: {
                                    colors: {
                                      primary: "#c6a65d", "primary-dark": "#b09045", "primary-light": "#e3cea0", "background-light": "#f8f7f6", "background-surface": "#ffffff", "text-main": "#1e1b14", "text-muted": "#817a6a", "border-subtle": "#f0efe9",
                                    },
                                    fontFamily: { display: ["Public Sans", "sans-serif"] }, borderRadius: { DEFAULT: "1rem", lg: "1.5rem", xl: "2rem", "2xl": "3rem", full: "9999px" }, boxShadow: {
                                      soft: "0 4px 20px -2px rgba(198,166,93,0.1)", glow: "0 0 15px rgba(198,166,93,0.3)",
                                    },
                                  },
                                },
                              };
                            </script>
                            <style>
                              .material-symbols-outlined {
                                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                              }

                              .icon-fill {
                                font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                              }

                              /* Range slider styling */
                              input[type=range] {
                                -webkit-appearance: none;
                                appearance: none;
                                width: 100%;
                                height: 4px;
                                border-radius: 9999px;
                                background: #e6e2db;
                                outline: none;
                              }

                              input[type=range]::-webkit-slider-thumb {
                                -webkit-appearance: none;
                                appearance: none;
                                width: 16px;
                                height: 16px;
                                border-radius: 50%;
                                background: #c6a65d;
                                cursor: pointer;
                                border: 2px solid #fff;
                                box-shadow: 0 0 4px rgba(198, 166, 93, .4);
                              }

                              /* Card hover animation */
                              .startup-card {
                                transition: transform .3s ease, box-shadow .3s ease;
                              }

                              .startup-card:hover {
                                transform: translateY(-4px);
                                box-shadow: 0 20px 40px -8px rgba(198, 166, 93, .15);
                              }

                              /* Fade-in animation */
                              @keyframes fadeIn {
                                from {
                                  opacity: 0;
                                  transform: translateY(16px);
                                }

                                to {
                                  opacity: 1;
                                  transform: translateY(0);
                                }
                              }

                              .fade-in {
                                animation: fadeIn .5s ease forwards;
                              }

                              /* Stagger */
                              .stagger-1 {
                                animation-delay: .05s;
                              }

                              .stagger-2 {
                                animation-delay: .10s;
                              }

                              .stagger-3 {
                                animation-delay: .15s;
                              }

                              .stagger-4 {
                                animation-delay: .20s;
                              }

                              .stagger-5 {
                                animation-delay: .25s;
                              }

                              .stagger-6 {
                                animation-delay: .30s;
                              }
                            </style>
                          </head>

                          <body
                            class="bg-background-light font-display text-text-main min-h-screen flex flex-col antialiased selection:bg-primary/30">
                            <!-- ═══════════════════════════════  NAVBAR  ═══════════════════════════════ -->
                            <header
                              class="sticky top-0 z-50 flex items-center justify-between border-b border-border-subtle bg-background-surface/90 px-8 py-4 backdrop-blur-md">
                              <!-- Logo + Nav -->
                              <div class="flex items-center gap-10"> <a href="../index.jsp"
                                  class="flex items-center gap-3 hover:opacity-80 transition-opacity" id="nav-logo">
                                  <div
                                    class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white shadow-soft">
                                    <span class="material-symbols-outlined text-xl">diamond</span>
                                  </div>
                                  <span class="text-xl font-bold tracking-tight">Investify</span>
                                </a>
                                <nav class="hidden md:flex items-center gap-8 pl-8 border-l border-border-subtle"
                                  aria-label="Main navigation"> <a href="dashboard.jsp"
                                    class="text-sm font-medium text-text-muted hover:text-text-main transition-colors"
                                    id="nav-dashboard">Dashboard</a> <a href="browse_startups.jsp"
                                    class="text-sm font-semibold text-primary border-b-2 border-primary pb-0.5"
                                    id="nav-browse">Browse</a> <a href="portfolio"
                                    class="text-sm font-medium text-text-muted hover:text-text-main transition-colors"
                                    id="nav-portfolio">Portfolio</a> <a href="watchlist.jsp"
                                    class="text-sm font-medium text-text-muted hover:text-text-main transition-colors"
                                    id="nav-watchlist">Watchlist</a> <a href="insights.jsp"
                                    class="text-sm font-medium text-text-muted hover:text-text-main transition-colors"
                                    id="nav-insights">Insights</a> </nav>
                              </div>
                              <!-- Search + User -->
                              <div class="flex items-center gap-5">
                                <div
                                  class="hidden lg:flex items-center rounded-full bg-background-light border border-border-subtle px-4 py-2 w-60 focus-within:border-primary focus-within:ring-1 focus-within:ring-primary/30 transition-all">
                                  <span class="material-symbols-outlined text-text-muted text-[20px]">search</span>
                                  <input id="global-search"
                                    class="w-full border-none bg-transparent p-0 pl-3 text-sm text-text-main placeholder:text-text-muted focus:ring-0"
                                    placeholder="Search opportunities…" type="text" />
                                </div>
                                <button class="relative p-2 text-text-muted hover:text-primary transition-colors"
                                  id="notif-btn" aria-label="Notifications"> <span
                                    class="material-symbols-outlined">notifications</span> <span
                                    class="absolute top-2 right-2 h-2 w-2 rounded-full bg-red-500 ring-2 ring-white"></span>
                                </button>
                                <button
                                  class="h-9 w-9 rounded-full overflow-hidden ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary text-white font-bold text-sm uppercase"
                                  id="user-avatar" aria-label="User profile" onclick="window.location='profile.jsp'">
                                  <%= userName !=null && !userName.isEmpty() ? userName.substring(0,1) : "U" %>
                                </button>
                              </div>
                            </header>
                            <!-- ═══════════════════════════════  MAIN  ════════════════════════════════ -->
                            <main class="mx-auto flex w-full max-w-[1440px] flex-1 gap-8 px-6 py-8 lg:px-10">
                              <!-- ─────────────── Sidebar ─────────────── -->
                              <aside class="hidden lg:flex w-64 shrink-0 flex-col gap-6" id="filters-sidebar">
                                <!-- Header -->
                                <div>
                                  <h1 class="text-2xl font-bold">Filters</h1>
                                  <p class="text-sm text-text-muted mt-1">Refine your investment search</p>
                                </div>
                                <!-- Active filters -->
                                <div id="active-filters" class="flex flex-wrap gap-2 min-h-[28px]">
                                  <!-- filled by JS -->
                                </div>
                                <!-- Domain -->
                                <div class="bg-white rounded-xl p-5 shadow-sm border border-border-subtle">
                                  <button class="w-full flex items-center justify-between mb-4" id="domain-toggle"
                                    aria-expanded="true" aria-controls="domain-list">
                                    <h3 class="font-semibold text-text-main">Domain</h3> <span
                                      class="material-symbols-outlined text-text-muted transition-transform"
                                      id="domain-chevron">expand_less</span>
                                  </button>
                                  <div id="domain-list" class="flex flex-col gap-3">
                                    <% for (Map.Entry<String, Integer> domainEntry : domainCounts.entrySet()) { %>
                                      <label class="flex items-center gap-3 cursor-pointer group"
                                        data-domain="<%= domainEntry.getKey() %>">
                                        <input type="checkbox" value="<%= domainEntry.getKey() %>"
                                          class="domain-check peer size-4 rounded border-gray-300 text-primary accent-[#c6a65d] focus:ring-primary/20" />
                                        <span class="text-sm text-text-main group-hover:text-primary transition-colors">
                                          <%= domainEntry.getKey() %>
                                        </span>
                                        <span class="ml-auto text-xs text-text-muted">
                                          <%= domainEntry.getValue() %>
                                        </span>
                                      </label>
                                      <% } %>
                                  </div>
                                </div>
                                <!-- Stage -->
                                <div class="bg-white rounded-xl p-5 shadow-sm border border-border-subtle">
                                  <button class="w-full flex items-center justify-between mb-4" id="stage-toggle"
                                    aria-expanded="true" aria-controls="stage-list">
                                    <h3 class="font-semibold text-text-main">Stage</h3> <span
                                      class="material-symbols-outlined text-text-muted transition-transform"
                                      id="stage-chevron">expand_less</span>
                                  </button>
                                  <div id="stage-list" class="flex flex-col gap-2">
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="stage" value=""
                                        class="size-4 border-gray-300 text-primary accent-[#c6a65d] focus:ring-primary/20"
                                        checked />
                                      <span class="text-sm text-text-main">All Stages</span>
                                    </label>
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="stage" value="Seed"
                                        class="size-4 border-gray-300 text-primary accent-[#c6a65d] focus:ring-primary/20" />
                                      <span class="text-sm text-text-main">Seed</span>
                                    </label>
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="stage" value="Series A"
                                        class="size-4 border-gray-300 text-primary accent-[#c6a65d] focus:ring-primary/20" />
                                      <span class="text-sm text-text-main">Series A</span>
                                    </label>
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="stage" value="Series B"
                                        class="size-4 border-gray-300 text-primary accent-[#c6a65d] focus:ring-primary/20" />
                                      <span class="text-sm text-text-main">Series B</span>
                                    </label>
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="stage" value="Pre-IPO"
                                        class="size-4 border-gray-300 text-primary accent-[#c6a65d] focus:ring-primary/20" />
                                      <span class="text-sm text-text-main">Pre-IPO</span>
                                    </label>
                                  </div>
                                </div>
                                <!-- Risk Level -->
                                <div class="bg-white rounded-xl p-5 shadow-sm border border-border-subtle">
                                  <h3 class="font-semibold text-text-main mb-4">Risk Level</h3>
                                  <div class="flex flex-col gap-2">
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="risk" value=""
                                        class="size-4 border-gray-300 accent-[#c6a65d] focus:ring-primary/20" checked />
                                      <span class="text-sm text-text-main">All Levels</span>
                                    </label>
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="risk" value="Low"
                                        class="size-4 border-gray-300 accent-[#c6a65d] focus:ring-primary/20" />
                                      <span class="text-sm text-text-main">Low Risk</span>
                                    </label>
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="risk" value="Medium"
                                        class="size-4 border-gray-300 accent-[#c6a65d] focus:ring-primary/20" />
                                      <span class="text-sm text-text-main">Balanced / Medium</span>
                                    </label>
                                    <label
                                      class="flex items-center gap-3 cursor-pointer group rounded-lg p-2 hover:bg-background-light">
                                      <input type="radio" name="risk" value="High"
                                        class="size-4 border-gray-300 accent-[#c6a65d] focus:ring-primary/20" />
                                      <span class="text-sm text-text-main">High Growth</span>
                                    </label>
                                  </div>
                                </div>
                                <!-- Clear all button -->
                                <button id="clear-all-btn"
                                  class="text-sm font-semibold text-text-muted hover:text-primary underline decoration-primary/30 underline-offset-4 transition-colors self-start">Clear
                                  All Filters</button>
                              </aside>
                              <!-- ─────────────── Main Content ─────────────── -->
                              <section class="flex flex-1 flex-col min-w-0">
                                <!-- Breadcrumb + heading -->
                                <div class="mb-6 flex flex-col justify-between gap-4 md:flex-row md:items-end">
                                  <div>
                                    <div class="mb-2 flex items-center gap-2 text-sm text-text-muted"> <a
                                        href="../index.jsp" class="hover:text-primary transition-colors">Home</a>
                                      <span>/</span> <span class="text-text-main font-medium">Browse Startups</span>
                                    </div>
                                    <h2 class="text-3xl font-bold tracking-tight text-text-main">Discover Opportunities
                                    </h2>
                                    <p class="mt-1 max-w-lg text-text-muted">Curated investment opportunities in
                                      high-growth
                                      startups vetted by our experts.</p>
                                  </div>
                                  <!-- Sort + view toggle -->
                                  <div class="flex items-center gap-3">
                                    <!-- Mobile search -->
                                    <div
                                      class="flex lg:hidden items-center rounded-full bg-white border border-border-subtle px-4 py-2 w-48 focus-within:border-primary transition-all">
                                      <span class="material-symbols-outlined text-text-muted text-[18px]">search</span>
                                      <input id="mobile-search"
                                        class="w-full border-none bg-transparent p-0 pl-2 text-sm text-text-main placeholder:text-text-muted focus:ring-0"
                                        placeholder="Search…" type="text" />
                                    </div> <span class="text-sm font-medium text-text-muted hidden sm:block">Sort
                                      by:</span>
                                    <div class="relative"> <select id="sort-select"
                                        class="cursor-pointer appearance-none rounded-lg border-none bg-white py-2 pl-4 pr-10 text-sm font-semibold text-text-main shadow-sm ring-1 ring-inset ring-gray-200 focus:ring-2 focus:ring-primary/20">
                                        <option value="recommended">Recommended</option>
                                        <option value="newest">Newest</option>
                                        <option value="funding-asc">Funding (Low→High)</option>
                                        <option value="funding-desc">Funding (High→Low)</option>
                                      </select> <span
                                        class="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-text-muted">
                                        <span class="material-symbols-outlined text-[18px]">expand_more</span> </span>
                                    </div>
                                    <!-- View toggle -->
                                    <div
                                      class="flex gap-1 rounded-lg bg-white p-1 shadow-sm border border-border-subtle">
                                      <button id="grid-view-btn"
                                        class="p-1.5 rounded text-primary bg-primary/10 transition-colors"
                                        aria-label="Grid view"> <span
                                          class="material-symbols-outlined text-[20px]">grid_view</span> </button>
                                      <button id="list-view-btn"
                                        class="p-1.5 rounded text-text-muted hover:text-primary transition-colors"
                                        aria-label="List view"> <span
                                          class="material-symbols-outlined text-[20px]">view_list</span> </button>
                                    </div>
                                  </div>
                                </div>
                                <!-- Results count -->
                                <p class="text-sm text-text-muted mb-6" id="results-count">Showing <span
                                    id="count-num">0</span> startups</p>
                                <!-- Grid -->
                                <div id="startup-grid" class="grid grid-cols-1 gap-6 md:grid-cols-2 xl:grid-cols-3">
                                  <!-- Filled by JS -->
                                </div>
                                <!-- Empty state -->
                                <div id="empty-state"
                                  class="hidden flex flex-col items-center justify-center py-24 text-center"> <span
                                    class="material-symbols-outlined text-[64px] text-text-muted mb-4">search_off</span>
                                  <h3 class="text-xl font-semibold text-text-main">No results found</h3>
                                  <p class="text-text-muted mt-2">Try adjusting your filters or search term.</p> <button
                                    id="reset-empty-btn"
                                    class="mt-6 rounded-full bg-primary px-6 py-2.5 text-sm font-semibold text-white hover:bg-primary-dark transition-colors">Reset
                                    Filters</button>
                                </div>
                                <!-- Pagination -->
                                <div id="pagination" class="mt-12 flex items-center justify-center gap-2"></div>
                              </section>
                            </main>
                            <!-- ═══════════════════════════════  FOOTER  ══════════════════════════════ -->
                            <footer class="border-t border-border-subtle bg-white py-10">
                              <div
                                class="mx-auto flex max-w-7xl flex-col items-center justify-between gap-6 px-6 lg:flex-row lg:px-8">
                                <div class="flex items-center gap-2">
                                  <div
                                    class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary text-white">
                                    <span class="material-symbols-outlined text-lg">diamond</span>
                                  </div> <span class="text-lg font-bold">Investify</span>
                                </div>
                                <p class="text-sm text-text-muted">&copy; 2024 Investify Platforms Inc. All rights
                                  reserved.
                                </p>
                                <div class="flex gap-6 text-sm text-text-muted"> <a href="#"
                                    class="hover:text-primary transition-colors">Terms</a> <a href="#"
                                    class="hover:text-primary transition-colors">Privacy</a> <a href="#"
                                    class="hover:text-primary transition-colors">Support</a> </div>
                              </div>
                            </footer>
                            <!-- ═══════════════════════════  JAVASCRIPT  ══════════════════════════════ -->
                            <script>
                              // ──────────── Data ────────────
                              const STARTUPS = [
      <%
        if (!dbStartups.isEmpty()) {
          String defaultImg = "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600&auto=format&fit=crop";
                                for (int i = 0; i < dbStartups.size(); i++) {
                                  Map < String, Object > s = dbStartups.get(i);
            String title = ((String) s.get("title")).replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
            String domain = ((String) s.get("domain")).replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
            String stage = ((String) s.get("stage")).replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
            String tagline = ((String) s.get("tagline")).replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
            String risk = (String) s.get("riskLevel");
            double target = ((Number) s.get("fundingGoal")).doubleValue();
            double equity = ((Number) s.get("equityOffered")).doubleValue();
            String stageColor = stageColorMap.getOrDefault(stage, "bg-primary");
            String img = imgMap.containsKey(domain) ? imgMap.get(domain) : defaultImg;
      %>
                                    {
                                      id: <%= s.get("id") %>,
                                      name: "<%= title %>",
                                      tagline: "<%= tagline %>",
                                      stage: "<%= stage %>",
                                      stageColor: "<%= stageColor %>",
                                      domain: "<%= domain %>",
                                      target: <%= ((Number) s.get("fundingGoal")).longValue() %>,
                                    equity: "<%= String.format(" % .1f", equity) %>%",
                                      risk: "<%= risk %>",
                                        badge: null,
                                          img: "<%= img %>",
                                            imgAlt: "<%= title %>"
                                }<%= (i < dbStartups.size() - 1) ? "," : "" %>
      <%
          }
        }
      %>
    ];

                              // ──────────── State ────────────
                              const state = {
                                domains: new Set(),
                                stage: "",
                                risk: "",
                                search: "",
                                sort: "recommended",
                                page: 1,
                                perPage: 6,
                                view: "grid"
                              };

                              // ──────────── Helpers ────────────
                              const $ = id => document.getElementById(id);
                              const fmt = n => n >= 1e6 ? `$<%="$"%>{(n / 1e6).toFixed(1)}M` : `$<%="$"%>{(n / 1000).toFixed(0)}k`;
                              const riskIcon = r => r === "Low" ? "shield" : r === "Medium" ? "shield_with_heart" : "warning";
                              const riskColor = r => r === "Low" ? "text-primary" : r === "Medium" ? "text-orange-500" : "text-red-500";

                              // ──────────── Filter & Render ────────────
                              function filteredData() {
                                let data = [...STARTUPS];
                                if (state.domains.size > 0) data = data.filter(s => state.domains.has(s.domain));
                                if (state.stage) data = data.filter(s => s.stage === state.stage);
                                if (state.risk) data = data.filter(s => s.risk === state.risk);
                                if (state.search) data = data.filter(s =>
                                  s.name.toLowerCase().includes(state.search) ||
                                  s.tagline.toLowerCase().includes(state.search) ||
                                  s.domain.toLowerCase().includes(state.search)
                                );
                                if (state.sort === "newest") data.reverse();
                                if (state.sort === "funding-asc") data.sort((a, b) => a.target - b.target);
                                if (state.sort === "funding-desc") data.sort((a, b) => b.target - a.target);
                                return data;
                              }

                              function renderActiveFilters() {
                                const el = $("active-filters");
                                el.innerHTML = "";
                                const tags = [];
                                state.domains.forEach(d => tags.push({
                                  label: d,
                                  remove: () => { state.domains.delete(d); syncCheckboxes(); update(); }
                                }));
                                if (state.stage) tags.push({
                                  label: state.stage,
                                  remove: () => { state.stage = ""; syncRadios("stage"); update(); }
                                });
                                if (state.risk) tags.push({
                                  label: state.risk + " Risk",
                                  remove: () => { state.risk = ""; syncRadios("risk"); update(); }
                                });
                                tags.forEach(tag => {
                                  const span = document.createElement("span");
                                  span.className = "inline-flex items-center gap-1 rounded-full bg-primary/10 px-3 py-1 text-xs font-medium text-primary-dark";
                                  span.innerHTML = `<%="$"%>{tag.label}<button class="ml-1 hover:text-red-500 flex items-center"><span class="material-symbols-outlined text-[13px]">close</span></button>`;
                                  span.querySelector("button").onclick = () => { tag.remove(); };
                                  el.appendChild(span);
                                });
                                if (tags.length > 0) {
                                  const clearBtn = document.createElement("button");
                                  clearBtn.className = "text-xs font-medium text-text-muted hover:text-primary underline decoration-primary/30 underline-offset-4";
                                  clearBtn.textContent = "Clear All";
                                  clearBtn.onclick = clearAll;
                                  el.appendChild(clearBtn);
                                }
                              }

                              function renderCards(data) {
                                const grid = $("startup-grid");
                                const pageData = data.slice((state.page - 1) * state.perPage, state.page * state.perPage);
                                if (state.view === "list") {
                                  grid.className = "flex flex-col gap-4";
                                } else {
                                  grid.className = "grid grid-cols-1 gap-6 md:grid-cols-2 xl:grid-cols-3";
                                }
                                if (data.length === 0) {
                                  grid.innerHTML = "";
                                  $("empty-state").classList.remove("hidden");
                                  $("pagination").innerHTML = "";
                                  $("count-num").textContent = "0";
                                  return;
                                }
                                $("empty-state").classList.add("hidden");
                                $("count-num").textContent = data.length;
                                grid.innerHTML = pageData.map((s, i) => {
                                  const staggerClass = `stagger-<%="$"%>{Math.min(i + 1, 6)}`;
                                  if (state.view === "list") {
                                    return `
          <a href="startup_detail.jsp?id=<%="$"%>{s.id}" class="startup-card fade-in <%="$"%>{staggerClass} flex overflow-hidden rounded-xl bg-white shadow-sm border border-border-subtle hover:border-primary/30 transition-all group">
            <div class="relative w-52 shrink-0 overflow-hidden">
              <img src="<%="$"%>{s.img}" alt="<%="$"%>{s.imgAlt}" class="h-full w-full object-cover transition-transform duration-700 group-hover:scale-105"/>
              <div class="absolute inset-0 bg-gradient-to-r from-transparent to-black/20"></div>
              <div class="absolute top-3 left-3">
                <div class="rounded px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-white w-fit <%="$"%>{s.stageColor}"><%="$"%>{s.stage}</div>
              </div>
            </div>
            <div class="flex flex-1 flex-col justify-between p-5">
              <div>
                <div class="flex items-start justify-between gap-2 mb-1">
                  <h3 class="text-lg font-bold text-text-main group-hover:text-primary transition-colors"><%="$"%>{s.name}</h3>
                  <%="$"%>{s.badge ? '<span class="flex items-center gap-1 rounded-full bg-white border border-border-subtle px-2 py-0.5 text-[10px] font-bold text-text-main shrink-0"><span class="material-symbols-outlined text-[13px] text-primary"><%="$"%>{s.badgeIcon}</span><%="$"%>{s.badge}</span>' : ""}
                </div>
                <span class="text-xs font-semibold text-text-muted uppercase tracking-wider"><%="$"%>{s.domain}</span>
                <p class="mt-2 text-sm text-text-muted leading-relaxed line-clamp-2"><%="$"%>{s.tagline}</p>
              </div>
              <div class="flex items-center gap-6 mt-4 pt-4 border-t border-border-subtle">
                <div><span class="text-xs text-text-muted uppercase tracking-wider block">Target</span><span class="text-base font-bold"><%="$"%>{fmt(s.target)}</span></div>
                <div><span class="text-xs text-text-muted uppercase tracking-wider block">Equity</span><span class="text-base font-bold"><%="$"%>{s.equity}</span></div>
                <div class="flex items-center gap-1.5 ml-auto">
                  <span class="material-symbols-outlined text-[18px] <%="$"%>{riskColor(s.risk)}"><%="$"%>{riskIcon(s.risk)}</span>
                  <span class="text-sm font-semibold"><%="$"%>{s.risk} Risk</span>
                </div>
                <span class="rounded-full bg-primary/10 px-4 py-2 text-sm font-bold text-primary-dark transition-colors group-hover:bg-primary group-hover:text-white">View Details &rarr;</span>
              </div>
            </div>
          </a>`;
                                  }
                                  // Grid card
                                  return `
        <a href="startup_detail.jsp?id=<%="$"%>{s.id}" class="startup-card fade-in <%="$"%>{staggerClass} group relative flex flex-col overflow-hidden rounded-xl bg-white shadow-sm border border-border-subtle hover:border-primary/20">
          <div class="relative h-52 w-full overflow-hidden">
            <img src="<%="$"%>{s.img}" alt="<%="$"%>{s.imgAlt}" class="h-full w-full object-cover transition-transform duration-700 group-hover:scale-105"/>
            <div class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent opacity-70"></div>
            <%="$"%>{s.badge ? '<div class="absolute right-3 top-3 rounded-full bg-white/90 backdrop-blur-sm px-3 py-1 text-xs font-bold text-text-main shadow-sm flex items-center gap-1"><span class="material-symbols-outlined text-[14px] text-primary"><%="$"%>{s.badgeIcon}</span><%="$"%>{s.badge}</div>' : ""}
            <div class="absolute bottom-4 left-4">
              <div class="mb-1 rounded px-2 py-0.5 text-[10px] font-bold uppercase tracking-wider text-white w-fit <%="$"%>{s.stageColor}"><%="$"%>{s.stage}</div>
              <h3 class="text-lg font-bold text-white"><%="$"%>{s.name}</h3>
            </div>
          </div>
          <div class="flex flex-1 flex-col p-5">
            <span class="text-[11px] font-semibold text-primary uppercase tracking-widest mb-2"><%="$"%>{s.domain}</span>
            <div class="mb-3 flex items-start justify-between">
              <div><span class="text-[10px] font-medium text-text-muted uppercase tracking-wider">Target</span><p class="text-base font-bold"><%="$"%>{fmt(s.target)}</p></div>
              <div class="text-right"><span class="text-[10px] font-medium text-text-muted uppercase tracking-wider">Equity</span><p class="text-base font-bold"><%="$"%>{s.equity}</p></div>
            </div>
            <p class="mb-4 text-sm leading-relaxed text-text-muted line-clamp-2"><%="$"%>{s.tagline}</p>
            <div class="mt-auto flex items-center justify-between border-t border-border-subtle pt-4">
              <div class="flex items-center gap-1.5">
                <span class="material-symbols-outlined text-[18px] <%="$"%>{riskColor(s.risk)}"><%="$"%>{riskIcon(s.risk)}</span>
                <span class="text-sm font-bold"><%="$"%>{s.risk} Risk</span>
              </div>
              <span class="rounded-full bg-primary/10 px-4 py-2 text-sm font-bold text-primary-dark transition-colors group-hover:bg-primary group-hover:text-white">View Details</span>
            </div>
          </div>
        </a>`;
                                }).join("");
                              }

                              function renderPagination(total) {
                                const pages = Math.ceil(total / state.perPage);
                                const el = $("pagination");
                                if (pages <= 1) { el.innerHTML = ""; return; }
                                let html = "";
                                html += `<button onclick="goPage(<%="$"%>{state.page - 1})" <%="$"%>{state.page === 1 ? "disabled" : ""} class="flex size-10 items-center justify-center rounded-full bg-white text-text-muted hover:bg-primary/10 hover:text-primary border border-border-subtle transition-colors disabled:opacity-30"><span class="material-symbols-outlined">chevron_left</span></button>`;
                                for (let p = 1; p <= pages; p++) {
                                  if (p === 1 || p === pages || Math.abs(p - state.page) <= 1) {
                                    html += `<button onclick="goPage(<%="$"%>{p})" class="flex size-10 items-center justify-center rounded-full text-sm font-medium transition-colors <%="$"%>{p === state.page ? "bg-primary text-white shadow-md shadow-primary/30" : "bg-white text-text-muted hover:bg-primary/10 hover:text-primary border border-border-subtle"}"><%="$"%>{p}</button>`;
                                  } else if (Math.abs(p - state.page) === 2) {
                                    html += `<span class="flex size-10 items-center justify-center text-text-muted">&hellip;</span>`;
                                  }
                                }
                                html += `<button onclick="goPage(<%="$"%>{state.page + 1})" <%="$"%>{state.page === pages ? "disabled" : ""} class="flex size-10 items-center justify-center rounded-full bg-white text-text-muted hover:bg-primary/10 hover:text-primary border border-border-subtle transition-colors disabled:opacity-30"><span class="material-symbols-outlined">chevron_right</span></button>`;
                                el.innerHTML = html;
                              }

                              function update() {
                                const data = filteredData();
                                renderActiveFilters();
                                renderCards(data);
                                renderPagination(data.length);
                              }

                              function goPage(p) {
                                const pages = Math.ceil(filteredData().length / state.perPage);
                                if (p < 1 || p > pages) return;
                                state.page = p;
                                renderCards(filteredData());
                                renderPagination(filteredData().length);
                                window.scrollTo({ top: 0, behavior: "smooth" });
                              }

                              // ──────────── Sync helpers ────────────
                              function syncCheckboxes() {
                                document.querySelectorAll(".domain-check").forEach(cb => {
                                  cb.checked = state.domains.has(cb.value);
                                });
                              }

                              function syncRadios(name) {
                                document.querySelectorAll(`input[name="<%="$"%>{name}"]`).forEach(r => {
                                  r.checked = r.value === (name === "stage" ? state.stage : state.risk);
                                });
                              }

                              // ──────────── Clear all ────────────
                              function clearAll() {
                                state.domains.clear();
                                state.stage = ""; state.risk = ""; state.search = ""; state.page = 1;
                                syncCheckboxes();
                                syncRadios("stage"); syncRadios("risk");
                                $("global-search").value = "";
                                if ($("mobile-search")) $("mobile-search").value = "";
                                update();
                              }

                              // ──────────── Event listeners ────────────
                              document.querySelectorAll(".domain-check").forEach(cb => {
                                cb.addEventListener("change", () => {
                                  if (cb.checked) state.domains.add(cb.value);
                                  else state.domains.delete(cb.value);
                                  state.page = 1;
                                  update();
                                });
                              });

                              document.querySelectorAll("input[name='stage']").forEach(r => {
                                r.addEventListener("change", () => { state.stage = r.value; state.page = 1; update(); });
                              });

                              document.querySelectorAll("input[name='risk']").forEach(r => {
                                r.addEventListener("change", () => { state.risk = r.value; state.page = 1; update(); });
                              });

                              $("sort-select").addEventListener("change", e => { state.sort = e.target.value; state.page = 1; update(); });

                              let searchTimeout;
                              function handleSearch(val) {
                                clearTimeout(searchTimeout);
                                searchTimeout = setTimeout(() => { state.search = val.toLowerCase(); state.page = 1; update(); }, 250);
                              }
                              $("global-search").addEventListener("input", e => handleSearch(e.target.value));
                              if ($("mobile-search")) $("mobile-search").addEventListener("input", e => handleSearch(e.target.value));
                              $("clear-all-btn").addEventListener("click", clearAll);
                              $("reset-empty-btn").addEventListener("click", clearAll);

                              // View toggle
                              $("grid-view-btn").addEventListener("click", () => {
                                state.view = "grid";
                                $("grid-view-btn").className = "p-1.5 rounded text-primary bg-primary/10 transition-colors";
                                $("list-view-btn").className = "p-1.5 rounded text-text-muted hover:text-primary transition-colors";
                                update();
                              });
                              $("list-view-btn").addEventListener("click", () => {
                                state.view = "list";
                                $("list-view-btn").className = "p-1.5 rounded text-primary bg-primary/10 transition-colors";
                                $("grid-view-btn").className = "p-1.5 rounded text-text-muted hover:text-primary transition-colors";
                                update();
                              });

                              // Collapsible sidebar sections
                              function toggleSection(id, chevronId) {
                                const list = $(id);
                                const chevron = $(chevronId);
                                if (list.style.display === "none") { list.style.display = ""; chevron.style.transform = ""; }
                                else { list.style.display = "none"; chevron.style.transform = "rotate(180deg)"; }
                              }
                              $("domain-toggle").addEventListener("click", () => toggleSection("domain-list", "domain-chevron"));
                              $("stage-toggle").addEventListener("click", () => toggleSection("stage-list", "stage-chevron"));

                              // ──────────── Init ────────────
                              update();
                            </script>
                          </body>

                          </html>
