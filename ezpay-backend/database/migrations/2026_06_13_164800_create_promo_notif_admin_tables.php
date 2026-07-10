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
        // 1. notifications
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('title', 150)->comment('Judul notifikasi');
            $table->text('message')->comment('Isi pesan');
            $table->enum('type', ['transaction', 'promo', 'system', 'security'])->default('system');
            $table->json('data_json')->nullable()->comment('Payload data tambahan');
            $table->boolean('is_read')->default(false);
            $table->boolean('is_pushed')->default(false)->comment('Apakah sudah dikirim via FCM');
            $table->timestamp('read_at')->nullable();
            $table->timestamps();

            $table->index('user_id');
            $table->index('is_read');
            $table->index('created_at');
        });

        // 2. promos
        Schema::create('promos', function (Blueprint $table) {
            $table->id();
            $table->string('title', 150);
            $table->text('description');
            $table->string('image_url', 255)->comment('URL gambar banner');
            $table->string('promo_code', 50)->nullable()->unique()->comment('Kode promo (opsional)');
            $table->enum('discount_type', ['percentage', 'fixed'])->default('fixed');
            $table->decimal('discount_value', 15, 2)->default(0.00)->comment('Nilai diskon (% atau Rp)');
            $table->decimal('min_transaction', 15, 2)->default(0.00)->comment('Minimal nominal transaksi');
            $table->decimal('max_discount', 15, 2)->default(0.00)->comment('Maksimal potongan diskon');
            $table->integer('quota')->nullable()->comment('Kuota pemakaian (null = unlimited)');
            $table->integer('used_count')->default(0);
            $table->dateTime('start_date');
            $table->dateTime('end_date');
            $table->enum('status', ['active', 'inactive', 'expired'])->default('active');
            $table->timestamps();

            $table->index('status');
            $table->index(['start_date', 'end_date']);
        });

        // 3. promo_usages
        Schema::create('promo_usages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('promo_id')->constrained('promos')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('transaction_id')->nullable()->constrained('transactions')->onDelete('set null');
            $table->decimal('discount_applied', 15, 2)->comment('Nominal diskon yang diterapkan');
            $table->timestamp('used_at')->useCurrent();

            $table->unique(['user_id', 'promo_id']);
            $table->index('promo_id');
        });

        // 4. admin_users
        Schema::create('admin_users', function (Blueprint $table) {
            $table->id();
            $table->string('name', 100);
            $table->string('email', 100)->unique();
            $table->string('password', 255)->comment('Hashed password (BCrypt)');
            $table->enum('role', ['super_admin', 'admin', 'operator', 'viewer'])->default('admin');
            $table->boolean('is_active')->default(true);
            $table->timestamp('last_login_at')->nullable();
            $table->timestamps();

            $table->index('email');
            $table->index('role');
        });

        // 5. admin_activity_logs
        Schema::create('admin_activity_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('admin_id')->constrained('admin_users')->onDelete('cascade');
            $table->string('action', 100)->comment('Contoh: suspend_user, approve_withdrawal, update_product');
            $table->string('target_type', 50)->nullable()->comment('Model target: User, Transaction, Product');
            $table->unsignedBigInteger('target_id')->nullable()->comment('ID target yang dioperasikan');
            $table->json('details')->nullable()->comment('Detail perubahan (old/new values)');
            $table->string('ip_address', 45)->nullable();
            $table->timestamps();

            $table->index('admin_id');
            $table->index('action');
            $table->index('created_at');
        });

        // 6. app_settings
        Schema::create('app_settings', function (Blueprint $table) {
            $table->id();
            $table->string('key', 100)->unique()->comment('Contoh: default_admin_fee, min_topup, max_transfer');
            $table->text('value');
            $table->string('description', 255)->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('app_settings');
        Schema::dropIfExists('admin_activity_logs');
        Schema::dropIfExists('admin_users');
        Schema::dropIfExists('promo_usages');
        Schema::dropIfExists('promos');
        Schema::dropIfExists('notifications');
    }
};
