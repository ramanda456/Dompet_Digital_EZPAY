<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\ProductCategory;
use App\Models\Transaction;
use App\Models\TransactionDetail;
use App\Models\User;
use App\Services\NotificationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Validator;

class PpobController extends Controller
{
    protected NotificationService $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    /**
     * Process PPOB purchase (Simulated)
     */
    public function purchase(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'product_code' => 'required|string|exists:products,product_code',
            'target_number' => 'required|string|min:5|max:100',
            'pin' => 'required|string|digits:6',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $user = $request->user();

        // 1. Verify PIN
        if (!$user->pin || !Hash::check($request->pin, $user->pin)) {
            return response()->json([
                'success' => false,
                'message' => 'PIN transaksi salah',
            ], 403);
        }

        // 2. Retrieve Product details
        $product = Product::where('product_code', $request->product_code)
            ->where('is_active', true)
            ->first();

        if (!$product) {
            return response()->json([
                'success' => false,
                'message' => 'Produk tidak ditemukan atau tidak aktif',
            ], 404);
        }

        // 3. Determine transaction type based on category
        $categorySlug = DB::table('product_categories')
            ->where('id', $product->category_id)
            ->value('slug');

        $type = match ($categorySlug) {
            'pulsa' => 'beli_pulsa',
            'paket-data' => 'beli_paket_data',
            'listrik' => 'bayar_listrik',
            'pdam' => 'bayar_pdam',
            'bpjs' => 'bayar_bpjs',
            'game' => 'top_up_game',
            default => 'beli_pulsa'
        };

        $amount = (float) $product->sell_price;
        $adminFee = (float) $product->admin_fee;
        $total = $amount + $adminFee;

        // 4. Execute Transaction
        try {
            $serialNumber = $this->generateMockSerialNumber($categorySlug);
            $targetName = $this->getMockCustomerName($request->target_number, $categorySlug);

            $transaction = DB::transaction(function () use ($user, $product, $type, $amount, $adminFee, $total, $request, $serialNumber, $targetName) {
                // Lock user balance
                $user = User::where('id', $user->id)->lockForUpdate()->first();

                if ($user->balance < $total) {
                    throw new \RuntimeException('Saldo tidak mencukupi (termasuk biaya admin)');
                }

                $balanceBefore = $user->balance;
                $user->decrement('balance', $total);
                $balanceAfter = $balanceBefore - $total;

                // Create transaction
                $trx = Transaction::create([
                    'transaction_code' => Transaction::generateCode(),
                    'sender_id' => $user->id,
                    'type' => $type,
                    'amount' => $amount,
                    'admin_fee' => $adminFee,
                    'total' => $total,
                    'status' => 'success',
                    'payment_method' => 'saldo_ezpay',
                    'note' => "Pembelian {$product->product_name} ke {$request->target_number}",
                    'sender_balance_before' => $balanceBefore,
                    'sender_balance_after' => $balanceAfter,
                ]);

                // Create transaction detail
                TransactionDetail::create([
                    'transaction_id' => $trx->id,
                    'product_id' => $product->id,
                    'target_number' => $request->target_number,
                    'target_name' => $targetName,
                    'serial_number' => $serialNumber,
                    'provider_ref' => 'MOCK-PPOB-' . time() . '-' . rand(1000, 9999),
                ]);

                return $trx;
            });

            // Load relations
            $transaction->load('detail');

            // 5. Send FCM Notification
            try {
                $productName = $product->product_name;
                $msgBody = "Pembelian {$productName} ke {$request->target_number} berhasil.";
                if ($categorySlug === 'listrik') {
                    $msgBody .= " Token Listrik Anda: {$serialNumber}";
                } elseif ($serialNumber) {
                    $msgBody .= " SN: {$serialNumber}";
                }

                $this->notificationService->sendNotification(
                    $transaction->sender_id,
                    'Transaksi PPOB Berhasil',
                    $msgBody,
                    ['transaction_code' => $transaction->transaction_code, 'type' => $type]
                );
            } catch (\Exception $e) {
                Log::error("Failed to send PPOB FCM Notification: " . $e->getMessage());
            }

            return response()->json([
                'success' => true,
                'message' => 'Transaksi PPOB berhasil diproses',
                'data' => [
                    'transaction_code' => $transaction->transaction_code,
                    'product_name' => $product->product_name,
                    'target_number' => $request->target_number,
                    'target_name' => $targetName,
                    'amount' => $transaction->amount,
                    'admin_fee' => $transaction->admin_fee,
                    'total' => $transaction->total,
                    'status' => $transaction->status,
                    'serial_number' => $serialNumber,
                    'created_at' => $transaction->created_at,
                ],
            ]);

        } catch (\Exception $e) {
            Log::error("PPOB Transaction Error: " . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Get list of active categories
     */
    public function categories()
    {
        $categories = DB::table('product_categories')
            ->where('is_active', true)
            ->orderBy('sort_order', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $categories,
        ]);
    }

    /**
     * Get products in a category
     */
    public function products(Request $request)
    {
        $categorySlug = $request->query('category');
        
        $query = Product::where('is_active', true);

        if ($categorySlug) {
            $categoryId = DB::table('product_categories')
                ->where('slug', $categorySlug)
                ->value('id');
            if ($categoryId) {
                $query->where('category_id', $categoryId);
            }
        }

        $products = $query->orderBy('sell_price', 'asc')->get();

        return response()->json([
            'success' => true,
            'data' => $products,
        ]);
    }

    /**
     * Generate simulated Serial Number or Token.
     */
    private function generateMockSerialNumber(string $categorySlug): string
    {
        if ($categorySlug === 'listrik') {
            // Token PLN 20 digits
            $parts = [];
            for ($i = 0; $i < 5; $i++) {
                $parts[] = str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT);
            }
            return implode('-', $parts);
        }

        if ($categorySlug === 'bpjs') {
            return 'BPJS-PAID-' . now()->format('Ymd') . rand(1000, 9999);
        }

        if ($categorySlug === 'pdam') {
            return 'PDAM-PAID-' . now()->format('Ymd') . rand(1000, 9999);
        }

        // Default serial number for pulsa/data/game
        return 'SN' . now()->format('ymdHms') . rand(10, 99);
    }

    /**
     * Generate simulated Customer Name for token/tagihan checks.
     */
    private function getMockCustomerName(string $targetNumber, string $categorySlug): string
    {
        if (in_array($categorySlug, ['listrik', 'pdam', 'bpjs'])) {
            $names = ['Ahmad Syarif', 'Budi Santoso', 'Siti Aminah', 'Rian Hidayat', 'Dewi Lestari', 'Joko Widodo'];
            // Determine name pseudo-randomly based on customer ID length/number
            $index = strlen($targetNumber) % count($names);
            return $names[$index];
        }

        return '';
    }
}
