<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_id',
        'buyer_id',
    ];

    // Relasi ke buyer
    public function buyer()
    {
        return $this->belongsTo(Buyer::class, 'buyer_id');
    }

    // Relasi ke products (many-to-many via order_details)
    public function products()
    {
        return $this->belongsToMany(Product::class, 'order_details')
            ->withPivot('quantity', 'total_price')
            ->withTimestamps();
    }

    // Relasi ke order_details
    public function orderDetails()
    {
        return $this->hasMany(OrderDetail::class, 'order_id');
    }
}
