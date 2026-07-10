<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Admin Dashboard') - EZ Pay</title>
    <!-- Google Fonts: Outfit & Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #4f46e5 0%, #3b82f6 100%);
            --glass-bg: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.4);
            --sidebar-width: 260px;
            --text-dark: #0f172a;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(circle at 10% 20%, rgba(239, 246, 255, 0.6) 0%, rgba(219, 234, 254, 0.6) 90%);
            background-attachment: fixed;
            color: var(--text-dark);
            min-height: 100vh;
            overflow-x: hidden;
        }

        h1, h2, h3, h4, h5, h6, .outfit {
            font-family: 'Outfit', sans-serif;
        }

        /* Sidebar Style */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            width: var(--sidebar-width);
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            border-right: 1px solid var(--glass-border);
            z-index: 1000;
            transition: all 0.3s ease;
            box-shadow: 4px 0 24px rgba(0, 0, 0, 0.03);
            display: flex;
            flex-direction: column;
        }

        .sidebar-brand {
            padding: 24px;
            font-weight: 800;
            font-size: 1.5rem;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: -0.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-menu {
            list-style: none;
            padding: 12px;
            margin: 0;
            flex-grow: 1;
        }

        .menu-item {
            margin-bottom: 6px;
        }

        .menu-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: var(--text-muted);
            text-decoration: none;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .menu-link:hover {
            color: #4f46e5;
            background: rgba(79, 70, 229, 0.05);
            transform: translateX(4px);
        }

        .menu-link.active {
            background: var(--primary-gradient);
            color: #ffffff;
            box-shadow: 0 4px 14px rgba(59, 130, 246, 0.3);
        }

        .sidebar-footer {
            padding: 16px 24px;
            border-top: 1px solid var(--glass-border);
        }

        /* Main Content Style */
        .main-content {
            margin-left: var(--sidebar-width);
            padding: 30px;
            transition: all 0.3s ease;
            min-height: 100vh;
        }

        /* Top Navbar */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 16px 24px;
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.02);
        }

        /* Card Custom Glassmorphism */
        .custom-card {
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.03);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            padding: 24px;
            margin-bottom: 24px;
        }

        .custom-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.06);
        }

        /* Button Gradient */
        .btn-gradient {
            background: var(--primary-gradient);
            border: none;
            color: white;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 12px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
        }

        .btn-gradient:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(79, 70, 229, 0.3);
            color: white;
        }

        /* Custom Table Styling */
        .custom-table {
            background: transparent !important;
        }

        .custom-table th {
            font-family: 'Outfit', sans-serif;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            color: var(--text-muted);
            border-bottom: 1px solid var(--glass-border);
            padding: 16px;
        }

        .custom-table td {
            padding: 16px;
            border-bottom: 1px solid rgba(0, 0, 0, 0.03);
            vertical-align: middle;
            font-weight: 500;
        }

        .custom-table tr:hover td {
            background: rgba(79, 70, 229, 0.02);
        }

        .badge-success-custom {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-warning-custom {
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .badge-danger-custom {
            background: rgba(239, 68, 68, 0.1);
            color: #ef4448;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        /* Alert styling */
        .custom-alert {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
        }

        /* Loader or micro-animations */
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .pulse-hover:hover {
            animation: pulse 1s infinite;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <i class="bi bi-wallet2 text-primary"></i>
            <span>EZ Pay Admin</span>
        </div>
        <ul class="sidebar-menu">
            <li class="menu-item">
                <a href="{{ route('admin.dashboard') }}" class="menu-link {{ Route::is('admin.dashboard') ? 'active' : '' }}">
                    <i class="bi bi-grid-1x2-fill"></i>
                    <span>Overview</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.users') }}" class="menu-link {{ Route::is('admin.users') ? 'active' : '' }}">
                    <i class="bi bi-people-fill"></i>
                    <span>Kelola User</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.transactions') }}" class="menu-link {{ Route::is('admin.transactions') ? 'active' : '' }}">
                    <i class="bi bi-cash-stack"></i>
                    <span>Log Transaksi</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="{{ route('admin.notifications.show') }}" class="menu-link {{ Route::is('admin.notifications.show') ? 'active' : '' }}">
                    <i class="bi bi-bell-fill"></i>
                    <span>Kirim Notifikasi</span>
                </a>
            </li>
        </ul>
        <div class="sidebar-footer">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <small class="text-muted d-block">Masuk sebagai</small>
                    <strong class="outfit" style="font-size: 0.85rem;">{{ session('admin_name', 'Administrator') }}</strong>
                </div>
                <form action="{{ route('admin.logout') }}" method="POST" class="m-0">
                    @csrf
                    <button type="submit" class="btn btn-sm btn-outline-danger border-0 rounded-circle" title="Logout">
                        <i class="bi bi-box-arrow-right fs-5"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="main-content">
        <!-- Top Bar -->
        <div class="top-bar">
            <div>
                <h4 class="m-0 outfit fw-bold">@yield('page_title', 'Overview')</h4>
                <small class="text-muted">{{ now()->translatedFormat('l, d F Y') }}</small>
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="badge bg-primary px-3 py-2 rounded-pill outfit" style="font-size: 0.8rem;">
                    EZPay Backend
                </span>
            </div>
        </div>

        <!-- Alerts -->
        @if (session('success'))
            <div class="alert alert-success alert-dismissible fade show custom-alert mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> {{ session('success') }}
                <button type="button" class="btn-close" data-refresh="true" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        @endif

        @if (session('error'))
            <div class="alert alert-danger alert-dismissible fade show custom-alert mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> {{ session('error') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        @endif

        @yield('content')
    </div>

    <!-- Bootstrap 5 Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    @yield('scripts')
</body>
</html>
