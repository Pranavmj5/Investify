<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Investify – Login</title>
        <meta name="description" content="Sign in to your Investify account." />
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
        </style>
    </head>

    <body class="font-display text-text-main min-h-screen flex flex-col items-center justify-center p-4 antialiased">
        <!-- Logo bar -->
        <a href="index.jsp" class="flex items-center gap-3 mb-8">
            <div
                class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary text-white shadow-[0_4px_12px_rgba(198,166,93,.4)]">
                <span class="material-symbols-outlined text-xl">diamond</span>
            </div>
            <span class="text-xl font-bold">Investify</span>
        </a>

        <div
            class="w-full max-w-md bg-white rounded-2xl shadow-[0_8px_40px_rgba(0,0,0,.07)] border border-border-subtle overflow-hidden">
            <!-- Hero image -->
            <div class="relative h-44 w-full overflow-hidden">
                <div class="absolute inset-0 bg-cover bg-center opacity-80"
                    style="background-image:linear-gradient(180deg,rgba(0,0,0,0) 0%,rgba(0,0,0,.5) 100%),url('https://lh3.googleusercontent.com/aida-public/AB6AXuCl2ZeQQZFRzYb3w3pFZlNciITWnQKH_fs5cCRFYNhksoluE9dLcJUrxGjDja035WDqYNUw3N_mGtV-QykyBPpXD4KYi8yhkJDONXCXFbKEBvGVzUM-rjjtBHQxd0YWnIbbmcfmT_PdqkhfHhY-YYgc_g4-l88FnubjzNP1vKRQhAecBRqDMNRNuD3bzbZo9gmda4fqYOnEh_KqTd-jbG6YFlT0ojAldjYkFPscXocqbQrORrlOOZp4gpu-J5ftxe4255e8lTHuMr3z')">
                </div>
                <div class="absolute bottom-5 left-6">
                    <p class="text-white text-2xl font-black tracking-tight">Investify</p>
                    <p class="text-white/80 text-sm">Premium Investment Portal</p>
                </div>
            </div>

            <div class="px-8 py-8">
                <h1 class="text-2xl font-bold text-center mb-6">Welcome Back</h1>

                <%-- Success message after registration --%>
                    <% if ("true".equals(request.getParameter("registered"))) { %>
                        <p
                            class="text-xs text-emerald-700 bg-emerald-50 border border-emerald-200 rounded-lg px-3 py-2 mb-4 text-center">
                            Account created successfully! Please sign in.
                        </p>
                        <% } %>

                            <form id="login-form" class="flex flex-col gap-5" action="login" method="POST">
                                <!-- Role selection -->
                                <div class="grid grid-cols-2 gap-3">
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="role" value="investor" class="peer sr-only" checked />
                                        <div
                                            class="flex flex-col p-3.5 rounded-xl border border-border-subtle bg-white hover:border-primary/50 peer-checked:border-primary peer-checked:bg-primary/5 peer-checked:ring-1 peer-checked:ring-primary transition-all">
                                            <span class="text-sm font-semibold mb-0.5">Investor</span>
                                            <span class="text-xs text-text-muted">Invest capital</span>
                                        </div>
                                        <span
                                            class="material-symbols-outlined absolute top-3 right-3 text-primary text-[18px] opacity-0 peer-checked:opacity-100 transition-opacity">check_circle</span>
                                    </label>
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="role" value="founder" class="peer sr-only" />
                                        <div
                                            class="flex flex-col p-3.5 rounded-xl border border-border-subtle bg-white hover:border-primary/50 peer-checked:border-primary peer-checked:bg-primary/5 peer-checked:ring-1 peer-checked:ring-primary transition-all">
                                            <span class="text-sm font-semibold mb-0.5">Founder</span>
                                            <span class="text-xs text-text-muted">Raise funds</span>
                                        </div>
                                        <span
                                            class="material-symbols-outlined absolute top-3 right-3 text-primary text-[18px] opacity-0 peer-checked:opacity-100 transition-opacity">check_circle</span>
                                    </label>
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="role" value="government" class="peer sr-only" />
                                        <div
                                            class="flex flex-col p-3.5 rounded-xl border border-border-subtle bg-white hover:border-primary/50 peer-checked:border-primary peer-checked:bg-primary/5 peer-checked:ring-1 peer-checked:ring-primary transition-all">
                                            <span class="text-sm font-semibold mb-0.5">Government</span>
                                            <span class="text-xs text-text-muted">Manage schemes</span>
                                        </div>
                                        <span
                                            class="material-symbols-outlined absolute top-3 right-3 text-primary text-[18px] opacity-0 peer-checked:opacity-100 transition-opacity">check_circle</span>
                                    </label>
                                    <label class="relative cursor-pointer">
                                        <input type="radio" name="role" value="admin" class="peer sr-only" />
                                        <div
                                            class="flex flex-col p-3.5 rounded-xl border border-border-subtle bg-white hover:border-primary/50 peer-checked:border-primary peer-checked:bg-primary/5 peer-checked:ring-1 peer-checked:ring-primary transition-all">
                                            <span class="text-sm font-semibold mb-0.5">Admin</span>
                                            <span class="text-xs text-text-muted">Platform control</span>
                                        </div>
                                        <span
                                            class="material-symbols-outlined absolute top-3 right-3 text-primary text-[18px] opacity-0 peer-checked:opacity-100 transition-opacity">check_circle</span>
                                    </label>
                                </div>

                                <!-- Email -->
                                <div>
                                    <label class="block text-sm font-semibold mb-1.5" for="email">Email Address</label>
                                    <div class="relative">
                                        <span
                                            class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-text-muted text-[20px]">mail</span>
                                        <input id="email" name="email" type="email" placeholder="Enter your email"
                                            required
                                            class="w-full pl-10 pr-4 py-3 rounded-xl border border-border-subtle bg-bg-cream/50 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors placeholder:text-text-muted" />
                                    </div>
                                </div>

                                <!-- Password -->
                                <div>
                                    <div class="flex justify-between mb-1.5">
                                        <label class="text-sm font-semibold" for="password">Password</label>
                                        <a href="#"
                                            class="text-xs text-text-muted hover:text-primary transition-colors">Forgot
                                            password?</a>
                                    </div>
                                    <div class="relative">
                                        <span
                                            class="material-symbols-outlined absolute left-3.5 top-1/2 -translate-y-1/2 text-text-muted text-[20px]">lock</span>
                                        <input id="password" name="password" type="password"
                                            placeholder="Enter your password" required
                                            class="w-full pl-10 pr-10 py-3 rounded-xl border border-border-subtle bg-bg-cream/50 text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors placeholder:text-text-muted" />
                                        <button type="button" onclick="togglePwd()"
                                            class="absolute right-3.5 top-1/2 -translate-y-1/2 text-text-muted hover:text-primary transition-colors">
                                            <span class="material-symbols-outlined text-[20px]"
                                                id="pwd-eye">visibility_off</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- Remember me -->
                                <label class="flex items-center gap-3 cursor-pointer select-none">
                                    <div class="relative">
                                        <input type="checkbox" id="remember" class="peer sr-only" />
                                        <div
                                            class="w-10 h-6 bg-gray-200 rounded-full peer-checked:bg-primary transition-colors after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-4">
                                        </div>
                                    </div>
                                    <span class="text-sm text-text-muted">Remember me for 30 days</span>
                                </label>

                                <!-- Error msg -->
                                <% String error=(String) request.getAttribute("error"); if (error==null)
                                    error=request.getParameter("error"); if (error !=null && !error.isEmpty()) { %>
                                    <p
                                        class="text-xs text-red-600 bg-red-50 border border-red-200 rounded-lg px-3 py-2">
                                        <%= error %>
                                    </p>
                                    <% } %>

                                        <!-- Submit -->
                                        <button type="submit" id="submit-btn"
                                            class="w-full bg-primary hover:bg-primary-dark text-white font-bold py-3.5 rounded-xl transition-all shadow-[0_4px_14px_0_rgba(198,166,93,.4)] hover:shadow-[0_6px_20px_rgba(198,166,93,.3)] hover:-translate-y-0.5 flex items-center justify-center gap-2">
                                            <span id="btn-text">Sign In</span>
                                            <span class="material-symbols-outlined text-[20px]">arrow_forward</span>
                                        </button>
                            </form>

                            <p class="text-center text-sm text-text-muted mt-6">
                                Don't have an account?
                                <a href="register.jsp"
                                    class="font-semibold text-primary hover:text-primary-dark ml-1">Create
                                    Account</a>
                            </p>
            </div>
        </div>
        <p class="text-xs text-text-muted mt-6 text-center">© 2024 Investify Platforms Inc. · <a href="#"
                class="hover:text-primary">Terms</a> · <a href="#" class="hover:text-primary">Privacy</a></p>

        <script>
            function togglePwd() {
                const i = document.getElementById('password');
                const e = document.getElementById('pwd-eye');
                if (i.type === 'password') { i.type = 'text'; e.textContent = 'visibility'; }
                else { i.type = 'password'; e.textContent = 'visibility_off'; }
            }
        </script>
    </body>

    </html>
