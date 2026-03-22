<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
        session.getAttribute("user_name"); %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Investify – My Watchlist</title>
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

                .fill {
                    font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24
                }

                .bar {
                    width: 0;
                    transition: width 1s ease
                }

                @keyframes fadeUp {
                    from {
                        opacity: 0;
                        transform: translateY(10px)
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0)
                    }
                }

                .fade-up {
                    animation: fadeUp .4s ease forwards
                }
            </style>
        </head>

        <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
            <header
                class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                <div class="flex items-center gap-8">
                    <a href="../index.jsp" class="flex items-center gap-3">
                        <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                                class="material-symbols-outlined text-xl">diamond</span></div><span
                            class="text-xl font-bold">Investify</span>
                    </a>
                    <nav class="hidden md:flex items-center gap-7 pl-8 border-l border-border-c text-sm">
                        <a href="dashboard.jsp"
                            class="font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
                        <a href="browse_startups.jsp"
                            class="font-medium text-text-muted hover:text-primary transition-colors">Browse</a>
                        <a href="portfolio"
                            class="font-medium text-text-muted hover:text-primary transition-colors">Portfolio</a>
                        <a href="watchlist.jsp"
                            class="font-semibold text-primary border-b-2 border-primary pb-0.5">Watchlist</a>
                        <a href="insights.jsp"
                            class="font-medium text-text-muted hover:text-primary transition-colors">Insights</a>
                    </nav>
                </div>
                <div class="flex items-center gap-4">
                    <a href="notifications.jsp"
                        class="relative p-2 text-text-muted hover:text-primary transition-colors"><span
                            class="material-symbols-outlined">notifications</span><span
                            class="absolute top-2 right-2 h-2 w-2 rounded-full bg-primary ring-2 ring-white"></span></a>
                    <a href="profile.jsp"
                        class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary text-white font-bold text-sm uppercase"
                        title="Profile">
                        <%= userName !=null && !userName.isEmpty() ? userName.substring(0,1) : "U" %>
                    </a>
                </div>
            </header>

            <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-6">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-black">My Watchlist</h1>
                        <p class="text-text-muted mt-1">Track startups you are interested in before investing.</p>
                    </div>
                    <a href="browse_startups.jsp"
                        class="flex items-center gap-2 h-10 px-5 rounded-full border border-border-c text-sm font-semibold hover:bg-surface hover:border-primary/40 transition-colors">
                        <span class="material-symbols-outlined text-[18px]">add</span>Add Startups
                    </a>
                </div>

                <!-- Watchlist cards -->
                <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-5" id="watchlist-grid">
                    <!-- rendered by JS -->
                </div>

                <!-- Empty state (hidden by default) -->
                <div id="empty-watchlist" class="hidden text-center py-20">
                    <span class="material-symbols-outlined text-[60px] text-text-muted mb-3 block"
                        style="font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 48">bookmark_border</span>
                    <p class="text-xl font-bold text-text-main">Your watchlist is empty</p>
                    <p class="text-text-muted text-sm mt-2 mb-6">Browse startups and click the bookmark icon to add them
                        here.
                    </p>
                    <a href="browse_startups.jsp"
                        class="inline-flex items-center gap-2 h-10 px-6 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors">Browse
                        Startups</a>
                </div>
            </main>

            <script>
                const WATCHLIST = [];
                function fmt(n) { return n >= 1e6 ? `$<%="$"%>{(n / 1e6).toFixed(1)}M` : `$<%="$"%>{(n / 1000).toFixed(0)}K`; }

                function renderWatchlist() {
                    if (WATCHLIST.length === 0) { document.getElementById('empty-watchlist').classList.remove('hidden'); return; }
                    document.getElementById('watchlist-grid').innerHTML = WATCHLIST.map((s, i) => `
    <div class="fade-up bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden hover:shadow-md transition-all group" style="animation-delay:<%="$"%>{i * .07}s">
      <div class="flex items-center justify-between p-5 pb-4 border-b border-border-c">
        <div class="flex items-center gap-3">
          <div class="size-10 rounded-xl <%="$"%>{s.iconBg} flex items-center justify-center"><span class="material-symbols-outlined text-[20px]"><%="$"%>{s.icon}</span></div>
          <div>
            <p class="font-bold text-sm leading-tight"><%="$"%>{s.name}</p>
            <p class="text-xs text-text-muted"><%="$"%>{s.domain} · <%="$"%>{s.stage}</p>
          </div>
        </div>
        <button onclick="removeFromWatchlist(<%="$"%>{s.id},this)" class="text-primary hover:text-red-400 transition-colors p-1" title="Remove from watchlist">
          <span class="material-symbols-outlined text-[22px] fill">bookmark</span>
        </button>
      </div>
      <div class="p-5 flex flex-col gap-4">
        <div class="flex justify-between items-center text-sm">
          <span class="text-text-muted">Funding Progress</span>
          <span class="font-black text-lg <%="$"%>{s.pct >= 75 ? 'text-primary' : 'text-text-main'}"><%="$"%>{s.pct}%</span>
        </div>
        <div class="h-2 bg-bg-light rounded-full overflow-hidden"><div class="h-full <%="$"%>{s.pct >= 75 ? 'bg-primary' : 'bg-text-muted/40'} rounded-full bar" data-pct="<%="$"%>{s.pct}"></div></div>
        <div class="grid grid-cols-2 gap-3 text-xs">
          <div class="bg-bg-light rounded-lg p-2.5"><p class="text-text-muted mb-0.5">Raised</p><p class="font-bold text-sm"><%="$"%>{fmt(s.raised)}</p></div>
          <div class="bg-bg-light rounded-lg p-2.5"><p class="text-text-muted mb-0.5">Goal</p><p class="font-bold text-sm"><%="$"%>{fmt(s.target)}</p></div>
        </div>
        <div class="flex items-center justify-between text-xs">
          <span class="<%="$"%>{s.trendUp ? 'text-emerald-600' : 'text-red-500'} font-bold"><%="$"%>{s.trend} this week</span>
          <span class="<%="$"%>{s.daysLeft <= 14 ? 'text-red-500' : 'text-text-muted'} font-semibold"><%="$"%>{s.daysLeft} days left</span>
        </div>
        <div class="flex gap-2">
          <a href="startup_detail.jsp?id=<%="$"%>{s.id}" class="flex-1 h-9 rounded-full border border-border-c text-xs font-semibold flex items-center justify-center hover:border-primary hover:text-primary transition-colors">View Details</a>
          <a href="invest.jsp?id=<%="$"%>{s.id}" class="flex-1 h-9 rounded-full bg-primary text-white text-xs font-bold flex items-center justify-center hover:bg-primary-dark transition-colors shadow-[0_2px_8px_rgba(198,166,93,.25)]">Invest Now</a>
        </div>
      </div>
    </div>`).join('');
                    // animate bars
                    setTimeout(() => { document.querySelectorAll('.bar[data-pct]').forEach(el => { el.style.width = el.dataset.pct + '%'; }); }, 300);
                }
                function removeFromWatchlist(id, btn) {
                    const idx = WATCHLIST.findIndex(s => s.id === id);
                    if (idx > -1) {
                        WATCHLIST.splice(idx, 1);
                        const card = btn.closest('[class*="fade-up"]');
                        card.style.transform = 'scale(0.95)'; card.style.opacity = '0'; card.style.transition = 'all .3s';
                        setTimeout(() => renderWatchlist(), 300);
                    }
                }
                renderWatchlist();
            </script>
        </body>

        </html>
