<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\Api\TopUpController;
use App\Http\Controllers\Api\FcmTokenController;
use App\Http\Controllers\Api\PpobController;
use Illuminate\Support\Facades\Route;

// ─── Public routes ───────────────────────────────────
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/webhooks/midtrans', [TopUpController::class, 'handleWebhook']);

// ─── Protected routes (requires Sanctum token) ──────
Route::middleware('auth:sanctum')->group(function () {

    // Auth & Profile
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // FCM Tokens
    Route::post('/fcm-token', [FcmTokenController::class, 'store']);

    // Saldo & Top Up
    Route::get('/saldo', [TransactionController::class, 'saldo']);
    Route::post('/topup', [TopUpController::class, 'initiate']);

    // PPOB
    Route::get('/ppob/categories', [PpobController::class, 'categories']);
    Route::get('/ppob/products', [PpobController::class, 'products']);
    Route::post('/ppob/purchase', [PpobController::class, 'purchase']);

    // Riwayat Transaksi
    Route::get('/transactions', [TransactionController::class, 'index']);
    Route::get('/transactions/{code}', [TransactionController::class, 'show']);

    // Transfer
    Route::post('/transfer/ezpay', [TransactionController::class, 'transferEzpay']);
    Route::post('/transfer/bank', [TransactionController::class, 'transferBank']);
    Route::post('/transfer/ewallet', [TransactionController::class, 'transferEwallet']);

    // Tarik Tunai
    Route::post('/tarik-tunai', [TransactionController::class, 'tarikTunai']);

    // PIN
    Route::post('/verify-pin', [TransactionController::class, 'verifyPinEndpoint']);
    Route::put('/change-pin', [TransactionController::class, 'changePin']);
});

