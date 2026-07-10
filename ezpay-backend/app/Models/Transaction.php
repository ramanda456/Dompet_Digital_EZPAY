<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Transaction extends Model
{
    protected $fillable = [
        'transaction_code',
        'reference_id',
        'sender_id',
        'receiver_id',
        'merchant_id',
        'type',
        'amount',
        'admin_fee',
        'total',
        'status',
        'payment_method',
        'note',
        'failed_reason',
        'sender_balance_before',
        'sender_balance_after',
        'receiver_balance_before',
        'receiver_balance_after',
    ];

    protected function casts(): array
    {
        return [
            'amount' => 'decimal:2',
            'admin_fee' => 'decimal:2',
            'total' => 'decimal:2',
            'sender_balance_before' => 'decimal:2',
            'sender_balance_after' => 'decimal:2',
            'receiver_balance_before' => 'decimal:2',
            'receiver_balance_after' => 'decimal:2',
        ];
    }

    // ─── Relationships ────────────────────────────────

    public function sender(): BelongsTo
    {
        return $this->belongsTo(User::class, 'sender_id');
    }

    public function receiver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'receiver_id');
    }

    public function merchant(): BelongsTo
    {
        return $this->belongsTo(Merchant::class);
    }

    public function detail(): HasOne
    {
        return $this->hasOne(TransactionDetail::class);
    }

    // ─── Helpers ──────────────────────────────────────

    /**
     * Generate a unique transaction code: TRX-YYYYMMDD-XXXXXX
     */
    public static function generateCode(): string
    {
        $date = now()->format('Ymd');
        $random = strtoupper(substr(bin2hex(random_bytes(3)), 0, 6));
        $code = "TRX-{$date}-{$random}";

        // Ensure uniqueness
        while (self::where('transaction_code', $code)->exists()) {
            $random = strtoupper(substr(bin2hex(random_bytes(3)), 0, 6));
            $code = "TRX-{$date}-{$random}";
        }

        return $code;
    }

    /**
     * Human-readable transaction type label.
     */
    public function getTypeLabelAttribute(): string
    {
        return match ($this->type) {
            'top_up_saldo' => 'Isi Saldo',
            'transfer_bank' => 'Transfer Bank',
            'transfer_ewallet' => 'Transfer E-Wallet',
            'transfer_ezpay' => 'Transfer EZ Pay',
            'tarik_tunai' => 'Tarik Tunai',
            'beli_pulsa' => 'Beli Pulsa',
            'beli_paket_data' => 'Beli Paket Data',
            'bayar_listrik' => 'Bayar Listrik',
            'bayar_pdam' => 'Bayar PDAM',
            'bayar_bpjs' => 'Bayar BPJS',
            'top_up_game' => 'Top Up Game',
            default => $this->type,
        };
    }
}
