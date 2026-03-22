<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user_id") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("user_name");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Investify – Settings</title>
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

        .toggle-track {
            width: 44px;
            height: 24px;
            border-radius: 9999px;
            background: #ddd;
            position: relative;
            transition: .2s;
            cursor: pointer
        }

        .toggle-track.on {
            background: #c6a65d
        }

        .toggle-thumb {
            position: absolute;
            top: 2px;
            left: 2px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #fff;
            transition: .2s;
            box-shadow: 0 1px 4px rgba(0, 0, 0, .15)
        }

        .toggle-track.on .toggle-thumb {
            left: 22px
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
            <a href="settings.jsp" class="text-sm font-semibold text-primary">Settings</a>
        </nav>
        <a href="settings.jsp"><img src="https://i.pravatar.cc/36?img=25"
                class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                alt="Founder" /></a>
    </header>
    <main class="max-w-3xl mx-auto px-6 py-8 flex flex-col gap-6">
        <div>
            <h1 class="text-3xl font-black">Settings</h1>
            <p class="text-text-muted mt-1">Manage your account preferences and security.</p>
        </div>

        <!-- Notifications Settings -->
        <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6">
            <h2 class="text-lg font-bold mb-5">Notification Preferences</h2>
            <div class="space-y-4">
                <div class="flex items-center justify-between py-3 border-b border-border-c">
                    <div>
                        <p class="font-semibold text-sm">Investor Updates</p>
                        <p class="text-xs text-text-muted">Get notified when new investors show interest</p>
                    </div>
                    <div class="toggle-track on" onclick="this.classList.toggle('on')">
                        <div class="toggle-thumb"></div>
                    </div>
                </div>
                <div class="flex items-center justify-between py-3 border-b border-border-c">
                    <div>
                        <p class="font-semibold text-sm">Application Status</p>
                        <p class="text-xs text-text-muted">Notifications on your startup profile review process</p>
                    </div>
                    <div class="toggle-track on" onclick="this.classList.toggle('on')">
                        <div class="toggle-thumb"></div>
                    </div>
                </div>
                <div class="flex items-center justify-between py-3 border-b border-border-c">
                    <div>
                        <p class="font-semibold text-sm">Investor Messages</p>
                        <p class="text-xs text-text-muted">Notify me when investors send a message</p>
                    </div>
                    <div class="toggle-track on" onclick="this.classList.toggle('on')">
                        <div class="toggle-thumb"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Appearance -->
        <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6">
            <h2 class="text-lg font-bold mb-5">Appearance</h2>
            <div class="grid grid-cols-3 gap-3">
                <label class="relative cursor-pointer">
                    <input type="radio" name="theme" value="light" class="peer sr-only" checked />
                    <div
                        class="p-4 rounded-xl border border-border-c peer-checked:border-primary peer-checked:ring-1 peer-checked:ring-primary transition-all text-center bg-white">
                        <span class="material-symbols-outlined text-[28px] mb-1 block text-text-main">light_mode</span>
                        <span class="text-xs font-semibold">Light</span>
                    </div>
                </label>
                <label class="relative cursor-pointer">
                    <input type="radio" name="theme" value="dark" class="peer sr-only" />
                    <div
                        class="p-4 rounded-xl border border-border-c peer-checked:border-primary peer-checked:ring-1 peer-checked:ring-primary transition-all text-center bg-gray-900">
                        <span class="material-symbols-outlined text-[28px] mb-1 block text-white">dark_mode</span>
                        <span class="text-xs font-semibold text-white">Dark</span>
                    </div>
                </label>
                <label class="relative cursor-pointer">
                    <input type="radio" name="theme" value="system" class="peer sr-only" />
                    <div
                        class="p-4 rounded-xl border border-border-c peer-checked:border-primary peer-checked:ring-1 peer-checked:ring-primary transition-all text-center">
                        <span class="material-symbols-outlined text-[28px] mb-1 block text-text-muted">computer</span>
                        <span class="text-xs font-semibold">System</span>
                    </div>
                </label>
            </div>
        </div>

        <!-- Security -->
        <div class="bg-surface rounded-2xl border border-border-c shadow-sm p-6">
            <h2 class="text-lg font-bold mb-5">Security</h2>
            <div class="space-y-3">
                <div class="flex items-center justify-between py-2">
                    <div>
                        <p class="font-semibold text-sm">Two-Factor Authentication</p>
                        <p class="text-xs text-text-muted">Secure your account with 2FA</p>
                    </div>
                    <button
                        class="h-9 px-4 rounded-full bg-primary/10 text-primary text-sm font-bold hover:bg-primary hover:text-white transition-colors">Enable
                        2FA</button>
                </div>
                <div class="flex items-center justify-between py-2 border-t border-border-c">
                    <div>
                        <p class="font-semibold text-sm">Change Password</p>
                        <p class="text-xs text-text-muted">Last changed 45 days ago</p>
                    </div>
                    <button
                        class="h-9 px-4 rounded-full border border-border-c text-sm font-semibold hover:bg-bg-light transition-colors">Update</button>
                </div>
                <div class="flex items-center justify-between py-2 border-t border-border-c">
                    <div>
                        <p class="font-semibold text-sm">Login Sessions</p>
                        <p class="text-xs text-text-muted">2 active sessions</p>
                    </div>
                    <button
                        class="h-9 px-4 rounded-full border border-red-200 text-red-600 text-sm font-semibold hover:bg-red-50 transition-colors">Sign
                        Out All</button>
                </div>
            </div>
        </div>

        <!-- Danger Zone -->
        <div class="bg-surface rounded-2xl border border-red-200 shadow-sm p-6">
            <h2 class="text-lg font-bold text-red-600 mb-2">Danger Zone</h2>
            <p class="text-sm text-text-muted mb-4">These actions are irreversible. Proceed with caution.</p>
            <div class="flex flex-wrap gap-3">
                <button
                    class="h-9 px-5 rounded-full border border-red-200 text-red-600 text-sm font-semibold hover:bg-red-50 transition-colors">Deactivate
                    Account</button>
                <a href="../login.jsp"
                    class="h-9 px-5 rounded-full bg-red-600 text-white text-sm font-bold hover:bg-red-700 transition-colors flex items-center">Sign
                    Out</a>
            </div>
        </div>
    </main>
</body>

</html>
