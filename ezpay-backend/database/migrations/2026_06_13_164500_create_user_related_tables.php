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
        // 1. user_fcm_tokens
        Schema::create('user_fcm_tokens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('fcm_token', 512)->comment('Token FCM dari Firebase Messaging');
            $table->string('device_info', 255)->nullable()->comment('Info device (model, OS version)');
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->unique(['user_id', 'fcm_token']);
            $table->index('user_id');
        });

        // 2. user_bank_accounts
        Schema::create('user_bank_accounts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('bank_code', 10)->comment('Kode bank: BSI, BNI, BRI, BCA, dll');
            $table->string('bank_name', 50)->comment('Nama bank lengkap');
            $table->string('account_number', 30)->comment('Nomor rekening');
            $table->string('account_holder_name', 100)->comment('Nama pemilik rekening');
            $table->boolean('is_verified')->default(false);
            $table->timestamps();

            $table->index('user_id');
        });

        // 3. pin_histories
        Schema::create('pin_histories', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('old_pin', 255)->nullable()->comment('PIN lama (hashed)');
            $table->string('new_pin', 255)->comment('PIN baru (hashed)');
            $table->timestamp('changed_at')->useCurrent();

            $table->index('user_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pin_histories');
        Schema::dropIfExists('user_bank_accounts');
        Schema::dropIfExists('user_fcm_tokens');
    }
};
