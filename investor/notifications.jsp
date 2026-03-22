<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
        session.getAttribute("user_name"); %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Investify – Notifications</title>
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

                .icon-fill {
                    font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24
                }
            </style>
        </head>

        <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
            <header
                class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                <div class="flex items-center gap-6">
                    <a href="../index.jsp" class="flex items-center gap-3">
                        <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                                class="material-symbols-outlined text-xl">diamond</span></div><span
                            class="text-lg font-bold">Investify</span>
                    </a>
                </div>
                <nav class="hidden lg:flex items-center gap-6">
                            <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
                            <a href="browse_startups.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Browse</a>
                            <a href="portfolio.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Portfolio</a>
                            <a href="watchlist.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Watchlist</a>
                            <a href="insights.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Insights</a>
                            <a href="notifications.jsp" class="text-sm font-semibold text-primary">Notifications</a>
                        </nav>
                <a href="profile.jsp"
                    class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all flex items-center justify-center bg-primary text-white font-bold text-sm uppercase"
                    title="Profile">
                    <%= userName !=null && !userName.isEmpty() ? userName.substring(0,1) : "U" %>
                </a>
            </header>
            <main class="max-w-3xl mx-auto px-6 py-8 flex flex-col gap-6">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-black">Notifications</h1>
                        <p class="text-text-muted mt-1">Stay up-to-date with your investments.</p>
                    </div>
                    <button onclick="markAllRead()"
                        class="text-sm font-semibold text-primary hover:text-primary-dark transition-colors">Mark all
                        read</button>
                </div>
                <!-- Filter tabs -->
                <div class="flex gap-2" id="filter-tabs">
                    <button onclick="filterNotifs('all',this)"
                        class="px-4 py-1.5 rounded-full bg-primary text-white text-sm font-semibold">All</button>
                    <button onclick="filterNotifs('investment',this)"
                        class="px-4 py-1.5 rounded-full bg-bg-light border border-border-c text-sm font-medium text-text-muted hover:border-primary/40 transition-colors">Investment</button>
                    <button onclick="filterNotifs('system',this)"
                        class="px-4 py-1.5 rounded-full bg-bg-light border border-border-c text-sm font-medium text-text-muted hover:border-primary/40 transition-colors">System</button>
                    <button onclick="filterNotifs('startup',this)"
                        class="px-4 py-1.5 rounded-full bg-bg-light border border-border-c text-sm font-medium text-text-muted hover:border-primary/40 transition-colors">Startup
                        Updates</button>
                </div>
                <!-- Notification list -->
                <div id="notif-list" class="flex flex-col gap-3">
                    <!-- rendered by JS -->
                </div>
            </main>
            <script>
                const NOTIFS = [];
                let curFilter = 'all';
                function renderNotifs() {
                    const filtered = curFilter === 'all' ? NOTIFS : NOTIFS.filter(n => n.type === curFilter);
                    const el = document.getElementById('notif-list');
                    if (!filtered.length) { el.innerHTML = '<div class="text-center py-12 text-text-muted"><span class="material-symbols-outlined text-[48px] mb-3 block">notifications_off</span><p class="font-semibold">No notifications</p></div>'; return; }
                    el.innerHTML = filtered.map(n => `
    <a href="${n.link}" class="flex gap-4 bg-surface rounded-2xl border ${n.unread ? 'border-primary/20 bg-primary/2' : 'border-border-c'} p-5 hover:shadow-md transition-all group notif-item" data-type="${n.type}" data-id="${n.id}" onclick="markRead(${n.id})">
      <div class="size-11 rounded-full flex-shrink-0 flex items-center justify-center ${n.color}"><span class="material-symbols-outlined text-[22px]">${n.icon}</span></div>
      <div class="flex-1 min-w-0">
        <div class="flex items-start justify-between gap-2">
          <p class="font-semibold text-sm leading-snug ${n.unread ? 'text-text-main' : 'text-text-muted'}">${n.title}</p>
          ${n.unread ? '<div class="size-2 rounded-full bg-primary flex-shrink-0 mt-1"></div>' : ''}
        </div>
        <p class="text-xs text-text-muted mt-1 leading-relaxed">${n.body}</p>
        <p class="text-xs text-text-muted mt-2 font-medium">${n.time}</p>
      </div>
    </a>`).join('');
                }
                function markRead(id) {
                    const n = NOTIFS.find(n => n.id === id);
                    if (n) n.unread = false;
                }
                function markAllRead() {
                    NOTIFS.forEach(n => n.unread = false);
                    renderNotifs();
                }
                function filterNotifs(type, btn) {
                    curFilter = type;
                    document.querySelectorAll('#filter-tabs button').forEach(b => { b.className = 'px-4 py-1.5 rounded-full bg-bg-light border border-border-c text-sm font-medium text-text-muted hover:border-primary/40 transition-colors'; });
                    btn.className = 'px-4 py-1.5 rounded-full bg-primary text-white text-sm font-semibold';
                    renderNotifs();
                }
                renderNotifs();
            </script>
        </body>

        </html>
