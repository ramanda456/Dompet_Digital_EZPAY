<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\User;
use App\Services\NotificationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class AdminDashboardController extends Controller
{
    protected NotificationService $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    /**
     * Dashboard Home Overview
     */
    public function index()
    {
        $stats = [
            'total_users' => User::count(),
            'total_balance' => User::sum('balance'),
            'total_transactions' => Transaction::count(),
            'total_revenue' => Transaction::where('status', 'success')->sum('admin_fee'),
        ];

        $recentTransactions = Transaction::with(['sender', 'receiver'])
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        return view('admin.index', compact('stats', 'recentTransactions'));
    }

    /**
     * Manage Users
     */
    public function users(Request $request)
    {
        $search = $request->query('search');

        $query = User::query();

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        $users = $query->orderBy('created_at', 'desc')->paginate(10);

        return view('admin.users', compact('users', 'search'));
    }

    /**
     * Suspend/Activate User
     */
    public function toggleUserStatus($id)
    {
        $user = User::findOrFail($id);
        $newStatus = $user->status === 'active' ? 'suspended' : 'active';
        
        $user->update(['status' => $newStatus]);

        $message = "Status pengguna {$user->name} berhasil diubah menjadi " . ucfirst($newStatus);
        return back()->with('success', $message);
    }

    /**
     * Direct Top Up / Add Balance (Useful for UAS presentations)
     */
    public function addBalance(Request $request, $id)
    {
        $request->validate([
            'amount' => 'required|numeric|min:1000',
        ]);

        $user = User::findOrFail($id);
        $amount = (float) $request->amount;

        try {
            DB::transaction(function () use ($user, $amount) {
                $user = User::where('id', $user->id)->lockForUpdate()->first();
                $balanceBefore = $user->balance;
                
                $user->increment('balance', $amount);
                $balanceAfter = $balanceBefore + $amount;

                // Create a manual top up transaction record
                Transaction::create([
                    'transaction_code' => Transaction::generateCode(),
                    'sender_id' => $user->id,
                    'type' => 'top_up_saldo',
                    'amount' => $amount,
                    'admin_fee' => 0,
                    'total' => $amount,
                    'status' => 'success',
                    'payment_method' => 'admin_manual',
                    'note' => 'Top Up Manual oleh Admin Dashboard',
                    'sender_balance_before' => $balanceBefore,
                    'sender_balance_after' => $balanceAfter,
                ]);
            });

            // Send notification
            try {
                $amountFormatted = number_format($amount, 0, ',', '.');
                $this->notificationService->sendNotification(
                    $user->id,
                    'Saldo Ditambahkan',
                    "Admin telah menambahkan saldo sebesar Rp {$amountFormatted} ke akun Anda."
                );
            } catch (\Exception $e) {
                Log::error("Failed to send manual top-up FCM notification: " . $e->getMessage());
            }

            return back()->with('success', "Saldo sebesar Rp " . number_format($amount, 0, ',', '.') . " berhasil ditambahkan ke " . $user->name);

        } catch (\Exception $e) {
            Log::error("Admin Add Balance Error: " . $e->getMessage());
            return back()->with('error', "Gagal menambah saldo: " . $e->getMessage());
        }
    }

    /**
     * View Transactions
     */
    public function transactions(Request $request)
    {
        $type = $request->query('type');
        $status = $request->query('status');

        $query = Transaction::with(['sender', 'receiver']);

        if ($type) {
            $query->where('type', $type);
        }

        if ($status) {
            $query->where('status', $status);
        }

        $transactions = $query->orderBy('created_at', 'desc')->paginate(15);

        return view('admin.transactions', compact('transactions', 'type', 'status'));
    }

    /**
     * Form Notifications
     */
    public function showNotifications()
    {
        $users = User::orderBy('name', 'asc')->get();
        return view('admin.notifications', compact('users'));
    }

    /**
     * Send Custom Push Notification
     */
    public function sendNotification(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:100',
            'body' => 'required|string',
            'target_user' => 'required|string',
        ]);

        $target = $request->target_user;
        $title = $request->title;
        $body = $request->body;

        if ($target === 'all') {
            $userIds = User::pluck('id')->toArray();
        } else {
            $userIds = [(int) $target];
        }

        if (empty($userIds)) {
            return back()->with('error', 'Tidak ada target user untuk dikirimkan notifikasi.');
        }

        $result = $this->notificationService->sendNotification($userIds, $title, $body, ['type' => 'broadcast']);

        $message = "Notifikasi terkirim: {$result['success']} sukses, {$result['failed']} gagal.";
        return back()->with('success', $message);
    }
}
