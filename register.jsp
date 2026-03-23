<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Investify – Create Account</title>
        <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;600;700;800&display=swap"
            rel="stylesheet" />
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet" />
        <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
        <script>tailwind.config = { theme: { extend: { colors: { primary: "#c6a65d", "primary-dark": "#b09045", "bg-cream": "#f4efe8", "text-main": "#1e1b14", "text-muted": "#817a6a", "border-subtle": "#e6e2db" }, fontFamily: { display: ["Public Sans", "sans-serif"] } } } }</script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24
            }

            body {
                background: radial-gradient(ellipse 80% 80% at 50% 0%, rgba(198, 166, 93, .1) 0%, transparent 60%), #f4efe8
            }

            .step-panel {
                display: none
            }

            .step-panel.active {
                display: block
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(20px)
                }

                to {
                    opacity: 1;
                    transform: translateX(0)
                }
            }

            .step-panel.active {
                animation: slideIn .3s ease forwards
            }
        </style>
    </head>

    <body class="font-display text-text-main min-h-screen flex flex-col items-center justify-center p-4 antialiased">
        <a href="index.jsp" class="flex items-center gap-3 mb-8">
            <div
                class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary text-white shadow-[0_4px_12px_rgba(198,166,93,.4)]">
                <span class="material-symbols-outlined text-xl">diamond</span>
            </div>
            <span class="text-xl font-bold">Investify</span>
        </a>

        <div
            class="w-full max-w-lg bg-white rounded-2xl shadow-[0_8px_40px_rgba(0,0,0,.07)] border border-border-subtle p-8">
            <h1 class="text-2xl font-bold mb-2 text-center">Create Your Account</h1>
            <p class="text-sm text-text-muted text-center mb-8">Join 8,500+ investors and founders on Investify</p>

            <%-- Error message --%>
                <% String error=(String) request.getAttribute("error"); if (error !=null && !error.isEmpty()) { %>
                    <p
                        class="text-xs text-red-600 bg-red-50 border border-red-200 rounded-lg px-3 py-2 mb-4 text-center">
                        <%= error %>
                    </p>
                    <% } %>

                        <!-- Progress steps -->
                        <div class="flex items-center justify-center gap-0 mb-8" id="progress-bar">
                            <div class="step-dot flex items-center justify-center w-8 h-8 rounded-full text-sm font-bold text-white bg-primary"
                                data-step="1">1</div>
                            <div class="h-0.5 w-16 bg-border-subtle step-line" id="line-1"></div>
                            <div class="step-dot flex items-center justify-center w-8 h-8 rounded-full text-sm font-bold text-text-muted bg-bg-cream"
                                data-step="2">2</div>
                            <div class="h-0.5 w-16 bg-border-subtle step-line" id="line-2"></div>
                            <div class="step-dot flex items-center justify-center w-8 h-8 rounded-full text-sm font-bold text-text-muted bg-bg-cream"
                                data-step="3">3</div>
                        </div>

                        <form id="register-form" action="register" method="POST" novalidate>

                            <!-- Step 1: Role -->
                            <div class="step-panel active" id="step-1">
                                <h2 class="text-lg font-bold mb-1">Choose Your Role</h2>
                                <p class="text-sm text-text-muted mb-5">Select the role that best describes you.</p>
                                <div class="grid grid-cols-2 gap-4">
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="role" value="investor" class="peer sr-only" checked />
                                        <div
                                            class="p-5 rounded-xl border border-border-subtle hover:border-primary/50 peer-checked:border-primary peer-checked:bg-primary/5 peer-checked:ring-1 peer-checked:ring-primary transition-all text-center">
                                            <span
                                                class="material-symbols-outlined text-[36px] text-primary mb-2 block">account_balance_wallet</span>
                                            <span class="font-bold block">Investor</span>
                                            <span class="text-xs text-text-muted">Invest in startups</span>
                                        </div>
                                        <span
                                            class="material-symbols-outlined absolute top-3 right-3 text-primary text-[18px] opacity-0 peer-checked:opacity-100 transition-opacity">check_circle</span>
                                    </label>
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="role" value="founder" class="peer sr-only" />
                                        <div
                                            class="p-5 rounded-xl border border-border-subtle hover:border-primary/50 peer-checked:border-primary peer-checked:bg-primary/5 peer-checked:ring-1 peer-checked:ring-primary transition-all text-center">
                                            <span
                                                class="material-symbols-outlined text-[36px] text-primary mb-2 block">rocket_launch</span>
                                            <span class="font-bold block">Founder</span>
                                            <span class="text-xs text-text-muted">List your startup</span>
                                        </div>
                                        <span
                                            class="material-symbols-outlined absolute top-3 right-3 text-primary text-[18px] opacity-0 peer-checked:opacity-100 transition-opacity">check_circle</span>
                                    </label>
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="role" value="government" class="peer sr-only" />
                                        <div
                                            class="p-5 rounded-xl border border-border-subtle hover:border-primary/50 peer-checked:border-primary peer-checked:bg-primary/5 peer-checked:ring-1 peer-checked:ring-primary transition-all text-center">
                                            <span
                                                class="material-symbols-outlined text-[36px] text-primary mb-2 block">account_balance</span>
                                            <span class="font-bold block">Government</span>
                                            <span class="text-xs text-text-muted">Manage schemes</span>
                                        </div>
                                        <span
                                            class="material-symbols-outlined absolute top-3 right-3 text-primary text-[18px] opacity-0 peer-checked:opacity-100 transition-opacity">check_circle</span>
                                    </label>
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="role" value="admin" class="peer sr-only" />
                                        <div
                                            class="p-5 rounded-xl border border-border-subtle hover:border-primary/50 peer-checked:border-primary peer-checked:bg-primary/5 peer-checked:ring-1 peer-checked:ring-primary transition-all text-center">
                                            <span
                                                class="material-symbols-outlined text-[36px] text-primary mb-2 block">admin_panel_settings</span>
                                            <span class="font-bold block">Admin</span>
                                            <span class="text-xs text-text-muted">Platform control</span>
                                        </div>
                                        <span
                                            class="material-symbols-outlined absolute top-3 right-3 text-primary text-[18px] opacity-0 peer-checked:opacity-100 transition-opacity">check_circle</span>
                                    </label>
                                </div>
                                <button type="button" onclick="goStep(2)"
                                    class="mt-6 w-full bg-primary hover:bg-primary-dark text-white font-bold py-3.5 rounded-xl transition-all shadow-[0_4px_14px_rgba(198,166,93,.35)] flex items-center justify-center gap-2">Continue<span
                                        class="material-symbols-outlined text-[20px]">arrow_forward</span></button>
                            </div>

                            <!-- Step 2: Personal Info -->
                            <div class="step-panel" id="step-2">
                                <h2 class="text-lg font-bold mb-1">Personal Information</h2>
                                <p class="text-sm text-text-muted mb-5">Tell us about yourself.</p>
                                <div class="flex flex-col gap-4">
                                    <div class="grid grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-semibold mb-1.5">First Name</label>
                                            <input type="text" name="firstName" placeholder="John" required
                                                class="w-full px-4 py-3 rounded-xl border border-border-subtle bg-bg-cream/50 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold mb-1.5">Last Name</label>
                                            <input type="text" name="lastName" placeholder="Doe" required
                                                class="w-full px-4 py-3 rounded-xl border border-border-subtle bg-bg-cream/50 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-semibold mb-1.5">Email Address</label>
                                        <div class="relative">
                                            <span
                                                class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-text-muted text-[20px]">mail</span>
                                            <input type="email" name="email" placeholder="john@example.com" required
                                                class="w-full pl-10 pr-4 py-3 rounded-xl border border-border-subtle bg-bg-cream/50 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-semibold mb-1.5">Password</label>
                                        <div class="relative">
                                            <span
                                                class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-text-muted text-[20px]">lock</span>
                                            <input type="password" name="password" placeholder="Min 8 characters"
                                                required
                                                class="w-full pl-10 pr-4 py-3 rounded-xl border border-border-subtle bg-bg-cream/50 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-semibold mb-1.5">Phone Number</label>
                                        <input type="tel" name="phone" placeholder="+91 98765 43210"
                                            class="w-full px-4 py-3 rounded-xl border border-border-subtle bg-bg-cream/50 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors" />
                                    </div>
                                </div>
                                <div class="flex gap-3 mt-6">
                                    <button type="button" onclick="goStep(1)"
                                        class="flex-1 py-3.5 rounded-xl border border-border-subtle text-sm font-semibold hover:bg-gray-50 transition-colors flex items-center justify-center gap-2"><span
                                            class="material-symbols-outlined text-[20px]">arrow_back</span>Back</button>
                                    <button type="button" onclick="goStep(3)"
                                        class="flex-1 bg-primary hover:bg-primary-dark text-white font-bold py-3.5 rounded-xl transition-all shadow-[0_4px_14px_rgba(198,166,93,.35)] flex items-center justify-center gap-2">Continue<span
                                            class="material-symbols-outlined text-[20px]">arrow_forward</span></button>
                                </div>
                            </div>

                            <!-- Step 3: Terms & Submit -->
                            <div class="step-panel" id="step-3">
                                <h2 class="text-lg font-bold mb-1">Almost Done!</h2>
                                <p class="text-sm text-text-muted mb-5">Review and confirm your registration.</p>
                                <div class="bg-bg-cream rounded-xl p-5 space-y-3 mb-5">
                                    <div class="flex items-center gap-3"><span
                                            class="material-symbols-outlined text-primary text-[22px]">verified</span><span
                                            class="text-sm font-medium">KYC verification will be sent to your
                                            email</span></div>
                                    <div class="flex items-center gap-3"><span
                                            class="material-symbols-outlined text-primary text-[22px]">security</span><span
                                            class="text-sm font-medium">Your data is encrypted & GDPR compliant</span>
                                    </div>
                                    <div class="flex items-center gap-3"><span
                                            class="material-symbols-outlined text-primary text-[22px]">schedule</span><span
                                            class="text-sm font-medium">Account review takes 24-48 hours</span></div>
                                </div>
                                <label class="flex items-start gap-3 cursor-pointer mb-5">
                                    <input type="checkbox" id="terms-check" class="mt-0.5 accent-[#c6a65d] size-4"
                                        required />
                                    <span class="text-sm text-text-muted">I agree to the <a href="#"
                                            class="text-primary hover:underline">Terms of Service</a> and <a href="#"
                                            class="text-primary hover:underline">Privacy Policy</a>. I confirm that all
                                        information provided
                                        is accurate.</span>
                                </label>
                                <div class="flex gap-3">
                                    <button type="button" onclick="goStep(2)"
                                        class="flex-1 py-3.5 rounded-xl border border-border-subtle text-sm font-semibold hover:bg-gray-50 transition-colors flex items-center justify-center gap-2"><span
                                            class="material-symbols-outlined text-[20px]">arrow_back</span>Back</button>
                                    <button type="submit"
                                        class="flex-1 bg-primary hover:bg-primary-dark text-white font-bold py-3.5 rounded-xl transition-all shadow-[0_4px_14px_rgba(198,166,93,.35)] flex items-center justify-center gap-2">Create
                                        Account<span class="material-symbols-outlined text-[20px]">check</span></button>
                                </div>
                            </div>

                        </form>

                        <p class="text-center text-sm text-text-muted mt-6">Already have an account? <a href="login.jsp"
                                class="font-semibold text-primary hover:text-primary-dark">Sign In</a></p>
        </div>

        <script>
            let curStep = 1;
            function goStep(n) {
                // Validate step 2 fields before proceeding to step 3
                if (n === 3) {
                    const fn = document.getElementById('firstName').value.trim();
                    const ln = document.getElementById('lastName').value.trim();
                    const em = document.getElementById('email').value.trim();
                    const pw = document.getElementById('password').value;
                    if (!fn || !ln || !em || !pw) {
                        alert('Please fill in all required fields before continuing.');
                        return;
                    }
                    if (pw.length < 6) {
                        alert('Password must be at least 6 characters.');
                        return;
                    }
                }
                document.getElementById('step-' + curStep).classList.remove('active');
                document.getElementById('step-' + n).classList.add('active');
                document.querySelectorAll('.step-dot').forEach(d => {
                    const s = parseInt(d.dataset.step);
                    if (s < n) { d.classList.remove('bg-bg-cream', 'text-text-muted'); d.classList.add('bg-primary', 'text-white'); d.textContent = '\u2713'; }
                    else if (s === n) { d.classList.remove('bg-bg-cream', 'text-text-muted'); d.classList.add('bg-primary', 'text-white'); d.textContent = s; }
                    else { d.classList.add('bg-bg-cream', 'text-text-muted'); d.classList.remove('bg-primary', 'text-white'); d.textContent = s; }
                });
                if (n > 1) document.getElementById('line-1').style.background = '#c6a65d';
                if (n > 2) document.getElementById('line-2').style.background = '#c6a65d';
                if (n < 2) document.getElementById('line-1').style.background = '';
                if (n < 3) document.getElementById('line-2').style.background = '';
                curStep = n;
            }
            function submitForm() {
                if (!document.getElementById('terms-check').checked) {
                    alert('Please agree to the Terms of Service and Privacy Policy.');
                    return;
                }
                document.getElementById('register-form').submit();
            }
        </script>
    </body>

    </html>
