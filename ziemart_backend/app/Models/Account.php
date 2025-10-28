<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Account extends Model
{
    use HasFactory;

    protected $fillable = [
        'username',
        'email',
        'role',
        'password',
    ];




    // Relasi ke buyer
    public function buyer()
    {
        return $this->hasOne(Buyer::class, 'account_id');
    }

    // Relasi ke seller
    public function seller()
    {
        return $this->hasOne(Seller::class, 'account_id');
    }

    // Relasi ke verifications
    public function verifications()
    {
        return $this->hasMany(Verification::class, 'account_id');
    }
}
