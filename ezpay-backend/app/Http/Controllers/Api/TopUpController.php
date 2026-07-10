<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\TransactionDetail;
use App\Models\User;
use App\Services\MidtransService;
use App\Services\NotificationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class TopUpController extends Controller
{
    protected MidtransService $midtransService;
    protected NotificationService $notificationService;

    public function __construct(MidtransService $midtransService, NotificationService $notificationService)
    {
        $this->midtransService = $midtransService;
        $this->notificationService = $notificationService;
    }

    /**
     * Initiate a top-up request.
     */
    public function initiate(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:10000', // Minimum top up Rp 10.000
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = $request->user();
        $amount = (float) $request->amount;
        $adminFee = 0; // Free admin or customize
        $total = $amount + $adminFee;

        try {
            $transaction = DB::transaction(function () use ($user, $amount, $adminFee, $total) {
                // Generate a pending transaction
                $trx = Transaction::create([
                    'transaction_code' => Transaction::generateCode(),
                    'sender_id' => $user->id, // Top-up owner
                    'type' => 'top_up_saldo',
                    'amount' => $amount,
                    'admin_fee' => $adminFee,
                    'total' => $total,
                    'status' => 'pending',
                    'payment_method' => 'midtrans',
                    'note' => 'Top Up Saldo EZ Pay',
                ]);

                return $trx;
            });

            // Get snap token from Midtrans
            $snapToken = $this->midtransService->createSnapToken($transaction, $user);

            // Construct redirect URL
            $isProduction = filter_var(env('MIDTRANS_IS_PRODUCTION', false), FILTER_VALIDATE_BOOLEAN);
            $baseUrl = $isProduction 
                ? 'https://app.midtrans.com/snap/v2/vtweb/' 
                : 'https://app.sandbox.midtrans.com/snap/v2/vtweb/';
            $redirectUrl = $baseUrl . $snapToken;

            // Store snap token/payment URL in transaction details
            TransactionDetail::create([
                'transaction_id' => $transaction->id,
                'payment_url' => $redirectUrl,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Top up berhasil diinisiasi',
                'data' => [
                    'transaction_code' => $transaction->transaction_code,
                    'amount' => $transaction->amount,
                    'admin_fee' => $transaction->admin_fee,
                    'total' => $transaction->total,
                    'status' => $transaction->status,
                    'snap_token' => $snapToken,
                    'redirect_url' => $redirectUrl,
                ],
            ]);

        } catch (\Exception $e) {
            Log::error("TopUp Initiation Error: " . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal menginisiasi top up: ' . $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Handle webhook callbacks from Midtrans.
     */
    public function handleWebhook(Request $request)
    {
        $payload = $request->all();
        Log::info("Midtrans Webhook Received: ", $payload);

        $orderId = $payload['order_id'] ?? null;
        $statusCode = $payload['status_code'] ?? null;
        $grossAmount = $payload['gross_amount'] ?? null;
        $receivedSignature = $payload['signature_key'] ?? null;
        $transactionStatus = $payload['transaction_status'] ?? null;
        $paymentType = $payload['payment_type'] ?? null;

        if (!$orderId || !$statusCode || !$grossAmount || !$receivedSignature) {
            return response()->json([
                'success' => false,
                'message' => 'Payload tidak lengkap',
            ], 400);
        }

        // Validate Midtrans signature key
        if (!$this->midtransService->validateSignature($orderId, $statusCode, $grossAmount, $receivedSignature)) {
            Log::warning("Midtrans Webhook: Invalid Signature Key for order {$orderId}");
            return response()->json([
                'success' => false,
                'message' => 'Signature key tidak valid',
            ], 403);
        }

        // Find transaction
        $transaction = Transaction::where('transaction_code', $orderId)->first();
        if (!$transaction) {
            Log::warning("Midtrans Webhook: Transaction {$orderId} not found");
            return response()->json([
                'success' => false,
                'message' => 'Transaksi tidak ditemukan',
            ], 404);
        }

        // Determine final transaction status
        $status = 'pending';
        $failedReason = null;

        if ($transactionStatus === 'capture') {
            if (($payload['fraud_status'] ?? 'accept') === 'accept') {
                $status = 'success';
            } else {
                $status = 'failed';
                $failedReason = 'Fraud detection rejected transaction';
            }
        } elseif ($transactionStatus === 'settlement') {
            $status = 'success';
        } elseif (in_array($transactionStatus, ['deny', 'cancel', 'expire'])) {
            $status = 'failed';
            $failedReason = "Status Midtrans: {$transactionStatus}";
        }

        // Update transaction and increment balance if success
        $balanceUpdated = false;
        try {
            DB::transaction(function () use ($transaction, $status, $paymentType, $failedReason, &$balanceUpdated) {
                // Lock transaction row
                $transaction = Transaction::where('id', $transaction->id)->lockForUpdate()->first();

                if ($transaction->status === 'success') {
                    // Already processed
                    return;
                }

                if ($status === 'success') {
                    // Lock user row and increment balance
                    $user = User::where('id', $transaction->sender_id)->lockForUpdate()->first();
                    $balanceBefore = $user->balance;
                    
                    $user->increment('balance', $transaction->amount);
                    $balanceAfter = $balanceBefore + $transaction->amount;

                    $transaction->update([
                        'status' => 'success',
                        'payment_method' => $paymentType ?? 'midtrans',
                        'sender_balance_before' => $balanceBefore,
                        'sender_balance_after' => $balanceAfter,
                    ]);

                    $balanceUpdated = true;
                } elseif ($status === 'failed') {
                    $transaction->update([
                        'status' => 'failed',
                        'payment_method' => $paymentType ?? 'midtrans',
                        'failed_reason' => $failedReason,
                    ]);
                }
            });

            // Send notification after successful commit
            if ($status === 'success' && $balanceUpdated) {
                $this->notificationService->sendNotification(
                    $transaction->sender_id,
                    'Isi Saldo Berhasil',
                    "Top up saldo sebesar Rp " . number_format($transaction->amount, 0, ',', '.') . " telah berhasil ditambahkan.",
                    ['transaction_code' => $transaction->transaction_code, 'type' => 'top_up_saldo']
                );
            } elseif ($status === 'failed') {
                $this->notificationService->sendNotification(
                    $transaction->sender_id,
                    'Isi Saldo Gagal',
                    "Top up saldo sebesar Rp " . number_format($transaction->amount, 0, ',', '.') . " gagal atau kedaluwarsa.",
                    ['transaction_code' => $transaction->transaction_code, 'type' => 'top_up_saldo']
                );
            }

            return response()->json([
                'success' => true,
                'message' => 'Status transaksi berhasil diperbarui',
            ]);

        } catch (\Exception $e) {
            Log::error("Webhook Status Update Error for {$orderId}: " . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Internal Server Error',
            ], 500);
        }
    }
}
