<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TransactionDetail extends Model
{
    protected $fillable = [
        'transaction_id',
        'product_id',
        'target_number',
        'target_name',
        'serial_number',
        'provider_ref',
        'bank_code',
        'bank_name',
        'account_number',
        'account_holder_name',
        'merchant_code',
        'withdrawal_code',
        'va_number',
        'payment_url',
    ];

    public function transaction(): BelongsTo
    {
        return $this->belongsTo(Transaction::class);
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}
