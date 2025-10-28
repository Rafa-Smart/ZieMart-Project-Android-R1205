<?php

namespace App\Models;

use App\Models\Comment;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'product_name',
        'description',
        'price',
        'stock',
        'img',
        'category_id',
    ];

    // Relasi ke category
    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }

    public function comments(){
        return $this->hasMany(Comment::class);
    }

    // Relasi ke sellers
    public function sellers()
    {
        return $this->belongsToMany(Seller::class, 'seller_products', 'product_id', 'seller_id')
            ->withTimestamps();
    }

    // Relasi ke orders (many-to-many via order_details)
    public function orders()
    {
        return $this->belongsToMany(Order::class, 'order_details')
            ->withPivot('quantity', 'total_price')
            ->withTimestamps();
    }

    // Relasi ke reviews
    public function reviews()
    {
        return $this->hasMany(Review::class, 'product_id');
    }
}
