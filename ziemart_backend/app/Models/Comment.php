<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    protected $fillable = [
        'comment_text', 'account_id', 'product_id'
    ];

    public function account()
    {
        return $this->belongsTo(Account::class);
    }
    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
