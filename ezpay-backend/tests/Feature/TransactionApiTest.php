<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class TransactionApiTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Helper: Create an authenticated user with balance and return user + token.
     */
    private function createAuthUser(float $balance = 500000, array $extra = []): array
    {
        $user = User::factory()->create(array_merge([
            'balance' => $balance,
            'pin' => Hash::make('123456'),
        ], $extra));

        $token = $user->createToken('test')->plainTextToken;

        return [$user, $token];
    }

    // ─── SALDO ────────────────────────────────────────

    public function test_user_can_check_saldo(): void
    {
        [$user, $token] = $this->createAuthUser(250000);

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$token}",
        ])->getJson('/api/saldo');

        $response->assertStatus(200)
                 ->assertJsonPath('success', true)
                 ->assertJsonPath('data.balance', '250000.00');
    }

    // ─── RIWAYAT TRANSAKSI ────────────────────────────

    public function test_user_can_get_empty_transaction_history(): void
    {
        [$user, $token] = $this->createAuthUser();

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$token}",
        ])->getJson('/api/transactions');

        $response->assertStatus(200)
                 ->assertJsonPath('success', true)
                 ->assertJsonPath('data.total', 0);
    }

    // ─── TRANSFER EZPAY (P2P) ─────────────────────────

    public function test_user_can_transfer_ezpay(): void
    {
        [$sender, $senderToken] = $this->createAuthUser(500000, [
            'phone' => '081111111111',
        ]);

        [$receiver, $_] = $this->createAuthUser(100000, [
            'phone' => '082222222222',
        ]);

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$senderToken}",
        ])->postJson('/api/transfer/ezpay', [
            'receiver_phone' => '082222222222',
            'amount' => 50000,
            'pin' => '123456',
            'note' => 'Bayar makan siang',
        ]);

        $response->assertStatus(200)
                 ->assertJsonPath('success', true)
                 ->assertJsonPath('data.type', 'transfer_ezpay')
                 ->assertJsonPath('data.status', 'success')
                 ->assertJsonPath('data.amount', '50000.00');

        // Verify balances updated
        $this->assertDatabaseHas('users', [
            'id' => $sender->id,
            'balance' => 450000.00,
        ]);

        $this->assertDatabaseHas('users', [
            'id' => $receiver->id,
            'balance' => 150000.00,
        ]);
    }

    public function test_transfer_ezpay_fails_with_insufficient_balance(): void
    {
        [$sender, $senderToken] = $this->createAuthUser(10000, [
            'phone' => '081111111111',
        ]);

        User::factory()->create(['phone' => '082222222222']);

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$senderToken}",
        ])->postJson('/api/transfer/ezpay', [
            'receiver_phone' => '082222222222',
            'amount' => 50000,
            'pin' => '123456',
        ]);

        $response->assertStatus(400)
                 ->assertJsonPath('success', false);
    }

    public function test_transfer_ezpay_fails_with_wrong_pin(): void
    {
        [$sender, $senderToken] = $this->createAuthUser(500000);
        User::factory()->create(['phone' => '082222222222']);

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$senderToken}",
        ])->postJson('/api/transfer/ezpay', [
            'receiver_phone' => '082222222222',
            'amount' => 50000,
            'pin' => '999999', // wrong PIN
        ]);

        $response->assertStatus(401)
                 ->assertJsonPath('code', 'INVALID_PIN');
    }

    // ─── TRANSFER BANK ───────────────────────────────

    public function test_user_can_transfer_bank(): void
    {
        [$user, $token] = $this->createAuthUser(500000);

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$token}",
        ])->postJson('/api/transfer/bank', [
            'amount' => 100000,
            'bank_code' => 'BCA',
            'bank_name' => 'Bank Central Asia',
            'account_number' => '1234567890',
            'account_holder_name' => 'John Doe',
            'pin' => '123456',
        ]);

        $response->assertStatus(200)
                 ->assertJsonPath('success', true)
                 ->assertJsonPath('data.type', 'transfer_bank')
                 ->assertJsonPath('data.status', 'processing');

        // Check balance reduced (amount + admin_fee 2500)
        $user->refresh();
        $this->assertEquals(397500, $user->balance);
    }

    // ─── TRANSFER E-WALLET ───────────────────────────

    public function test_user_can_transfer_ewallet(): void
    {
        [$user, $token] = $this->createAuthUser(500000);

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$token}",
        ])->postJson('/api/transfer/ewallet', [
            'amount' => 100000,
            'ewallet_name' => 'Dana',
            'account_number' => '081234567890',
            'account_holder_name' => 'Jane Doe',
            'pin' => '123456',
        ]);

        $response->assertStatus(200)
                 ->assertJsonPath('success', true)
                 ->assertJsonPath('data.type', 'transfer_ewallet')
                 ->assertJsonPath('data.status', 'processing');

        // Check balance reduced (amount + admin_fee 1000)
        $user->refresh();
        $this->assertEquals(399000, $user->balance);
    }

    // ─── TARIK TUNAI ─────────────────────────────────

    public function test_user_can_tarik_tunai(): void
    {
        [$user, $token] = $this->createAuthUser(500000);

        // Create merchant in test DB
        \Illuminate\Support\Facades\DB::table('merchants')->insert([
            'merchant_code' => 'ALF001',
            'merchant_name' => 'Alfamart',
            'merchant_type' => 'alfamart',
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$token}",
        ])->postJson('/api/tarik-tunai', [
            'amount' => 100000,
            'merchant_code' => 'ALF001',
            'pin' => '123456',
        ]);

        $response->assertStatus(200)
                 ->assertJsonPath('success', true)
                 ->assertJsonPath('data.type', 'tarik_tunai')
                 ->assertJsonPath('data.status', 'pending');

        // Check withdrawal code exists in detail
        $this->assertNotNull($response->json('data.detail.withdrawal_code'));

        // Check balance reduced
        $user->refresh();
        $this->assertEquals(400000, $user->balance);
    }

    // ─── VERIFY PIN ──────────────────────────────────

    public function test_verify_pin_correct(): void
    {
        [$user, $token] = $this->createAuthUser();

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$token}",
        ])->postJson('/api/verify-pin', ['pin' => '123456']);

        $response->assertStatus(200)
                 ->assertJsonPath('success', true);
    }

    public function test_verify_pin_wrong(): void
    {
        [$user, $token] = $this->createAuthUser();

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$token}",
        ])->postJson('/api/verify-pin', ['pin' => '000000']);

        $response->assertStatus(401)
                 ->assertJsonPath('success', false);
    }

    // ─── CHANGE PIN ──────────────────────────────────

    public function test_user_can_change_pin(): void
    {
        [$user, $token] = $this->createAuthUser();

        $response = $this->withHeaders([
            'Authorization' => "Bearer {$token}",
        ])->putJson('/api/change-pin', [
            'old_pin' => '123456',
            'new_pin' => '654321',
        ]);

        $response->assertStatus(200)
                 ->assertJsonPath('success', true);

        // Verify new PIN works
        $user->refresh();
        $this->assertTrue(Hash::check('654321', $user->pin));

        // Verify pin_histories has a record
        $this->assertDatabaseHas('pin_histories', [
            'user_id' => $user->id,
        ]);
    }

    // ─── TRANSACTION DETAIL (SHOW) ───────────────────

    public function test_user_can_view_transaction_detail(): void
    {
        [$sender, $senderToken] = $this->createAuthUser(500000, [
            'phone' => '081111111111',
        ]);

        [$receiver, $_] = $this->createAuthUser(100000, [
            'phone' => '082222222222',
        ]);

        // Do a transfer first
        $transferResponse = $this->withHeaders([
            'Authorization' => "Bearer {$senderToken}",
        ])->postJson('/api/transfer/ezpay', [
            'receiver_phone' => '082222222222',
            'amount' => 25000,
            'pin' => '123456',
        ]);

        $trxCode = $transferResponse->json('data.transaction_code');

        // Fetch detail
        $response = $this->withHeaders([
            'Authorization' => "Bearer {$senderToken}",
        ])->getJson("/api/transactions/{$trxCode}");

        $response->assertStatus(200)
                 ->assertJsonPath('success', true)
                 ->assertJsonPath('data.transaction_code', $trxCode)
                 ->assertJsonPath('data.type', 'transfer_ezpay');
    }
}
