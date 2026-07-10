<?php

use App\Http\Controllers\Admin\AdminAuthController;
use App\Http\Controllers\Admin\AdminDashboardController;
use Illuminate\Support\Facades\Route;

// Redirect / to admin login by default for easy presentation/access
Route::get('/', function () {
    return redirect()->route('admin.login');
});

// ─── Admin Authentication ───────────────────────────────────
Route::get('/admin/login', [AdminAuthController::class, 'showLogin'])->name('admin.login');
Route::post('/admin/login', [AdminAuthController::class, 'login']);
Route::post('/admin/logout', [AdminAuthController::class, 'logout'])->name('admin.logout');

// ─── Protected Admin Dashboard ──────────────────────────────
Route::middleware('admin.auth')->group(function () {
    
    // Overview Dashboard Home
    Route::get('/admin', [AdminDashboardController::class, 'index'])->name('admin.dashboard');

    // Manage Users
    Route::get('/admin/users', [AdminDashboardController::class, 'users'])->name('admin.users');
    Route::post('/admin/users/{id}/toggle', [AdminDashboardController::class, 'toggleUserStatus'])->name('admin.users.toggle');
    Route::post('/admin/users/{id}/add-balance', [AdminDashboardController::class, 'addBalance'])->name('admin.users.add-balance');

    // Transactions Log
    Route::get('/admin/transactions', [AdminDashboardController::class, 'transactions'])->name('admin.transactions');

    // Custom Notifications
    Route::get('/admin/notifications', [AdminDashboardController::class, 'showNotifications'])->name('admin.notifications.show');
    Route::post('/admin/notifications/send', [AdminDashboardController::class, 'sendNotification'])->name('admin.notifications.send');
});
