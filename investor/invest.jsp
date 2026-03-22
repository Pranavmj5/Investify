<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ page import="java.sql.*, com.investify.db.DBConnection" %>
<% 
    if (session.getAttribute("user_id") == null) { 
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; 
    } 
    int userId = (int) session.getAttribute("user_id"); 
    String userName = (String) session.getAttribute("user_name"); 

    String startupIdStr = request.getParameter("id");
    if (startupIdStr == null || startupIdStr.trim().isEmpty()) {
        response.sendRedirect("browse_startups.jsp");
        return;
    }
    int startupId = Integer.parseInt(startupIdStr);

    String startupName = "Selected Startup";
    String domain = "Unknown Domain";
    double fundingGoal = 0;
    double fundingRaised = 0;
    double minTicket = 10000;
    double equityOffered = 0;
    int fundingPercent = 0;

    try (Connection conn = DBConnection.getConnection()) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM startup WHERE id = ?");
        ps.setInt(1, startupId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            startupName = rs.getString("title");
            domain = rs.getString("domain");
            fundingGoal = rs.getDouble("funding_goal");
            fundingRaised = rs.getDouble("funding_raised");
            minTicket = rs.getDouble("min_ticket");
            equityOffered = rs.getDouble("equity_offered");
            if (fundingGoal > 0) fundingPercent = (int) Math.round((fundingRaised / fundingGoal) * 100);
        } else {
            response.sendRedirect("browse_startups.jsp");
            return;
        }
    } catch(Exception e) {
        e.printStackTrace();
    }
    String fmtMin = minTicket >= 1000000 ? "$" + String.format("%.1fM", minTicket/1000000) : "$" + String.format("%.0fK", minTicket/1000);
    String fmtGoal = fundingGoal >= 1000000 ? "$" + String.format("%.1fM", fundingGoal/1000000) : "$" + String.format("%.0fK", fundingGoal/1000);
    String fmtRaised = fundingRaised >= 1000000 ? "$" + String.format("%.1fM", fundingRaised/1000000) : "$" + String.format("%.0fK", fundingRaised/1000);
%>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Investify – Make an Investment</title>
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

                .step-indicator {
                    transition: .3s
                }

                input[type=range] {
                    -webkit-appearance: none;
                    appearance: none;
                    width: 100%;
                    height: 6px;
                    border-radius: 9999px;
                    background: #e6e2db;
                    outline: none
                }

                input[type=range]::-webkit-slider-thumb {
                    -webkit-appearance: none;
                    appearance: none;
                    width: 20px;
                    height: 20px;
                    border-radius: 50%;
                    background: #c6a65d;
                    cursor: pointer;
                    border: 2px solid #fff;
                    box-shadow: 0 0 6px rgba(198, 166, 93, .4)
                }
            </style>
        </head>

        <body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
            <!-- NAVBAR -->
            <header
                class="sticky top-0 z-50 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                <a href="../index.jsp" class="flex items-center gap-3">
                    <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                            class="material-symbols-outlined text-xl">diamond</span></div><span
                        class="text-xl font-bold">Investify</span>
                </a>
                <a href="browse_startups.jsp"
                    class="flex items-center gap-1.5 text-sm text-text-muted hover:text-primary transition-colors"><span
                        class="material-symbols-outlined text-[18px]">arrow_back</span>Back to Browse</a>
            </header>

            <main class="max-w-5xl mx-auto px-6 py-10 flex flex-col gap-8">
                <!-- Progress steps -->
                <div>
                    <h1 class="text-3xl font-black mb-6">Express Investment Interest</h1>
                    <div class="flex items-center gap-0" id="steps">
                        <div class="flex items-center gap-3" id="step-1-indicator">
                            <div
                                class="size-9 rounded-full bg-primary text-white text-sm font-bold flex items-center justify-center shadow-[0_2px_8px_rgba(198,166,93,.4)]">
                                1</div>
                            <span class="text-sm font-semibold text-primary hidden sm:block">Choose Amount</span>
                        </div>
                        <div class="h-0.5 flex-1 bg-border-c mx-4" id="line-1"></div>
                        <div class="flex items-center gap-3" id="step-2-indicator">
                            <div class="size-9 rounded-full bg-bg-light border-2 border-border-c text-text-muted text-sm font-bold flex items-center justify-center step-indicator"
                                id="step-2-num">2</div>
                            <span class="text-sm font-medium text-text-muted hidden sm:block" id="step-2-label">KYC &
                                Terms</span>
                        </div>
                        <div class="h-0.5 flex-1 bg-border-c mx-4" id="line-2"></div>
                        <div class="flex items-center gap-3" id="step-3-indicator">
                            <div class="size-9 rounded-full bg-bg-light border-2 border-border-c text-text-muted text-sm font-bold flex items-center justify-center step-indicator"
                                id="step-3-num">3</div>
                            <span class="text-sm font-medium text-text-muted hidden sm:block" id="step-3-label">Review &
                                Submit</span>
                        </div>
                    </div>
                </div>

                <div class="grid md:grid-cols-3 gap-6">
                    <!-- FORM AREA -->
                    <div class="md:col-span-2">
                        <form id="investForm" action="../invest" method="POST">
                        <input type="hidden" name="startupId" value="<%= startupId %>">
                        <input type="hidden" name="amount" id="form-amount" value="25000">

                        <!-- STEP 1: Amount -->
                        <div id="panel-1"
                            class="bg-surface rounded-2xl border border-border-c shadow-sm p-8 flex flex-col gap-6">
                            <div>
                                <h2 class="text-xl font-bold">Choose Investment Amount</h2>
                                <p class="text-text-muted text-sm mt-1">You are expressing interest in <span
                                        class="font-semibold text-text-main" id="invest-startup-name"><%= startupName %></span></p>
                            </div>

                            <!-- Amount slider -->
                            <div>
                                <div class="flex justify-between text-sm mb-3">
                                    <span class="font-semibold">Investment Amount</span>
                                    <span class="font-black text-2xl text-primary" id="amount-display">$25,000</span>
                                </div>
                                <input type="range" min="10000" max="500000" step="5000" value="25000"
                                    id="amount-slider" class="w-full mb-2" />
                                <div class="flex justify-between text-xs text-text-muted"><span>Min $10K</span><span>Max
                                        $500K</span></div>
                            </div>

                            <!-- Quick select amounts -->
                            <div>
                                <p class="text-sm font-semibold mb-3">Quick select</p>
                                <div class="flex flex-wrap gap-2" id="quick-amounts">
                                    <button type="button" onclick="setAmount(10000)"
                                        class="quick-btn px-4 py-2 rounded-full border border-border-c text-sm font-semibold hover:border-primary hover:text-primary transition-colors">$10K</button>
                                    <button type="button" onclick="setAmount(25000)"
                                        class="quick-btn px-4 py-2 rounded-full border-2 border-primary text-primary text-sm font-bold">$25K</button>
                                    <button type="button" onclick="setAmount(50000)"
                                        class="quick-btn px-4 py-2 rounded-full border border-border-c text-sm font-semibold hover:border-primary hover:text-primary transition-colors">$50K</button>
                                    <button type="button" onclick="setAmount(100000)"
                                        class="quick-btn px-4 py-2 rounded-full border border-border-c text-sm font-semibold hover:border-primary hover:text-primary transition-colors">$100K</button>
                                    <button type="button" onclick="setAmount(250000)"
                                        class="quick-btn px-4 py-2 rounded-full border border-border-c text-sm font-semibold hover:border-primary hover:text-primary transition-colors">$250K</button>
                                </div>
                            </div>

                            <!-- Estimated equity -->
                            <div class="bg-primary/5 border border-primary/20 rounded-xl p-5">
                                <p class="text-sm font-semibold mb-3 text-primary">Estimated Returns at <span
                                        id="amt-label">$25,000</span></p>
                                <div class="grid grid-cols-3 gap-4 text-center">
                                    <div>
                                        <p class="text-xs text-text-muted mb-1">Est. Equity</p>
                                        <p class="font-black text-lg" id="equity-val">0.096%</p>
                                    </div>
                                    <div>
                                        <p class="text-xs text-text-muted mb-1">If 3× return</p>
                                        <p class="font-black text-lg text-emerald-600" id="ret3">$75K</p>
                                    </div>
                                    <div>
                                        <p class="text-xs text-text-muted mb-1">If 5× return</p>
                                        <p class="font-black text-lg text-emerald-600" id="ret5">$125K</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Message to founder -->
                            <div>
                                <label class="block text-sm font-semibold mb-1.5">Message to Founder (optional)</label>
                                <textarea rows="4" name="message"
                                    class="w-full px-4 py-3 rounded-xl border border-border-c bg-bg-light text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors resize-none"
                                    placeholder="Introduce yourself, explain your interest, or ask a question…"></textarea>
                            </div>

                            <div class="flex justify-end">
                                <button type="button" onclick="goStep(2)"
                                    class="h-11 px-8 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)] flex items-center gap-2">Continue
                                    <span class="material-symbols-outlined text-[18px]">arrow_forward</span></button>
                            </div>
                        </div>

                        <!-- STEP 2: KYC & Terms -->
                        <div id="panel-2"
                            class="hidden bg-surface rounded-2xl border border-border-c shadow-sm p-8 flex flex-col gap-6">
                            <div>
                                <h2 class="text-xl font-bold">KYC & Investment Terms</h2>
                                <p class="text-text-muted text-sm mt-1">Required disclosures before your interest is
                                    forwarded
                                    to the startup.</p>
                            </div>
                            <div class="flex flex-col gap-4">
                                <div class="flex items-start gap-3 p-4 bg-bg-light rounded-xl border border-border-c">
                                    <span class="material-symbols-outlined text-emerald-600 mt-0.5">verified_user</span>
                                    <div>
                                        <p class="font-semibold text-sm">KYC Status: Verified</p>
                                        <p class="text-xs text-text-muted">Your identity has been verified. No further
                                            action
                                            needed.</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3 p-4 bg-bg-light rounded-xl border border-border-c">
                                    <span
                                        class="material-symbols-outlined text-emerald-600 mt-0.5">account_balance</span>
                                    <div>
                                        <p class="font-semibold text-sm">Accredited Investor Status: Confirmed</p>
                                        <p class="text-xs text-text-muted">Annual income > $200K or net worth > $1M (Reg
                                            D
                                            compliant)</p>
                                    </div>
                                </div>
                            </div>
                            <div class="space-y-3 border border-border-c rounded-xl p-5 bg-bg-light">
                                <p class="text-sm font-bold mb-3">Investment Disclosures</p>
                                <label class="flex items-start gap-3 cursor-pointer">
                                    <input type="checkbox" id="check-risk"
                                        class="mt-0.5 size-4 rounded accent-[#c6a65d]" />
                                    <span class="text-sm text-text-muted leading-relaxed">I understand that startup
                                        investments
                                        involve significant risk, including the risk of total loss of my invested
                                        capital.</span>
                                </label>
                                <label class="flex items-start gap-3 cursor-pointer">
                                    <input type="checkbox" id="check-lock"
                                        class="mt-0.5 size-4 rounded accent-[#c6a65d]" />
                                    <span class="text-sm text-text-muted leading-relaxed">I acknowledge that my
                                        investment
                                        may
                                        be illiquid for 3–7 years and there is no guaranteed exit.</span>
                                </label>
                                <label class="flex items-start gap-3 cursor-pointer">
                                    <input type="checkbox" id="check-nda"
                                        class="mt-0.5 size-4 rounded accent-[#c6a65d]" />
                                    <span class="text-sm text-text-muted leading-relaxed">I agree to the Non-Disclosure
                                        Agreement (NDA) and will not share the startup's confidential
                                        information.</span>
                                </label>
                                <label class="flex items-start gap-3 cursor-pointer">
                                    <input type="checkbox" id="check-terms"
                                        class="mt-0.5 size-4 rounded accent-[#c6a65d]" />
                                    <span class="text-sm text-text-muted leading-relaxed">I have read and accept
                                        Investify's
                                        <a href="#" class="text-primary hover:underline">Terms of Service</a> and <a
                                            href="#" class="text-primary hover:underline">Investment
                                            Agreement</a>.</span>
                                </label>
                            </div>
                            <div class="flex justify-between">
                                <button type="button" onclick="goStep(1)"
                                    class="flex items-center gap-2 h-11 px-6 rounded-full border border-border-c text-sm font-semibold hover:bg-bg-light transition-colors"><span
                                        class="material-symbols-outlined text-[18px]">arrow_back</span>Back</button>
                                <button type="button" onclick="validateStep2()"
                                    class="h-11 px-8 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)] flex items-center gap-2">Review
                                    <span class="material-symbols-outlined text-[18px]">arrow_forward</span></button>
                            </div>
                        </div>

                        <!-- STEP 3: Review -->
                        <div id="panel-3"
                            class="hidden bg-surface rounded-2xl border border-border-c shadow-sm p-8 flex flex-col gap-6">
                            <div>
                                <h2 class="text-xl font-bold">Review & Submit</h2>
                                <p class="text-text-muted text-sm mt-1">Confirm your investment interest before
                                    submitting.
                                </p>
                            </div>
                            <div class="flex flex-col gap-3">
                                <div class="flex justify-between py-3 border-b border-border-c text-sm"><span
                                        class="text-text-muted">Startup</span><span class="font-bold"
                                        id="review-startup"><%= startupName %></span>
                                </div>
                                <div class="flex justify-between py-3 border-b border-border-c text-sm"><span
                                        class="text-text-muted">Stage</span><span class="font-bold">Series A</span>
                                </div>
                                <div class="flex justify-between py-3 border-b border-border-c text-sm"><span
                                        class="text-text-muted">Investment Amount</span><span
                                        class="font-black text-primary" id="review-amount">$25,000</span></div>
                                <div class="flex justify-between py-3 border-b border-border-c text-sm"><span
                                        class="text-text-muted">Estimated Equity</span><span class="font-bold"
                                        id="review-equity">0.096%</span></div>
                                <div class="flex justify-between py-3 border-b border-border-c text-sm"><span
                                        class="text-text-muted">Instrument</span><span class="font-bold">Equity
                                        (SAFE)</span>
                                </div>
                                <div class="flex justify-between py-3 border-b border-border-c text-sm"><span
                                        class="text-text-muted">Escrow Provider</span><span class="font-bold">Investify
                                        Trust
                                        Services</span></div>
                                <div class="flex justify-between py-3 text-sm"><span class="text-text-muted">Platform
                                        Fee</span><span class="font-bold">1.5% of investment</span></div>
                            </div>
                            <div class="bg-amber-50 border border-amber-200 rounded-xl p-4 text-sm text-amber-800"><span
                                    class="material-symbols-outlined text-[18px] mr-2 align-middle">info</span>Submitting
                                does
                                not immediately transfer funds. The founder will review your interest and Investify will
                                initiate due diligence before any transaction.</div>
                            <div class="flex justify-between">
                                <button type="button" onclick="goStep(2)"
                                    class="flex items-center gap-2 h-11 px-6 rounded-full border border-border-c text-sm font-semibold hover:bg-bg-light transition-colors"><span
                                        class="material-symbols-outlined text-[18px]">arrow_back</span>Back</button>
                                <button type="button" onclick="submitInvestment()"
                                    class="h-11 px-8 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)] flex items-center gap-2"><span
                                        class="material-symbols-outlined text-[18px]">send</span>Submit
                                    Interest</button>
                            </div>
                        </div>
                        </form>

                        <!-- SUCCESS -->
                        <div id="panel-success"
                            class="hidden bg-surface rounded-2xl border border-border-c shadow-sm p-12 text-center">
                            <div
                                class="size-20 rounded-full bg-emerald-50 flex items-center justify-center mx-auto mb-5">
                                <span class="material-symbols-outlined text-[44px] text-emerald-600"
                                    style="font-variation-settings:'FILL' 1,'wght' 400,'GRAD' 0,'opsz' 24">check_circle</span>
                            </div>
                            <h2 class="text-2xl font-black text-text-main">Interest Submitted!</h2>
                            <p class="text-text-muted mt-3 max-w-sm mx-auto">Your investment interest of <span
                                    class="font-bold text-text-main" id="success-amount">$25,000</span> has
                                been sent. The founder will review and respond within 48 hours.</p>
                            <div class="flex flex-col sm:flex-row gap-3 justify-center mt-8">
                                <a href="portfolio"
                                    class="h-11 px-6 rounded-full bg-primary text-white text-sm font-bold hover:bg-primary-dark transition-colors shadow-[0_2px_10px_rgba(198,166,93,.3)] flex items-center justify-center gap-2"><span
                                        class="material-symbols-outlined text-[18px]">pie_chart</span>View Portfolio</a>
                                <a href="browse_startups.jsp"
                                    class="h-11 px-6 rounded-full border border-border-c text-sm font-semibold hover:bg-bg-light transition-colors flex items-center justify-center gap-2"><span
                                        class="material-symbols-outlined text-[18px]">explore</span>Browse More</a>
                            </div>
                        </div>
                    </div>

                    <!-- SIDEBAR: Startup summary card -->
                    <div class="flex flex-col gap-4">
                        <div
                            class="bg-surface rounded-2xl border border-border-c shadow-sm overflow-hidden sticky top-24">
                            <div class="h-28 bg-gradient-to-br from-primary/20 to-primary/5 flex items-end p-4">
                                <div class="size-12 rounded-xl bg-white shadow-md flex items-center justify-center">
                                    <span
                                        class="material-symbols-outlined text-primary text-[22px]">currency_exchange</span>
                                </div>
                            </div>
                            <div class="p-5">
                                <h3 class="font-black text-base" id="sidebar-name"><%= startupName %></h3>
                                <p class="text-xs text-text-muted mt-0.5" id="sidebar-domain"><%= domain %></p>
                                <div class="my-4 space-y-2.5 text-sm">
                                    <div class="flex justify-between"><span class="text-text-muted">Funding
                                            Goal</span><span class="font-bold" id="sidebar-goal"><%= fmtGoal %></span></div>
                                    <div class="flex justify-between"><span class="text-text-muted">Raised So
                                            Far</span><span class="font-bold text-emerald-600"
                                            id="sidebar-raised"><%= fmtRaised %></span></div>
                                    <div class="flex justify-between"><span class="text-text-muted">Min
                                            Ticket</span><span class="font-bold" id="sidebar-min"><%= fmtMin %></span></div>
                                    <div class="flex justify-between"><span class="text-text-muted">Equity
                                            Offered</span><span class="font-bold" id="sidebar-equity"><%= equityOffered %>%</span></div>
                                </div>
                                <div class="h-2 bg-bg-light rounded-full overflow-hidden mb-1">
                                    <div class="h-full bg-primary rounded-full" style="width:<%= fundingPercent %>%" id="sidebar-bar"></div>
                                </div>
                                <p class="text-xs text-text-muted" id="sidebar-info"><%= fundingPercent %>% funded</p>
                                <a href="startup_detail.jsp?id=<%= startupId %>"
                                    class="mt-4 flex items-center gap-1.5 text-xs font-semibold text-primary hover:text-primary-dark transition-colors">View
                                    Full Profile <span
                                        class="material-symbols-outlined text-[15px]">open_in_new</span></a>
                            </div>
                        </div>

                        <!-- Security badge -->
                        <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-4 flex items-start gap-3">
                            <span class="material-symbols-outlined text-emerald-600 mt-0.5">lock</span>
                            <div>
                                <p class="text-sm font-semibold">Secured & Compliant</p>
                                <p class="text-xs text-text-muted mt-0.5">256-bit encryption · SEBI compliant ·
                                    Escrow-protected
                                    funds</p>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <script>
                let currentAmount = 25000;
                function formatCurrency(n) { return n >= 1000000 ? `$${(n / 1000000).toFixed(1)}M` : `$${(n / 1000).toFixed(0)}K`; }
                function updateAmount(val) {
                    currentAmount = val;
                    document.getElementById('amount-display').textContent = '$' + Number(val).toLocaleString();
                    document.getElementById('amt-label').textContent = '$' + Number(val).toLocaleString();
                    document.getElementById('amount-slider').value = val;
                    const equity = ((val / 26000000) * 8.5).toFixed(3);
                    document.getElementById('equity-val').textContent = equity + '%';
                    document.getElementById('ret3').textContent = formatCurrency(val * 3);
                    document.getElementById('ret5').textContent = formatCurrency(val * 5);
                    document.getElementById('review-amount').textContent = '$' + Number(val).toLocaleString();
                    document.getElementById('review-equity').textContent = equity + '%';
                    document.getElementById('success-amount').textContent = '$' + Number(val).toLocaleString();
                    document.getElementById('form-amount').value = val;
                    document.querySelectorAll('.quick-btn').forEach(b => {
                        const bv = b.textContent.replace('$', '').replace('K', '000');
                        const bnum = parseInt(bv) || 0;
                        b.className = bnum === val ? 'quick-btn px-4 py-2 rounded-full border-2 border-primary text-primary text-sm font-bold' : 'quick-btn px-4 py-2 rounded-full border border-border-c text-sm font-semibold hover:border-primary hover:text-primary transition-colors';
                    });
                }
                function setAmount(val) { updateAmount(val); }
                document.getElementById('amount-slider').addEventListener('input', e => updateAmount(parseInt(e.target.value)));

                function goStep(n) {
                    [1, 2, 3].forEach(i => {
                        document.getElementById('panel-' + i).classList.add('hidden');
                        const num = document.getElementById('step-' + i + '-num');
                        const label = document.getElementById('step-' + i + '-label');
                        if (num) { num.className = 'size-9 rounded-full bg-bg-light border-2 border-border-c text-text-muted text-sm font-bold flex items-center justify-center step-indicator'; }
                        if (label) { label.className = 'text-sm font-medium text-text-muted hidden sm:block'; }
                    });
                    document.getElementById('panel-' + n).classList.remove('hidden');
                    const num = document.getElementById('step-' + n + '-num');
                    const label = document.getElementById('step-' + n + '-label');
                    if (num) { num.className = 'size-9 rounded-full bg-primary text-white text-sm font-bold flex items-center justify-center step-indicator shadow-[0_2px_8px_rgba(198,166,93,.4)]'; }
                    if (label) { label.className = 'text-sm font-semibold text-primary hidden sm:block'; }
                }
                function validateStep2() {
                    const checks = ['check-risk', 'check-lock', 'check-nda', 'check-terms'];
                    if (checks.every(id => document.getElementById(id).checked)) { goStep(3); }
                    else { alert('Please read and agree to all disclosures before proceeding.'); }
                }
                function submitInvestment() {
                    document.getElementById('investForm').submit();
                    [1, 2, 3].forEach(i => {
                        const num = document.getElementById('step-' + i + '-num');
                        if (num) { num.className = 'size-9 rounded-full bg-emerald-600 text-white text-sm font-bold flex items-center justify-center step-indicator'; }
                        const label = document.getElementById('step-' + i + '-label');
                        if (label) { label.className = 'text-sm font-semibold text-emerald-700 hidden sm:block'; }
                    });
                }
                // Init
                goStep(1);
            </script>
        </body>

        </html>
