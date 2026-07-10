@extends('admin.layout')

@section('title', 'Kirim Notifikasi')
@section('page_title', 'Push Notification FCM')

@section('content')
<div class="row">
    <div class="col-md-7">
        <div class="custom-card">
            <h5 class="outfit fw-bold text-dark mb-4"><i class="bi bi-send text-primary me-2"></i> Kirim Notifikasi Baru</h5>
            
            <form action="{{ route('admin.notifications.send') }}" method="POST">
                @csrf
                
                <!-- Target User Selection -->
                <div class="mb-3">
                    <label for="target_user" class="form-label text-muted text-uppercase fw-bold" style="font-size: 0.75rem;">Target Pengguna</label>
                    <select name="target_user" id="target_user" class="form-select" required>
                        <option value="all">📢 Kirim ke Semua Pengguna (Broadcast)</option>
                        <optgroup label="Pengguna Spesifik">
                            @foreach($users as $user)
                                <option value="{{ $user->id }}">👤 {{ $user->name }} ({{ $user->phone }})</option>
                            @endforeach
                        </optgroup>
                    </select>
                    <small class="text-muted mt-1 d-block">Pilih target penerima notifikasi.</small>
                </div>

                <!-- Title -->
                <div class="mb-3">
                    <label for="title" class="form-label text-muted text-uppercase fw-bold" style="font-size: 0.75rem;">Judul Notifikasi (Title)</label>
                    <input type="text" name="title" id="title" class="form-control" placeholder="Promo Spesifik Hari Ini! 🎉" required>
                    <small class="text-muted mt-1 d-block">Maksimal 100 karakter.</small>
                </div>

                <!-- Body / Message -->
                <div class="mb-4">
                    <label for="body" class="form-label text-muted text-uppercase fw-bold" style="font-size: 0.75rem;">Isi Pesan (Body)</label>
                    <textarea name="body" id="body" rows="4" class="form-control" placeholder="Dapatkan cashback 10% untuk transaksi transfer pulsa/data hari ini. Yuk gunakan EZ Pay sekarang!" required></textarea>
                    <small class="text-muted mt-1 d-block">Pesan lengkap yang akan tampil di status bar ponsel.</small>
                </div>

                <!-- Action Button -->
                <div class="d-grid">
                    <button type="submit" class="btn btn-gradient py-3 outfit fw-bold">
                        <i class="bi bi-telegram me-2"></i> Kirim Push Notification
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <div class="col-md-5">
        <!-- Info Card -->
        <div class="custom-card border-start border-primary border-4" style="background: rgba(239, 246, 255, 0.9);">
            <h5 class="outfit fw-bold text-primary mb-3"><i class="bi bi-info-circle-fill"></i> Bagaimana Ini Bekerja?</h5>
            <ol class="text-muted ps-3" style="font-size: 0.9rem; line-height: 1.6;">
                <li class="mb-2">Admin menuliskan pesan notifikasi.</li>
                <li class="mb-2">Laravel mengidentifikasi token FCM aktif yang terdaftar di database MySQL berdasarkan target pengguna yang dipilih.</li>
                <li class="mb-2">Server Laravel mengirim payload ke **Firebase Cloud Messaging (FCM)** menggunakan credentials admin.</li>
                <li class="mb-2">Firebase mendistribusikan notifikasi secara real-time ke perangkat mobile pengguna yang terhubung.</li>
            </ol>
            <div class="alert alert-warning border-0 rounded-3 mt-4" style="font-size: 0.8rem;">
                <i class="bi bi-lightbulb-fill me-1"></i> Fitur ini membuktikan integrasi penuh dari database MySQL, server REST API Laravel, dan Firebase Cloud Messaging ke perangkat mobile
            </div>
        </div>
    </div>
</div>
@endsection
