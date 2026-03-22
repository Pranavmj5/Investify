<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
    <%@ page import="java.sql.*, com.investify.db.DBConnection" %>
        <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
            return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
            session.getAttribute("user_name"); if (userName==null) userName="Government Official" ; int totalStartups=0;
            int approvedStartups=0; int pendingStartups=0; int activeSchemes=0; double grantsAllocated=0; Connection
            conn=null; try { conn=DBConnection.getConnection(); Statement st=conn.createStatement(); ResultSet
            rs1=st.executeQuery("SELECT COUNT(*) FROM startup"); if (rs1.next()) totalStartups=rs1.getInt(1);
            rs1.close(); ResultSet rs2=st.executeQuery("SELECT COUNT(*) FROM startup WHERE status='approved'");
    if (rs2.next()) approvedStartups = rs2.getInt(1);
    rs2.close();

    ResultSet rs3 = st.executeQuery(" SELECT COUNT(*) FROM startup WHERE status='pending'");
    if (rs3.next()) pendingStartups = rs3.getInt(1);
    rs3.close();

    ResultSet rs4 = st.executeQuery(" SELECT COUNT(*) FROM schemes WHERE status='active'");
    if (rs4.next()) activeSchemes = rs4.getInt(1);
    rs4.close();

    ResultSet rs5 = st.executeQuery(" SELECT COALESCE(SUM(budget),0) FROM schemes WHERE status='active'");
    if (rs5.next()) grantsAllocated = rs5.getDouble(1);
    rs5.close();

    st.close();
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (conn != null) try { conn.close(); } catch (Exception ex) {}
}

String fmtGrants;
if (grantsAllocated >= 10000000) {
    fmtGrants = String.format(" %.1fCr", grantsAllocated / 10000000); } else if (grantsAllocated>= 100000) {
            fmtGrants = String.format("%.1fL", grantsAllocated / 100000);
            } else if (grantsAllocated >= 1000) {
            fmtGrants = String.format("%.0fK", grantsAllocated / 1000);
            } else {
            fmtGrants = String.format("%.0f", grantsAllocated);
            }
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Investify - Government Dashboard</title>
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

                    .bar-fill {
                        width: 0;
                        transition: width 1.1s cubic-bezier(.25, .8, .25, 1)
                    }
                </style>
            </head>

            <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
                <header
                    class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                    <div class="flex items-center gap-8">
                        <a href="../index.jsp" class="flex items-center gap-3">
                            <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                                <span class="material-symbols-outlined text-xl">diamond</span>
                            </div><span class="text-lg font-bold">Investify</span>
                        </a>
                        <span
                            class="hidden md:block text-xs font-bold uppercase tracking-widest text-blue-700 bg-blue-50 rounded-full px-3 py-1">Government
                            Portal</span>
                    </div>
                    <nav class="hidden lg:flex items-center gap-6">
				<a href="dashboard.jsp" class="text-sm font-semibold text-primary border-b-2 border-primary pb-1">Dashboard</a>
				<a href="schemes.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Schemes</a>
				<a href="applications.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Applications</a>
				<a href="grants.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Grants</a>
				<a href="reports.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Reports</a>
			</nav>
                    <a href="settings.jsp">
                        <img src="https://i.pravatar.cc/36?img=60"
                            class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                            alt="Gov official" />
                    </a>
                </header>

                <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-8">
                    <div class="flex justify-between items-start">
                        <div>
                            <h1 class="text-3xl font-black">Welcome, <%= userName %>
                            </h1>
                            <p class="text-text-muted mt-1">Monitor ecosystem health, schemes, and beneficiary startups.
                            </p>
                        </div>
                        <a href="schemes.jsp"
                            class="flex items-center gap-2 h-10 px-5 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)]">
                            <span class="material-symbols-outlined text-[18px]">add</span>New Scheme
                        </a>
                    </div>

                    <div class="grid grid-cols-2 md:grid-cols-4 gap-5">
                        <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                            <div class="flex justify-between items-center mb-3">
                                <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Registered
                                    Startups</p>
                                <div
                                    class="size-8 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                                    <span class="material-symbols-outlined text-[18px]">rocket_launch</span>
                                </div>
                            </div>
                            <p class="text-3xl font-black">
                                <%= totalStartups %>
                            </p>
                            <div class="h-1 bg-bg-light rounded-full mt-3">
                                <div class="h-full bg-primary rounded-full bar-fill"
                                    data-pct="<%= totalStartups > 0 ? 75 : 0 %>"></div>
                            </div>
                        </div>
                        <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                            <div class="flex justify-between items-center mb-3">
                                <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Active Schemes</p>
                                <div
                                    class="size-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                                    <span class="material-symbols-outlined text-[18px]">policy</span>
                                </div>
                            </div>
                            <p class="text-3xl font-black">
                                <%= activeSchemes %>
                            </p>
                            <div class="h-1 bg-bg-light rounded-full mt-3">
                                <div class="h-full bg-blue-500 rounded-full bar-fill"
                                    data-pct="<%= activeSchemes > 0 ? 55 : 0 %>"></div>
                            </div>
                        </div>
                        <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                            <div class="flex justify-between items-center mb-3">
                                <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Grants Allocated
                                </p>
                                <div
                                    class="size-8 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                                    <span class="material-symbols-outlined text-[18px]">payments</span>
                                </div>
                            </div>
                            <p class="text-3xl font-black">&#8377;<%= fmtGrants %>
                            </p>
                            <div class="h-1 bg-bg-light rounded-full mt-3">
                                <div class="h-full bg-green-500 rounded-full bar-fill"
                                    data-pct="<%= grantsAllocated > 0 ? 60 : 0 %>"></div>
                            </div>
                        </div>
                        <div class="bg-surface rounded-2xl p-5 border border-border-c shadow-sm">
                            <div class="flex justify-between items-center mb-3">
                                <p class="text-xs font-bold uppercase tracking-wider text-text-muted">Pending Reviews
                                </p>
                                <div
                                    class="size-8 rounded-full bg-amber-100 flex items-center justify-center text-amber-600">
                                    <span class="material-symbols-outlined text-[18px]">pending</span>
                                </div>
                            </div>
                            <p class="text-3xl font-black">
                                <%= pendingStartups %>
                            </p>
                            <div class="h-1 bg-bg-light rounded-full mt-3">
                                <div class="h-full bg-amber-500 rounded-full bar-fill"
                                    data-pct="<%= pendingStartups > 0 ? 38 : 0 %>"></div>
                            </div>
                        </div>
                    </div>

                    <div class="grid md:grid-cols-3 gap-6">
                        <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6">
                            <h2 class="text-lg font-bold mb-5">Sector Breakdown</h2>
                            <div class="space-y-4">
                                <div class="text-center py-8 text-text-muted">
                                    <span class="material-symbols-outlined text-4xl mb-2 block"
                                        style="font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 48">pie_chart</span>
                                    <p class="font-semibold text-text-main">No sector data</p>
                                    <p class="text-sm mt-1">Sector breakdown will appear when startups are registered.
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 md:col-span-2">
                            <div class="flex justify-between items-center mb-5">
                                <h2 class="text-lg font-bold">Recent Scheme Applications</h2>
                                <a href="schemes.jsp"
                                    class="text-sm font-semibold text-primary hover:text-primary-dark transition-colors">View
                                    All &rarr;</a>
                            </div>
                            <div class="space-y-3">
                                <div class="text-center py-8 text-text-muted">
                                    <span class="material-symbols-outlined text-4xl mb-2 block"
                                        style="font-variation-settings:'FILL' 0,'wght' 300,'GRAD' 0,'opsz' 48">inbox</span>
                                    <p class="font-semibold text-text-main">No recent applications</p>
                                    <p class="text-sm mt-1">Scheme applications will appear here when startups apply.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <a href="schemes.jsp"
                            class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                            <div
                                class="size-12 rounded-full bg-primary/10 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-white transition-colors">
                                <span class="material-symbols-outlined text-[22px]">policy</span>
                            </div><span class="text-sm font-semibold text-center">Manage Schemes</span>
                        </a>
                        <a href="grants.jsp"
                            class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                            <div
                                class="size-12 rounded-full bg-green-50 flex items-center justify-center text-green-600 group-hover:bg-green-600 group-hover:text-white transition-colors">
                                <span class="material-symbols-outlined text-[22px]">payments</span>
                            </div><span class="text-sm font-semibold text-center">Grant Allocation</span>
                        </a>
                        <a href="reports.jsp"
                            class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                            <div
                                class="size-12 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 group-hover:bg-blue-600 group-hover:text-white transition-colors">
                                <span class="material-symbols-outlined text-[22px]">bar_chart</span>
                            </div><span class="text-sm font-semibold text-center">Reports</span>
                        </a>
                        <a href="schemes.jsp"
                            class="bg-surface rounded-2xl border border-border-c p-5 flex flex-col items-center gap-3 hover:border-primary/30 hover:shadow-md transition-all group">
                            <div
                                class="size-12 rounded-full bg-amber-50 flex items-center justify-center text-amber-600 group-hover:bg-amber-600 group-hover:text-white transition-colors">
                                <span class="material-symbols-outlined text-[22px]">verified_user</span>
                            </div><span class="text-sm font-semibold text-center">Verification</span>
                        </a>
                    </div>
                </main>
                <script>setTimeout(function () { document.querySelectorAll('.bar-fill[data-pct]').forEach(function (el) { el.style.width = el.dataset.pct + '%'; }); }, 300);</script>
            </body>

            </html>
