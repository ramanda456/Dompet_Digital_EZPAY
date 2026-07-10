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
        // 1. product_categories
        Schema::create('product_categories', function (Blueprint $table) {
            $table->id();
            $table->string('name', 50)->comment('Nama kategori: Pulsa, Paket Data, Token Listrik, dll');
            $table->string('slug', 50)->unique()->comment('Slug URL: pulsa, paket-data, listrik, dll');
            $table->string('icon', 255)->nullable()->comment('Path/URL ikon kategori');
            $table->text('description')->nullable();
            $table->boolean('is_active')->default(true);
            $table->integer('sort_order')->default(0)->comment('Urutan tampil di menu');
            $table->timestamps();
        });

        // 2. products
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->foreignId('category_id')->constrained('product_categories')->onDelete('restrict');
            $table->string('product_code', 50)->unique()->comment('Kode produk dari provider PPOB (Digiflazz buyer_sku_code)');
            $table->string('product_name', 150)->comment('Nama produk: Telkomsel 10.000, Token PLN 50.000, dll');
            $table->string('provider', 50)->comment('Operator/provider: Telkomsel, PLN, PDAM, Garena, dll');
            $table->decimal('base_price', 15, 2)->comment('Harga beli dari provider (modal)');
            $table->decimal('sell_price', 15, 2)->comment('Harga jual ke user (termasuk margin)');
            $table->decimal('admin_fee', 10, 2)->default(0.00)->comment('Biaya admin terpisah (jika ada)');
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index('category_id');
            $table->index('provider');
            $table->index('product_code');
        });

        // 3. merchants
        Schema::create('merchants', function (Blueprint $table) {
            $table->id();
            $table->string('merchant_code', 30)->unique()->comment('Kode unik merchant');
            $table->string('merchant_name', 100)->comment('Nama gerai: Alfamart Jl. Sudirman');
            $table->string('merchant_type', 50)->comment('Tipe: alfamart, indomaret, alfamidi');
            $table->text('address')->nullable();
            $table->string('phone', 20)->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index('merchant_type');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('merchants');
        Schema::dropIfExists('products');
        Schema::dropIfExists('product_categories');
    }
};
