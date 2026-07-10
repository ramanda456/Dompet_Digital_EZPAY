@extends('admin.layout')

@section('title', 'Log Transaksi')
@section('page_title', 'Audit Log Transaksi')

@section('content')
<div class="custom-card">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center gap-3 mb-4">
        <h5 class="m-0 outfit fw-bold">Daftar Transaksi Database MySQL</h5>
        
        <!-- Filters -->
        <form action="{{ route('admin.transactions') }}" method="GET" class="d-flex flex-wrap gap-2">
            <!-- Filter Type -->
            <select name="type" class="form-select text-capitalize" style="min-width: 180px;">
                <option value="">-- Semua Jenis --</option>
                <option value="top_up_saldo" {{ $type === 'top_up_saldo' ? 'selected' : '' }}>Top Up Saldo</option>
                <option value="transfer_ezpay" {{ $type === 'transfer_ezpay' ? 'selected' : '' }}>Transfer P2P (EZ Pay)</option>
                <option value="transfer_bank" {{ $type === 'transfer_bank' ? 'selected' : '' }}>Transfer Bank</option>
                <option value="transfer_ewallet" {{ $type === 'transfer_ewallet' ? 'selected' : '' }}>Transfer E-Wallet</option>
                <option value="tarik_tunai" {{ $type === 'tarik_tunai' ? 'selected' : '' }}>Tarik Tunai</option>
                <option value="beli_pulsa" {{ $type === 'beli_pulsa' ? 'selected' : '' }}>Beli Pulsa</option>
                <option value="beli_paket_data" {{ $type === 'beli_paket_data' ? 'selected' : '' }}>Beli Paket Data</option>
                <option value="bayar_listrik" {{ $type === 'bayar_listrik' ? 'selected' : '' }}>Bayar Listrik</option>
                <option value="bayar_pdam" {{ $type === 'bayar_pdam' ? 'selected' : '' }}>Bayar PDAM</option>
                <option value="bayar_bpjs" {{ $type === 'bayar_bpjs' ? 'selected' : '' }}>Bayar BPJS</option>
                <option value="top_up_game" {{ $type === 'top_up_game' ? 'selected' : '' }}>Top Up Game</option>
            </select>

            <!-- Filter Status -->
            <select name="status" class="form-select text-capitalize" style="min-width: 150px;">
                <option value="">-- Semua Status --</option>
                <option value="success" {{ $status === 'success' ? 'selected' : '' }}>Success</option>
                <option value="pending" {{ $status === 'pending' ? 'selected' : '' }}>Pending</option>
                <option value="processing" {{ $status === 'processing' ? 'selected' : '' }}>Processing</option>
                <option value="failed" {{ $status === 'failed' ? 'selected' : '' }}>Failed</option>
                <option value="cancelled" {{ $status === 'cancelled' ? 'selected' : '' }}>Cancelled</option>
            </select>

            <button type="submit" class="btn btn-gradient px-4">Filter</button>
            
            @if($type || $status)
                <a href="{{ route('admin.transactions') }}" class="btn btn-outline-secondary d-flex align-items-center justify-content-center px-3"><i class="bi bi-arrow-counterclockwise"></i></a>
            @endif
        </form>
    </div>

    <div class="table-responsive">
        <table class="table custom-table">
            <thead>
                <tr>
                    <th>Kode Transaksi</th>
                    <th>Pengguna</th>
                    <th>Jenis</th>
                    <th>Nominal</th>
                    <th>Admin Fee</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Metode</th>
                    <th>Waktu</th>
                </tr>
            </thead>
            <tbody>
                @forelse($transactions as $trx)
                    <tr>
                        <td>
                            <code class="fw-bold fs-6">{{ $trx->transaction_code }}</code>
                            @if($trx->reference_id)
                                <small class="text-muted d-block" style="font-size: 0.75rem;">Ref: {{ $trx->reference_id }}</small>
                            @endif
                        </td>
                        <td>
                            @if($trx->sender)
                                <div class="d-flex flex-column">
                                    <span class="fw-bold">{{ $trx->sender->name }}</span>
                                    <small class="text-muted" style="font-size: 0.8rem;">Pengirim: {{ $trx->sender->phone }}</small>
                                </div>
                            @else
                                <span class="text-muted">Admin / System</span>
                            @endif

                            @if($trx->receiver)
                                <div class="d-flex flex-column mt-1 pt-1 border-top border-light">
                                    <span class="fw-bold" style="font-size: 0.85rem;">Penerima: {{ $trx->receiver->name }}</span>
                                    <small class="text-muted" style="font-size: 0.75rem;">{{ $trx->receiver->phone }}</small>
                                </div>
                            @endif
                        </td>
                        <td>
                            <span class="badge bg-light text-dark border rounded-pill px-3 py-1 outfit" style="font-size: 0.75rem;">
                                {{ $trx->type_label }}
                            </span>
                        </td>
                        <td class="outfit">Rp {{ number_format($trx->amount, 0, ',', '.') }}</td>
                        <td class="outfit text-muted">Rp {{ number_format($trx->admin_fee, 0, ',', '.') }}</td>
                        <td class="outfit fw-bold text-primary">Rp {{ number_format($trx->total, 0, ',', '.') }}</td>
                        <td>
                            @if($trx->status === 'success')
                                <span class="badge-success-custom"><i class="bi bi-check-circle"></i> Sukses</span>
                            @elseif($trx->status === 'pending')
                                <span class="badge-warning-custom"><i class="bi bi-hourglass-split"></i> Pending</span>
                            @elseif($trx->status === 'processing')
                                <span class="badge-warning-custom"><i class="bi bi-gear-fill"></i> Diproses</span>
                            @elseif($trx->status === 'failed')
                                <span class="badge-danger-custom" title="{{ $trx->failed_reason }}"><i class="bi bi-x-circle"></i> Gagal</span>
                                @if($trx->failed_reason)
                                    <small class="text-danger d-block" style="font-size: 0.75rem; max-width: 150px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">{{ $trx->failed_reason }}</small>
                                @endif
                            @else
                                <span class="badge bg-secondary text-white rounded-pill px-2 py-1" style="font-size: 0.75rem;">{{ $trx->status }}</span>
                            @endif
                        </td>
                        <td class="text-capitalize">{{ str_replace('_', ' ', $trx->payment_method ?? '-') }}</td>
                        <td>
                            <span class="d-block">{{ $trx->created_at->format('d/m/Y') }}</span>
                            <small class="text-muted d-block" style="font-size: 0.8rem;">{{ $trx->created_at->format('H:i') }} WIB</small>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="9" class="text-center py-4 text-muted">Tidak ada transaksi yang cocok dengan filter.</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <!-- Pagination links -->
    <div class="d-flex justify-content-end mt-4">
        {{ $transactions->appends(['type' => $type, 'status' => $status])->links('pagination::bootstrap-5') }}
    </div>
</div>
@endsection
