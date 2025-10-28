<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Review extends Model
{
    use HasFactory;

    protected $fillable = [
        'rating',
        'comment',
        'buyer_id',
        'product_id',
    ];

    // Relasi ke buyer
    public function buyer()
    {
        return $this->belongsTo(Buyer::class, 'buyer_id');
    }

    // Relasi ke product
    public function product()
    {
        return $this->belongsTo(Product::class, 'product_id');
    }
}
