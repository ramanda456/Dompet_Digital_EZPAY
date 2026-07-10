<?php

namespace Tests\Feature;

use App\Models\Product;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class PpobApiTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        // Seed database to populate product categories and products
        $this->seed();
    }

    /**
     * Test listing product categories.
     */
    public function test_get_categories()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)
            ->getJson('/api/ppob/categories');

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
            ])
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'name',
                        'slug',
                        'is_active',
                    ]
                ]
            ]);
    }

    /**
     * Test listing products.
     */
    public function test_get_products()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)
            ->getJson('/api/ppob/products?category=pulsa');

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
            ])
            ->assertJsonStructure([
                'data' => [
                    '*' => [
                        'id',
                        'category_id',
                        'product_code',
                        'product_name',
                        'sell_price',
                    ]
                ]
            ]);
    }

    /**
     * Test successful purchase of Pulsa.
     */
    public function test_purchase_pulsa_success()
    {
        $user = User::factory()->create([
            'balance' => 50000.00,
            'pin' => Hash::make('123456'),
        ]);

        // "tsel10" costs Rp 11.000 (sell_price) and 0 admin_fee (total = 11000)
        $product = Product::where('product_code', 'tsel10')->first();
        $this->assertNotNull($product);

        $response = $this->actingAs($user)
            ->postJson('/api/ppob/purchase', [
                'product_code' => 'tsel10',
                'target_number' => '081234567890',
                'pin' => '123456',
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Transaksi PPOB berhasil diproses',
                'data' => [
                    'product_name' => 'Telkomsel 10.000',
                    'target_number' => '081234567890',
                    'amount' => 11000.00,
                    'admin_fee' => 0.00,
                    'total' => 11000.00,
                    'status' => 'success',
                ]
            ]);

        // Assert database updates
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'balance' => 39000.00, // 50000 - 11000
        ]);

        $this->assertDatabaseHas('transactions', [
            'sender_id' => $user->id,
            'type' => 'beli_pulsa',
            'amount' => 11000.00,
            'total' => 11000.00,
            'status' => 'success',
        ]);
    }

    /**
     * Test purchase failed due to incorrect PIN.
     */
    public function test_purchase_failed_wrong_pin()
    {
        $user = User::factory()->create([
            'balance' => 50000.00,
            'pin' => Hash::make('123456'),
        ]);

        $response = $this->actingAs($user)
            ->postJson('/api/ppob/purchase', [
                'product_code' => 'tsel10',
                'target_number' => '081234567890',
                'pin' => '654321', // Wrong PIN
            ]);

        $response->assertStatus(403)
            ->assertJson([
                'success' => false,
                'message' => 'PIN transaksi salah',
            ]);

        // Assert balance unchanged
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'balance' => 50000.00,
        ]);
    }

    /**
     * Test purchase failed due to insufficient balance.
     */
    public function test_purchase_failed_insufficient_balance()
    {
        $user = User::factory()->create([
            'balance' => 5000.00, // Insufficient (needed 11000)
            'pin' => Hash::make('123456'),
        ]);

        $response = $this->actingAs($user)
            ->postJson('/api/ppob/purchase', [
                'product_code' => 'tsel10',
                'target_number' => '081234567890',
                'pin' => '123456',
            ]);

        $response->assertStatus(500)
            ->assertJson([
                'success' => false,
                'message' => 'Saldo tidak mencukupi (termasuk biaya admin)',
            ]);

        // Assert balance unchanged
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'balance' => 5000.00,
        ]);
    }

    /**
     * Test token pln formatting.
     */
    public function test_purchase_listrik_success_generates_pln_token()
    {
        $user = User::factory()->create([
            'balance' => 100000.00,
            'pin' => Hash::make('123456'),
        ]);

        // "pln50" costs sell_price 51000 + admin_fee 1000 (total = 52000)
        $response = $this->actingAs($user)
            ->postJson('/api/ppob/purchase', [
                'product_code' => 'pln50',
                'target_number' => '14023948574',
                'pin' => '123456',
            ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'product_name' => 'Token Listrik 50.000',
                    'target_number' => '14023948574',
                    'amount' => 51000.00,
                    'admin_fee' => 1000.00,
                    'total' => 52000.00,
                    'status' => 'success',
                ]
            ]);

        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'balance' => 48000.00, // 100000 - 52000
        ]);

        // Retrieve transaction and detail
        $transaction = \App\Models\Transaction::where('sender_id', $user->id)->where('type', 'bayar_listrik')->first();
        $this->assertNotNull($transaction);
        
        $detail = $transaction->detail;
        $this->assertNotNull($detail);
        $this->assertNotNull($detail->target_name);
        
        // Assert serial number is 20-digit PLN token format (4-4-4-4-4 separated by hyphens)
        // Length should be 20 digits + 4 hyphens = 24 characters
        $this->assertEquals(24, strlen($detail->serial_number));
        $this->assertMatchesRegularExpression('/^\d{4}-\d{4}-\d{4}-\d{4}-\d{4}$/', $detail->serial_number);
    }
}
