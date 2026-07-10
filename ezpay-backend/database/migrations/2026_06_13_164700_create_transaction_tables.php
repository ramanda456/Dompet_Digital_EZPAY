<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. transactions
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->string('transaction_code', 50)->unique()->comment('Kode unik: TRX-YYYYMMDD-XXXXXX');
            $table->string('reference_id', 100)->nullable()->comment('ID referensi dari provider eksternal');
            
            $table->foreignId('sender_id')->nullable()->constrained('users')->onDelete('set null');
            $table->foreignId('receiver_id')->nullable()->constrained('users')->onDelete('set null');
            $table->foreignId('merchant_id')->nullable()->constrained('merchants')->onDelete('set null');

            $table->enum('type', [
                'top_up_saldo',
                'transfer_bank',
                'transfer_ewallet',
                'transfer_ezpay',
                'tarik_tunai',
                'beli_pulsa',
                'beli_paket_data',
                'bayar_listrik',
                'bayar_pdam',
                'bayar_bpjs',
                'top_up_game'
            ])->comment('Jenis transaksi');

            $table->decimal('amount', 15, 2)->comment('Nominal transaksi (harga pokok)');
            $table->decimal('admin_fee', 10, 2)->default(0.00)->comment('Biaya admin');
            $table->decimal('total', 15, 2)->comment('Total = amount + admin_fee');

            $table->enum('status', ['pending', 'processing', 'success', 'failed', 'cancelled', 'refunded'])->default('pending');
            $table->string('payment_method', 50)->nullable()->comment('Metode bayar: va_bca, gopay, ewallet_saldo, saldo_ezpay, tunai');
            $table->string('note', 255)->nullable()->comment('Catatan transaksi dari user');
            $table->string('failed_reason', 255)->nullable()->comment('Alasan gagal (jika status = failed)');

            $table->decimal('sender_balance_before', 15, 2)->nullable()->comment('Saldo pengirim sebelum transaksi');
            $table->decimal('sender_balance_after', 15, 2)->nullable()->comment('Saldo pengirim setelah transaksi');
            $table->decimal('receiver_balance_before', 15, 2)->nullable()->comment('Saldo penerima sebelum transaksi');
            $table->decimal('receiver_balance_after', 15, 2)->nullable()->comment('Saldo penerima setelah transaksi');

            $table->timestamps();

            $table->index('sender_id');
            $table->index('receiver_id');
            $table->index('type');
            $table->index('status');
            $table->index('created_at');
            $table->index('transaction_code');
        });

        // 2. transaction_details
        Schema::create('transaction_details', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaction_id')->constrained('transactions')->onDelete('cascade');
            
            // Untuk PPOB (Pulsa, Data, Listrik, PDAM, BPJS, Game)
            $table->foreignId('product_id')->nullable()->constrained('products')->onDelete('set null');
            $table->string('target_number', 100)->nullable()->comment('No HP / ID Pelanggan PLN / No BPJS / ID Game');
            $table->string('target_name', 100)->nullable()->comment('Nama pemilik (dari cek tagihan)');
            $table->string('serial_number', 255)->nullable()->comment('SN pulsa / Token listrik 20-digit');
            $table->string('provider_ref', 100)->nullable()->comment('Ref ID dari Digiflazz/provider');

            // Untuk Transfer Bank / E-Wallet
            $table->string('bank_code', 10)->nullable()->comment('Kode bank tujuan');
            $table->string('bank_name', 50)->nullable()->comment('Nama bank/e-wallet tujuan');
            $table->string('account_number', 50)->nullable()->comment('No rekening / No e-wallet tujuan');
            $table->string('account_holder_name', 100)->nullable()->comment('Nama pemilik rekening/e-wallet');

            // Untuk Tarik Tunai
            $table->string('merchant_code', 30)->nullable()->comment('Kode gerai merchant');
            $table->string('withdrawal_code', 20)->nullable()->comment('Kode tarik tunai (ditunjukkan ke kasir)');

            // Untuk Top Up Saldo
            $table->string('va_number', 50)->nullable()->comment('Nomor Virtual Account');
            $table->string('payment_url', 512)->nullable()->comment('URL pembayaran Midtrans Snap');

            $table->timestamps();

            $table->index('transaction_id');
        });

        // 3. payment_gateway_logs
        Schema::create('payment_gateway_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('transaction_id')->constrained('transactions')->onDelete('cascade');
            $table->string('gateway', 30)->default('midtrans');
            $table->string('event_type', 50)->comment('create_transaction, notification, callback, dll');
            $table->json('request_body')->nullable();
            $table->json('response_body')->nullable();
            $table->integer('http_status')->nullable();
            $table->timestamps();

            $table->index('transaction_id');
            $table->index('event_type');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payment_gateway_logs');
        Schema::dropIfExists('transaction_details');
        Schema::dropIfExists('transactions');
    }
};
