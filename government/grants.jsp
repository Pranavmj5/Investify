<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.investify.db.DBConnection, java.sql.*, java.util.*" %>
<%
    StringBuilder grantsJson = new StringBuilder(); grantsJson.append("[");
    double totalBudget = 0; double disbursed = 0; double pending = 0;
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement()) {
        
        ResultSet rsBudget = stmt.executeQuery("SELECT SUM(budget) FROM schemes");
        if(rsBudget.next()) totalBudget = rsBudget.getDouble(1);
        if(totalBudget == 0) totalBudget = 5000000000L;
        rsBudget.close();
        
        ResultSet rs = stmt.executeQuery("SELECT s.title, g.scheme_name, g.grant_amount, g.approval_status, g.updated_at FROM government_status g JOIN startup s ON g.startup_id = s.id ORDER BY g.updated_at DESC");
        boolean first = true;
        while(rs.next()) {
            if(!first) grantsJson.append(",");
            String name = rs.getString("title").replace("\"", "\\\"");
            String scheme = rs.getString("scheme_name"); if(scheme!=null) scheme = scheme.replace("\"", "\\\""); else scheme = "General Fund";
            double amt = rs.getDouble("grant_amount");
            String status = rs.getString("approval_status");
            if("approved".equals(status)) { status = "disbursed"; disbursed += amt; }
            else if("pending".equals(status)) pending += amt;
            String date = rs.getDate("updated_at") != null ? rs.getDate("updated_at").toString() : "2025-10-15";
            
            String amtStr = "₹" + (int)(amt/100000) + " Lakhs";
            if(amt >= 10000000) amtStr = "₹" + String.format("%.1f", amt/10000000) + " Cr";
            
            grantsJson.append("{ name: \"").append(name).append("\", scheme: \"").append(scheme)
                      .append("\", amount: \"").append(amtStr).append("\", date: \"").append(date)
                      .append("\", status: \"").append(status).append("\", icon: \"business\", iconBg: \"bg-blue-100 text-blue-600\" }");
            first = false;
        }
        rs.close();
    } catch(Exception e) { e.printStackTrace(); }
    grantsJson.append("]");
%>

    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
        session.getAttribute("user_name"); %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Investify – Grant Allocation</title>
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
            <header
                class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                <div class="flex items-center gap-6"><a href="../index.jsp" class="flex items-center gap-3">
                        <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                                class="material-symbols-outlined text-xl">diamond</span></div><span
                            class="text-lg font-bold">Investify</span>
                    </a><span
                        class="hidden md:block text-xs font-bold uppercase tracking-widest text-blue-700 bg-blue-50 rounded-full px-3 py-1">Government
                        Portal</span></div>
                <nav class="hidden lg:flex items-center gap-6">
				<a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
				<a href="schemes.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Schemes</a>
				<a href="applications.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Applications</a>
				<a href="grants.jsp" class="text-sm font-semibold text-primary border-b-2 border-primary pb-1">Grants</a>
				<a href="reports.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Reports</a>
			</nav>
                <a href="settings.jsp"><img src="https://i.pravatar.cc/36?img=60"
                        class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                        alt="User" /></a>
            </header>
            <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-6">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-black">Grant Allocation</h1>
                        <p class="text-text-muted mt-1">Review and disburse grants to eligible startups.</p>
                    </div>
                    <div class="flex items-center gap-3 bg-surface border border-border-c rounded-xl p-0.5">
                        <button id="filter-all" onclick="filterGrants('all',this)"
                            class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold">All</button>
                        <button onclick="filterGrants('pending',this)"
                            class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">Pending</button>
                        <button onclick="filterGrants('approved',this)"
                            class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">Approved</button>
                        <button onclick="filterGrants('disbursed',this)"
                            class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">Disbursed</button>
                    </div>
                </div>

                <!-- Summary -->
                <div class="grid grid-cols-3 gap-5">
                    <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm text-center">
                        <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-1">Total Budget</p>
                        <p class="text-2xl font-black">₹<%= String.format("%.0f", totalBudget/10000000) %> Cr</p>
                    </div>
                    <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm text-center">
                        <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-1">Disbursed</p>
                        <p class="text-2xl font-black text-emerald-600">₹<%= String.format("%.2f", disbursed/10000000) %> Cr</p>
                    </div>
                    <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm text-center">
                        <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-1">Pending</p>
                        <p class="text-2xl font-black text-amber-500">₹<%= String.format("%.2f", pending/10000000) %> Cr</p>
                    </div>
                </div>

                <!-- Grants table -->
                <div class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden">
                    <div class="px-6 py-4 border-b border-border-c">
                        <h2 class="text-lg font-bold">Grant Applications</h2>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left text-sm" id="grants-table">
                            <thead class="bg-bg-light text-xs font-bold uppercase tracking-wider text-text-muted">
                                <tr>
                                    <th class="px-6 py-3.5">Startup</th>
                                    <th class="px-6 py-3.5">Scheme</th>
                                    <th class="px-6 py-3.5">Amount</th>
                                    <th class="px-6 py-3.5">Applied</th>
                                    <th class="px-6 py-3.5">Status</th>
                                    <th class="px-6 py-3.5">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border-c" id="grants-body"></tbody>
                        </table>
                    </div>
                </div>
            </main>
            <script>
                const GRANTS = <%= grantsJson.toString() %>;
                const STATUS_MAP = { pending: { cls: 'bg-amber-50 text-amber-700', label: 'Pending' }, approved: { cls: 'bg-emerald-50 text-emerald-700', label: 'Approved' }, disbursed: { cls: 'bg-blue-50 text-blue-700', label: 'Disbursed' } };
                let curFilter = 'all';
                function renderGrants() {
                    const filtered = curFilter === 'all' ? GRANTS : GRANTS.filter(g => g.status === curFilter);
                    document.getElementById('grants-body').innerHTML = filtered.length === 0
                        ? '<tr><td colspan="6" class="px-6 py-16 text-center text-text-muted"><span class="material-symbols-outlined text-4xl mb-2 block" style="font-variation-settings:\'FILL\' 0,\'wght\' 300,\'GRAD\' 0,\'opsz\' 48">assignment</span><p class="font-semibold text-text-main">No grant applications</p><p class="text-sm mt-1">Grant applications will appear here when startups apply for schemes.</p></td></tr>'
                        : filtered.map(g => {
                            const s = STATUS_MAP[g.status];
                            const actions = g.status === 'pending' ? `<button onclick="approve(this)" class="h-8 px-3 rounded-full bg-primary text-white text-xs font-bold hover:bg-primary-dark transition-colors mr-1">Approve</button><button class="h-8 px-3 rounded-full border border-red-200 text-red-600 text-xs font-semibold hover:bg-red-50 transition-colors">Reject</button>` : g.status === 'approved' ? `<button onclick="disburse(this)" class="h-8 px-3 rounded-full bg-emerald-600 text-white text-xs font-bold hover:bg-emerald-700 transition-colors">Disburse</button>` : '-';
                            return `<tr class="hover:bg-bg-light transition-colors" data-status="${g.status}">
                        <td class="px-6 py-4"><div class="flex items-center gap-3"><div class="size-9 rounded-lg ${g.iconBg} flex items-center justify-center"><span class="material-symbols-outlined text-[18px]">${g.icon}</span></div><span class="font-semibold">${g.name}</span></div></td>
                        <td class="px-6 py-4 text-text-muted">${g.scheme}</td>
                        <td class="px-6 py-4 font-bold">${g.amount}</td>
                        <td class="px-6 py-4 text-text-muted">${g.date}</td>
                        <td class="px-6 py-4"><span class="px-2.5 py-0.5 rounded-full text-xs font-bold ${s.cls}">${s.label}</span></td>
                        <td class="px-6 py-4">${actions}</td>
                    </tr>`;
                        }).join('');
                }
                function filterGrants(type, btn) {
                    curFilter = type;
                    document.querySelectorAll('#filter-all').forEach(b => b.className = 'px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors');
                    document.querySelectorAll('header ~ main button').forEach(b => { if (b.closest('div.flex')) b.className = 'px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors'; });
                    btn.className = 'px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold';
                    renderGrants();
                }
                function approve(btn) {
                    btn.closest('tr').querySelector('td:nth-child(5) span').className = 'px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700';
                    btn.closest('tr').querySelector('td:nth-child(5) span').textContent = 'Approved';
                    btn.closest('td').innerHTML = '<button onclick="disburse(this)" class="h-8 px-3 rounded-full bg-emerald-600 text-white text-xs font-bold hover:bg-emerald-700 transition-colors">Disburse</button>';
                }
                function disburse(btn) {
                    btn.closest('tr').querySelector('td:nth-child(5) span').className = 'px-2.5 py-0.5 rounded-full text-xs font-bold bg-blue-50 text-blue-700';
                    btn.closest('tr').querySelector('td:nth-child(5) span').textContent = 'Disbursed';
                    btn.closest('td').innerHTML = '-';
                }
                renderGrants();
            </script>
        </body>

        </html>