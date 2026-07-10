<?php

namespace App\Services;

use App\Models\Merchant;
use App\Models\Transaction;
use App\Models\TransactionDetail;
use App\Models\User;
use Illuminate\Support\Facades\DB;

use App\Services\NotificationService;
use Illuminate\Support\Facades\Log;

class TransactionService
{
    protected NotificationService $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }
    /**
     * Transfer saldo sesama pengguna EZ Pay (P2P).
     */
    public function transferEzpay(User $sender, string $receiverPhone, float $amount, ?string $note = null): Transaction
    {
        if ($amount <= 0) {
            throw new \InvalidArgumentException('Nominal transfer harus lebih dari 0');
        }

        $transaction = DB::transaction(function () use ($sender, $receiverPhone, $amount, $note) {
            // Lock sender row for update
            $sender = User::where('id', $sender->id)->lockForUpdate()->first();

            if ($sender->balance < $amount) {
                throw new \RuntimeException('Saldo tidak mencukupi');
            }

            $receiver = User::where('phone', $receiverPhone)->lockForUpdate()->first();

            if (!$receiver) {
                throw new \RuntimeException('Nomor penerima tidak terdaftar di EZ Pay');
            }

            if ($receiver->id === $sender->id) {
                throw new \RuntimeException('Tidak bisa transfer ke diri sendiri');
            }

            $adminFee = 0;
            $total = $amount + $adminFee;

            if ($sender->balance < $total) {
                throw new \RuntimeException('Saldo tidak mencukupi (termasuk biaya admin)');
            }

            // Snapshot balances
            $senderBalanceBefore = $sender->balance;
            $receiverBalanceBefore = $receiver->balance;

            // Update balances
            $sender->decrement('balance', $total);
            $receiver->increment('balance', $amount);

            $senderBalanceAfter = $senderBalanceBefore - $total;
            $receiverBalanceAfter = $receiverBalanceBefore + $amount;

            // Create transaction record
            $trx = Transaction::create([
                'transaction_code' => Transaction::generateCode(),
                'sender_id' => $sender->id,
                'receiver_id' => $receiver->id,
                'type' => 'transfer_ezpay',
                'amount' => $amount,
                'admin_fee' => $adminFee,
                'total' => $total,
                'status' => 'success',
                'payment_method' => 'saldo_ezpay',
                'note' => $note,
                'sender_balance_before' => $senderBalanceBefore,
                'sender_balance_after' => $senderBalanceAfter,
                'receiver_balance_before' => $receiverBalanceBefore,
                'receiver_balance_after' => $receiverBalanceAfter,
            ]);

            return $trx->load(['sender:id,name,phone', 'receiver:id,name,phone']);
        });

        // Kirim notifikasi setelah DB transaction sukses commit
        try {
            $senderName = $transaction->sender->name ?? 'User';
            $receiverName = $transaction->receiver->name ?? 'User';
            $amountFormatted = number_format($amount, 0, ',', '.');

            $this->notificationService->sendNotification(
                $transaction->sender_id,
                'Transfer Berhasil',
                "Transfer ke {$receiverName} sebesar Rp {$amountFormatted} berhasil.",
                ['transaction_code' => $transaction->transaction_code, 'type' => 'transfer_ezpay']
            );

            $this->notificationService->sendNotification(
                $transaction->receiver_id,
                'Transfer Diterima',
                "Menerima transfer dari {$senderName} sebesar Rp {$amountFormatted}.",
                ['transaction_code' => $transaction->transaction_code, 'type' => 'transfer_ezpay']
            );
        } catch (\Exception $e) {
            Log::error("Failed to send transfer notifications: " . $e->getMessage());
        }

        return $transaction;
    }

    /**
     * Transfer ke rekening bank (BSI, BNI, BRI, BCA, dll).
     */
    public function transferBank(
        User $sender,
        float $amount,
        string $bankCode,
        string $bankName,
        string $accountNumber,
        string $accountHolderName,
        ?string $note = null
    ): Transaction {
        if ($amount <= 0) {
            throw new \InvalidArgumentException('Nominal transfer harus lebih dari 0');
        }

        $transaction = DB::transaction(function () use ($sender, $amount, $bankCode, $bankName, $accountNumber, $accountHolderName, $note) {
            $sender = User::where('id', $sender->id)->lockForUpdate()->first();

            $adminFee = (float) $this->getSetting('default_admin_fee_bank', 2500);
            $total = $amount + $adminFee;

            if ($sender->balance < $total) {
                throw new \RuntimeException('Saldo tidak mencukupi (termasuk biaya admin Rp ' . number_format($adminFee, 0, ',', '.') . ')');
            }

            $senderBalanceBefore = $sender->balance;
            $sender->decrement('balance', $total);
            $senderBalanceAfter = $senderBalanceBefore - $total;

            $trx = Transaction::create([
                'transaction_code' => Transaction::generateCode(),
                'sender_id' => $sender->id,
                'type' => 'transfer_bank',
                'amount' => $amount,
                'admin_fee' => $adminFee,
                'total' => $total,
                'status' => 'processing', // Butuh proses disbursement
                'payment_method' => 'saldo_ezpay',
                'note' => $note,
                'sender_balance_before' => $senderBalanceBefore,
                'sender_balance_after' => $senderBalanceAfter,
            ]);

            TransactionDetail::create([
                'transaction_id' => $trx->id,
                'bank_code' => $bankCode,
                'bank_name' => $bankName,
                'account_number' => $accountNumber,
                'account_holder_name' => $accountHolderName,
            ]);

            return $trx->load('detail');
        });

        // Kirim notifikasi setelah DB transaction sukses commit
        try {
            $amountFormatted = number_format($amount, 0, ',', '.');
            $this->notificationService->sendNotification(
                $transaction->sender_id,
                'Transfer Bank Diproses',
                "Transfer ke bank {$bankName} (rekening {$accountNumber}) sebesar Rp {$amountFormatted} sedang diproses.",
                ['transaction_code' => $transaction->transaction_code, 'type' => 'transfer_bank']
            );
        } catch (\Exception $e) {
            Log::error("Failed to send transfer_bank notification: " . $e->getMessage());
        }

        return $transaction;
    }

    /**
     * Transfer ke e-wallet (Dana, GoPay, ShopeePay, iSaku).
     */
    public function transferEwallet(
        User $sender,
        float $amount,
        string $ewalletName,
        string $accountNumber,
        string $accountHolderName,
        ?string $note = null
    ): Transaction {
        if ($amount <= 0) {
            throw new \InvalidArgumentException('Nominal transfer harus lebih dari 0');
        }

        $transaction = DB::transaction(function () use ($sender, $amount, $ewalletName, $accountNumber, $accountHolderName, $note) {
            $sender = User::where('id', $sender->id)->lockForUpdate()->first();

            $adminFee = (float) $this->getSetting('default_admin_fee_ewallet', 1000);
            $total = $amount + $adminFee;

            if ($sender->balance < $total) {
                throw new \RuntimeException('Saldo tidak mencukupi (termasuk biaya admin Rp ' . number_format($adminFee, 0, ',', '.') . ')');
            }

            $senderBalanceBefore = $sender->balance;
            $sender->decrement('balance', $total);
            $senderBalanceAfter = $senderBalanceBefore - $total;

            $trx = Transaction::create([
                'transaction_code' => Transaction::generateCode(),
                'sender_id' => $sender->id,
                'type' => 'transfer_ewallet',
                'amount' => $amount,
                'admin_fee' => $adminFee,
                'total' => $total,
                'status' => 'processing',
                'payment_method' => 'saldo_ezpay',
                'note' => $note,
                'sender_balance_before' => $senderBalanceBefore,
                'sender_balance_after' => $senderBalanceAfter,
            ]);

            TransactionDetail::create([
                'transaction_id' => $trx->id,
                'bank_name' => $ewalletName,
                'account_number' => $accountNumber,
                'account_holder_name' => $accountHolderName,
            ]);

            return $trx->load('detail');
        });

        // Kirim notifikasi setelah DB transaction sukses commit
        try {
            $amountFormatted = number_format($amount, 0, ',', '.');
            $this->notificationService->sendNotification(
                $transaction->sender_id,
                'Transfer E-Wallet Diproses',
                "Transfer ke e-wallet {$ewalletName} (rekening {$accountNumber}) sebesar Rp {$amountFormatted} sedang diproses.",
                ['transaction_code' => $transaction->transaction_code, 'type' => 'transfer_ewallet']
            );
        } catch (\Exception $e) {
            Log::error("Failed to send transfer_ewallet notification: " . $e->getMessage());
        }

        return $transaction;
    }

    /**
     * Tarik tunai di merchant (Alfamart, Indomaret, Alfamidi).
     */
    public function tarikTunai(User $sender, float $amount, string $merchantCode): Transaction
    {
        if ($amount <= 0) {
            throw new \InvalidArgumentException('Nominal tarik tunai harus lebih dari 0');
        }

        // We declare $withdrawalCode here to access it after commit
        $withdrawalCode = '';

        $transaction = DB::transaction(function () use ($sender, $amount, $merchantCode, &$withdrawalCode) {
            $sender = User::where('id', $sender->id)->lockForUpdate()->first();

            $merchant = Merchant::where('merchant_code', $merchantCode)
                ->where('is_active', true)
                ->first();

            if (!$merchant) {
                throw new \RuntimeException('Merchant tidak ditemukan atau tidak aktif');
            }

            $adminFee = 0;
            $total = $amount + $adminFee;

            if ($sender->balance < $total) {
                throw new \RuntimeException('Saldo tidak mencukupi');
            }

            $senderBalanceBefore = $sender->balance;
            $sender->decrement('balance', $total);
            $senderBalanceAfter = $senderBalanceBefore - $total;

            // Generate 6-digit withdrawal code for the cashier
            $withdrawalCode = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);

            $trx = Transaction::create([
                'transaction_code' => Transaction::generateCode(),
                'sender_id' => $sender->id,
                'merchant_id' => $merchant->id,
                'type' => 'tarik_tunai',
                'amount' => $amount,
                'admin_fee' => $adminFee,
                'total' => $total,
                'status' => 'pending', // Menunggu verifikasi kasir
                'payment_method' => 'tunai',
                'sender_balance_before' => $senderBalanceBefore,
                'sender_balance_after' => $senderBalanceAfter,
            ]);

            TransactionDetail::create([
                'transaction_id' => $trx->id,
                'merchant_code' => $merchantCode,
                'withdrawal_code' => $withdrawalCode,
            ]);

            return $trx->load(['detail', 'merchant']);
        });

        // Kirim notifikasi setelah DB transaction sukses commit
        try {
            $amountFormatted = number_format($amount, 0, ',', '.');
            $merchantName = $transaction->merchant->merchant_name ?? 'Merchant';
            $this->notificationService->sendNotification(
                $transaction->sender_id,
                'Pengajuan Tarik Tunai Berhasil',
                "Tarik tunai di {$merchantName} sebesar Rp {$amountFormatted} berhasil. Gunakan kode penarikan {$withdrawalCode} di kasir.",
                ['transaction_code' => $transaction->transaction_code, 'type' => 'tarik_tunai']
            );
        } catch (\Exception $e) {
            Log::error("Failed to send tarik_tunai notification: " . $e->getMessage());
        }

        return $transaction;
    }

    /**
     * Get app setting value from app_settings table.
     */
    private function getSetting(string $key, $default = null)
    {
        $value = DB::table('app_settings')->where('key', $key)->value('value');
        return $value ?? $default;
    }
}
