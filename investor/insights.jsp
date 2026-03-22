<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
        session.getAttribute("user_name"); %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Investify – Market Insights</title>
            <meta name="description"
                content="Curated market insights, sector trends, and investment intelligence for Investify users." />
            <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800;900&display=swap"
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

                .bar {
                    transition: width 1.1s cubic-bezier(.25, .8, .25, 1)
                }

                @keyframes fadeUp {
                    from {
                        opacity: 0;
                        transform: translateY(12px)
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

                .ticker-wrap {
                    overflow: hidden;
                    white-space: nowrap
                }

                .ticker {
                    display: inline-block;
                    animation: ticker 30s linear infinite
                }

                @keyframes ticker {
                    0% {
                        transform: translateX(0)
                    }

                    100% {
                        transform: translateX(-50%)
                    }
                }
            </style>
        </head>

        <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">

            <!-- NAVBAR -->
            <header
                class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                <div class="flex items-center gap-8">
                    <a href="../index.jsp" class="flex items-center gap-3 hover:opacity-80 transition-opacity">
                        <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                                class="material-symbols-outlined text-xl">diamond</span></div>
                        <span class="text-xl font-bold tracking-tight">Investify</span>
                    </a>
                    <nav class="hidden md:flex items-center gap-7 pl-8 border-l border-border-c text-sm">
                        <a href="dashboard.jsp"
                            class="font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
                        <a href="browse_startups.jsp"
                            class="font-medium text-text-muted hover:text-primary transition-colors">Browse</a>
                        <a href="portfolio"
                            class="font-medium text-text-muted hover:text-primary transition-colors">Portfolio</a>
                        <a href="watchlist.jsp"
                            class="font-medium text-text-muted hover:text-primary transition-colors">Watchlist</a>
                        <a href="insights.jsp"
                            class="font-semibold text-primary border-b-2 border-primary pb-0.5">Insights</a>
                    </nav>
                </div>
                <div class="flex items-center gap-4">
                    <a href="notifications.jsp"
                        class="relative p-2 text-text-muted hover:text-primary transition-colors">
                        <span class="material-symbols-outlined">notifications</span>
                        <span class="absolute top-2 right-2 h-2 w-2 rounded-full bg-primary ring-2 ring-white"></span>
                    </a>
                    <a href="profile.jsp"
                        class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary text-white font-bold text-sm uppercase"
                        title="Profile">
                        <%= userName !=null && !userName.isEmpty() ? userName.substring(0,1) : "U" %>
                    </a>
                </div>
            </header>

            <!-- TICKER (empty - will display live data when available) -->
            <div class="bg-text-main text-primary ticker-wrap py-2">
                <div class="ticker text-xs font-semibold tracking-wide">
                    <span class="mx-8">No market data available yet</span>
                </div>
            </div>

            <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-10">

                <!-- Hero -->
                <div class="fade-up stagger-1">
                    <h1 class="text-4xl font-black">Market Insights</h1>
                    <p class="text-text-muted mt-1 text-lg">Sector trends, investment intelligence, and curated
                        research.</p>
                </div>

                <!-- Sector Performance -->
                <section class="fade-up stagger-2">
                    <h2 class="text-2xl font-bold mb-5">Sector Performance <span
                            class="text-sm font-normal text-text-muted ml-2">Q1 2026</span></h2>
                    <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
                        <div
                            class="bg-surface rounded-2xl border border-border-c shadow-sm p-5 text-center hover:shadow-md transition-shadow cursor-pointer group">
                            <div
                                class="size-12 rounded-full bg-primary/10 flex items-center justify-center mx-auto mb-3 group-hover:bg-primary group-hover:text-white text-primary transition-colors">
                                <span class="material-symbols-outlined text-[24px]">currency_exchange</span>
                            </div>
                            <p class="font-bold text-sm">Fintech</p>
                            <p class="text-text-muted font-black text-xl mt-1"></p>
                            <p class="text-xs text-text-muted mt-1">ROI  0 startups</p>
                        </div>
                        <div
                            class="bg-surface rounded-2xl border border-border-c shadow-sm p-5 text-center hover:shadow-md transition-shadow cursor-pointer group">
                            <div
                                class="size-12 rounded-full bg-blue-100 flex items-center justify-center mx-auto mb-3 group-hover:bg-blue-600 group-hover:text-white text-blue-600 transition-colors">
                                <span class="material-symbols-outlined text-[24px]">biotech</span>
                            </div>
                            <p class="font-bold text-sm">Healthcare</p>
                            <p class="text-text-muted font-black text-xl mt-1"></p>
                            <p class="text-xs text-text-muted mt-1">ROI  0 startups</p>
                        </div>
                        <div
                            class="bg-surface rounded-2xl border border-border-c shadow-sm p-5 text-center hover:shadow-md transition-shadow cursor-pointer group">
                            <div
                                class="size-12 rounded-full bg-purple-100 flex items-center justify-center mx-auto mb-3 group-hover:bg-purple-600 group-hover:text-white text-purple-600 transition-colors">
                                <span class="material-symbols-outlined text-[24px]">smart_toy</span>
                            </div>
                            <p class="font-bold text-sm">AI & Robotics</p>
                            <p class="text-text-muted font-black text-xl mt-1"></p>
                            <p class="text-xs text-text-muted mt-1">ROI  0 startups</p>
                        </div>
                        <div
                            class="bg-surface rounded-2xl border border-border-c shadow-sm p-5 text-center hover:shadow-md transition-shadow cursor-pointer group">
                            <div
                                class="size-12 rounded-full bg-green-100 flex items-center justify-center mx-auto mb-3 group-hover:bg-green-600 group-hover:text-white text-green-600 transition-colors">
                                <span class="material-symbols-outlined text-[24px]">eco</span>
                            </div>
                            <p class="font-bold text-sm">Sustainability</p>
                            <p class="text-text-muted font-black text-xl mt-1"></p>
                            <p class="text-xs text-text-muted mt-1">ROI  0 startups</p>
                        </div>
                        <div
                            class="bg-surface rounded-2xl border border-border-c shadow-sm p-5 text-center hover:shadow-md transition-shadow cursor-pointer group">
                            <div
                                class="size-12 rounded-full bg-amber-100 flex items-center justify-center mx-auto mb-3 group-hover:bg-amber-600 group-hover:text-white text-amber-600 transition-colors">
                                <span class="material-symbols-outlined text-[24px]">school</span>
                            </div>
                            <p class="font-bold text-sm">EdTech</p>
                            <p class="text-text-muted font-black text-xl mt-1"></p>
                            <p class="text-xs text-text-muted mt-1">ROI  0 startups</p>
                        </div>
                    </div>
                </section>

                <div class="grid md:grid-cols-2 gap-6">
                    <!-- Trending investments bar chart -->
                    <section class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 fade-up stagger-3">
                        <h2 class="text-lg font-bold mb-5">Hottest Investments Right Now</h2>
                        <div class="text-center py-10 text-text-muted">
                            <span class="material-symbols-outlined text-4xl mb-2 block"
                                style="font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 48">trending_up</span>
                            <p class="font-semibold text-text-main">No trending data yet</p>
                            <p class="text-sm mt-1">Investment trends will appear here when data is available.</p>
                        </div>
                    </section>

                    <!-- Market sentiment + macro metrics -->
                    <section class="flex flex-col gap-4 fade-up stagger-4">
                        <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6">
                            <h2 class="text-lg font-bold mb-4">Market Sentiment</h2>
                            <div class="text-center py-6 text-text-muted">
                                <span class="material-symbols-outlined text-4xl mb-2 block"
                                    style="font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 48">monitoring</span>
                                <p class="font-semibold text-text-main">No sentiment data</p>
                                <p class="text-sm mt-1">Market sentiment will be displayed once data is available.</p>
                            </div>
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-4 text-center">
                                <p class="text-xs text-text-muted font-semibold mb-1">Total Capital Deployed</p>
                                <p class="text-xl font-black">$0</p>
                                <p class="text-xs text-text-muted font-bold mt-0.5"></p>
                            </div>
                            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-4 text-center">
                                <p class="text-xs text-text-muted font-semibold mb-1">Avg. Deal Size</p>
                                <p class="text-xl font-black">$0</p>
                                <p class="text-xs text-text-muted font-bold mt-0.5"></p>
                            </div>
                            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-4 text-center">
                                <p class="text-xs text-text-muted font-semibold mb-1">New Startups (Q1)</p>
                                <p class="text-xl font-black">0</p>
                                <p class="text-xs text-text-muted font-bold mt-0.5"></p>
                            </div>
                            <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-4 text-center">
                                <p class="text-xs text-text-muted font-semibold mb-1">Platform Avg. ROI</p>
                                <p class="text-xl font-black text-text-muted"></p>
                                <p class="text-xs text-text-muted font-bold mt-0.5"></p>
                            </div>
                        </div>
                    </section>
                </div>

                <!-- Research articles -->
                <section>
                    <div class="flex items-center justify-between mb-5">
                        <h2 class="text-2xl font-bold">Research & Analysis</h2>
                        <div class="flex gap-2" id="article-tabs">
                            <button onclick="filterArticles('all',this)"
                                class="px-4 py-1.5 rounded-full bg-primary text-white text-xs font-bold">All</button>
                            <button onclick="filterArticles('sector',this)"
                                class="px-4 py-1.5 rounded-full bg-bg-light border border-border-c text-xs font-medium text-text-muted hover:border-primary/40 transition-colors">Sector</button>
                            <button onclick="filterArticles('policy',this)"
                                class="px-4 py-1.5 rounded-full bg-bg-light border border-border-c text-xs font-medium text-text-muted hover:border-primary/40 transition-colors">Policy</button>
                            <button onclick="filterArticles('macro',this)"
                                class="px-4 py-1.5 rounded-full bg-bg-light border border-border-c text-xs font-medium text-text-muted hover:border-primary/40 transition-colors">Macro</button>
                        </div>
                    </div>
                    <div id="articles-grid" class="grid md:grid-cols-3 gap-5">
                        <!-- JS rendered -->
                    </div>
                </section>

                <!-- Watchlist / CTA -->
                <section
                    class="bg-gradient-to-r from-text-main to-text-main/90 rounded-2xl p-8 text-white flex flex-col md:flex-row items-center justify-between gap-6">
                    <div>
                        <h2 class="text-2xl font-black">Personalise Your Insights</h2>
                        <p class="text-white/60 mt-2 max-w-lg">Follow sectors and add startups to your watchlist to
                            receive
                            personalised alerts and curated research tailored to your portfolio.</p>
                    </div>
                    <a href="browse_startups.jsp"
                        class="flex-shrink-0 flex items-center gap-2 h-11 px-6 rounded-full bg-primary text-white font-bold text-sm hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.4)] whitespace-nowrap">
                        <span class="material-symbols-outlined text-[18px]">explore</span>Browse Startups
                    </a>
                </section>

            </main>

            <script>
                const ARTICLES = [];
                let curFilter = 'all';
                function renderArticles() {
                    const filtered = curFilter === 'all' ? ARTICLES : ARTICLES.filter(a => a.type === curFilter);
                    document.getElementById('articles-grid').innerHTML = filtered.map(a => `
    <div class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden hover:shadow-md transition-shadow group cursor-pointer">
      <div class="h-36 bg-gradient-to-br from-text-main/10 to-primary/10 flex items-center justify-center">
        <span class="material-symbols-outlined text-[48px] text-primary/30">article</span>
      </div>
      <div class="p-5">
        <div class="flex items-center gap-2 mb-3">
          <span class="px-2.5 py-0.5 rounded-full text-xs font-bold ${a.tagColor}">${a.tag}</span>
          <span class="text-xs text-text-muted">${a.read} read</span>
        </div>
        <h3 class="font-bold text-sm leading-snug mb-2 group-hover:text-primary transition-colors line-clamp-2">${a.title}</h3>
        <p class="text-xs text-text-muted leading-relaxed mb-4 line-clamp-2">${a.summary}</p>
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-2"><img src="https://i.pravatar.cc/28?u=${a.author}" class="h-6 w-6 rounded-full"/><span class="text-xs text-text-muted">${a.author}</span></div>
          <span class="text-xs text-text-muted">${a.date}</span>
        </div>
      </div>
    </div>`).join('');
                }
                function filterArticles(type, btn) {
                    curFilter = type;
                    document.querySelectorAll('#article-tabs button').forEach(b => { b.className = 'px-4 py-1.5 rounded-full bg-bg-light border border-border-c text-xs font-medium text-text-muted hover:border-primary/40 transition-colors'; });
                    btn.className = 'px-4 py-1.5 rounded-full bg-primary text-white text-xs font-bold';
                    renderArticles();
                }
                setTimeout(() => { document.querySelectorAll('.bar[data-pct]').forEach(el => { el.style.width = el.dataset.pct + '%'; }); }, 400);
                renderArticles();
            </script>
        </body>

        </html>
