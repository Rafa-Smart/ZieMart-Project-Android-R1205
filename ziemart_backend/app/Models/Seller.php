<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Seller extends Model
{
    use HasFactory;

    protected $fillable = [
        'store_name',
        'phone_number',
        'verification_id',
        'account_id',
    ];

    public function products()
    {
        return $this->belongsToMany(Product::class, 'seller_products', 'seller_id', 'product_id')
            ->withTimestamps();
    }

    // Relasi ke verification
    public function verification()
    {
        return $this->belongsTo(Verification::class, 'verification_id');
    }



    // Relasi ke account
    public function account()
    {
        return $this->belongsTo(Account::class, 'account_id');
    }
}
