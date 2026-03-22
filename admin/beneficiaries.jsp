<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
<% 
   if (session.getAttribute("user_id") == null || !"admin".equals(session.getAttribute("role"))) { 
       response.sendRedirect(request.getContextPath() + "/login.jsp"); 
       return; 
   } 

   int total = 0, active = 0, completed = 0, flagged = 0;
   StringBuilder jsArray = new StringBuilder();

   try (Connection conn = DBConnection.getConnection()) {
       String q = "SELECT a.status as app_status, s.title, sc.name as scheme_name " +
                  "FROM scheme_applications a " +
                  "JOIN startup s ON a.startup_id = s.id " +
                  "JOIN schemes sc ON a.scheme_id = sc.id";
       ResultSet rs = conn.createStatement().executeQuery(q);
       while(rs.next()){
           String appStatus = rs.getString("app_status");
           String sTitle = rs.getString("title").replace("'", "\\'");
           String scName = rs.getString("scheme_name").replace("'", "\\'");
           
           String uiStatus = "flagged";
           if("approved".equals(appStatus)) {
               uiStatus = "active";
               active++;
           } else if("disbursed".equals(appStatus)) {
               uiStatus = "completed";
               completed++;
           } else if("rejected".equals(appStatus) || "under_review".equals(appStatus)) {
               uiStatus = "flagged";
               flagged++;
           } else {
               // pending
               uiStatus = "flagged";
               flagged++;
           }
           total++;

           String benefit = "Grant Processing";
           if ("completed".equals(uiStatus)) benefit = "Funds Disbursed";
           else if ("active".equals(uiStatus)) benefit = "Funds Approved";

           String milestone = "completed".equals(uiStatus) ? "100%" : "pending";

           jsArray.append(String.format("{ name: '%s', scheme: '%s', benefit: '%s', milestone: '%s', status: '%s', iconBg: 'bg-indigo-100 text-indigo-600', icon: 'business' },",
               sTitle, scName, benefit, milestone, uiStatus));
       }
   } catch(Exception e) {
       e.printStackTrace();
   }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Investify – Beneficiary Tracking</title>
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800&display=swap"
        rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
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
                class="hidden md:block text-xs font-bold uppercase tracking-widest text-red-700 bg-red-50 rounded-full px-3 py-1">Admin
                Portal</span></div>
        <nav class="hidden lg:flex items-center gap-6">
                                    <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Analytics</a>
                                    <a href="verification.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Verification</a>
                                    <a href="beneficiaries.jsp" class="text-sm font-semibold text-primary">Beneficiaries</a>
                                </nav>
        <a href="../investor/profile.jsp"><img src="https://i.pravatar.cc/36?img=12"
                class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                alt="Admin" /></a>
    </header>
    <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-6">
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-black">Beneficiary Tracking</h1>
                <p class="text-text-muted mt-1">Monitor startups receiving government scheme benefits.</p>
            </div>
            <div class="relative">
                <span
                    class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-text-muted text-[18px]">search</span>
                <input type="text" placeholder="Search beneficiary…" oninput="searchBeneficiaries(this.value)"
                    class="pl-9 pr-4 py-2.5 rounded-xl border border-border-c bg-surface text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors w-56" />
            </div>
        </div>

        <!-- Summary -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-5">
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-1">Total Beneficiaries</p>
                <p class="text-2xl font-black"><%= total %></p>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-1">Active</p>
                <p class="text-2xl font-black text-emerald-600"><%= active %></p>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-1">Completed</p>
                <p class="text-2xl font-black text-blue-600"><%= completed %></p>
            </div>
            <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                <p class="text-xs font-bold uppercase tracking-wider text-text-muted mb-1">Flagged</p>
                <p class="text-2xl font-black text-amber-600"><%= flagged %></p>
            </div>
        </div>

        <!-- Table -->
        <div class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden">
            <div class="px-6 py-4 border-b border-border-c">
                <h2 class="font-bold text-lg">Beneficiary List</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead class="bg-bg-light text-xs font-bold uppercase tracking-wider text-text-muted">
                        <tr>
                            <th class="px-6 py-3.5">Startup</th>
                            <th class="px-6 py-3.5">Scheme</th>
                            <th class="px-6 py-3.5">Benefit</th>
                            <th class="px-6 py-3.5">Milestone</th>
                            <th class="px-6 py-3.5">Status</th>
                            <th class="px-6 py-3.5">Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border-c" id="benef-body"></tbody>
                </table>
            </div>
        </div>
    </main>
    <script>
        const BENEFICIARIES = [<%= jsArray.toString() %>];
        const STATUS_STYLES = { active: 'bg-emerald-50 text-emerald-700', completed: 'bg-blue-50 text-blue-700', flagged: 'bg-amber-50 text-amber-700' };
        let searchTerm = '';
        function renderBenef() {
            const filtered = BENEFICIARIES.filter(b => !searchTerm || b.name.toLowerCase().includes(searchTerm));
            document.getElementById('benef-body').innerHTML = filtered.map(b => `
    <tr class="hover:bg-bg-light transition-colors">
      <td class="px-6 py-4"><div class="flex items-center gap-3"><div class="size-9 rounded-lg ${b.iconBg} flex items-center justify-center"><span class="material-symbols-outlined text-[18px]">${b.icon}</span></div><span class="font-semibold">${b.name}</span></div></td>
      <td class="px-6 py-4 text-text-muted">${b.scheme}</td>
      <td class="px-6 py-4 font-semibold">${b.benefit}</td>
      <td class="px-6 py-4 text-text-muted">${b.milestone}</td>
      <td class="px-6 py-4"><span class="px-2.5 py-0.5 rounded-full text-xs font-bold capitalize ${STATUS_STYLES[b.status]}">${b.status}</span></td>
      <td class="px-6 py-4"><button class="text-primary hover:text-primary-dark text-xs font-semibold">View Report →</button></td>
    </tr>`).join('');
        }
        function searchBeneficiaries(val) { searchTerm = val.toLowerCase(); renderBenef(); }
        renderBenef();
    </script>
</body>

</html>