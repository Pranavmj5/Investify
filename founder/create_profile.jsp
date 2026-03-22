<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
        <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
            return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
            session.getAttribute("user_name"); boolean showSuccess="1" .equals(request.getParameter("success")); String
            errorMsg=(String) request.getAttribute("error"); // Load existing startup for this founder
            Map startupData=(Map) request.getAttribute("startup"); if (startupData==null) { startupData=new HashMap(); try
            (Connection conn=DBConnection.getConnection()) { PreparedStatement
            ps=conn.prepareStatement( "SELECT * FROM startup WHERE founder_id = ? ORDER BY created_at DESC LIMIT 1" );
            ps.setInt(1, userId); ResultSet rs=ps.executeQuery(); if (rs.next()) { startupData.put("id",
            Integer.valueOf(rs.getInt("id"))); startupData.put("title", rs.getString("title") !=null ?
            rs.getString("title") : "" ); startupData.put("domain", rs.getString("domain") !=null ?
            rs.getString("domain") : "" ); startupData.put("stage", rs.getString("stage") !=null ? rs.getString("stage")
            : "" ); startupData.put("tagline", rs.getString("tagline") !=null ? rs.getString("tagline") : "" );
            startupData.put("description", rs.getString("description") !=null ? rs.getString("description") : "" );
            startupData.put("fundingGoal", Double.valueOf(rs.getDouble("funding_goal")));
            startupData.put("fundingRaised", Double.valueOf(rs.getDouble("funding_raised")));
            startupData.put("equityOffered", Double.valueOf(rs.getDouble("equity_offered")));
            startupData.put("minTicket", Double.valueOf(rs.getDouble("min_ticket"))); startupData.put("valuation",
            Double.valueOf(rs.getDouble("valuation"))); startupData.put("riskLevel", rs.getString("risk_level") !=null ?
            rs.getString("risk_level") : "Medium" ); startupData.put("website", rs.getString("website") !=null ?
            rs.getString("website") : "" ); startupData.put("linkedin", rs.getString("linkedin") !=null ?
            rs.getString("linkedin") : "" ); startupData.put("hqLocation", rs.getString("hq_location") !=null ?
            rs.getString("hq_location") : "" ); startupData.put("foundedYear",
            Integer.valueOf(rs.getInt("founded_year"))); startupData.put("status", rs.getString("status") !=null ?
            rs.getString("status") : "" ); } } catch (Exception e) { e.printStackTrace(); } } boolean
            hasStartup=startupData.containsKey("id"); String sTitle=hasStartup ? (String) startupData.get("title") : ""
            ; String sDomain=hasStartup ? (String) startupData.get("domain") : "" ; String sStage=hasStartup ? (String)
            startupData.get("stage") : "" ; String sTagline=hasStartup ? (String) startupData.get("tagline") : "" ;
            String sDesc=hasStartup ? (String) startupData.get("description") : "" ; double sFundingGoal=hasStartup ?
            ((Number) startupData.get("fundingGoal")).doubleValue() : 0; double sFundingRaised=hasStartup ? ((Number)
            startupData.get("fundingRaised")).doubleValue() : 0; double sEquity=hasStartup ? ((Number)
            startupData.get("equityOffered")).doubleValue() : 0; double sMinTicket=hasStartup ? ((Number)
            startupData.get("minTicket")).doubleValue() : 0; double sValuation=hasStartup ? ((Number)
            startupData.get("valuation")).doubleValue() : 0; String sRiskLevel=hasStartup ? (String)
            startupData.get("riskLevel") : "Medium" ; String sWebsite=hasStartup ? (String) startupData.get("website")
            : "" ; String sLinkedin=hasStartup ? (String) startupData.get("linkedin") : "" ; String
            sHqLocation=hasStartup ? (String) startupData.get("hqLocation") : "" ; int sFoundedYear=hasStartup ?
            ((Number) startupData.get("foundedYear")).intValue() : 0; String sStatus=hasStartup ? (String)
            startupData.get("status") : "" ; %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Investify – Create Startup Profile</title>
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

                    .tab-btn {
                        transition: .15s
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
                    <a href="../index.jsp" class="flex items-center gap-3">
                        <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                                class="material-symbols-outlined text-xl">diamond</span></div><span
                            class="text-lg font-bold">Investify</span>
                    </a>
                    <nav class="hidden lg:flex items-center gap-6">
            <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">My Startup</a>
            <a href="requests.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Requests</a>
            <a href="schemes.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Schemes</a>
            <a href="messages.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Messages</a>
            <a href="settings.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Settings</a>
        </nav>
                    <a href="dashboard.jsp"><img src="https://i.pravatar.cc/36?img=25"
                            class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                            alt="Founder" /></a>
                </header>

                <!-- Success Toast -->
                <% if (showSuccess) { %>
                    <div id="success-toast"
                        class="toast-enter fixed top-20 left-1/2 -translate-x-1/2 z-[100] flex items-center gap-3 bg-emerald-50 border border-emerald-200 rounded-2xl px-6 py-4 shadow-lg max-w-lg">
                        <div class="size-10 rounded-full bg-emerald-100 flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-emerald-600 text-[22px]">check_circle</span>
                        </div>
                        <div>
                            <p class="font-bold text-emerald-800 text-sm">Startup Submitted Successfully!</p>
                            <p class="text-xs text-emerald-600 mt-0.5">Your startup profile has been sent to the admin
                                for
                                review. You will be notified once it's approved.</p>
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
                                class="fixed top-20 left-1/2 -translate-x-1/2 z-[100] flex items-center gap-3 bg-red-50 border border-red-200 rounded-2xl px-6 py-4 shadow-lg max-w-lg toast-enter">
                                <div class="size-10 rounded-full bg-red-100 flex items-center justify-center shrink-0">
                                    <span class="material-symbols-outlined text-red-600 text-[22px]">error</span>
                                </div>
                                <div>
                                    <p class="font-bold text-red-800 text-sm">Submission Failed</p>
                                    <p class="text-xs text-red-600 mt-0.5">
                                        <%= errorMsg %>
                                    </p>
                                </div>
                            </div>
                            <% } %>

                                <main class="max-w-3xl mx-auto px-6 py-8 flex flex-col gap-6">
                                    <div>
                                        <h1 class="text-3xl font-black">Startup Profile</h1>
                                        <p class="text-text-muted mt-1">Create and manage your startup's public
                                            investment
                                            profile.</p>
                                    </div>

                                    <!-- Tab nav -->
                                    <div class="flex gap-1 bg-bg-light border border-border-c rounded-xl p-1">
                                        <button type="button" onclick="showTab('basic',this)" id="tab-basic"
                                            class="tab-btn flex-1 rounded-lg py-2 text-sm font-bold bg-white shadow-sm text-text-main">Basic
                                            Info</button>
                                        <button type="button" onclick="showTab('funding',this)" id="tab-funding"
                                            class="tab-btn flex-1 rounded-lg py-2 text-sm font-medium text-text-muted hover:text-text-main">Funding</button>
                                        <button type="button" onclick="showTab('team',this)" id="tab-team"
                                            class="tab-btn flex-1 rounded-lg py-2 text-sm font-medium text-text-muted hover:text-text-main">Team</button>
                                        <button type="button" onclick="showTab('docs',this)" id="tab-docs"
                                            class="tab-btn flex-1 rounded-lg py-2 text-sm font-medium text-text-muted hover:text-text-main">Documents</button>
                                    </div>

                                    <!-- Basic Info Tab -->
                                    <form id="startup-form" action="<%= request.getContextPath() %>/startups"
                                        method="POST" enctype="multipart/form-data">
                                        <div id="tab-basic-panel" class="flex flex-col gap-5">
                                            <div
                                                class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 flex flex-col gap-4">
                                                <!-- Logo upload -->
                                                <div class="flex items-center gap-5">
                                                    <div id="logo-preview-box"
                                                        class="h-20 w-20 rounded-2xl border-2 border-dashed border-border-c bg-bg-light flex flex-col items-center justify-center text-text-muted cursor-pointer hover:border-primary transition-colors"
                                                        onclick="document.getElementById('logo-input').click()">
                                                        <span class="material-symbols-outlined text-[28px]"
                                                            id="logo-icon">add_photo_alternate</span>
                                                        <span class="text-[10px] mt-1" id="logo-label">Logo</span>
                                                    </div>
                                                    <div>
                                                        <p class="font-semibold text-sm">Upload Startup Logo</p>
                                                        <p class="text-xs text-text-muted">PNG or JPG, max 2MB, min
                                                            200×200px</p>
                                                        <input type="file" id="logo-input" name="logo" accept="image/*"
                                                            class="hidden" onchange="handleLogoSelect(this)" />
                                                        <button type="button"
                                                            onclick="document.getElementById('logo-input').click()"
                                                            class="mt-2 h-8 px-4 rounded-full border border-border-c text-xs font-semibold hover:bg-bg-light transition-colors">Browse
                                                            File</button>
                                                    </div>
                                                </div>
                                                <div class="grid md:grid-cols-2 gap-4">
                                                    <div class="md:col-span-2"><label
                                                            class="block text-sm font-semibold mb-1.5">Startup Name
                                                            *</label><input type="text" name="title" id="field-title"
                                                            placeholder="Your startup name"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                            value="<%= sTitle %>" />
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Domain /
                                                            Industry
                                                            *</label>
                                                        <select name="domain"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors">
                                                            <option <%="FinTech" .equals(sDomain)?"selected":""%>
                                                                >FinTech</option>
                                                            <option <%="HealthTech" .equals(sDomain)?"selected":""%>
                                                                >HealthTech</option>
                                                            <option <%="AI & Robotics" .equals(sDomain)?"selected":""%>
                                                                >AI & Robotics</option>
                                                            <option <%="CleanTech" .equals(sDomain)?"selected":""%>
                                                                >CleanTech</option>
                                                            <option <%="EdTech" .equals(sDomain)?"selected":""%>>EdTech
                                                            </option>
                                                            <option <%="SaaS" .equals(sDomain)?"selected":""%>>SaaS
                                                            </option>
                                                            <option <%="AgriTech" .equals(sDomain)?"selected":""%>
                                                                >AgriTech</option>
                                                            <option <%="FoodTech" .equals(sDomain)?"selected":""%>
                                                                >FoodTech</option>
                                                            <option <%="E-Commerce" .equals(sDomain)?"selected":""%>
                                                                >E-Commerce</option>
                                                            <option <%="CyberSecurity" .equals(sDomain)?"selected":""%>
                                                                >CyberSecurity</option>
                                                            <option <%="Logistics" .equals(sDomain)?"selected":""%>
                                                                >Logistics</option>
                                                        </select>
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Stage
                                                            *</label>
                                                        <select name="stage"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors">
                                                            <option <%="Pre-Seed" .equals(sStage)?"selected":""%>
                                                                >Pre-Seed</option>
                                                            <option <%="Seed" .equals(sStage)?"selected":""%>>Seed
                                                            </option>
                                                            <option <%="Series A" .equals(sStage)?"selected":""%>>Series
                                                                A</option>
                                                            <option <%="Series B" .equals(sStage)?"selected":""%>>Series
                                                                B</option>
                                                            <option <%="Pre-IPO" .equals(sStage)?"selected":""%>>Pre-IPO
                                                            </option>
                                                        </select>
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Founded
                                                            Year</label><input type="number" name="foundedYear"
                                                            placeholder="2021"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                            value="<%= sFoundedYear > 0 ? sFoundedYear : "" %>" />
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">HQ
                                                            Location</label><input type="text" name="hqLocation"
                                                            placeholder="San Francisco, CA"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                            value="<%= sHqLocation %>" />
                                                    </div>
                                                    <div class="md:col-span-2"><label
                                                            class="block text-sm font-semibold mb-1.5">Short Tagline
                                                            *</label><input type="text" name="tagline"
                                                            id="field-tagline"
                                                            placeholder="One-line description of your startup"
                                                            maxlength="80"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                            value="<%= sTagline %>" />
                                                    </div>
                                                    <div class="md:col-span-2"><label
                                                            class="block text-sm font-semibold mb-1.5">About /
                                                            Description
                                                            *</label><textarea rows="4" name="description"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors resize-none"
                                                            placeholder="Describe your startup, product, and vision..."><%= sDesc %></textarea>
                                                    </div>
                                                    <div><label
                                                            class="block text-sm font-semibold mb-1.5">Website</label><input
                                                            type="url" name="website" placeholder="https://yoursite.com"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                            value="<%= sWebsite %>" />
                                                    </div>
                                                    <div><label
                                                            class="block text-sm font-semibold mb-1.5">LinkedIn</label><input
                                                            type="url" name="linkedin"
                                                            placeholder="https://linkedin.com/company/..."
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                            value="<%= sLinkedin %>" />
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="flex justify-end gap-3">
                                                <button type="button"
                                                    class="h-10 px-6 rounded-full border border-border-c text-sm font-semibold hover:bg-surface transition-colors">Save
                                                    Draft</button>
                                                <button type="button"
                                                    onclick="showTab('funding',document.getElementById('tab-funding'))"
                                                    class="h-10 px-6 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)] flex items-center gap-2">Next:
                                                    Funding <span
                                                        class="material-symbols-outlined text-[18px]">arrow_forward</span></button>
                                            </div>
                                        </div>

                                        <!-- Funding Tab -->
                                        <div id="tab-funding-panel" class="hidden flex-col gap-5">
                                            <div
                                                class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 flex flex-col gap-4">
                                                <div class="grid md:grid-cols-2 gap-4">
                                                    <div><label class="block text-sm font-semibold mb-1.5">Funding Goal
                                                            *</label>
                                                        <div class="relative"><span
                                                                class="absolute left-4 top-1/2 -translate-y-1/2 text-text-muted font-semibold text-sm">$</span><input
                                                                type="number" name="fundingGoal" placeholder="6000000"
                                                                class="w-full pl-8 pr-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                                value="<%= sFundingGoal > 0 ? (long)sFundingGoal : "" %>" />
                                                        </div>
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Amount Raised
                                                            So
                                                            Far</label>
                                                        <div class="relative"><span
                                                                class="absolute left-4 top-1/2 -translate-y-1/2 text-text-muted font-semibold text-sm">$</span><input
                                                                type="number" name="fundingRaised" placeholder="4200000"
                                                                class="w-full pl-8 pr-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                                value="<%= sFundingRaised > 0 ? (long)sFundingRaised : "" %>" />
                                                        </div>
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Equity
                                                            Offered
                                                            (%)</label><input type="number" name="equityOffered"
                                                            placeholder="8.5" step="0.1"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                            value="<%= sEquity > 0 ? sEquity : "" %>" />
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Min Ticket
                                                            Size</label>
                                                        <div class="relative"><span
                                                                class="absolute left-4 top-1/2 -translate-y-1/2 text-text-muted font-semibold text-sm">$</span><input
                                                                type="number" name="minTicket" placeholder="10000"
                                                                class="w-full pl-8 pr-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                                value="<%= sMinTicket > 0 ? (long)sMinTicket : "" %>" />
                                                        </div>
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Pre-Money
                                                            Valuation</label>
                                                        <div class="relative"><span
                                                                class="absolute left-4 top-1/2 -translate-y-1/2 text-text-muted font-semibold text-sm">$</span><input
                                                                type="number" name="valuation" placeholder="22000000"
                                                                class="w-full pl-8 pr-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors"
                                                                value="<%= sValuation > 0 ? (long)sValuation : "" %>" />
                                                        </div>
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Round Closing
                                                            Date</label><input type="date" value="2026-06-30"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                    </div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Instrument
                                                            Type</label><select
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors">
                                                            <option>Equity</option>
                                                            <option>Convertible Note</option>
                                                            <option>SAFE</option>
                                                        </select></div>
                                                    <div><label class="block text-sm font-semibold mb-1.5">Risk
                                                            Level</label><select name="riskLevel"
                                                            class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors">
                                                            <option>Low</option>
                                                            <option selected>Medium</option>
                                                            <option>High</option>
                                                        </select></div>
                                                </div>
                                            </div>
                                            <div class="flex justify-end gap-3">
                                                <button type="button"
                                                    onclick="showTab('basic',document.getElementById('tab-basic'))"
                                                    class="h-10 px-6 rounded-full border border-border-c text-sm font-semibold hover:bg-surface transition-colors flex items-center gap-2"><span
                                                        class="material-symbols-outlined text-[18px]">arrow_back</span>Back</button>
                                                <button type="button"
                                                    onclick="showTab('team',document.getElementById('tab-team'))"
                                                    class="h-10 px-6 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)] flex items-center gap-2">Next:
                                                    Team <span
                                                        class="material-symbols-outlined text-[18px]">arrow_forward</span></button>
                                            </div>
                                        </div>

                                        <!-- Team Tab -->
                                        <div id="tab-team-panel" class="hidden flex-col gap-5">
                                            <div
                                                class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 flex flex-col gap-5">
                                                <div
                                                    class="flex items-center gap-4 p-4 bg-bg-light rounded-xl border border-border-c">
                                                    <img src="https://i.pravatar.cc/60?img=25"
                                                        class="h-14 w-14 rounded-full object-cover ring-2 ring-primary/20" />
                                                    <div class="flex-1 grid md:grid-cols-3 gap-3">
                                                        <input type="text" value="Dr. Aisha Patel"
                                                            placeholder="Full Name"
                                                            class="px-3 py-2 rounded-lg border border-border-c bg-white text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                        <input type="text" value="CEO & Founder" placeholder="Title"
                                                            class="px-3 py-2 rounded-lg border border-border-c bg-white text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                        <input type="url" placeholder="LinkedIn URL"
                                                            class="px-3 py-2 rounded-lg border border-border-c bg-white text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                    </div>
                                                </div>
                                                <div
                                                    class="flex items-center gap-4 p-4 bg-bg-light rounded-xl border border-border-c">
                                                    <img src="https://i.pravatar.cc/60?img=53"
                                                        class="h-14 w-14 rounded-full object-cover ring-2 ring-primary/20" />
                                                    <div class="flex-1 grid md:grid-cols-3 gap-3">
                                                        <input type="text" value="James Wu" placeholder="Full Name"
                                                            class="px-3 py-2 rounded-lg border border-border-c bg-white text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                        <input type="text" value="CTO" placeholder="Title"
                                                            class="px-3 py-2 rounded-lg border border-border-c bg-white text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                        <input type="url" placeholder="LinkedIn URL"
                                                            class="px-3 py-2 rounded-lg border border-border-c bg-white text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                                    </div>
                                                </div>
                                                <button type="button"
                                                    class="flex items-center gap-2 text-sm font-semibold text-primary hover:text-primary-dark transition-colors w-fit"><span
                                                        class="material-symbols-outlined text-[20px]">add_circle</span>Add
                                                    Team Member</button>
                                            </div>
                                            <div class="flex justify-end gap-3">
                                                <button type="button"
                                                    onclick="showTab('funding',document.getElementById('tab-funding'))"
                                                    class="h-10 px-6 rounded-full border border-border-c text-sm font-semibold hover:bg-surface transition-colors flex items-center gap-2"><span
                                                        class="material-symbols-outlined text-[18px]">arrow_back</span>Back</button>
                                                <button type="button"
                                                    onclick="showTab('docs',document.getElementById('tab-docs'))"
                                                    class="h-10 px-6 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)] flex items-center gap-2">Next:
                                                    Documents <span
                                                        class="material-symbols-outlined text-[18px]">arrow_forward</span></button>
                                            </div>
                                        </div>

                                        <!-- Documents Tab -->
                                        <div id="tab-docs-panel" class="hidden flex-col gap-5">
                                            <div
                                                class="bg-surface rounded-2xl border border-border-c shadow-sm p-6 flex flex-col gap-4">
                                                <!-- Hidden file inputs -->
                                                <input type="file" id="pitchDeck-input" name="pitchDeck"
                                                    accept=".pdf,.pptx,.ppt,.docx" class="hidden"
                                                    onchange="handleDocSelect('pitchDeck', this)" />
                                                <input type="file" id="financialModel-input" name="financialModel"
                                                    accept=".pdf,.xlsx,.xls,.csv,.docx" class="hidden"
                                                    onchange="handleDocSelect('financialModel', this)" />
                                                <input type="file" id="capTable-input" name="capTable"
                                                    accept=".pdf,.xlsx,.xls,.csv,.docx" class="hidden"
                                                    onchange="handleDocSelect('capTable', this)" />

                                                <!-- Pitch Deck row -->
                                                <div class="flex items-center justify-between p-4 bg-bg-light rounded-xl border border-border-c"
                                                    id="row-pitchDeck">
                                                    <div class="flex items-center gap-3">
                                                        <div
                                                            class="size-9 rounded-lg bg-red-50 text-red-500 flex items-center justify-center">
                                                            <span
                                                                class="material-symbols-outlined text-[18px]">picture_as_pdf</span>
                                                        </div>
                                                        <div>
                                                            <span class="text-sm font-semibold">Pitch Deck</span>
                                                            <span id="pitchDeck-filename"
                                                                class="text-xs text-text-muted block hidden"></span>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center gap-2" id="pitchDeck-actions">
                                                        <button type="button"
                                                            onclick="document.getElementById('pitchDeck-input').click()"
                                                            class="h-8 px-3 rounded-full border border-border-c text-xs font-semibold hover:border-primary transition-colors">Upload</button>
                                                    </div>
                                                </div>

                                                <!-- Financial Model row -->
                                                <div class="flex items-center justify-between p-4 bg-bg-light rounded-xl border border-border-c"
                                                    id="row-financialModel">
                                                    <div class="flex items-center gap-3">
                                                        <div
                                                            class="size-9 rounded-lg bg-blue-50 text-blue-500 flex items-center justify-center">
                                                            <span
                                                                class="material-symbols-outlined text-[18px]">description</span>
                                                        </div>
                                                        <div>
                                                            <span class="text-sm font-semibold">Financial Model</span>
                                                            <span id="financialModel-filename"
                                                                class="text-xs text-text-muted block hidden"></span>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center gap-2" id="financialModel-actions">
                                                        <button type="button"
                                                            onclick="document.getElementById('financialModel-input').click()"
                                                            class="h-8 px-3 rounded-full border border-border-c text-xs font-semibold hover:border-primary transition-colors">Upload</button>
                                                    </div>
                                                </div>

                                                <!-- Cap Table row -->
                                                <div class="flex items-center justify-between p-4 bg-bg-light rounded-xl border border-border-c"
                                                    id="row-capTable">
                                                    <div class="flex items-center gap-3">
                                                        <div
                                                            class="size-9 rounded-lg bg-green-50 text-green-500 flex items-center justify-center">
                                                            <span
                                                                class="material-symbols-outlined text-[18px]">table_chart</span>
                                                        </div>
                                                        <div>
                                                            <span class="text-sm font-semibold">Cap Table</span>
                                                            <span id="capTable-filename"
                                                                class="text-xs text-text-muted block hidden"></span>
                                                        </div>
                                                    </div>
                                                    <div class="flex items-center gap-2" id="capTable-actions">
                                                        <button type="button"
                                                            onclick="document.getElementById('capTable-input').click()"
                                                            class="h-8 px-3 rounded-full border border-border-c text-xs font-semibold hover:border-primary transition-colors">Upload</button>
                                                    </div>
                                                </div>

                                                <!-- Drop zone -->
                                                <div id="drop-zone"
                                                    class="border-2 border-dashed border-border-c rounded-xl p-8 text-center hover:border-primary transition-colors cursor-pointer"
                                                    onclick="document.getElementById('pitchDeck-input').click()">
                                                    <span
                                                        class="material-symbols-outlined text-[36px] text-text-muted mb-2 block">upload_file</span>
                                                    <p class="font-semibold text-sm">Drop files <span
                                                            class="text-primary cursor-pointer">here</span> or click to
                                                        upload</p>
                                                    <p class="text-xs text-text-muted mt-1">PDF, XLSX, DOCX accepted ·
                                                        Max
                                                        25MB each</p>
                                                </div>
                                            </div>
                                            <div class="flex justify-end gap-3">
                                                <button type="button"
                                                    onclick="showTab('team',document.getElementById('tab-team'))"
                                                    class="h-10 px-6 rounded-full border border-border-c text-sm font-semibold hover:bg-surface transition-colors flex items-center gap-2"><span
                                                        class="material-symbols-outlined text-[18px]">arrow_back</span>Back</button>
                                                <button type="submit" id="submit-btn"
                                                    class="h-10 px-6 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)] flex items-center gap-2"><span
                                                        class="material-symbols-outlined text-[18px]">send</span>Submit
                                                    for
                                                    Review</button>
                                            </div>
                                        </div>
                                    </form>
                                </main>
                                <script>
                                    function showTab(name, btn) {
                                        ['basic', 'funding', 'team', 'docs'].forEach(t => {
                                            document.getElementById('tab-' + t + '-panel').classList.add('hidden');
                                            document.getElementById('tab-' + t + '-panel').classList.remove('flex');
                                            document.getElementById('tab-' + t).className = 'tab-btn flex-1 rounded-lg py-2 text-sm font-medium text-text-muted hover:text-text-main';
                                        });
                                        document.getElementById('tab-' + name + '-panel').classList.remove('hidden');
                                        document.getElementById('tab-' + name + '-panel').classList.add('flex');
                                        document.getElementById('tab-' + name).className = 'tab-btn flex-1 rounded-lg py-2 text-sm font-bold bg-white shadow-sm text-text-main';
                                    }

                                    // Document upload handling
                                    function handleDocSelect(docType, input) {
                                        const file = input.files[0];
                                        if (!file) return;
                                        const fnEl = document.getElementById(docType + '-filename');
                                        const actionsEl = document.getElementById(docType + '-actions');
                                        fnEl.textContent = file.name;
                                        fnEl.classList.remove('hidden');
                                        actionsEl.innerHTML =
                                            '<span class="text-xs text-emerald-600 font-bold bg-emerald-50 px-2 py-0.5 rounded-full">Uploaded</span>' +
                                            '<button type="button" onclick="removeDoc(\'' + docType + '\')" class="text-text-muted hover:text-red-500 transition-colors"><span class="material-symbols-outlined text-[18px]">delete</span></button>';
                                    }

                                    function removeDoc(docType) {
                                        const input = document.getElementById(docType + '-input');
                                        input.value = '';
                                        const fnEl = document.getElementById(docType + '-filename');
                                        fnEl.textContent = '';
                                        fnEl.classList.add('hidden');
                                        const actionsEl = document.getElementById(docType + '-actions');
                                        actionsEl.innerHTML =
                                            '<button type="button" onclick="document.getElementById(\'' + docType + '-input\').click()" class="h-8 px-3 rounded-full border border-border-c text-xs font-semibold hover:border-primary transition-colors">Upload</button>';
                                    }

                                    function handleLogoSelect(input) {
                                        if (input.files[0]) {
                                            document.getElementById('logo-icon').textContent = 'check_circle';
                                            document.getElementById('logo-label').textContent = input.files[0].name.substring(0, 8) + '...';
                                        }
                                    }

                                    // Drop zone drag & drop
                                    const dropZone = document.getElementById('drop-zone');
                                    ['dragenter', 'dragover'].forEach(evt => {
                                        dropZone.addEventListener(evt, e => { e.preventDefault(); dropZone.classList.add('border-primary', 'bg-primary/5'); });
                                    });
                                    ['dragleave', 'drop'].forEach(evt => {
                                        dropZone.addEventListener(evt, e => { e.preventDefault(); dropZone.classList.remove('border-primary', 'bg-primary/5'); });
                                    });
                                    dropZone.addEventListener('drop', e => {
                                        const files = e.dataTransfer.files;
                                        if (files.length > 0) {
                                            // Assign dropped file to the first empty slot
                                            const slots = ['pitchDeck', 'financialModel', 'capTable'];
                                            for (let slot of slots) {
                                                const inp = document.getElementById(slot + '-input');
                                                if (!inp.files || inp.files.length === 0) {
                                                    const dt = new DataTransfer();
                                                    dt.items.add(files[0]);
                                                    inp.files = dt.files;
                                                    handleDocSelect(slot, inp);
                                                    break;
                                                }
                                            }
                                        }
                                    });

                                    // Toast auto-dismiss
                                    function dismissToast() {
                                        const toast = document.getElementById('success-toast');
                                        if (toast) { toast.classList.remove('toast-enter'); toast.classList.add('toast-exit'); setTimeout(() => toast.remove(), 300); }
                                    }
        <% if (showSuccess) { %>
                                        setTimeout(dismissToast, 6000);
        <% } %>

                                        // Form validation and submission
                                        document.getElementById('startup-form').addEventListener('submit', function (e) {
                                            var title = document.getElementById('field-title').value.trim();
                                            var tagline = document.getElementById('field-tagline').value.trim();

                                            // Reset border colors
                                            document.getElementById('field-title').style.borderColor = '';
                                            document.getElementById('field-tagline').style.borderColor = '';

                                            if (!title) {
                                                e.preventDefault();
                                                showTab('basic', document.getElementById('tab-basic'));
                                                document.getElementById('field-title').focus();
                                                document.getElementById('field-title').style.borderColor = '#ef4444'; // Tailwind red-500
                                                return false;
                                            }
                                            if (!tagline) {
                                                e.preventDefault();
                                                showTab('basic', document.getElementById('tab-basic'));
                                                document.getElementById('field-tagline').focus();
                                                document.getElementById('field-tagline').style.borderColor = '#ef4444'; // Tailwind red-500
                                                return false;
                                            }
                                            var btn = document.getElementById('submit-btn');
                                            btn.disabled = true;
                                            btn.innerHTML = '<span class="material-symbols-outlined text-[18px] animate-spin">progress_activity</span>Submitting...';
                                        });
                                </script>
            </body>

            </html>
