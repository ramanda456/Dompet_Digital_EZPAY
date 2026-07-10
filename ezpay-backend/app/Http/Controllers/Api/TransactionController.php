<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Services\TransactionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class TransactionController extends Controller
{
    protected TransactionService $transactionService;

    public function __construct(TransactionService $transactionService)
    {
        $this->transactionService = $transactionService;
    }

    // ─── SALDO ────────────────────────────────────────

    /**
     * GET /api/saldo — Cek saldo user yang sedang login.
     */
    public function saldo(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'success' => true,
            'message' => 'Saldo berhasil diambil',
            'data' => [
                'balance' => $user->balance,
                'formatted_balance' => 'Rp ' . number_format($user->balance, 0, ',', '.'),
            ]
        ]);
    }

    // ─── RIWAYAT TRANSAKSI ────────────────────────────

    /**
     * GET /api/transactions — Riwayat transaksi user (paginated).
     *
     * Query params:
     *   - type (string, optional): filter by transaction type
     *   - status (string, optional): filter by status
     *   - per_page (int, optional, default 15): jumlah per halaman
     */
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Transaction::where('sender_id', $user->id)
            ->orWhere('receiver_id', $user->id);

        if ($request->filled('type')) {
            $query->where('type', $request->type);
        }

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $perPage = $request->input('per_page', 15);

        $transactions = $query
            ->with(['sender:id,name,phone', 'receiver:id,name,phone', 'detail', 'merchant:id,merchant_name,merchant_type'])
            ->orderBy('created_at', 'desc')
            ->paginate($perPage);

        return response()->json([
            'success' => true,
            'message' => 'Riwayat transaksi berhasil diambil',
            'data' => $transactions,
        ]);
    }

    /**
     * GET /api/transactions/{code} — Detail 1 transaksi berdasarkan kode.
     */
    public function show(Request $request, string $code)
    {
        $user = $request->user();

        $transaction = Transaction::where('transaction_code', $code)
            ->where(function ($q) use ($user) {
                $q->where('sender_id', $user->id)
                  ->orWhere('receiver_id', $user->id);
            })
            ->with(['sender:id,name,phone', 'receiver:id,name,phone', 'detail', 'merchant'])
            ->first();

        if (!$transaction) {
            return response()->json([
                'success' => false,
                'message' => 'Transaksi tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail transaksi berhasil diambil',
            'data' => $transaction,
        ]);
    }

    // ─── TRANSFER EZ PAY (P2P) ───────────────────────

    /**
     * POST /api/transfer/ezpay — Transfer saldo ke sesama pengguna EZ Pay.
     */
    public function transferEzpay(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'receiver_phone' => 'required|string',
            'amount' => 'required|numeric|min:10000',
            'pin' => 'required|string|size:6',
            'note' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        // Verify PIN
        $user = $request->user();
        if (!$this->verifyPin($user, $request->pin)) {
            return response()->json([
                'success' => false,
                'message' => 'PIN salah',
                'code' => 'INVALID_PIN'
            ], 401);
        }

        try {
            $transaction = $this->transactionService->transferEzpay(
                sender: $user,
                receiverPhone: $request->receiver_phone,
                amount: (float) $request->amount,
                note: $request->note,
            );

            return response()->json([
                'success' => true,
                'message' => 'Transfer EZ Pay berhasil',
                'data' => $transaction,
            ]);
        } catch (\RuntimeException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    // ─── TRANSFER BANK ───────────────────────────────

    /**
     * POST /api/transfer/bank — Transfer ke rekening bank.
     */
    public function transferBank(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:10000',
            'bank_code' => 'required|string|max:10',
            'bank_name' => 'required|string|max:50',
            'account_number' => 'required|string|max:30',
            'account_holder_name' => 'required|string|max:100',
            'pin' => 'required|string|size:6',
            'note' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();
        if (!$this->verifyPin($user, $request->pin)) {
            return response()->json([
                'success' => false,
                'message' => 'PIN salah',
                'code' => 'INVALID_PIN'
            ], 401);
        }

        try {
            $transaction = $this->transactionService->transferBank(
                sender: $user,
                amount: (float) $request->amount,
                bankCode: $request->bank_code,
                bankName: $request->bank_name,
                accountNumber: $request->account_number,
                accountHolderName: $request->account_holder_name,
                note: $request->note,
            );

            return response()->json([
                'success' => true,
                'message' => 'Transfer bank sedang diproses',
                'data' => $transaction,
            ]);
        } catch (\RuntimeException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    // ─── TRANSFER E-WALLET ───────────────────────────

    /**
     * POST /api/transfer/ewallet — Transfer ke e-wallet (Dana, GoPay, ShopeePay, iSaku).
     */
    public function transferEwallet(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:10000',
            'ewallet_name' => 'required|string|max:50',
            'account_number' => 'required|string|max:50',
            'account_holder_name' => 'required|string|max:100',
            'pin' => 'required|string|size:6',
            'note' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();
        if (!$this->verifyPin($user, $request->pin)) {
            return response()->json([
                'success' => false,
                'message' => 'PIN salah',
                'code' => 'INVALID_PIN'
            ], 401);
        }

        try {
            $transaction = $this->transactionService->transferEwallet(
                sender: $user,
                amount: (float) $request->amount,
                ewalletName: $request->ewallet_name,
                accountNumber: $request->account_number,
                accountHolderName: $request->account_holder_name,
                note: $request->note,
            );

            return response()->json([
                'success' => true,
                'message' => 'Transfer e-wallet sedang diproses',
                'data' => $transaction,
            ]);
        } catch (\RuntimeException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    // ─── TARIK TUNAI ─────────────────────────────────

    /**
     * POST /api/tarik-tunai — Tarik tunai di merchant (Alfamart/Indomaret/Alfamidi).
     */
    public function tarikTunai(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:50000',
            'merchant_code' => 'required|string|max:30',
            'pin' => 'required|string|size:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();
        if (!$this->verifyPin($user, $request->pin)) {
            return response()->json([
                'success' => false,
                'message' => 'PIN salah',
                'code' => 'INVALID_PIN'
            ], 401);
        }

        try {
            $transaction = $this->transactionService->tarikTunai(
                sender: $user,
                amount: (float) $request->amount,
                merchantCode: $request->merchant_code,
            );

            return response()->json([
                'success' => true,
                'message' => 'Tarik tunai berhasil diproses. Tunjukkan kode ke kasir.',
                'data' => $transaction,
            ]);
        } catch (\RuntimeException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 400);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    // ─── PIN HELPERS ─────────────────────────────────

    /**
     * POST /api/verify-pin — Verifikasi PIN user (dipanggil sebelum transaksi dari Flutter).
     */
    public function verifyPinEndpoint(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'pin' => 'required|string|size:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();
        $isValid = $this->verifyPin($user, $request->pin);

        return response()->json([
            'success' => $isValid,
            'message' => $isValid ? 'PIN valid' : 'PIN salah',
        ], $isValid ? 200 : 401);
    }

    /**
     * PUT /api/change-pin — Ganti PIN transaksi.
     */
    public function changePin(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'old_pin' => 'required|string|size:6',
            'new_pin' => 'required|string|size:6|different:old_pin',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();
        if (!$this->verifyPin($user, $request->old_pin)) {
            return response()->json([
                'success' => false,
                'message' => 'PIN lama salah',
                'code' => 'INVALID_PIN'
            ], 401);
        }

        try {
            // Save PIN history
            \Illuminate\Support\Facades\DB::table('pin_histories')->insert([
                'user_id' => $user->id,
                'old_pin' => $user->pin,
                'new_pin' => \Illuminate\Support\Facades\Hash::make($request->new_pin),
                'changed_at' => now(),
            ]);

            // Update PIN
            $user->update(['pin' => \Illuminate\Support\Facades\Hash::make($request->new_pin)]);

            return response()->json([
                'success' => true,
                'message' => 'PIN berhasil diubah',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan sistem',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    // ─── Private Helpers ─────────────────────────────

    /**
     * Verify user's transaction PIN.
     */
    private function verifyPin($user, string $pin): bool
    {
        if (empty($user->pin)) {
            return false;
        }
        return \Illuminate\Support\Facades\Hash::check($pin, $user->pin);
    }
}
