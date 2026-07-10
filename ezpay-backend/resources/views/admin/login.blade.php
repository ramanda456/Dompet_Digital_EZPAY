<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin - EZ Pay</title>
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
            --text-dark: #0f172a;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: radial-gradient(circle at 10% 20%, rgba(239, 246, 255, 0.6) 0%, rgba(219, 234, 254, 0.6) 90%);
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            box-shadow: 0 16px 48px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 420px;
            padding: 40px 30px;
            text-align: center;
            animation: fadeInUp 0.6s ease;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .brand-icon {
            font-size: 3rem;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            display: inline-block;
        }

        .btn-gradient {
            background: var(--primary-gradient);
            border: none;
            color: white;
            font-weight: 600;
            padding: 12px;
            border-radius: 12px;
            width: 100%;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2);
            transition: all 0.2s ease;
        }

        .btn-gradient:hover {
            opacity: 0.9;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(79, 70, 229, 0.3);
            color: white;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px 16px;
            border: 1px solid rgba(0, 0, 0, 0.08);
            background: rgba(255, 255, 255, 0.5);
            transition: all 0.2s ease;
        }

        .form-control:focus {
            background: #ffffff;
            border-color: #4f46e5;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="brand-icon">
            <i class="bi bi-wallet2"></i>
        </div>
        <h3 class="outfit fw-bold text-dark mb-1">Masuk Admin</h3>
        <p class="text-muted mb-4" style="font-size: 0.9rem;">EZ Pay Web Backend — UAS Demo</p>

        @if ($errors->has('login'))
            <div class="alert alert-danger border-0 rounded-3 text-start mb-4" style="font-size: 0.85rem;">
                <i class="bi bi-exclamation-circle-fill me-2"></i> {{ $errors->first('login') }}
            </div>
        @endif

        @if (session('success'))
            <div class="alert alert-success border-0 rounded-3 text-start mb-4" style="font-size: 0.85rem;">
                <i class="bi bi-check-circle-fill me-2"></i> {{ session('success') }}
            </div>
        @endif

        <form action="{{ route('admin.login') }}" method="POST" class="text-start">
            @csrf
            <div class="mb-3">
                <label for="email" class="form-label fw-600 text-muted" style="font-size: 0.8rem; text-transform: uppercase;">Email</label>
                <input type="email" name="email" id="email" class="form-control" placeholder="admin@ezpay.id" value="{{ old('email', 'admin@ezpay.id') }}" required>
            </div>
            
            <div class="mb-4">
                <label for="password" class="form-label fw-600 text-muted" style="font-size: 0.8rem; text-transform: uppercase;">Password</label>
                <input type="password" name="password" id="password" class="form-control" placeholder="••••••••" value="admin123" required>
            </div>

            <button type="submit" class="btn btn-gradient">Masuk Sekarang</button>
        </form>

        <div class="mt-4">
            <small class="text-muted d-block" style="font-size: 0.75rem;">Default Demo UAS:</small>
            <small class="text-muted d-block" style="font-size: 0.75rem;">Email: <strong>admin@ezpay.id</strong> | Pass: <strong>admin123</strong></small>
        </div>
    </div>

</body>
</html>
