<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Investify – Invest in the Future of Innovation</title>
    <meta name="description"
        content="Access premium startup investment opportunities vetted by experts on Investify." />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700;800;900&display=swap"
        rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
        rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { primary: "#c6a65d", "primary-dark": "#b09045", "bg-cream": "#f4efe8", "text-main": "#1e1b14", "text-muted": "#817a6a", "border-subtle": "#e6e1d6" },
                    fontFamily: { display: ["Public Sans", "sans-serif"] },
                    borderRadius: { DEFAULT: "1rem", lg: "1.5rem", xl: "2rem", full: "9999px" },
                    boxShadow: { soft: "0 4px 20px -2px rgba(198,166,93,.15)", card: "0 10px 40px -10px rgba(0,0,0,.07)" }
                }
            }
        };
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24
        }

        @keyframes float {

            0%,
            100% {
                transform: translateY(0)
            }

            50% {
                transform: translateY(-12px)
            }
        }

        .float {
            animation: float 4s ease-in-out infinite
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(24px)
            }

            to {
                opacity: 1;
                transform: translateY(0)
            }
        }

        .fade-up {
            animation: fadeUp .7s ease forwards
        }

        .stagger-1 {
            animation-delay: .1s
        }

        .stagger-2 {
            animation-delay: .2s
        }

        .stagger-3 {
            animation-delay: .3s
        }

        .hero-bg {
            background: radial-gradient(ellipse 80% 60% at 70% 40%, rgba(198, 166, 93, .13) 0%, transparent 70%), radial-gradient(ellipse 50% 40% at 10% 60%, rgba(220, 211, 195, .25) 0%, transparent 60%), #f4efe8
        }

        .gradient-text {
            background: linear-gradient(135deg, #c6a65d, #e8c87a);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text
        }

        .feature-card {
            transition: transform .3s, box-shadow .3s
        }

        .feature-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 40px -8px rgba(198, 166, 93, .2)
        }

        /* Mobile menu */
        #mobile-menu {
            transition: max-height .3s ease, opacity .3s ease;
            overflow: hidden;
            max-height: 0;
            opacity: 0
        }

        #mobile-menu.open {
            max-height: 400px;
            opacity: 1
        }
    </style>
</head>

<body class="font-display text-text-main antialiased overflow-x-hidden">

    <!-- ═══ NAVBAR ═══ -->
    <header class="sticky top-0 z-50 w-full backdrop-blur-md bg-bg-cream/90 border-b border-border-subtle">
        <div class="mx-auto flex h-20 max-w-6xl items-center justify-between px-6">
            <a href="index.jsp" class="flex items-center gap-3">
                <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary text-white shadow-soft">
                    <span class="material-symbols-outlined text-xl">diamond</span>
                </div>
                <span class="text-xl font-bold tracking-tight">Investify</span>
            </a>
            <nav class="hidden md:flex items-center gap-8">
                <a href="#how-it-works"
                    class="text-sm font-medium text-text-muted hover:text-primary transition-colors">How it Works</a>
                <a href="login.jsp"
                    class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Startups</a>
                <a href="#for-investors"
                    class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Investors</a>
                <a href="#for-founders"
                    class="text-sm font-medium text-text-muted hover:text-primary transition-colors">Founders</a>
            </nav>
            <div class="hidden md:flex items-center gap-3">
                <a href="login.jsp"
                    class="h-10 px-6 rounded-full text-sm font-semibold text-text-main hover:bg-black/5 transition-colors flex items-center">Login</a>
                <a href="register.jsp"
                    class="h-10 px-6 rounded-full bg-primary text-white text-sm font-bold shadow-soft hover:bg-primary-dark transition-colors flex items-center">Register</a>
            </div>
            <!-- Mobile menu button -->
            <button id="menu-btn" class="md:hidden p-2 text-text-muted hover:text-primary transition-colors"
                onclick="toggleMenu()">
                <span class="material-symbols-outlined" id="menu-icon">menu</span>
            </button>
        </div>
        <!-- Mobile menu -->
        <div id="mobile-menu" class="md:hidden bg-bg-cream border-t border-border-subtle px-6 py-4 space-y-3">
            <a href="#how-it-works" class="block text-sm font-medium text-text-muted hover:text-primary py-2">How it
                Works</a>
            <a href="login.jsp" class="block text-sm font-medium text-text-muted hover:text-primary py-2">Startups</a>
            <a href="login.jsp" class="block text-sm font-semibold text-text-main py-2">Login</a>
            <a href="register.jsp"
                class="block w-full text-center rounded-full bg-primary text-white text-sm font-bold py-2.5 mt-2">Register</a>
        </div>
    </header>

    <!-- ═══ HERO ═══ -->
    <section class="hero-bg relative min-h-[90vh] flex items-center px-6 py-16 overflow-hidden">
        <div
            class="absolute -top-40 -right-40 w-[700px] h-[700px] bg-primary/8 rounded-full blur-3xl pointer-events-none">
        </div>
        <div class="mx-auto max-w-6xl w-full relative z-10 grid lg:grid-cols-2 gap-14 items-center">
            <!-- Left text -->
            <div class="flex flex-col gap-7 fade-up">
                <div
                    class="inline-flex items-center gap-2 bg-primary/10 text-primary-dark rounded-full px-4 py-1.5 text-xs font-bold uppercase tracking-wider w-fit">
                    <span class="material-symbols-outlined text-[16px]">verified</span>
                    Government-Backed & Vetted Platform
                </div>
                <h1 class="text-5xl lg:text-6xl font-black leading-[1.05] tracking-tight">
                    Invest in the <br />
                    <span class="gradient-text">Future of Innovation</span>
                </h1>
                <p class="text-lg text-text-muted leading-relaxed max-w-lg">
                    Access premium startup opportunities with Investify's curated platform. We bridge the gap between
                    visionary founders and sophisticated investors worldwide.
                </p>
                <div class="flex flex-col sm:flex-row gap-4">
                    <a href="register.jsp"
                        class="h-14 px-8 rounded-full bg-primary text-white font-bold text-base shadow-soft hover:bg-primary-dark transition-all hover:scale-[1.02] flex items-center justify-center gap-2">
                        Start Investing
                        <span class="material-symbols-outlined text-[20px]">arrow_forward</span>
                    </a>
                    <a href="login.jsp"
                        class="h-14 px-8 rounded-full bg-white border border-border-subtle text-text-main font-bold text-base hover:bg-gray-50 transition-all flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined text-[20px]">explore</span>
                        Browse Startups
                    </a>
                </div>
                <!-- Stats row -->
                <div class="flex items-center gap-8 pt-4">
                    <div>
                        <p class="text-3xl font-black text-text-main">$500M+</p>
                        <p class="text-xs text-text-muted font-semibold uppercase tracking-wide mt-0.5">Total Invested
                        </p>
                    </div>
                    <div class="w-px h-10 bg-border-subtle"></div>
                    <div>
                        <p class="text-3xl font-black text-text-main">1,200+</p>
                        <p class="text-xs text-text-muted font-semibold uppercase tracking-wide mt-0.5">Startups Listed
                        </p>
                    </div>
                    <div class="w-px h-10 bg-border-subtle"></div>
                    <div>
                        <p class="text-3xl font-black text-text-main">8,500+</p>
                        <p class="text-xs text-text-muted font-semibold uppercase tracking-wide mt-0.5">Investors</p>
                    </div>
                </div>
            </div>
            <!-- Right: visual card -->
            <div class="relative fade-up stagger-2 hidden lg:block">
                <div class="relative rounded-2xl overflow-hidden shadow-2xl aspect-[4/3]">
                    <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent z-10"></div>
                    <div class="w-full h-full bg-cover bg-center"
                        style="background-image:url('https://lh3.googleusercontent.com/aida-public/AB6AXuCxKpCtJuDZgboydkGJWa69IPIgGI3jO1p7KJirzubhR5oTKX3tYPb41KAok1jgB9H1AjAwESSYqz0xWIxvJ3gPpeZ9K8qe4aL-54EVxNSWGcTf4Ai2xYLe49L2t0eHQLeRkJ2EVmn26LrB8W9epOjqdse35no0-hrWMSIrzYIxfgv_daf7tn9fSdH-KMZITdcSlH20jk-Wz4l5qQ_M7S2G5aKPpPXai9ubUnTUUoR1upMLnOXmgRb11K6mdiEoWobJ6Mh0tUUXCWEU')">
                    </div>
                    <!-- Floating card -->
                    <div
                        class="absolute bottom-6 left-6 z-20 bg-white/95 backdrop-blur p-4 rounded-xl shadow-lg max-w-[220px] float">
                        <div class="flex items-center gap-2 mb-1.5">
                            <div class="h-7 w-7 rounded-full bg-green-100 flex items-center justify-center">
                                <span class="material-symbols-outlined text-green-600 text-[16px]">trending_up</span>
                            </div>
                            <span class="text-sm font-bold">Trending Now</span>
                        </div>
                        <p class="text-xs text-text-muted leading-relaxed">FinTech Series A rounds oversubscribing at
                            record rates.</p>
                    </div>
                    <!-- Top pill -->
                    <div
                        class="absolute top-5 right-5 z-20 bg-primary text-white rounded-full px-4 py-1.5 text-xs font-bold shadow-soft">
                        320 Gov. Supported
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ═══ FEATURES ═══ -->
    <section id="how-it-works" class="py-24 px-6 bg-white/60">
        <div class="mx-auto max-w-6xl">
            <div class="text-center max-w-2xl mx-auto mb-16 fade-up">
                <span class="text-primary font-bold tracking-widest uppercase text-xs mb-3 block">Why Choose
                    Investify</span>
                <h2 class="text-4xl font-black text-text-main mb-4">Premium Features for<br />Modern Investors</h2>
                <p class="text-lg text-text-muted">Experience a new standard of investment security and access with our
                    proprietary technology.</p>
            </div>
            <div class="grid md:grid-cols-3 gap-8">
                <div class="feature-card bg-white border border-border-subtle rounded-2xl p-8">
                    <div
                        class="w-14 h-14 rounded-2xl bg-primary/10 flex items-center justify-center text-primary mb-6 transition-colors">
                        <span class="material-symbols-outlined text-[28px]">admin_panel_settings</span>
                    </div>
                    <h3 class="text-xl font-bold mb-3">Role-Based Access</h3>
                    <p class="text-text-muted leading-relaxed">Tailored dashboards for investors, founders, government
                        officials and platform admins with full privacy controls.</p>
                </div>
                <div class="feature-card bg-white border border-border-subtle rounded-2xl p-8">
                    <div class="w-14 h-14 rounded-2xl bg-primary/10 flex items-center justify-center text-primary mb-6">
                        <span class="material-symbols-outlined text-[28px]">verified_user</span>
                    </div>
                    <h3 class="text-xl font-bold mb-3">Verification System</h3>
                    <p class="text-text-muted leading-relaxed">Rigorous multi-step vetting with KYC/AML compliance and
                        deep due diligence on every startup listing.</p>
                </div>
                <div class="feature-card bg-white border border-border-subtle rounded-2xl p-8">
                    <div class="w-14 h-14 rounded-2xl bg-primary/10 flex items-center justify-center text-primary mb-6">
                        <span class="material-symbols-outlined text-[28px]">analytics</span>
                    </div>
                    <h3 class="text-xl font-bold mb-3">Risk Score Engine</h3>
                    <p class="text-text-muted leading-relaxed">Advanced analytics providing real-time risk scores based
                        on market volatility, team experience, and traction metrics.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ═══ HOW IT WORKS ═══ -->
    <section id="for-investors" class="py-24 px-6 bg-bg-cream">
        <div class="mx-auto max-w-6xl">
            <div class="text-center mb-16">
                <span class="text-primary font-bold tracking-widest uppercase text-xs block mb-3">Simple Process</span>
                <h2 class="text-4xl font-black">How It Works</h2>
            </div>
            <div class="grid md:grid-cols-4 gap-6">
                <div class="text-center">
                    <div
                        class="w-14 h-14 rounded-full bg-primary text-white flex items-center justify-center text-xl font-black mx-auto mb-5 shadow-soft">
                        1</div>
                    <h4 class="font-bold mb-2">Create Account</h4>
                    <p class="text-sm text-text-muted">Register as an investor or founder and complete your profile
                        verification.</p>
                </div>
                <div class="text-center">
                    <div
                        class="w-14 h-14 rounded-full bg-primary/20 text-primary-dark flex items-center justify-center text-xl font-black mx-auto mb-5">
                        2</div>
                    <h4 class="font-bold mb-2">Browse Startups</h4>
                    <p class="text-sm text-text-muted">Explore curated, government-vetted startups filtered by domain,
                        stage, and risk.</p>
                </div>
                <div class="text-center">
                    <div
                        class="w-14 h-14 rounded-full bg-primary/20 text-primary-dark flex items-center justify-center text-xl font-black mx-auto mb-5">
                        3</div>
                    <h4 class="font-bold mb-2">Express Interest</h4>
                    <p class="text-sm text-text-muted">Send investment interest directly. Our team connects you with
                        founders within 48 hours.</p>
                </div>
                <div class="text-center">
                    <div
                        class="w-14 h-14 rounded-full bg-primary/20 text-primary-dark flex items-center justify-center text-xl font-black mx-auto mb-5">
                        4</div>
                    <h4 class="font-bold mb-2">Track Portfolio</h4>
                    <p class="text-sm text-text-muted">Monitor all investments, returns, and startup updates in your
                        personal dashboard.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ═══ CTA DARK SECTION ═══ -->
    <section class="py-20 px-6">
        <div class="mx-auto max-w-6xl">
            <div class="bg-text-main rounded-3xl overflow-hidden shadow-2xl">
                <div class="grid md:grid-cols-2">
                    <div class="p-12 md:p-16 flex flex-col justify-center">
                        <h2 class="text-3xl md:text-4xl font-black text-white mb-5">Ready to Diversify<br />Your
                            Portfolio?</h2>
                        <p class="text-gray-400 mb-8 leading-relaxed">Join an exclusive community of forward-thinking
                            investors. Access opportunities usually reserved for institutional players.</p>
                        <ul class="space-y-3 mb-10">
                            <li class="flex items-center gap-3 text-gray-300 text-sm"><span
                                    class="material-symbols-outlined text-primary text-[20px]">check_circle</span>Curated
                                Deal Flow from verified startups</li>
                            <li class="flex items-center gap-3 text-gray-300 text-sm"><span
                                    class="material-symbols-outlined text-primary text-[20px]">check_circle</span>Low
                                minimum investments from $5,000</li>
                            <li class="flex items-center gap-3 text-gray-300 text-sm"><span
                                    class="material-symbols-outlined text-primary text-[20px]">check_circle</span>Automated
                                portfolio tracking & reports</li>
                            <li class="flex items-center gap-3 text-gray-300 text-sm"><span
                                    class="material-symbols-outlined text-primary text-[20px]">check_circle</span>Government-backed
                                startup support</li>
                        </ul>
                        <a href="register.jsp"
                            class="w-fit h-12 px-8 rounded-full bg-primary text-white font-bold hover:bg-primary-dark transition-colors shadow-soft flex items-center gap-2">
                            Join Investify Now
                            <span class="material-symbols-outlined text-[20px]">arrow_forward</span>
                        </a>
                    </div>
                    <div class="relative h-64 md:h-auto bg-cover bg-center"
                        style="background-image:url('https://lh3.googleusercontent.com/aida-public/AB6AXuACIOaYCJnIuF2K7r7x2bIV1sfw7P7FDATF6E8aAJwKGtOukTZXOb-DUnKCo4JcZkIfakF_h5T38P2plOHtKvOwCan4_Ux_s3X7gDQoG_3A2ywXozxyA79k8yXfWEKhRi3s9EQ2D_njSQzP21QVVbRW8TjSa5hUja_CEbF-eFmG2jwQO7A8VjvWFMb_zdomHUVSSE5xPxPQOnVzyWASS-vy6ldLDnGO6Y7N7VWrbQa5_y_iMWXYm7RHkpnd6KxPRDQEvwJbntU0kgPN')">
                        <div class="absolute inset-0 bg-primary/20 mix-blend-multiply"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ═══ FOR FOUNDERS ═══ -->
    <section id="for-founders" class="py-24 px-6 bg-white/60">
        <div class="mx-auto max-w-6xl grid md:grid-cols-2 gap-16 items-center">
            <div>
                <span class="text-primary font-bold tracking-widest uppercase text-xs block mb-4">For Founders</span>
                <h2 class="text-4xl font-black mb-6">Raise Capital.<br />Scale Faster.</h2>
                <p class="text-text-muted mb-8 leading-relaxed text-lg">Investify gives you direct access to a network
                    of vetted investors actively looking for startups like yours. Our platform handles the matching,
                    compliance, and progress tracking.</p>
                <div class="grid grid-cols-2 gap-4 mb-8">
                    <div class="bg-bg-cream rounded-xl p-4">
                        <p class="text-2xl font-black text-primary">94%</p>
                        <p class="text-sm text-text-muted mt-1">Funding success rate</p>
                    </div>
                    <div class="bg-bg-cream rounded-xl p-4">
                        <p class="text-2xl font-black text-primary">42 days</p>
                        <p class="text-sm text-text-muted mt-1">Avg. time to close</p>
                    </div>
                </div>
                <a href="founder/create_profile.jsp"
                    class="inline-flex items-center gap-2 h-12 px-8 rounded-full bg-primary text-white font-bold hover:bg-primary-dark transition-colors shadow-soft">
                    Create Startup Profile
                    <span class="material-symbols-outlined text-[20px]">arrow_forward</span>
                </a>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div class="bg-white border border-border-subtle rounded-2xl p-6 text-center shadow-card">
                    <span class="material-symbols-outlined text-primary text-[40px] mb-3">rocket_launch</span>
                    <p class="font-bold">Fast Onboarding</p>
                    <p class="text-xs text-text-muted mt-1">Profile live in 24h</p>
                </div>
                <div class="bg-white border border-border-subtle rounded-2xl p-6 text-center shadow-card mt-6">
                    <span class="material-symbols-outlined text-primary text-[40px] mb-3">account_balance</span>
                    <p class="font-bold">Gov. Support</p>
                    <p class="text-xs text-text-muted mt-1">Scheme eligibility</p>
                </div>
                <div class="bg-white border border-border-subtle rounded-2xl p-6 text-center shadow-card">
                    <span class="material-symbols-outlined text-primary text-[40px] mb-3">groups</span>
                    <p class="font-bold">Rich Network</p>
                    <p class="text-xs text-text-muted mt-1">8,500+ investors</p>
                </div>
                <div class="bg-white border border-border-subtle rounded-2xl p-6 text-center shadow-card mt-6">
                    <span class="material-symbols-outlined text-primary text-[40px] mb-3">insights</span>
                    <p class="font-bold">Live Analytics</p>
                    <p class="text-xs text-text-muted mt-1">Track every view</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ═══ FOOTER ═══ -->
    <footer class="bg-white border-t border-border-subtle pt-16 pb-8">
        <div class="mx-auto max-w-6xl px-6">
            <div class="grid grid-cols-2 md:grid-cols-5 gap-8 mb-12">
                <div class="col-span-2">
                    <div class="flex items-center gap-3 mb-5">
                        <div class="flex h-9 w-9 items-center justify-center rounded-xl bg-primary text-white"><span
                                class="material-symbols-outlined text-xl">diamond</span></div>
                        <span class="text-xl font-bold">Investify</span>
                    </div>
                    <p class="text-text-muted text-sm max-w-xs mb-6 leading-relaxed">The premier platform for
                        discovering and investing in the next generation of industry-defining startups.</p>
                    <div class="flex gap-3">
                        <a href="#"
                            class="w-9 h-9 rounded-full bg-bg-cream flex items-center justify-center text-text-muted hover:bg-primary hover:text-white transition-colors"><span
                                class="material-symbols-outlined text-[18px]">group</span></a>
                        <a href="#"
                            class="w-9 h-9 rounded-full bg-bg-cream flex items-center justify-center text-text-muted hover:bg-primary hover:text-white transition-colors"><span
                                class="material-symbols-outlined text-[18px]">post_add</span></a>
                        <a href="#"
                            class="w-9 h-9 rounded-full bg-bg-cream flex items-center justify-center text-text-muted hover:bg-primary hover:text-white transition-colors"><span
                                class="material-symbols-outlined text-[18px]">alternate_email</span></a>
                    </div>
                </div>
                <div>
                    <h4 class="font-bold mb-5 text-sm">Platform</h4>
                    <ul class="space-y-3 text-sm text-text-muted">
                        <li><a href="login.jsp" class="hover:text-primary transition-colors">Browse
                                Startups</a></li>
                        <li><a href="login.jsp" class="hover:text-primary transition-colors">Investor
                                Dashboard</a></li>
                        <li><a href="login.jsp" class="hover:text-primary transition-colors">Founder
                                Dashboard</a></li>
                        <li><a href="login.jsp" class="hover:text-primary transition-colors">Gov.
                                Portal</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold mb-5 text-sm">Company</h4>
                    <ul class="space-y-3 text-sm text-text-muted">
                        <li><a href="#" class="hover:text-primary transition-colors">About Us</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Careers</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Press</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Contact</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold mb-5 text-sm">Legal</h4>
                    <ul class="space-y-3 text-sm text-text-muted">
                        <li><a href="#" class="hover:text-primary transition-colors">Privacy Policy</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Terms of Service</a></li>
                        <li><a href="#" class="hover:text-primary transition-colors">Risk Disclosure</a></li>
                    </ul>
                </div>
            </div>
            <div
                class="border-t border-border-subtle pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
                <p class="text-sm text-text-muted">© 2024 Investify Platforms Inc. All rights reserved.</p>
                <div class="flex items-center gap-2 text-sm text-text-muted">
                    <span class="material-symbols-outlined text-primary text-[16px]">verified_user</span>
                    Government-Registered & Regulated Platform
                </div>
            </div>
        </div>
    </footer>
    <script>
        function toggleMenu() {
            const m = document.getElementById('mobile-menu');
            const i = document.getElementById('menu-icon');
            m.classList.toggle('open');
            i.textContent = m.classList.contains('open') ? 'close' : 'menu';
        }
    </script>
</body>

</html>