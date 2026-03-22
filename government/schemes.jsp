<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
    <%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
        <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
            return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
            session.getAttribute("user_name"); List<Map<String, Object>> schemeList = new ArrayList<>();

                try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement ps = conn.prepareStatement(
                "SELECT s.*, (SELECT COUNT(*) FROM scheme_applications sa WHERE sa.scheme_id = s.id) AS app_count " +
                "FROM schemes s ORDER BY s.created_at DESC"
                );
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                        m.put("id", Integer.valueOf(rs.getInt("id")));
                        m.put("name", rs.getString("name") != null ? rs.getString("name") : "");
                        m.put("targetSector", rs.getString("target_sector") != null ? rs.getString("target_sector") :
                        "All Sectors");
                        m.put("budget", Double.valueOf(rs.getDouble("budget")));
                        m.put("description", rs.getString("description") != null ? rs.getString("description") : "");
                        m.put("status", rs.getString("status") != null ? rs.getString("status") : "draft");
                        m.put("openDate", rs.getDate("open_date"));
                        m.put("closeDate", rs.getDate("close_date"));
                        m.put("appCount", Integer.valueOf(rs.getInt("app_count")));
                        schemeList.add(m);
                        }
                        } catch (Exception e) {
                        e.printStackTrace();
                        }

                        boolean showSuccess = request.getParameter("success") != null;
                        String successType = request.getParameter("success");
                        String errorMsg = request.getParameter("error");

                        // Icons for different sectors
                        String[] icons = new String[10];
                        icons[0] = "rocket_launch";
                        icons[1] = "agriculture";
                        icons[2] = "biotech";
                        icons[3] = "school";
                        icons[4] = "bolt";
                        icons[5] = "health_and_safety";
                        icons[6] = "smart_toy";
                        icons[7] = "memory";
                        icons[8] = "storefront";
                        icons[9] = "security";

                        String[] iconBgs = new String[10];
                        iconBgs[0] = "bg-primary/10 text-primary";
                        iconBgs[1] = "bg-green-100 text-green-600";
                        iconBgs[2] = "bg-blue-100 text-blue-600";
                        iconBgs[3] = "bg-purple-100 text-purple-600";
                        iconBgs[4] = "bg-amber-100 text-amber-600";
                        iconBgs[5] = "bg-red-100 text-red-600";
                        iconBgs[6] = "bg-indigo-100 text-indigo-600";
                        iconBgs[7] = "bg-cyan-100 text-cyan-600";
                        iconBgs[8] = "bg-pink-100 text-pink-600";
                        iconBgs[9] = "bg-teal-100 text-teal-600";
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="utf-8" />
                            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                            <title>Investify � Scheme Management</title>
                            <link
                                href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800&display=swap"
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

                                .toast-enter {
                                    animation: slideDown .4s ease forwards;
                                }

                                .toast-exit {
                                    animation: slideUp .3s ease forwards;
                                }

                                @keyframes slideDown {
                                    from {
                                        opacity: 0;
                                        transform: translateY(-20px);
                                    }

                                    to {
                                        opacity: 1;
                                        transform: translateY(0);
                                    }
                                }

                                @keyframes slideUp {
                                    from {
                                        opacity: 1;
                                        transform: translateY(0);
                                    }

                                    to {
                                        opacity: 0;
                                        transform: translateY(-20px);
                                    }
                                }
                            </style>
                        </head>

                        <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
                            <header
                                class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                                <div class="flex items-center gap-6"><a href="../index.jsp"
                                        class="flex items-center gap-3">
                                        <div
                                            class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                                            <span class="material-symbols-outlined text-xl">diamond</span>
                                        </div><span class="text-lg font-bold">Investify</span>
                                    </a><span
                                        class="hidden md:block text-xs font-bold uppercase tracking-widest text-blue-700 bg-blue-50 rounded-full px-3 py-1">Government
                                        Portal</span></div>
                                <nav class="hidden lg:flex items-center gap-6">
				<a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
				<a href="schemes.jsp" class="text-sm font-semibold text-primary border-b-2 border-primary pb-1">Schemes</a>
				<a href="applications.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Applications</a>
				<a href="grants.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Grants</a>
				<a href="reports.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Reports</a>
			</nav>
                                <a href="settings.jsp"><img src="https://i.pravatar.cc/36?img=60"
                                        class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                                        alt="User" /></a>
                            </header>

                            <!-- Success Toast -->
                            <% if (showSuccess) { %>
                                <div id="success-toast"
                                    class="toast-enter fixed top-20 left-1/2 -translate-x-1/2 z-[100] flex items-center gap-3 bg-emerald-50 border border-emerald-200 rounded-2xl px-6 py-4 shadow-lg max-w-lg">
                                    <div
                                        class="size-10 rounded-full bg-emerald-100 flex items-center justify-center shrink-0">
                                        <span
                                            class="material-symbols-outlined text-emerald-600 text-[22px]">check_circle</span>
                                    </div>
                                    <div>
                                        <p class="font-bold text-emerald-800 text-sm">
                                            <% if ("created".equals(successType)) { %>Scheme Created!<% } else if
                                                    ("updated".equals(successType)) { %>Scheme Updated!<% } else if
                                                        ("deleted".equals(successType)) { %>Scheme Deleted!<% } else {
                                                            %>Success!<% } %>
                                        </p>
                                        <p class="text-xs text-emerald-600 mt-0.5">Your changes have been saved
                                            successfully.</p>
                                    </div>
                                    <button onclick="dismissToast()"
                                        class="text-emerald-400 hover:text-emerald-700 transition-colors ml-2">
                                        <span class="material-symbols-outlined text-[18px]">close</span>
                                    </button>
                                </div>
                                <% } %>

                                    <!-- Error Banner -->
                                    <% if (errorMsg !=null) { %>
                                        <div
                                            class="toast-enter fixed top-20 left-1/2 -translate-x-1/2 z-[100] flex items-center gap-3 bg-red-50 border border-red-200 rounded-2xl px-6 py-4 shadow-lg max-w-lg">
                                            <div
                                                class="size-10 rounded-full bg-red-100 flex items-center justify-center shrink-0">
                                                <span
                                                    class="material-symbols-outlined text-red-600 text-[22px]">error</span>
                                            </div>
                                            <div>
                                                <p class="font-bold text-red-800 text-sm">Error</p>
                                                <p class="text-xs text-red-600 mt-0.5">
                                                    <%= errorMsg %>
                                                </p>
                                            </div>
                                        </div>
                                        <% } %>

                                            <main class="max-w-[1200px] mx-auto px-6 py-8 flex flex-col gap-6">
                                                <div class="flex items-center justify-between">
                                                    <div>
                                                        <h1 class="text-3xl font-black">Scheme Management</h1>
                                                        <p class="text-text-muted mt-1">Create and manage government
                                                            startup support schemes.</p>
                                                    </div>
                                                    <button
                                                        onclick="document.getElementById('scheme-modal').classList.remove('hidden')"
                                                        class="flex items-center gap-2 h-10 px-5 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)]"><span
                                                            class="material-symbols-outlined text-[18px]">add</span>New
                                                        Scheme</button>
                                                </div>

                                                <!-- Schemes grid -->
                                                <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-5">
                                                    <% if (schemeList.isEmpty()) { %>
                                                        <div
                                                            class="md:col-span-2 lg:col-span-3 text-center py-16 text-text-muted">
                                                            <span
                                                                class="material-symbols-outlined text-5xl mb-3 block">inbox</span>
                                                            <p class="font-bold text-lg">No schemes yet</p>
                                                            <p class="text-sm mt-1">Click "New Scheme" to create your
                                                                first government support scheme.</p>
                                                        </div>
                                                        <% } else { int idx=0; for (Map<String, Object> scheme :
                                                            schemeList) {
                                                            int schemeId = ((Number) scheme.get("id")).intValue();
                                                            String sName = (String) scheme.get("name");
                                                            String sDesc = (String) scheme.get("description");
                                                            double sBudget = ((Number)
                                                            scheme.get("budget")).doubleValue();
                                                            String sStatus = (String) scheme.get("status");
                                                            String sSector = (String) scheme.get("targetSector");
                                                            int appCount = ((Number) scheme.get("appCount")).intValue();
                                                            int iconIdx = idx % icons.length;

                                                            String statusLabel = sStatus.substring(0,1).toUpperCase() +
                                                            sStatus.substring(1);
                                                            String statusClass = "active".equals(sStatus)
                                                            ? "bg-emerald-50 text-emerald-700"
                                                            : "draft".equals(sStatus)
                                                            ? "bg-amber-50 text-amber-700"
                                                            : "bg-red-50 text-red-600";

                                                            String budgetFormatted;
                                                            if (sBudget >= 10000000) budgetFormatted =
                                                            String.format("%.0fCr", sBudget / 10000000);
                                                            else if (sBudget >= 100000) budgetFormatted =
                                                            String.format("%.0fL", sBudget / 100000);
                                                            else if (sBudget >= 1000) budgetFormatted =
                                                            String.format("%.0fK", sBudget / 1000);
                                                            else budgetFormatted = String.format("%.0f", sBudget);
                                                            %>
                                                            <div
                                                                class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 hover:shadow-md transition-shadow">
                                                                <div class="flex items-start justify-between mb-4">
                                                                    <div
                                                                        class="size-11 rounded-xl <%= iconBgs[iconIdx] %> flex items-center justify-center">
                                                                        <span
                                                                            class="material-symbols-outlined text-[22px]">
                                                                            <%= icons[iconIdx] %>
                                                                        </span>
                                                                    </div>
                                                                    <span
                                                                        class="<%= statusClass %> text-xs font-bold px-2.5 py-0.5 rounded-full">
                                                                        <%= statusLabel %>
                                                                    </span>
                                                                </div>
                                                                <h3 class="font-bold text-base mb-1">
                                                                    <%= sName %>
                                                                </h3>
                                                                <p
                                                                    class="text-sm text-text-muted mb-4 leading-relaxed line-clamp-2">
                                                                    <%= sDesc.length()> 120 ? sDesc.substring(0, 120) +
                                                                        "..." : sDesc %>
                                                                </p>
                                                                <div class="grid grid-cols-2 gap-3 text-xs mb-4">
                                                                    <div class="bg-bg-light rounded-lg p-2.5">
                                                                        <p class="text-text-muted">Applications</p>
                                                                        <p class="font-bold text-base mt-0.5">
                                                                            <%= appCount %>
                                                                        </p>
                                                                    </div>
                                                                    <div class="bg-bg-light rounded-lg p-2.5">
                                                                        <p class="text-text-muted">Budget</p>
                                                                        <p class="font-bold text-base mt-0.5">&#8377;<%=
                                                                                budgetFormatted %>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                                <div class="flex gap-2">
                                                                    <button onclick="editScheme(<%= schemeId %>)"
                                                                        class="flex-1 h-8 rounded-full border border-border-c text-xs font-semibold hover:bg-bg-light transition-colors">Edit</button>
                                                                    <% if ("draft".equals(sStatus)) { %>
                                                                        <form method="POST"
                                                                            action="<%= request.getContextPath() %>/government/schemes"
                                                                            class="flex-1">
                                                                            <input type="hidden" name="action"
                                                                                value="update_scheme" />
                                                                            <input type="hidden" name="schemeId"
                                                                                value="<%= schemeId %>" />
                                                                            <input type="hidden" name="schemeName"
                                                                                value="<%= sName %>" />
                                                                            <input type="hidden" name="description"
                                                                                value="" />
                                                                            <input type="hidden" name="budget"
                                                                                value="<%= sBudget %>" />
                                                                            <input type="hidden" name="status"
                                                                                value="active" />
                                                                            <button type="submit"
                                                                                class="w-full h-8 rounded-full bg-emerald-50 text-emerald-700 text-xs font-bold hover:bg-emerald-600 hover:text-white transition-colors">Publish</button>
                                                                        </form>
                                                                        <% } else { %>
                                                                            <button onclick="viewApps(<%= schemeId %>)"
                                                                                class="flex-1 h-8 rounded-full bg-primary/10 text-primary text-xs font-bold hover:bg-primary hover:text-white transition-colors">View
                                                                                Applications</button>
                                                                            <% } %>
                                                                </div>
                                                            </div>
                                                            <% idx++; } } %>

                                                                <!-- Add new card -->
                                                                <div class="bg-surface rounded-2xl border-2 border-dashed border-border-c p-6 flex flex-col items-center justify-center text-center cursor-pointer hover:border-primary transition-colors group min-h-[240px]"
                                                                    onclick="document.getElementById('scheme-modal').classList.remove('hidden')">
                                                                    <div
                                                                        class="size-12 rounded-full bg-bg-light flex items-center justify-center text-text-muted group-hover:bg-primary group-hover:text-white transition-colors mb-3">
                                                                        <span
                                                                            class="material-symbols-outlined text-[24px]">add</span>
                                                                    </div>
                                                                    <p
                                                                        class="font-semibold text-text-muted group-hover:text-primary transition-colors">
                                                                        Create New Scheme</p>
                                                                </div>
                                                </div>
                                            </main>

                                            <!-- New Scheme Modal -->
                                            <div id="scheme-modal"
                                                class="hidden fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                                                <div class="bg-surface rounded-2xl shadow-2xl w-full max-w-lg">
                                                    <div
                                                        class="flex items-center justify-between p-6 border-b border-border-c">
                                                        <h2 class="text-lg font-bold">New Government Scheme</h2>
                                                        <button
                                                            onclick="document.getElementById('scheme-modal').classList.add('hidden')"
                                                            class="text-text-muted hover:text-text-main transition-colors"><span
                                                                class="material-symbols-outlined">close</span></button>
                                                    </div>
                                                    <form action="<%= request.getContextPath() %>/government/schemes"
                                                        method="POST">
                                                        <input type="hidden" name="action" value="create_scheme" />
                                                        <div class="p-6 flex flex-col gap-4">
                                                            <div><label
                                                                    class="block text-sm font-semibold mb-1.5">Scheme
                                                                    Name *</label><input type="text" name="schemeName"
                                                                    required
                                                                    placeholder="e.g. National AI Mission Grant"
                                                                    class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                            </div>
                                                            <div><label
                                                                    class="block text-sm font-semibold mb-1.5">Target
                                                                    Sector</label><select name="targetSector"
                                                                    class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors">
                                                                    <option>All Sectors</option>
                                                                    <option>Fintech</option>
                                                                    <option>Healthcare</option>
                                                                    <option>AI & Robotics</option>
                                                                    <option>Sustainability</option>
                                                                    <option>EdTech</option>
                                                                    <option>AgriTech</option>
                                                                </select></div>
                                                            <div><label class="block text-sm font-semibold mb-1.5">Total
                                                                    Budget (&#8377;)</label><input type="number"
                                                                    name="budget" placeholder="e.g. 5000000"
                                                                    class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                            </div>
                                                            <div class="grid grid-cols-2 gap-4">
                                                                <div><label
                                                                        class="block text-sm font-semibold mb-1.5">Opening
                                                                        Date</label><input type="date" name="openDate"
                                                                        class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                                </div>
                                                                <div><label
                                                                        class="block text-sm font-semibold mb-1.5">Closing
                                                                        Date</label><input type="date" name="closeDate"
                                                                        class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                                </div>
                                                            </div>
                                                            <div><label
                                                                    class="block text-sm font-semibold mb-1.5">Description</label><textarea
                                                                    rows="3" name="description"
                                                                    class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors resize-none"
                                                                    placeholder="Describe eligibility criteria and support details..."></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="flex gap-3 p-6 border-t border-border-c">
                                                            <button type="button"
                                                                onclick="document.getElementById('scheme-modal').classList.add('hidden')"
                                                                class="flex-1 h-10 rounded-full border border-border-c text-sm font-semibold hover:bg-bg-light transition-colors">Cancel</button>
                                                            <button type="submit"
                                                                class="flex-1 h-10 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors">Save
                                                                as Draft</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                            <!-- Edit Scheme Modal -->
                                            <div id="edit-modal"
                                                class="hidden fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                                                <div class="bg-surface rounded-2xl shadow-2xl w-full max-w-lg">
                                                    <div
                                                        class="flex items-center justify-between p-6 border-b border-border-c">
                                                        <h2 class="text-lg font-bold">Edit Scheme</h2>
                                                        <button
                                                            onclick="document.getElementById('edit-modal').classList.add('hidden')"
                                                            class="text-text-muted hover:text-text-main transition-colors"><span
                                                                class="material-symbols-outlined">close</span></button>
                                                    </div>
                                                    <form action="<%= request.getContextPath() %>/government/schemes"
                                                        method="POST">
                                                        <input type="hidden" name="action" value="update_scheme" />
                                                        <input type="hidden" name="schemeId" id="edit-id" value="" />
                                                        <div class="p-6 flex flex-col gap-4">
                                                            <div><label
                                                                    class="block text-sm font-semibold mb-1.5">Scheme
                                                                    Name</label><input id="edit-name" type="text"
                                                                    name="schemeName"
                                                                    class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                            </div>
                                                            <div><label
                                                                    class="block text-sm font-semibold mb-1.5">Description</label><textarea
                                                                    id="edit-desc" rows="3" name="description"
                                                                    class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors resize-none"></textarea>
                                                            </div>
                                                            <div class="grid grid-cols-2 gap-4">
                                                                <div><label
                                                                        class="block text-sm font-semibold mb-1.5">Budget</label><input
                                                                        id="edit-budget" type="number" name="budget"
                                                                        class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                                </div>
                                                                <div><label
                                                                        class="block text-sm font-semibold mb-1.5">Status</label><select
                                                                        id="edit-status" name="status"
                                                                        class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors">
                                                                        <option value="active">Active</option>
                                                                        <option value="draft">Draft</option>
                                                                        <option value="closed">Closed</option>
                                                                    </select></div>
                                                            </div>
                                                        </div>
                                                        <div class="flex gap-3 p-6 border-t border-border-c">
                                                            <button type="button"
                                                                onclick="document.getElementById('edit-modal').classList.add('hidden')"
                                                                class="flex-1 h-10 rounded-full border border-border-c text-sm font-semibold hover:bg-bg-light transition-colors">Cancel</button>
                                                            <button type="submit"
                                                                class="flex-1 h-10 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors">Save
                                                                Changes</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>

                                            <script>
                                                // Build the SCHEMES object from database data
                                                const SCHEMES = {
            <% for (Map < String, Object > scheme : schemeList) {
                int sId = ((Number) scheme.get("id")).intValue();
                String sName = ((String) scheme.get("name")).replace("'", "\\'").replace("\"", "\\\"");
                String sDesc = ((String) scheme.get("description")).replace("'", "\\'").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
                double sBudget = ((Number) scheme.get("budget")).doubleValue();
                String sStatus = (String) scheme.get("status");
            %>
            <%= sId %>: {
                                                        name: "<%= sName %>",
                                                            desc: "<%= sDesc %>",
                                                                budget: <%= sBudget %>,
                                                                    status: "<%= sStatus %>"
                                                    },
            <% } %>
        };

                                                function editScheme(id) {
                                                    var s = SCHEMES[id];
                                                    if (!s) return;
                                                    document.getElementById('edit-id').value = id;
                                                    document.getElementById('edit-name').value = s.name;
                                                    document.getElementById('edit-desc').value = s.desc;
                                                    document.getElementById('edit-budget').value = s.budget;
                                                    document.getElementById('edit-status').value = s.status;
                                                    document.getElementById('edit-modal').classList.remove('hidden');
                                                }
                                                function viewApps(schemeId) {
                                                    window.location.href = 'applications.jsp?schemeId=' + schemeId;
                                                }

                                                // Toast auto-dismiss
                                                function dismissToast() {
                                                    var toast = document.getElementById('success-toast');
                                                    if (toast) { toast.classList.remove('toast-enter'); toast.classList.add('toast-exit'); setTimeout(function () { toast.remove(); }, 300); }
                                                }
        <% if (showSuccess) { %>
                                                    setTimeout(dismissToast, 6000);
        <% } %>
                                            </script>
                        </body>

                        </html>
