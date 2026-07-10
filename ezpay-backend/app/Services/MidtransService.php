<?php

namespace App\Services;

use Midtrans\Config;
use Midtrans\Snap;
use App\Models\Transaction;
use App\Models\User;
use Illuminate\Support\Facades\Log;

class MidtransService
{
    public function __construct()
    {
        Config::$serverKey = env('MIDTRANS_SERVER_KEY', 'SB-Mid-server-mock');
        Config::$clientKey = env('MIDTRANS_CLIENT_KEY', 'SB-Mid-client-mock');
        Config::$isProduction = filter_var(env('MIDTRANS_IS_PRODUCTION', false), FILTER_VALIDATE_BOOLEAN);
        Config::$isSanitized = true;
        Config::$is3ds = true;
    }

    /**
     * Create snap token for a top-up transaction.
     */
    public function createSnapToken(Transaction $transaction, User $user): string
    {
        // For testing/local without real server key, return a mock token
        if (app()->environment('testing') || env('MIDTRANS_SERVER_KEY') === null || env('MIDTRANS_SERVER_KEY') === '') {
            return 'mock-snap-token-' . $transaction->transaction_code;
        }

        $params = [
            'transaction_details' => [
                'order_id' => $transaction->transaction_code,
                'gross_amount' => (int) $transaction->total,
            ],
            'customer_details' => [
                'first_name' => $user->name,
                'email' => $user->email,
                'phone' => $user->phone,
            ],
            'item_details' => [
                [
                    'id' => 'topup_saldo',
                    'price' => (int) $transaction->amount,
                    'quantity' => 1,
                    'name' => 'Top Up Saldo EZ Pay',
                ]
            ],
        ];

        try {
            return Snap::getSnapToken($params);
        } catch (\Exception $e) {
            Log::error("Midtrans Snap Token Exception: " . $e->getMessage());
            throw new \RuntimeException("Gagal membuat pembayaran Midtrans: " . $e->getMessage());
        }
    }

    /**
     * Validate Midtrans webhook signature key.
     */
    public function validateSignature(string $orderId, string $statusCode, string $grossAmount, string $receivedSignature): bool
    {
        $serverKey = env('MIDTRANS_SERVER_KEY', 'SB-Mid-server-mock');
        
        // Formulate signature components. Note: Midtrans gross_amount may be sent as float string, e.g. "50000.00"
        // Sometimes it needs formatting or matching exactly what Midtrans sent.
        // Convert to float/integer representation or match string.
        // To be safe, we match string format exactly as sent by Midtrans, or parse/format to 2 decimals if needed.
        $signatureSource = $orderId . $statusCode . $grossAmount . $serverKey;
        $calculatedSignature = hash('sha512', $signatureSource);

        return hash_equals($calculatedSignature, $receivedSignature);
    }
}
