<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

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
        'seller_id',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'stock' => 'integer',
    ];

    // Relasi ke Category
    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    // Relasi ke Seller
    public function seller()
    {
        return $this->belongsTo(Seller::class);
    }

    // Relasi ke Comments
    public function comments()
    {
        return $this->hasMany(Comment::class);
    }
}