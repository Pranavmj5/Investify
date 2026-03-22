<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ page import="java.sql.*, com.investify.db.DBConnection, java.util.*" %>
<%
    if (session.getAttribute("user_id")==null) { 
        response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; 
    } 
    int userId=(int) session.getAttribute("user_id"); 
    String userName=(String) session.getAttribute("user_name"); 

    if (userName==null) userName="Founder"; 
    String startupName="No Startup Registered";
    String dbError = null;
    List<Map<String, String>> requestsList = new ArrayList<>();
    
    try (Connection conn=DBConnection.getConnection()) { 
        PreparedStatement ps=conn.prepareStatement("SELECT * FROM startup WHERE founder_id=? LIMIT 1"); 
        ps.setInt(1, userId); 
        ResultSet rs=ps.executeQuery(); 
        if (rs.next()) {
            startupName=rs.getString("title"); 
            int startupId = rs.getInt("id");

            PreparedStatement ps3 = conn.prepareStatement("SELECT ir.*, u.name as investor_name, u.email as investor_email FROM investment_request ir JOIN users u ON ir.investor_id = u.id WHERE ir.startup_id=? ORDER BY ir.created_at DESC");
            ps3.setInt(1, startupId);
            ResultSet rs3 = ps3.executeQuery();
            while(rs3.next()){
                Map<String, String> req = new HashMap<>();
                req.put("id", String.valueOf(rs3.getInt("id")));
                req.put("investor_name", rs3.getString("investor_name"));
                req.put("investor_email", rs3.getString("investor_email"));
                req.put("amountStr", String.format("%,.0f", rs3.getDouble("amount")));
                req.put("message", rs3.getString("message"));
                String status = rs3.getString("status");
                if(status != null) status = status.trim();
                req.put("status", status);
                req.put("created_at", rs3.getString("created_at"));
                requestsList.add(req);
            }
        }
    } catch (Exception e) { 
        e.printStackTrace();
        dbError = e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Investify – Investment Requests</title>
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: { primary: "#c6a65d", "primary-dark": "#b09045", "bg-light": "#f8f7f6", "surface": "#ffffff", "text-main": "#1e1b14", "text-muted": "#817a6a", "border-c": "#e3e2dd" }, fontFamily: { display: ["Public Sans", "sans-serif"] } } } }
    </script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24 }
        .modal-enter { animation: modalFadeIn 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .modal-body-enter { animation: modalSlideUp 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        @keyframes modalFadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes modalSlideUp { from { opacity: 0; transform: translateY(20px) scale(0.98); } to { opacity: 1; transform: translateY(0) scale(1); } }
    </style>
</head>

<body class="bg-bg-light font-display text-text-main min-h-screen antialiased">
    <!-- Header -->
    <header class="sticky top-0 z-40 flex items-center justify-between border-b border-border-c bg-surface/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
        <div class="flex items-center gap-8">
            <a href="../index.jsp" class="flex items-center gap-3">
                <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white">
                    <span class="material-symbols-outlined text-xl">diamond</span>
                </div>
                <span class="text-lg font-bold">Investify</span>
            </a>
            <span class="hidden md:block text-xs font-bold uppercase tracking-widest text-primary bg-primary/10 rounded-full px-3 py-1">Founder Portal</span>
        </div>
        <nav class="hidden lg:flex items-center gap-6">
            <a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">My Startup</a>
            <a href="requests.jsp" class="text-sm font-semibold text-primary">Requests</a>
            <a href="schemes.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Schemes</a>
            <a href="messages.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Messages</a>
            <a href="settings.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Settings</a>
        </nav>
        <div class="flex items-center gap-4">
            <a href="messages.jsp" class="relative p-2 text-text-muted hover:text-primary transition-colors">
                <span class="material-symbols-outlined">notifications</span>
                <span class="absolute top-2 right-2 h-2 w-2 rounded-full bg-primary ring-2 ring-white"></span>
            </a>
            <a href="create_profile.jsp">
                <img src="https://i.pravatar.cc/36?img=25" class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover" alt="Founder" />
            </a>
        </div>
    </header>

    <main class="max-w-[1000px] mx-auto px-6 py-8 flex flex-col gap-8">
        <div>
            <h1 class="text-3xl font-black">Investment Requests</h1>
            <p class="text-text-muted mt-1">Manage and respond to investor proposals for your startup.</p>
        </div>

        <!-- Requests List -->
        <div class="flex flex-col gap-4">
            <% if (requestsList.isEmpty()) { %>
                <div class="bg-surface rounded-2xl border border-border-c p-12 text-center">
                    <span class="material-symbols-outlined text-5xl text-text-muted mb-4 opacity-50" style="font-variation-settings: 'wght' 200">inbox</span>
                    <h3 class="text-lg font-bold">No Requests Yet</h3>
                    <p class="text-text-muted mt-1 max-w-sm mx-auto">When investors express interest in your startup, their proposals will appear here for your review.</p>
                </div>
            <% } else { 
                for(int i = 0; i < requestsList.size(); i++) {
                    Map<String, String> req = requestsList.get(i);
                    String msg = req.get("message");
                    if(msg == null || msg.trim().isEmpty()) { msg = "No message provided."; }
                    String status = req.get("status");
                    
                    String badgeClass = "bg-amber-100 text-amber-800 border-amber-200";
                    if ("accepted".equalsIgnoreCase(status)) badgeClass = "bg-green-100 text-green-800 border-green-200";
                    else if ("rejected".equalsIgnoreCase(status)) badgeClass = "bg-red-100 text-red-800 border-red-200";
            %>
                <div class="bg-surface border border-border-c hover:border-primary/40 rounded-2xl p-5 flex flex-col sm:flex-row gap-5 items-start sm:items-center justify-between transition-all group shadow-sm hover:shadow-md">
                    <div class="flex items-center gap-4">
                        <div class="h-12 w-12 shrink-0 rounded-full bg-primary/10 text-primary flex items-center justify-center font-bold text-lg">
                            <%= req.get("investor_name").substring(0,1).toUpperCase() %>
                        </div>
                        <div>
                            <div class="flex items-center gap-3">
                                <h3 class="font-bold text-lg"><%= req.get("investor_name") %></h3>
                                <span class="text-[10px] font-bold px-2 py-0.5 rounded border <%= badgeClass %> uppercase tracking-wider"><%= status %></span>
                            </div>
                            <p class="text-sm text-text-muted">Proposed investment: <span class="font-black text-text-main">$<%= req.get("amountStr") %></span></p>
                        </div>
                    </div>
                    <button type="button" onclick='openModal(<%= i %>)' class="h-10 px-5 rounded-full border border-border-c text-sm font-semibold group-hover:bg-bg-light transition-colors whitespace-nowrap">View Details</button>
                </div>
                
                <!-- Hidden data for modal -->
                <script>
                    window.requestData = window.requestData || [];
                    window.requestData[<%= i %>] = {
                        id: "<%= req.get("id") %>",
                        startupName: "<%= startupName %>",
                        investorName: "<%= req.get("investor_name") %>",
                        investorEmail: "<%= req.get("investor_email") %>",
                        amount: "$<%= req.get("amountStr") %>",
                        message: "<%= msg.replace("\"", "\\\"").replace("\n", " ") %>",
                        status: "<%= status %>"
                    };
                </script>
            <%   }
               } %>
        </div>
    </main>

    <!-- Modal Backdrop -->
    <div id="modal-backdrop" class="fixed inset-0 bg-text-main/40 backdrop-blur-sm z-50 hidden flex-col items-center justify-center p-4">
        <!-- Modal Container -->
        <div id="modal-content" class="bg-surface w-full max-w-2xl rounded-[24px] shadow-2xl overflow-hidden hidden flex-col relative">
            <button onclick="closeModal()" class="absolute top-5 right-5 h-8 w-8 rounded-full hover:bg-bg-light flex items-center justify-center text-text-muted hover:text-text-main transition-colors z-10">
                <span class="material-symbols-outlined text-[20px]">close</span>
            </button>
            
            <div class="px-8 pt-8 pb-6 border-b border-border-c bg-gradient-to-b from-bg-light/60 to-surface">
                <h2 class="text-[22px] font-black uppercase tracking-tight">Investor Details</h2>
                <p class="text-sm text-text-muted mt-1" id="m-subtitle">Reviewing proposal</p>
            </div>
            
            <div class="p-8 flex flex-col gap-8 overflow-y-auto max-h-[70vh]">
                <!-- Profile Block -->
                <div class="flex items-center gap-5">
                    <div class="h-16 w-16 shrink-0 rounded-xl bg-primary/10 text-primary border border-primary/20 flex items-center justify-center font-black text-2xl" id="m-avatar">
                        E
                    </div>
                    <div>
                        <h3 class="text-xl font-bold" id="m-name">Eleanor Rigby</h3>
                        <p class="text-sm text-text-muted" id="m-email">eleanor.rigby@rigbyventures.com</p>
                        <div class="flex items-center gap-2 mt-2">
                            <span class="text-[10px] font-bold px-2 py-1 rounded bg-bg-light border border-border-c text-text-muted uppercase tracking-wider">Venture Capital</span>
                            <span class="text-[10px] font-bold px-2 py-1 rounded bg-bg-light border border-border-c text-text-muted uppercase tracking-wider">Tier 1 Partner</span>
                        </div>
                    </div>
                </div>

                <!-- Metrics -->
                <div class="grid grid-cols-2 gap-4">
                    <div class="bg-bg-light rounded-xl p-5 border border-border-c/50">
                        <p class="text-[10px] font-bold uppercase tracking-wider text-text-muted mb-1">Investment Amount</p>
                        <p class="text-2xl font-black text-[#eaa81b]" id="m-amount">$500,000</p>
                    </div>
                    <div class="bg-bg-light rounded-xl p-5 border border-border-c/50">
                        <p class="text-[10px] font-bold uppercase tracking-wider text-text-muted mb-1">Risk Score</p>
                        <div class="flex items-baseline gap-2">
                            <p class="text-2xl font-black">82</p>
                            <span class="text-[10px] font-bold px-2 py-0.5 rounded bg-green-100 text-green-700 uppercase tracking-wider">Low Risk</span>
                        </div>
                    </div>
                </div>

                <!-- Proposal Message -->
                <div>
                    <p class="text-[11px] font-bold uppercase tracking-wider text-text-main mb-3">Proposal Message</p>
                    <div class="border-l-[3px] border-[#eaa81b] bg-[#eaa81b]/5 p-5 rounded-r-xl">
                        <p class="text-[15px] italic text-text-main leading-relaxed" id="m-message">""</p>
                    </div>
                </div>

                <!-- Documents -->
                <div>
                    <p class="text-[11px] font-bold uppercase tracking-wider text-text-main mb-3">Uploaded Documents</p>
                    <div class="flex items-center justify-between p-4 border border-border-c rounded-xl hover:border-primary/30 transition-colors cursor-pointer group">
                        <div class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-text-muted group-hover:text-primary transition-colors">description</span>
                            <span class="text-sm font-medium" id="m-doc">Pitch Deck.pdf</span>
                        </div>
                        <span class="material-symbols-outlined text-text-muted group-hover:text-primary transition-colors">download</span>
                    </div>
                </div>
            </div>

            <!-- Actions -->
            <div class="p-8 border-t border-border-c flex gap-4" id="m-actions">
                <form action="<%= request.getContextPath() %>/founder/investment-decision" method="POST" class="flex-1 flex gap-4 m-0">
                    <input type="hidden" name="requestId" id="m-reqId" value="">
                    
                    <button type="submit" name="action" value="accept" class="flex-1 h-12 rounded-[8px] bg-[#eaa81b] hover:bg-[#d69614] text-white text-[15px] font-bold transition-colors shadow-sm text-center">
                        Approve Investment
                    </button>
                    <button type="button" onclick="rejectForm()" class="flex-1 h-12 rounded-[8px] border border-text-main text-text-main hover:bg-bg-light text-[15px] font-bold transition-colors shadow-sm text-center">
                        Request Revisions
                    </button>
                    <!-- actual reject submit button hidden -->
                    <button type="submit" name="action" value="reject" id="m-rejectBtn" class="hidden"></button>
                </form>
            </div>
            
            <!-- Status indicator (when already processed) -->
            <div class="p-6 border-t border-border-c text-center hidden" id="m-status-wrap">
                <span class="inline-block px-4 py-2 rounded-full font-bold text-sm" id="m-status-badge"></span>
            </div>
        </div>
    </div>

    <script>
        function openModal(idx) {
            const data = window.requestData[idx];
            
            document.getElementById('m-reqId').value = data.id;
            document.getElementById('m-subtitle').textContent = `Reviewing proposal for ${data.startupName} Series A`;
            document.getElementById('m-avatar').textContent = data.investorName.charAt(0).toUpperCase();
            document.getElementById('m-name').textContent = data.investorName;
            document.getElementById('m-email').textContent = data.investorEmail;
            document.getElementById('m-amount').textContent = data.amount;
            document.getElementById('m-message').textContent = `"${data.message}"`;
            document.getElementById('m-doc').textContent = `Pitch Deck_${data.startupName.replace(/\s+/g, '')}_${data.investorName.split(' ').pop()}.pdf`;
            
            if (data.status.toLowerCase() !== 'pending') {
                document.getElementById('m-actions').classList.add('hidden');
                document.getElementById('m-status-wrap').classList.remove('hidden');
                const badge = document.getElementById('m-status-badge');
                if (data.status.toLowerCase() === 'accepted') {
                    badge.className = 'inline-block px-4 py-2 rounded-full font-bold text-sm bg-green-100 text-green-800 border border-green-200 uppercase tracking-wider';
                    badge.textContent = 'Investment Approved';
                } else {
                    badge.className = 'inline-block px-4 py-2 rounded-full font-bold text-sm bg-red-100 text-red-800 border border-red-200 uppercase tracking-wider';
                    badge.textContent = 'Investment Rejected';
                }
            } else {
                document.getElementById('m-actions').classList.remove('hidden');
                document.getElementById('m-status-wrap').classList.add('hidden');
            }

            const backdrop = document.getElementById('modal-backdrop');
            const content = document.getElementById('modal-content');
            backdrop.classList.remove('hidden');
            backdrop.classList.add('flex', 'modal-enter');
            content.classList.remove('hidden');
            content.classList.add('flex', 'modal-body-enter');
            document.body.style.overflow = 'hidden';
        }

        function closeModal() {
            const backdrop = document.getElementById('modal-backdrop');
            const content = document.getElementById('modal-content');
            backdrop.classList.remove('modal-enter', 'flex');
            backdrop.classList.add('hidden');
            content.classList.remove('modal-body-enter', 'flex');
            content.classList.add('hidden');
            document.body.style.overflow = '';
        }

        function rejectForm() {
            // Because Request Revisions functions as Reject based on user requirement to decide true or false
            document.getElementById('m-rejectBtn').click();
        }
    </script>
</body>
</html>
