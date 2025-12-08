<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'account_id',
        'product_id',
        'quantity',
        'total_price',
        'status',
        'order_date',
    ];

    protected $casts = [
        'order_date' => 'datetime',
        'total_price' => 'decimal:2',
    ];

    // Relasi ke Account
    public function account()
    {
        return $this->belongsTo(Account::class, 'account_id');
    }

    // Relasi ke Product
    public function product()
    {
        return $this->belongsTo(Product::class, 'product_id');
    }

    // Scope untuk filter by status
    public function scopeByStatus($query, $status)
    {
        return $query->where('status', $status);
    }

    // Scope untuk order terbaru
    public function scopeLatest($query)
    {
        return $query->orderBy('order_date', 'desc');
    }
}
