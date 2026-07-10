<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Create a Test User
        User::factory()->create([
            'name' => 'Test User',
            'email' => 'user@ezpay.id',
            'phone' => '081234567890',
            'nik' => '3171012345678901',
            'gender' => 'Laki-laki',
            'balance' => 500000.00, // Beri saldo awal 500rb untuk testing
        ]);

        // 2. Seed Product Categories
        $categories = [
            ['name' => 'Pulsa', 'slug' => 'pulsa', 'description' => 'Pembelian pulsa semua operator', 'sort_order' => 1, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Paket Data', 'slug' => 'paket-data', 'description' => 'Pembelian paket internet', 'sort_order' => 2, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Token Listrik', 'slug' => 'listrik', 'description' => 'Pembelian token listrik PLN Prabayar', 'sort_order' => 3, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'PDAM', 'slug' => 'pdam', 'description' => 'Pembayaran tagihan air PDAM', 'sort_order' => 4, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'BPJS Kesehatan', 'slug' => 'bpjs', 'description' => 'Pembayaran iuran BPJS Kesehatan', 'sort_order' => 5, 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Voucher Game', 'slug' => 'game', 'description' => 'Top up game online', 'sort_order' => 6, 'created_at' => now(), 'updated_at' => now()],
        ];
        \Illuminate\Support\Facades\DB::table('product_categories')->insert($categories);

        // Get Category IDs
        $pulsaId = \Illuminate\Support\Facades\DB::table('product_categories')->where('slug', 'pulsa')->value('id');
        $listrikId = \Illuminate\Support\Facades\DB::table('product_categories')->where('slug', 'listrik')->value('id');
        $gameId = \Illuminate\Support\Facades\DB::table('product_categories')->where('slug', 'game')->value('id');

        // 3. Seed Products
        $products = [
            // Pulsa
            ['category_id' => $pulsaId, 'product_code' => 'tsel5', 'product_name' => 'Telkomsel 5.000', 'provider' => 'Telkomsel', 'base_price' => 5500.00, 'sell_price' => 6000.00, 'admin_fee' => 0.00, 'created_at' => now(), 'updated_at' => now()],
            ['category_id' => $pulsaId, 'product_code' => 'tsel10', 'product_name' => 'Telkomsel 10.000', 'provider' => 'Telkomsel', 'base_price' => 10500.00, 'sell_price' => 11000.00, 'admin_fee' => 0.00, 'created_at' => now(), 'updated_at' => now()],
            ['category_id' => $pulsaId, 'product_code' => 'tsel20', 'product_name' => 'Telkomsel 20.000', 'provider' => 'Telkomsel', 'base_price' => 20200.00, 'sell_price' => 21000.00, 'admin_fee' => 0.00, 'created_at' => now(), 'updated_at' => now()],
            ['category_id' => $pulsaId, 'product_code' => 'tsel50', 'product_name' => 'Telkomsel 5.0000', 'provider' => 'Telkomsel', 'base_price' => 49500.00, 'sell_price' => 51000.00, 'admin_fee' => 0.00, 'created_at' => now(), 'updated_at' => now()],
            ['category_id' => $pulsaId, 'product_code' => 'tsel100', 'product_name' => 'Telkomsel 100.000', 'provider' => 'Telkomsel', 'base_price' => 98500.00, 'sell_price' => 100000.00, 'admin_fee' => 0.00, 'created_at' => now(), 'updated_at' => now()],
            // Token Listrik
            ['category_id' => $listrikId, 'product_code' => 'pln20', 'product_name' => 'Token Listrik 20.000', 'provider' => 'PLN', 'base_price' => 20500.00, 'sell_price' => 21000.00, 'admin_fee' => 1000.00, 'created_at' => now(), 'updated_at' => now()],
            ['category_id' => $listrikId, 'product_code' => 'pln50', 'product_name' => 'Token Listrik 50.000', 'provider' => 'PLN', 'base_price' => 50500.00, 'sell_price' => 51000.00, 'admin_fee' => 1000.00, 'created_at' => now(), 'updated_at' => now()],
            ['category_id' => $listrikId, 'product_code' => 'pln100', 'product_name' => 'Token Listrik 100.000', 'provider' => 'PLN', 'base_price' => 100500.00, 'sell_price' => 101000.00, 'admin_fee' => 1000.00, 'created_at' => now(), 'updated_at' => now()],
            // Voucher Game
            ['category_id' => $gameId, 'product_code' => 'ml86', 'product_name' => 'Mobile Legends 86 Diamonds', 'provider' => 'Moonton', 'base_price' => 18000.00, 'sell_price' => 20000.00, 'admin_fee' => 0.00, 'created_at' => now(), 'updated_at' => now()],
            ['category_id' => $gameId, 'product_code' => 'ml172', 'product_name' => 'Mobile Legends 172 Diamonds', 'provider' => 'Moonton', 'base_price' => 35000.00, 'sell_price' => 38000.00, 'admin_fee' => 0.00, 'created_at' => now(), 'updated_at' => now()],
            ['category_id' => $gameId, 'product_code' => 'ff100', 'product_name' => 'Free Fire 100 Diamonds', 'provider' => 'Garena', 'base_price' => 14000.00, 'sell_price' => 16000.00, 'admin_fee' => 0.00, 'created_at' => now(), 'updated_at' => now()],
        ];
        \Illuminate\Support\Facades\DB::table('products')->insert($products);

        // 4. Seed Merchants
        $merchants = [
            ['merchant_code' => 'ALF001', 'merchant_name' => 'Alfamart', 'merchant_type' => 'alfamart', 'created_at' => now(), 'updated_at' => now()],
            ['merchant_code' => 'IND001', 'merchant_name' => 'Indomaret', 'merchant_type' => 'indomaret', 'created_at' => now(), 'updated_at' => now()],
            ['merchant_code' => 'ALM001', 'merchant_name' => 'Alfamidi', 'merchant_type' => 'alfamidi', 'created_at' => now(), 'updated_at' => now()],
        ];
        \Illuminate\Support\Facades\DB::table('merchants')->insert($merchants);

        // 5. Seed App Settings
        $settings = [
            ['key' => 'min_topup_saldo', 'value' => '10000', 'description' => 'Minimal nominal top up saldo (Rp)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'max_topup_saldo', 'value' => '10000000', 'description' => 'Maksimal nominal top up saldo (Rp)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'min_transfer', 'value' => '10000', 'description' => 'Minimal nominal transfer (Rp)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'max_transfer', 'value' => '25000000', 'description' => 'Maksimal nominal transfer per transaksi (Rp)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'default_admin_fee_ewallet', 'value' => '1000', 'description' => 'Biaya admin default top up e-wallet (Rp)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'default_admin_fee_bank', 'value' => '2500', 'description' => 'Biaya admin transfer bank (Rp)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'min_withdrawal', 'value' => '50000', 'description' => 'Minimal tarik tunai (Rp)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'max_withdrawal', 'value' => '5000000', 'description' => 'Maksimal tarik tunai per hari (Rp)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'midtrans_server_key', 'value' => '', 'description' => 'Server key Midtrans (diisi di .env)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'digiflazz_username', 'value' => '', 'description' => 'Username Digiflazz (diisi di .env)', 'created_at' => now(), 'updated_at' => now()],
            ['key' => 'digiflazz_api_key', 'value' => '', 'description' => 'API key Digiflazz (diisi di .env)', 'created_at' => now(), 'updated_at' => now()],
        ];
        \Illuminate\Support\Facades\DB::table('app_settings')->insert($settings);

        // 6. Seed Admin Users
        \Illuminate\Support\Facades\DB::table('admin_users')->insert([
            'name' => 'Super Admin',
            'email' => 'admin@ezpay.id',
            'password' => \Illuminate\Support\Facades\Hash::make('admin123'), // Default Password
            'role' => 'super_admin',
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
