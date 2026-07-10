@extends('admin.layout')

@section('title', 'Overview')
@section('page_title', 'Dashboard Overview')

@section('content')
<div class="row">
    <!-- Stat Card 1 -->
    <div class="col-md-3">
        <div class="custom-card">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <span class="text-muted d-block outfit fw-bold mb-1" style="font-size: 0.8rem; text-transform: uppercase;">Total Pengguna</span>
                    <h2 class="m-0 outfit fw-bold">{{ number_format($stats['total_users']) }}</h2>
                </div>
                <div class="badge bg-primary-subtle p-3 rounded-circle text-primary">
                    <i class="bi bi-people-fill fs-4"></i>
                </div>
            </div>
            <div class="mt-3">
                <small class="text-success"><i class="bi bi-arrow-up-short"></i> Pengguna terdaftar</small>
            </div>
        </div>
    </div>
    
    <!-- Stat Card 2 -->
    <div class="col-md-3">
        <div class="custom-card">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <span class="text-muted d-block outfit fw-bold mb-1" style="font-size: 0.8rem; text-transform: uppercase;">Total Saldo Beredar</span>
                    <h2 class="m-0 outfit fw-bold" style="font-size: 1.35rem; margin-top: 5px;">Rp {{ number_format($stats['total_balance'], 0, ',', '.') }}</h2>
                </div>
                <div class="badge bg-success-subtle p-3 rounded-circle text-success">
                    <i class="bi bi-cash-coin fs-4"></i>
                </div>
            </div>
            <div class="mt-3">
                <small class="text-success"><i class="bi bi-shield-check"></i> Saldo tersimpan aman</small>
            </div>
        </div>
    </div>

    <!-- Stat Card 3 -->
    <div class="col-md-3">
        <div class="custom-card">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <span class="text-muted d-block outfit fw-bold mb-1" style="font-size: 0.8rem; text-transform: uppercase;">Jumlah Transaksi</span>
                    <h2 class="m-0 outfit fw-bold">{{ number_format($stats['total_transactions']) }}</h2>
                </div>
                <div class="badge bg-warning-subtle p-3 rounded-circle text-warning">
                    <i class="bi bi-activity fs-4"></i>
                </div>
            </div>
            <div class="mt-3">
                <small class="text-muted">Total dari semua fitur</small>
            </div>
        </div>
    </div>

    <!-- Stat Card 4 -->
    <div class="col-md-3">
        <div class="custom-card">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <span class="text-muted d-block outfit fw-bold mb-1" style="font-size: 0.8rem; text-transform: uppercase;">Pendapatan Fee Admin</span>
                    <h2 class="m-0 outfit fw-bold" style="font-size: 1.35rem; margin-top: 5px;">Rp {{ number_format($stats['total_revenue'], 0, ',', '.') }}</h2>
                </div>
                <div class="badge bg-info-subtle p-3 rounded-circle text-info">
                    <i class="bi bi-graph-up fs-4"></i>
                </div>
            </div>
            <div class="mt-3">
                <small class="text-info"><i class="bi bi-plus-circle"></i> Pendapatan kotor</small>
            </div>
        </div>
    </div>
</div>

<div class="row mt-4">
    <!-- Recent Transactions Table -->
    <div class="col-12">
        <div class="custom-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="m-0 outfit fw-bold"><i class="bi bi-clock-history me-2 text-primary"></i> Transaksi Terbaru</h5>
                <a href="{{ route('admin.transactions') }}" class="btn btn-sm btn-outline-primary border-0 rounded-pill fw-bold outfit">Lihat Semua</a>
            </div>
            
            <div class="table-responsive">
                <table class="table custom-table">
                    <thead>
                        <tr>
                            <th>Kode Transaksi</th>
                            <th>Pengguna (Pengirim)</th>
                            <th>Jenis</th>
                            <th>Total Nominal</th>
                            <th>Status</th>
                            <th>Metode Bayar</th>
                            <th>Waktu</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($recentTransactions as $trx)
                            <tr>
                                <td><code class="fw-bold">{{ $trx->transaction_code }}</code></td>
                                <td>
                                    @if($trx->sender)
                                        <div class="d-flex flex-column">
                                            <span>{{ $trx->sender->name }}</span>
                                            <small class="text-muted" style="font-size: 0.8rem;">{{ $trx->sender->phone }}</small>
                                        </div>
                                    @else
                                        <span class="text-muted">System / Admin</span>
                                    @endif
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border rounded-pill px-3 py-1 outfit" style="font-size: 0.75rem;">
                                        {{ $trx->type_label }}
                                    </span>
                                </td>
                                <td class="outfit fw-bold">Rp {{ number_format($trx->total, 0, ',', '.') }}</td>
                                <td>
                                    @if($trx->status === 'success')
                                        <span class="badge-success-custom"><i class="bi bi-check-circle"></i> Sukses</span>
                                    @elseif($trx->status === 'pending')
                                        <span class="badge-warning-custom"><i class="bi bi-hourglass-split"></i> Pending</span>
                                    @elseif($trx->status === 'processing')
                                        <span class="badge-warning-custom"><i class="bi bi-gear-fill"></i> Diproses</span>
                                    @else
                                        <span class="badge-danger-custom"><i class="bi bi-x-circle"></i> Gagal</span>
                                    @endif
                                </td>
                                <td class="text-capitalize">{{ str_replace('_', ' ', $trx->payment_method ?? '-') }}</td>
                                <td>
                                    <small class="text-muted d-block">{{ $trx->created_at->format('d/m/Y') }}</small>
                                    <small class="text-muted d-block" style="font-size: 0.8rem;">{{ $trx->created_at->format('H:i') }} WIB</small>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">Belum ada transaksi terekam.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
@endsection
