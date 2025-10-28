<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Verification extends Model
{
    use HasFactory;

    protected $fillable = [
        'verification_code',
        'reason',
        'status',
        'account_id',
    ];

    // Relasi ke account
    public function account()
    {
        return $this->belongsTo(Account::class, 'account_id');
    }

    // Relasi ke sellers
    public function sellers()
    {
        return $this->hasMany(Seller::class, 'verification_id');
    }
}
