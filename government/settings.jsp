<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% if (session.getAttribute("user_id")==null) { response.sendRedirect(request.getContextPath() + "/login.jsp" );
        return; } int userId=(int) session.getAttribute("user_id"); String userName=(String)
        session.getAttribute("user_name"); if (userName==null) userName="Government Official" ; %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
            <title>Investify - Settings</title>
            <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
            <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@400;500;700;900&display=swap"
                rel="stylesheet" />
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                rel="stylesheet" />
            <script>
                tailwind.config = {
                    darkMode: "class",
                    theme: {
                        extend: {
                            colors: {
                                "primary": "#c6a65d",
                                "background-light": "#f8f7f6",
                                "background-dark": "#1e1b14",
                                "surface-light": "#ffffff",
                                "surface-dark": "#2c2820",
                                "text-main-light": "#161512",
                                "text-main-dark": "#e8e6e3",
                                "text-sec-light": "#817a6a",
                                "text-sec-dark": "#b0aa9e",
                            },
                            fontFamily: {
                                "display": ["Public Sans", "sans-serif"]
                            },
                            borderRadius: {
                                "DEFAULT": "1rem",
                                "lg": "2rem",
                                "xl": "3rem",
                                "full": "9999px"
                            },
                        },
                    },
                }
            </script>
        </head>

        <body class="bg-background-light dark:bg-background-dark font-display antialiased min-h-screen flex flex-col">
            <!-- Top Navigation -->
            <header
                class="sticky top-0 z-50 flex items-center justify-between border-b border-gray-200 dark:border-gray-800 bg-surface-light/95 dark:bg-surface-dark/95 backdrop-blur-md px-6 lg:px-10 py-3.5">
                <div class="flex items-center gap-6"><a href="../index.jsp" class="flex items-center gap-3">
                        <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                                class="material-symbols-outlined text-xl">diamond</span></div><span
                            class="text-lg font-bold text-text-main-light dark:text-text-main-dark">Investify</span>
                    </a><span
                        class="hidden md:block text-xs font-bold uppercase tracking-widest text-blue-700 bg-blue-50 rounded-full px-3 py-1">Government
                        Portal</span></div>
                <nav class="hidden lg:flex items-center gap-6">
				<a href="dashboard.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Dashboard</a>
				<a href="schemes.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Schemes</a>
				<a href="applications.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Applications</a>
				<a href="grants.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Grants</a>
				<a href="reports.jsp" class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Reports</a>
			</nav>
                <div class="flex items-center gap-4">
                    <a href="settings.jsp">
                        <img src="https://i.pravatar.cc/36?img=60"
                            class="h-9 w-9 rounded-full ring-2 ring-transparent hover:ring-primary transition-all cursor-pointer object-cover"
                            alt="Gov official" />
                    </a>
                </div>
            </header>
            <!-- Main Content Area -->
            <main class="flex-grow flex justify-center py-8 px-4 sm:px-6 lg:px-8">
                <div class="w-full max-w-[960px] flex flex-col gap-8">
                    <!-- Page Header -->
                    <div class="flex flex-col gap-3 pb-2 border-b border-gray-200 dark:border-gray-800">
                        <h1
                            class="text-text-main-light dark:text-text-main-dark text-4xl font-black leading-tight tracking-[-0.033em]">
                            Settings</h1>
                        <p class="text-text-sec-light dark:text-text-sec-dark text-base font-normal">Manage your
                            profile, account preferences and appearance.</p>
                    </div>
                    <!-- Tabs Navigation -->
                    <div class="w-full overflow-x-auto pb-2 -mb-2 no-scrollbar">
                        <nav class="flex gap-8 min-w-max border-b border-gray-200 dark:border-gray-800">
                            <a class="pb-3 px-1 border-b-[3px] border-primary text-text-main-light dark:text-text-main-dark text-sm font-bold tracking-wide"
                                href="#">Profile</a>
                            <a class="pb-3 px-1 border-b-[3px] border-transparent text-text-sec-light dark:text-text-sec-dark hover:text-primary transition-colors text-sm font-bold tracking-wide"
                                href="#">Security</a>
                            <a class="pb-3 px-1 border-b-[3px] border-transparent text-text-sec-light dark:text-text-sec-dark hover:text-primary transition-colors text-sm font-bold tracking-wide"
                                href="#">Notifications</a>
                            <a class="pb-3 px-1 border-b-[3px] border-transparent text-text-sec-light dark:text-text-sec-dark hover:text-primary transition-colors text-sm font-bold tracking-wide"
                                href="#">Appearance</a>
                            <a class="pb-3 px-1 border-b-[3px] border-transparent text-text-sec-light dark:text-text-sec-dark hover:text-primary transition-colors text-sm font-bold tracking-wide"
                                href="#">Billing</a>
                        </nav>
                    </div>
                    <!-- Content Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                        <!-- Left Column: User Card -->
                        <div class="md:col-span-1">
                            <div
                                class="bg-surface-light dark:bg-surface-dark rounded-xl p-6 shadow-sm border border-gray-100 dark:border-gray-800 flex flex-col items-center text-center">
                                <div class="relative mb-4 group cursor-pointer">
                                    <div class="w-24 h-24 rounded-full bg-cover bg-center border-4 border-background-light dark:border-background-dark shadow-md"
                                        style='background-image: url("https://i.pravatar.cc/150?img=60");'></div>
                                    <div
                                        class="absolute bottom-0 right-0 bg-primary text-white p-1.5 rounded-full shadow-lg hover:bg-primary/90 transition-colors">
                                        <span class="material-symbols-outlined text-[16px] block">edit</span>
                                    </div>
                                </div>
                                <h3 class="text-text-main-light dark:text-text-main-dark text-xl font-bold mb-1">
                                    <%= userName %>
                                </h3>
                                <span
                                    class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider">
                                    <span class="material-symbols-outlined text-[14px]">verified</span>
                                    Government Official
                                </span>
                            </div>
                            <!-- Quick Links -->
                            <div class="mt-6 flex flex-col gap-2">
                                <a class="flex items-center justify-between p-3 rounded-lg hover:bg-surface-light dark:hover:bg-surface-dark group transition-colors"
                                    href="#">
                                    <div class="flex items-center gap-3">
                                        <div
                                            class="size-8 rounded-full bg-blue-50 dark:bg-blue-900/20 flex items-center justify-center text-blue-600 dark:text-blue-400">
                                            <span class="material-symbols-outlined text-[18px]">lock</span>
                                        </div>
                                        <span
                                            class="text-text-main-light dark:text-text-main-dark font-medium text-sm">Login
                                            &amp; Security</span>
                                    </div>
                                    <span
                                        class="material-symbols-outlined text-text-sec-light text-[18px] group-hover:translate-x-1 transition-transform">chevron_right</span>
                                </a>
                                <a class="flex items-center justify-between p-3 rounded-lg flex-row cursor-pointer group transition-colors hover:bg-red-50 dark:hover:bg-red-900/20"
                                    href="<%= request.getContextPath() %>/logout">
                                    <div class="flex items-center gap-3">
                                        <div
                                            class="size-8 rounded-full bg-red-50 dark:bg-red-900/20 flex items-center justify-center text-red-600 dark:text-red-400">
                                            <span class="material-symbols-outlined text-[18px]">logout</span>
                                        </div>
                                        <span class="text-red-600 dark:text-red-400 font-medium text-sm">Logout</span>
                                    </div>
                                </a>
                            </div>
                        </div>
                        <!-- Right Column: Settings Form -->
                        <div class="md:col-span-2 space-y-6">
                            <!-- Theme Preferences -->
                            <div
                                class="bg-surface-light dark:bg-surface-dark rounded-xl border border-gray-100 dark:border-gray-800 overflow-hidden">
                                <div class="p-6 border-b border-gray-100 dark:border-gray-800">
                                    <h2 class="text-xl font-bold text-text-main-light dark:text-text-main-dark mb-1">
                                        Theme Preferences</h2>
                                    <p class="text-text-sec-light dark:text-text-sec-dark text-sm">Customize how
                                        Investify looks on your device.</p>
                                </div>
                                <div class="p-6 grid grid-cols-1 sm:grid-cols-3 gap-4">
                                    <!-- Light Mode Option -->
                                    <label class="relative cursor-pointer group">
                                        <input class="peer sr-only" name="theme" type="radio" value="light" checked />
                                        <div
                                            class="flex flex-col gap-3 p-4 rounded-xl border-2 border-gray-200 dark:border-gray-700 peer-checked:border-primary peer-checked:bg-primary/5 transition-all h-full">
                                            <div
                                                class="w-full aspect-video rounded-lg bg-gray-100 border border-gray-200 overflow-hidden relative">
                                                <!-- Abstract representation of light UI -->
                                                <div class="absolute top-2 left-2 w-16 h-2 bg-white rounded-full"></div>
                                                <div class="absolute top-6 left-2 w-8 h-8 bg-white rounded-full"></div>
                                                <div class="absolute top-6 left-12 right-2 h-20 bg-white rounded-lg">
                                                </div>
                                            </div>
                                            <div class="flex items-center justify-between">
                                                <span
                                                    class="font-bold text-text-main-light dark:text-text-main-dark">Light
                                                    Mode</span>
                                                <div
                                                    class="size-5 rounded-full border border-gray-300 peer-checked:border-primary peer-checked:bg-primary flex items-center justify-center text-white">
                                                    <span
                                                        class="material-symbols-outlined text-[14px] opacity-0 peer-checked:opacity-100">check</span>
                                                </div>
                                            </div>
                                        </div>
                                    </label>
                                    <!-- Dark Mode Option -->
                                    <label class="relative cursor-pointer group">
                                        <input class="peer sr-only" name="theme" type="radio" value="dark" />
                                        <div
                                            class="flex flex-col gap-3 p-4 rounded-xl border-2 border-gray-200 dark:border-gray-700 peer-checked:border-primary peer-checked:bg-primary/5 transition-all h-full">
                                            <div
                                                class="w-full aspect-video rounded-lg bg-gray-800 border border-gray-700 overflow-hidden relative">
                                                <!-- Abstract representation of dark UI -->
                                                <div class="absolute top-2 left-2 w-16 h-2 bg-gray-600 rounded-full">
                                                </div>
                                                <div class="absolute top-6 left-2 w-8 h-8 bg-gray-600 rounded-full">
                                                </div>
                                                <div class="absolute top-6 left-12 right-2 h-20 bg-gray-600 rounded-lg">
                                                </div>
                                            </div>
                                            <div class="flex items-center justify-between">
                                                <span
                                                    class="font-bold text-text-main-light dark:text-text-main-dark">Dark
                                                    Mode</span>
                                                <div
                                                    class="size-5 rounded-full border border-gray-300 dark:border-gray-600 peer-checked:border-primary peer-checked:bg-primary flex items-center justify-center text-white">
                                                    <span
                                                        class="material-symbols-outlined text-[14px] opacity-0 peer-checked:opacity-100">check</span>
                                                </div>
                                            </div>
                                        </div>
                                    </label>
                                    <!-- System Option -->
                                    <label class="relative cursor-pointer group">
                                        <input class="peer sr-only" name="theme" type="radio" value="system" />
                                        <div
                                            class="flex flex-col gap-3 p-4 rounded-xl border-2 border-gray-200 dark:border-gray-700 peer-checked:border-primary peer-checked:bg-primary/5 transition-all h-full">
                                            <div
                                                class="w-full aspect-video rounded-lg bg-gradient-to-br from-gray-100 to-gray-800 border border-gray-200 dark:border-gray-700 overflow-hidden relative flex items-center justify-center">
                                                <span
                                                    class="material-symbols-outlined text-gray-400 text-3xl">settings_brightness</span>
                                            </div>
                                            <div class="flex items-center justify-between">
                                                <span
                                                    class="font-bold text-text-main-light dark:text-text-main-dark">System</span>
                                                <div
                                                    class="size-5 rounded-full border border-gray-300 dark:border-gray-600 peer-checked:border-primary peer-checked:bg-primary flex items-center justify-center text-white">
                                                    <span
                                                        class="material-symbols-outlined text-[14px] opacity-0 peer-checked:opacity-100">check</span>
                                                </div>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </div>
                            <!-- Interface Settings -->
                            <div
                                class="bg-surface-light dark:bg-surface-dark rounded-xl border border-gray-100 dark:border-gray-800 overflow-hidden">
                                <div class="p-6 border-b border-gray-100 dark:border-gray-800">
                                    <h2 class="text-xl font-bold text-text-main-light dark:text-text-main-dark mb-1">
                                        Interface Settings</h2>
                                    <p class="text-text-sec-light dark:text-text-sec-dark text-sm">Fine tune your
                                        dashboard experience.</p>
                                </div>
                                <div class="divide-y divide-gray-100 dark:divide-gray-800">
                                    <!-- Toggle Item -->
                                    <div
                                        class="p-5 flex items-center justify-between hover:bg-background-light dark:hover:bg-background-dark/50 transition-colors">
                                        <div class="flex flex-col">
                                            <span
                                                class="text-text-main-light dark:text-text-main-dark font-medium">Compact
                                                Mode</span>
                                            <span
                                                class="text-text-sec-light dark:text-text-sec-dark text-sm mt-1">Reduce
                                                spacing to view more data on screen</span>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input class="sr-only peer" type="checkbox" value="" />
                                            <div
                                                class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary">
                                            </div>
                                        </label>
                                    </div>
                                    <!-- Toggle Item -->
                                    <div
                                        class="p-5 flex items-center justify-between hover:bg-background-light dark:hover:bg-background-dark/50 transition-colors">
                                        <div class="flex flex-col">
                                            <span class="text-text-main-light dark:text-text-main-dark font-medium">Show
                                                Portfolio Balance</span>
                                            <span class="text-text-sec-light dark:text-text-sec-dark text-sm mt-1">Hide
                                                your balance on the dashboard for privacy</span>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input checked="" class="sr-only peer" type="checkbox" value="" />
                                            <div
                                                class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary">
                                            </div>
                                        </label>
                                    </div>
                                    <!-- Toggle Item -->
                                    <div
                                        class="p-5 flex items-center justify-between hover:bg-background-light dark:hover:bg-background-dark/50 transition-colors">
                                        <div class="flex flex-col">
                                            <span
                                                class="text-text-main-light dark:text-text-main-dark font-medium">Real-time
                                                Animations</span>
                                            <span
                                                class="text-text-sec-light dark:text-text-sec-dark text-sm mt-1">Enable
                                                chart animations and live ticker updates</span>
                                        </div>
                                        <label class="relative inline-flex items-center cursor-pointer">
                                            <input checked="" class="sr-only peer" type="checkbox" value="" />
                                            <div
                                                class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary">
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <!-- Save Changes Actions -->
                            <div class="flex justify-end pt-4 pb-12">
                                <button
                                    class="px-6 py-2 rounded-full text-text-sec-light dark:text-text-sec-dark font-bold hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors mr-3">Cancel</button>
                                <button
                                    class="px-8 py-2 rounded-full bg-primary hover:bg-primary/90 text-white font-bold shadow-lg shadow-primary/20 transition-all transform active:scale-95">Save
                                    Changes</button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </body>

        </html>
