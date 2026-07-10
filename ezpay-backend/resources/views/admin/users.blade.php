@extends('admin.layout')

@section('title', 'Kelola User')
@section('page_title', 'Kelola Pengguna')

@section('content')
<div class="custom-card">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h5 class="m-0 outfit fw-bold">Daftar Pengguna Aplikasi</h5>
        
        <!-- Search bar -->
        <form action="{{ route('admin.users') }}" method="GET" class="d-flex gap-2" style="max-width: 350px;">
            <input type="text" name="search" class="form-control" placeholder="Cari nama, email, hp..." value="{{ $search }}">
            <button type="submit" class="btn btn-gradient px-3"><i class="bi bi-search"></i></button>
            @if($search)
                <a href="{{ route('admin.users') }}" class="btn btn-outline-secondary d-flex align-items-center justify-content-center"><i class="bi bi-x-lg"></i></a>
            @endif
        </form>
    </div>

    <div class="table-responsive">
        <table class="table custom-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nama Pengguna</th>
                    <th>Kontak & NIK</th>
                    <th>Saldo</th>
                    <th>Status</th>
                    <th>Tanggal Daftar</th>
                    <th class="text-center">Aksi</th>
                </tr>
            </thead>
            <tbody>
                @forelse($users as $user)
                    <tr>
                        <td><code>#{{ $user->id }}</code></td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 38px; height: 38px; font-size: 0.9rem;">
                                    {{ strtoupper(substr($user->name, 0, 2)) }}
                                </div>
                                <div class="d-flex flex-column">
                                    <span class="fw-bold">{{ $user->name }}</span>
                                    <small class="text-muted" style="font-size: 0.8rem;">{{ $user->email }}</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="d-flex flex-column">
                                <span><i class="bi bi-phone text-muted me-1"></i> {{ $user->phone }}</span>
                                <small class="text-muted" style="font-size: 0.8rem;"><i class="bi bi-card-id-text text-muted me-1"></i> NIK: {{ $user->nik }}</small>
                            </div>
                        </td>
                        <td class="outfit fw-bold text-primary">Rp {{ number_format($user->balance, 0, ',', '.') }}</td>
                        <td>
                            @if($user->status === 'active')
                                <span class="badge-success-custom"><i class="bi bi-check-circle"></i> Aktif</span>
                            @elseif($user->status === 'suspended')
                                <span class="badge-danger-custom"><i class="bi bi-slash-circle"></i> Suspended</span>
                            @else
                                <span class="badge-warning-custom"><i class="bi bi-question-circle"></i> Unverified</span>
                            @endif
                        </td>
                        <td>
                            <small class="text-muted">{{ $user->created_at->format('d M Y H:i') }} WIB</small>
                        </td>
                        <td>
                            <div class="d-flex justify-content-center gap-2">
                                <!-- Direct Top Up trigger -->
                                <button type="button" class="btn btn-sm btn-success rounded-pill fw-bold px-3 outfit" data-bs-toggle="modal" data-bs-target="#topupModal-{{ $user->id }}">
                                    <i class="bi bi-plus-circle me-1"></i> Isi Saldo
                                </button>
                                
                                <!-- Toggle Status Suspend -->
                                <form action="{{ route('admin.users.toggle', $user->id) }}" method="POST" class="m-0">
                                    @csrf
                                    @if($user->status === 'active')
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill fw-bold px-3 outfit">
                                            <i class="bi bi-slash-circle me-1"></i> Suspend
                                        </button>
                                    @else
                                        <button type="submit" class="btn btn-sm btn-outline-success rounded-pill fw-bold px-3 outfit">
                                            <i class="bi bi-check2-circle me-1"></i> Aktifkan
                                        </button>
                                    @endif
                                </form>
                            </div>
                        </td>
                    </tr>

                    <!-- Top Up Modal for each user -->
                    <div class="modal fade" id="topupModal-{{ $user->id }}" tabindex="-1" aria-labelledby="topupModalLabel-{{ $user->id }}" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 rounded-4 shadow-lg">
                                <div class="modal-header border-0 bg-light rounded-top-4 py-3">
                                    <h5 class="modal-title outfit fw-bold" id="topupModalLabel-{{ $user->id }}">Isi Saldo Pengguna</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="{{ route('admin.users.add-balance', $user->id) }}" method="POST">
                                    @csrf
                                    <div class="modal-body p-4">
                                        <p class="text-muted">Masukkan nominal saldo yang ingin ditambahkan ke akun <strong>{{ $user->name }}</strong>.</p>
                                        <div class="mb-3">
                                            <label class="form-label text-muted text-uppercase fw-bold" style="font-size: 0.75rem;">Nominal (Rupiah)</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light border-end-0 fw-bold">Rp</span>
                                                <input type="number" name="amount" class="form-control border-start-0 outfit fw-bold" placeholder="50000" min="1000" required>
                                            </div>
                                            <small class="text-muted mt-1 d-block">Minimal pengisian manual Rp 1.000</small>
                                        </div>
                                    </div>
                                    <div class="modal-footer border-0 p-3">
                                        <button type="button" class="btn btn-light rounded-3 fw-bold" data-bs-dismiss="modal">Batal</button>
                                        <button type="submit" class="btn btn-gradient rounded-3 px-4">Proses Top Up</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                @empty
                    <tr>
                        <td colspan="7" class="text-center py-4 text-muted">Pengguna tidak ditemukan.</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <!-- Pagination links -->
    <div class="d-flex justify-content-end mt-4">
        {{ $users->appends(['search' => $search])->links('pagination::bootstrap-5') }}
    </div>
</div>
@endsection
