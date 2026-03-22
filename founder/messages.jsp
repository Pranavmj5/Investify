<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("user_name");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Investify – Messages (Founder)</title>
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800;900&display=swap"
        rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
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

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(8px)
            }

            to {
                opacity: 1;
                transform: translateY(0)
            }
        }

        .fade-up {
            animation: fadeUp .35s ease forwards
        }
    </style>
</head>

<body class="bg-bg-light font-display text-text-main min-h-screen antialiased">

    <!-- FOUNDER NAV -->
    <header
        class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
        <div class="flex items-center gap-8">
            <a href="../index.jsp" class="flex items-center gap-3">
                <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                        class="material-symbols-outlined text-xl">diamond</span></div>
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
            <a href="messages.jsp" class="text-sm font-semibold text-primary">Messages</a>
            <a href="settings.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Settings</a>
        </nav>
        <div class="flex items-center gap-4">
            <a href="messages.jsp" class="relative p-2 text-text-muted hover:text-primary transition-colors">
                <span class="material-symbols-outlined">notifications</span>
                <span class="absolute top-2 right-2 h-2 w-2 rounded-full bg-primary ring-2 ring-white"></span>
            </a>
            <a href="create_profile.jsp">
                <img src="https://i.pravatar.cc/36?img=25"
                    class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                    alt="Founder" />
            </a>
        </div>
    </header>

    <main class="max-w-[1100px] mx-auto px-6 py-8 flex flex-col gap-6">
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-black">Messages & Notifications</h1>
                <p class="text-text-muted mt-1">Stay on top of investor interest, platform updates, and KYC status.</p>
            </div>
            <button onclick="markAllRead()"
                class="flex items-center gap-2 h-9 px-5 rounded-full border border-border-c text-sm font-semibold hover:border-primary/40 hover:bg-surface transition-colors">
                <span class="material-symbols-outlined text-[18px]">done_all</span>Mark all read
            </button>
        </div>

        <!-- Filter tabs -->
        <div class="flex items-center gap-2 bg-surface border border-border-c rounded-xl p-0.5 w-fit" id="filter-tabs">
            <button onclick="filterNotifs('all',this)"
                class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold">All</button>
            <button onclick="filterNotifs('interest',this)"
                class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">Investor
                Interest</button>
            <button onclick="filterNotifs('kyc',this)"
                class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">KYC
                / Docs</button>
            <button onclick="filterNotifs('system',this)"
                class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">System</button>
        </div>

        <!-- Notifications list -->
        <div class="flex flex-col gap-3" id="notifs-list"></div>
    </main>

    <script>
        const NOTIFS = [];
        let curFilter = 'all';
        function filterNotifs(type, btn) {
            curFilter = type;
            document.querySelectorAll('#filter-tabs button').forEach(b => b.className = 'px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors');
            btn.className = 'px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold';
            renderNotifs();
        }
        function renderNotifs() {
            const filtered = curFilter === 'all' ? NOTIFS : NOTIFS.filter(n => n.type === curFilter);
            document.getElementById('notifs-list').innerHTML = filtered.map((n, i) => `
    <div class="fade-up bg-surface rounded-2xl border ${n.unread ? 'border-primary/30 shadow-[0_2px_12px_rgba(198,166,93,.1)]' : 'border-border-c'} shadow-sm px-5 py-4 flex items-start gap-4 transition-all" style="animation-delay:${i * .04}s" id="notif-${i}">
      ${n.avatar ? `<img src="${n.avatar}" class="h-10 w-10 rounded-full object-cover ring-2 ring-border-c flex-shrink-0" alt=""/>` : `<div class="size-10 rounded-xl ${n.iconBg} flex items-center justify-center flex-shrink-0"><span class="material-symbols-outlined text-[20px]">${n.icon}</span></div>`}
      <div class="flex-1 min-w-0">
        <div class="flex items-start justify-between gap-3 mb-1">
          <p class="text-sm font-bold leading-tight">${n.title}${n.unread ? '<span class="inline-block w-2 h-2 rounded-full bg-primary ml-2 align-middle"></span>' : ''}</p>
          <span class="text-xs text-text-muted whitespace-nowrap flex-shrink-0">${n.time}</span>
        </div>
        <p class="text-sm text-text-muted leading-relaxed">${n.body}</p>
        ${n.type === 'interest' && n.avatar ? `<div class="flex gap-2 mt-3"><button onclick="acceptInterest(${i})" class="h-8 px-4 rounded-full bg-primary text-white text-xs font-bold hover:bg-primary-dark transition-colors">Accept</button><button onclick="declineInterest(${i})" class="h-8 px-4 rounded-full border border-border-c text-xs font-semibold hover:bg-bg-light transition-colors">Decline</button></div>` : ''}
      </div>
    </div>`).join('');
        }
        function markAllRead() {
            NOTIFS.forEach(n => n.unread = false);
            renderNotifs();
        }
        function acceptInterest(i) {
            const el = document.getElementById('notif-' + i);
            el.querySelector('.flex.gap-2').innerHTML = '<span class="text-xs font-bold text-emerald-600 bg-emerald-50 px-3 py-1.5 rounded-full">✓ Accepted</span>';
            NOTIFS[i].unread = false; el.classList.remove('border-primary/30'); el.classList.add('border-border-c');
        }
        function declineInterest(i) {
            const el = document.getElementById('notif-' + i);
            el.querySelector('.flex.gap-2').innerHTML = '<span class="text-xs font-bold text-red-500 bg-red-50 px-3 py-1.5 rounded-full">✗ Declined</span>';
            NOTIFS[i].unread = false; el.classList.remove('border-primary/30'); el.classList.add('border-border-c');
        }
        renderNotifs();
    </script>
</body>

</html>
