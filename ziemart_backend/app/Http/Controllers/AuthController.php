<?php

namespace App\Http\Controllers;

use App\Models\Account;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        // Load account dengan relasi buyer/seller
        $account = Account::where('email', $request->email)
            ->with(['buyer', 'seller.verification'])
            ->first();

        if (!$account) {
            return response()->json([
                'success' => false,
                'message' => 'Email tidak ditemukan.',
            ], 404);
        }

        if (!Hash::check($request->password, $account->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Password salah.',
            ], 401);
        }

        // Cek verifikasi untuk seller
        if ($account->role === 'seller' && $account->seller) {
            $verification = $account->seller->verification;
            if ($verification && $verification->status !== 'approved') {
                return response()->json([
                    'success' => false,
                    'message' => 'Akun seller belum diverifikasi. Silakan cek email Anda.',
                ], 403);
            }
        }

        // Siapkan data user
        $userData = [
            'id' => $account->id,
            'username' => $account->username,
            'email' => $account->email,
            'role' => $account->role,
        ];

        // Tambahkan data spesifik berdasarkan role
        if ($account->role === 'buyer' && $account->buyer) {
            $userData['phone_number'] = $account->buyer->phone_number;
            $userData['full_name'] = $account->buyer->fullname;
        } elseif ($account->role === 'seller' && $account->seller) {
            $userData['phone_number'] = $account->seller->phone_number;
            $userData['store_name'] = $account->seller->store_name;
        }

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'data' => $userData,
        ], 200);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $account = Account::where('email', $request->email)->first();

        if (!$account) {
            return response()->json([
                'success' => false,
                'message' => 'Email tidak ditemukan.',
            ], 404);
        }

        // Generate password baru
        $newPassword = substr(str_shuffle('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'), 0, 8);

        // Update password
        $account->password = Hash::make($newPassword);
        $account->save();

        // Kirim email
        try {
            \Mail::raw(
                "Halo {$account->username},\n\nPassword baru kamu adalah: {$newPassword}\n\nSilakan login dan ubah password segera setelah masuk.",
                function ($message) use ($account) {
                    $message->to($account->email)
                        ->subject('Reset Password - Ziemart');
                }
            );
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengirim email. Pastikan konfigurasi MAIL_* benar.',
                'error' => $e->getMessage(),
            ], 500);
        }

        return response()->json([
            'success' => true,
            'message' => 'Password baru telah dikirim ke email Anda.',
        ], 200);
    }
}