<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.*" %>
        <%@ page import="com.investify.db.DBConnection" %>
            <%@ page import="java.sql.*" %>
                <%@ page import="java.text.SimpleDateFormat" %>
                    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath()
                        + "/login.jsp" ); return; } String role=(String) session.getAttribute("role"); if
                        (!"admin".equals(role)) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
                        return; } List pendingStartups=new ArrayList(); String
                        sq="SELECT s.*, u.name as founder_name FROM startup s " + "JOIN users u ON s.founder_id = u.id "
                        + "WHERE s.status = 'pending' " + "ORDER BY s.created_at DESC" ; try { Connection
                        conn=DBConnection.getConnection(); PreparedStatement ps=conn.prepareStatement(sq); ResultSet
                        rs=ps.executeQuery(); while (rs.next()) { HashMap row=new HashMap(); row.put("id",
                        Integer.valueOf(rs.getInt("id"))); String t=rs.getString("title"); row.put("title", t !=null ? t
                        : "Untitled" ); String d=rs.getString("domain"); row.put("domain", d !=null ? d : "N/A" );
                        String st=rs.getString("stage"); row.put("stage", st !=null ? st : "N/A" ); String
                        fn=rs.getString("founder_name"); row.put("founderName", fn !=null ? fn : "Unknown" );
                        row.put("createdAt", rs.getTimestamp("created_at")); pendingStartups.add(row); } rs.close();
                        ps.close(); conn.close(); } catch (Exception e) { e.printStackTrace(); } int
                        pendingCount=pendingStartups.size(); String ctx=request.getContextPath(); %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="utf-8" />
                            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                            <title>Investify - Admin Verification</title>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800&display=swap"
                                rel="stylesheet" />
                            <link
                                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                                rel="stylesheet" />
                            <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
                            <script>tailwind.config = { theme: { extend: { colors: { primary: "#c6a65d", "primary-dark": "#b09045", "bg-light": "#f8f7f6", surface: "#ffffff", "text-main": "#1e1b14", "text-muted": "#817a6a", "border-c": "#e3e2dd" }, fontFamily: { display: ["Public Sans", "sans-serif"] } } } };</script>
                            <style>
                                .material-symbols-outlined {
                                    font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24
                                }
                            </style>
                        </head>

                        <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
                            <header
                                class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                                <div class="flex items-center gap-6">
                                    <a href="../index.jsp" class="flex items-center gap-3">
                                        <div
                                            class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                                            <span class="material-symbols-outlined text-xl">diamond</span></div>
                                        <span class="text-lg font-bold">Investify</span>
                                    </a>
                                    <span
                                        class="hidden md:block text-xs font-bold uppercase tracking-widest text-red-700 bg-red-50 rounded-full px-3 py-1">Admin
                                        Portal</span>
                                </div>
                                <nav class="hidden lg:flex items-center gap-6">
                                    <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Analytics</a>
                                    <a href="verification.jsp" class="text-sm font-semibold text-primary">Verification</a>
                                    <a href="beneficiaries.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Beneficiaries</a>
                                </nav>
                                <a href="../investor/profile.jsp"><img src="https://i.pravatar.cc/36?img=12"
                                        class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                                        alt="Admin" /></a>
                            </header>
                            <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-6">
                                <div class="flex items-center justify-between">
                                    <div>
                                        <h1 class="text-3xl font-black">Verification Portal</h1>
                                        <p class="text-text-muted mt-1">Review and verify startup listings and user KYC
                                            submissions.</p>
                                    </div>
                                    <div class="flex items-center gap-2 bg-surface border border-border-c rounded-xl p-0.5"
                                        id="vtabs">
                                        <button id="vt-startups" onclick="switchTab('startups',this)"
                                            class="px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold">Startups</button>
                                        <button onclick="switchTab('users',this)"
                                            class="px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors">Users
                                            KYC</button>
                                    </div>
                                </div>
                                <div id="panel-startups">
                                    <div
                                        class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden">
                                        <div
                                            class="px-6 py-4 border-b border-border-c flex justify-between items-center">
                                            <h2 class="font-bold text-lg">Pending Startup Verifications</h2>
                                            <span
                                                class="bg-amber-50 text-amber-700 font-bold text-xs px-3 py-1 rounded-full">
                                                <%= pendingCount %> Pending
                                            </span>
                                        </div>
                                        <div id="startup-rows" class="divide-y divide-border-c">
                                            <% if (pendingStartups.isEmpty()) { %>
                                                <div class="text-center py-8 text-text-muted">
                                                    <span
                                                        class="material-symbols-outlined text-4xl mb-2 block">verified_user</span>
                                                    <p class="text-sm font-semibold">No pending startup submissions</p>
                                                    <p class="text-xs mt-1">New startup applications will appear here.
                                                    </p>
                                                </div>
                                                <% } else { for (int i=0; i < pendingStartups.size(); i++) { HashMap
                                                    row=(HashMap) pendingStartups.get(i); int sid=((Integer)
                                                    row.get("id")).intValue(); String sTitle=(String) row.get("title");
                                                    String sDomain=(String) row.get("domain"); String sStage=(String)
                                                    row.get("stage"); String sFounder=(String) row.get("founderName");
                                                    Object ca=row.get("createdAt"); String sDate="N/A" ; if (ca !=null)
                                                    { sDate=new SimpleDateFormat("MMM dd, yyyy").format(ca); } %>
                                                    <div
                                                        class="flex items-center gap-4 px-6 py-4 hover:bg-bg-light transition-colors">
                                                        <div
                                                            class="size-10 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center">
                                                            <span
                                                                class="material-symbols-outlined text-[20px]">rocket_launch</span>
                                                        </div>
                                                        <div class="flex-1">
                                                            <p class="font-semibold text-sm">
                                                                <%= sTitle %>
                                                            </p>
                                                            <p class="text-xs text-text-muted">
                                                                <%= sFounder %> &middot; <%= sDate %>
                                                            </p>
                                                        </div>
                                                        <span
                                                            class="hidden md:block text-xs bg-bg-light border border-border-c px-2.5 py-1 rounded-full font-medium">
                                                            <%= sDomain %>
                                                        </span>
                                                        <span
                                                            class="hidden md:block text-xs bg-bg-light border border-border-c px-2.5 py-1 rounded-full font-medium">
                                                            <%= sStage %>
                                                        </span>
                                                        <div class="flex gap-2">
                                                            <form method="POST" action="<%= ctx %>/admin/startups"
                                                                style="display:inline;">
                                                                <input type="hidden" name="id" value="<%= sid %>" />
                                                                <input type="hidden" name="action" value="approve" />
                                                                <button type="submit"
                                                                    class="h-8 px-3 rounded-full bg-primary text-white text-xs font-bold hover:bg-primary-dark transition-colors">Approve</button>
                                                            </form>
                                                            <form method="POST" action="<%= ctx %>/admin/startups"
                                                                style="display:inline;">
                                                                <input type="hidden" name="id" value="<%= sid %>" />
                                                                <input type="hidden" name="action" value="reject" />
                                                                <button type="submit"
                                                                    class="h-8 px-3 rounded-full border border-red-200 text-red-600 text-xs font-semibold hover:bg-red-50 transition-colors">Reject</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                    <% } } %>
                                        </div>
                                    </div>
                                </div>
                                <div id="panel-users" class="hidden">
                                    <div
                                        class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden">
                                        <div
                                            class="px-6 py-4 border-b border-border-c flex justify-between items-center">
                                            <h2 class="font-bold text-lg">User KYC Submissions</h2>
                                            <span
                                                class="bg-amber-50 text-amber-700 font-bold text-xs px-3 py-1 rounded-full">0
                                                Pending</span>
                                        </div>
                                        <div class="divide-y divide-border-c">
                                            <div class="text-center py-8 text-text-muted">
                                                <span
                                                    class="material-symbols-outlined text-4xl mb-2 block">verified_user</span>
                                                <p class="text-sm font-semibold">No pending KYC submissions</p>
                                                <p class="text-xs mt-1">User KYC submissions will appear here.</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </main>
                            <script>
                                function switchTab(name, btn) {
                                    document.querySelectorAll('#vtabs button').forEach(function (b) {
                                        b.className = 'px-4 py-2 rounded-lg text-sm font-medium text-text-muted hover:text-text-main transition-colors';
                                    });
                                    btn.className = 'px-4 py-2 rounded-lg bg-primary text-white text-sm font-bold';
                                    document.getElementById('panel-startups').classList.toggle('hidden', name !== 'startups');
                                    document.getElementById('panel-users').classList.toggle('hidden', name !== 'users');
                                }
                            </script>
                        </body>

                        </html>
