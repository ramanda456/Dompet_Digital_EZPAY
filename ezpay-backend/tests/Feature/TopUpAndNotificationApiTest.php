<?php

namespace Tests\Feature;

use App\Models\Transaction;
use App\Models\User;
use App\Models\UserFcmToken;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class TopUpAndNotificationApiTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
    }

    /**
     * Test storing FCM Token.
     */
    public function test_store_fcm_token()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)
            ->postJson('/api/fcm-token', [
                'fcm_token' => 'mock-fcm-token-123',
                'device_info' => 'iPhone 15 Pro, iOS 17.2',
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'FCM Token berhasil disimpan',
            ]);

        $this->assertDatabaseHas('user_fcm_tokens', [
            'user_id' => $user->id,
            'fcm_token' => 'mock-fcm-token-123',
            'device_info' => 'iPhone 15 Pro, iOS 17.2',
            'is_active' => true,
        ]);
    }

    /**
     * Test initiating top up.
     */
    public function test_initiate_top_up()
    {
        $user = User::factory()->create([
            'balance' => 0,
        ]);

        $response = $this->actingAs($user)
            ->postJson('/api/topup', [
                'amount' => 50000,
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Top up berhasil diinisiasi',
            ])
            ->assertJsonStructure([
                'data' => [
                    'transaction_code',
                    'amount',
                    'admin_fee',
                    'total',
                    'status',
                    'snap_token',
                    'redirect_url',
                ]
            ]);

        $this->assertDatabaseHas('transactions', [
            'sender_id' => $user->id,
            'type' => 'top_up_saldo',
            'amount' => 50000.00,
            'status' => 'pending',
        ]);
    }

    /**
     * Test successful Midtrans Webhook callback.
     */
    public function test_midtrans_webhook_success()
    {
        $user = User::factory()->create([
            'balance' => 10000.00,
        ]);

        $transaction = Transaction::create([
            'transaction_code' => 'TRX-20260616-TOPUP1',
            'sender_id' => $user->id,
            'type' => 'top_up_saldo',
            'amount' => 50000.00,
            'admin_fee' => 0,
            'total' => 50000.00,
            'status' => 'pending',
        ]);

        // Calculate valid signature key: SHA512(order_id + status_code + gross_amount + ServerKey)
        $orderId = $transaction->transaction_code;
        $statusCode = '200';
        $grossAmount = '50000.00';
        $serverKey = env('MIDTRANS_SERVER_KEY', 'SB-Mid-server-mock');
        $signatureKey = hash('sha512', $orderId . $statusCode . $grossAmount . $serverKey);

        $payload = [
            'order_id' => $orderId,
            'status_code' => $statusCode,
            'gross_amount' => $grossAmount,
            'signature_key' => $signatureKey,
            'transaction_status' => 'settlement',
            'payment_type' => 'gopay',
            'fraud_status' => 'accept',
        ];

        $response = $this->postJson('/api/webhooks/midtrans', $payload);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Status transaksi berhasil diperbarui',
            ]);

        // Assert transaction status updated to success
        $this->assertDatabaseHas('transactions', [
            'id' => $transaction->id,
            'status' => 'success',
            'payment_method' => 'gopay',
            'sender_balance_before' => 10000.00,
            'sender_balance_after' => 60000.00,
        ]);

        // Assert user balance is incremented
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'balance' => 60000.00,
        ]);
    }

    /**
     * Test failed Midtrans Webhook callback.
     */
    public function test_midtrans_webhook_failure()
    {
        $user = User::factory()->create([
            'balance' => 10000.00,
        ]);

        $transaction = Transaction::create([
            'transaction_code' => 'TRX-20260616-TOPUP2',
            'sender_id' => $user->id,
            'type' => 'top_up_saldo',
            'amount' => 50000.00,
            'admin_fee' => 0,
            'total' => 50000.00,
            'status' => 'pending',
        ]);

        $orderId = $transaction->transaction_code;
        $statusCode = '407'; // Example status code for expire/cancel
        $grossAmount = '50000.00';
        $serverKey = env('MIDTRANS_SERVER_KEY', 'SB-Mid-server-mock');
        $signatureKey = hash('sha512', $orderId . $statusCode . $grossAmount . $serverKey);

        $payload = [
            'order_id' => $orderId,
            'status_code' => $statusCode,
            'gross_amount' => $grossAmount,
            'signature_key' => $signatureKey,
            'transaction_status' => 'expire',
            'payment_type' => 'bank_transfer',
        ];

        $response = $this->postJson('/api/webhooks/midtrans', $payload);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Status transaksi berhasil diperbarui',
            ]);

        // Assert transaction status updated to failed
        $this->assertDatabaseHas('transactions', [
            'id' => $transaction->id,
            'status' => 'failed',
            'payment_method' => 'bank_transfer',
        ]);

        // Assert user balance remains the same
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'balance' => 10000.00,
        ]);
    }

    /**
     * Test invalid signature callback is rejected.
     */
    public function test_midtrans_webhook_invalid_signature()
    {
        $user = User::factory()->create();

        $transaction = Transaction::create([
            'transaction_code' => 'TRX-20260616-TOPUP3',
            'sender_id' => $user->id,
            'type' => 'top_up_saldo',
            'amount' => 50000.00,
            'admin_fee' => 0,
            'total' => 50000.00,
            'status' => 'pending',
        ]);

        $payload = [
            'order_id' => $transaction->transaction_code,
            'status_code' => '200',
            'gross_amount' => '50000.00',
            'signature_key' => 'invalid-signature-key-123456',
            'transaction_status' => 'settlement',
        ];

        $response = $this->postJson('/api/webhooks/midtrans', $payload);

        $response->assertStatus(403)
            ->assertJson([
                'success' => false,
                'message' => 'Signature key tidak valid',
            ]);

        // Assert transaction status remains pending
        $this->assertDatabaseHas('transactions', [
            'id' => $transaction->id,
            'status' => 'pending',
        ]);
    }
}
