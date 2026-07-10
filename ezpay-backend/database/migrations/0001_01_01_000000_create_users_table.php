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
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('firebase_uid', 128)->unique()->comment('UID dari Firebase Auth, sebagai penghubung');
            $table->string('name', 100)->comment('Nama lengkap pengguna');
            $table->string('email', 100)->unique()->comment('Email terdaftar');
            $table->string('phone', 20)->unique()->comment('Nomor handphone (format: 08xxx)');
            $table->string('nik', 20)->unique()->comment('Nomor Induk Kependudukan (16 digit)');
            $table->enum('gender', ['Laki-laki', 'Perempuan']);
            $table->string('profile_picture', 255)->nullable()->comment('URL/path foto profil');
            $table->string('pin', 255)->nullable()->comment('PIN transaksi (6 digit, hashed BCrypt)');
            $table->decimal('balance', 15, 2)->default(0.00)->comment('Saldo aktif pengguna (dalam Rupiah)');
            $table->enum('status', ['active', 'suspended', 'unverified'])->default('active');
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password')->nullable()->comment('Password backup / kompatibilitas auth');
            $table->rememberToken();
            $table->timestamps();

            $table->index('firebase_uid');
            $table->index('phone');
            $table->index('email');
            $table->index('status');
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('sessions');
    }
};
