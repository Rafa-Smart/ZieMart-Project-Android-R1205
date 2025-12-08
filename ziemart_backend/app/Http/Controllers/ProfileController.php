<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\Buyer;
use App\Models\Seller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class ProfileController extends Controller
{
    // GET Profile by Account ID
    public function getProfile($id)
    {
        $account = Account::with(['buyer', 'seller'])->find($id);

        if (!$account) {
            return response()->json([
                'success' => false,
                'message' => 'Akun tidak ditemukan.',
            ], 404);
        }

        $profileData = [
            'id' => $account->id,
            'username' => $account->username,
            'email' => $account->email,
            'role' => $account->role,
        ];

        if ($account->role === 'buyer' && $account->buyer) {
            $profileData['phone_number'] = $account->buyer->phone_number;
            $profileData['full_name'] = $account->buyer->fullname;
        } elseif ($account->role === 'seller' && $account->seller) {
            $profileData['phone_number'] = $account->seller->phone_number;
            $profileData['store_name'] = $account->seller->store_name;
        }

        return response()->json([
            'success' => true,
            'data' => $profileData,
        ], 200);
    }

    // UPDATE Profile
    public function updateProfile(Request $request, $id)
    {
        $account = Account::with(['buyer', 'seller'])->find($id);

        if (!$account) {
            return response()->json([
                'success' => false,
                'message' => 'Akun tidak ditemukan.',
            ], 404);
        }

        // Validasi
        $request->validate([
            'username' => 'sometimes|string|max:100|unique:accounts,username,' . $id,
            'email' => 'sometimes|email|unique:accounts,email,' . $id,
            'phone_number' => 'sometimes|string|max:20',
        ]);

        // Update data account
        if ($request->has('username')) {
            $account->username = $request->username;
        }
        if ($request->has('email')) {
            $account->email = $request->email;
        }

        $account->save();

        // Update data buyer atau seller
        if ($account->role === 'buyer' && $account->buyer) {
            if ($request->has('phone_number')) {
                $account->buyer->phone_number = $request->phone_number;
            }
            if ($request->has('full_name')) {
                $account->buyer->fullname = $request->full_name;
            }
            $account->buyer->save();
        } elseif ($account->role === 'seller' && $account->seller) {
            if ($request->has('phone_number')) {
                $account->seller->phone_number = $request->phone_number;
            }
            if ($request->has('store_name')) {
                $account->seller->store_name = $request->store_name;
            }
            $account->seller->save();
        }

        // Return updated data
        $profileData = [
            'id' => $account->id,
            'username' => $account->username,
            'email' => $account->email,
            'role' => $account->role,
        ];

        if ($account->role === 'buyer' && $account->buyer) {
            $profileData['phone_number'] = $account->buyer->phone_number;
            $profileData['full_name'] = $account->buyer->fullname;
        } elseif ($account->role === 'seller' && $account->seller) {
            $profileData['phone_number'] = $account->seller->phone_number;
            $profileData['store_name'] = $account->seller->store_name;
        }

        return response()->json([
            'success' => true,
            'message' => 'Profile berhasil diupdate.',
            'data' => $profileData,
        ], 200);
    }

    // CHANGE PASSWORD
    public function changePassword(Request $request, $id)
    {
        $account = Account::find($id);

        if (!$account) {
            return response()->json([
                'success' => false,
                'message' => 'Akun tidak ditemukan.',
            ], 404);
        }

        $request->validate([
            'old_password' => 'required',
            'new_password' => 'required|min:6',
        ]);

        // Cek password lama
        if (!Hash::check($request->old_password, $account->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Password lama salah.',
            ], 400);
        }

        // Update password baru
        $account->password = Hash::make($request->new_password);
        $account->save();

        return response()->json([
            'success' => true,
            'message' => 'Password berhasil diubah.',
        ], 200);
    }

    // DELETE Account
    public function deleteAccount($id)
    {
        $account = Account::find($id);

        if (!$account) {
            return response()->json([
                'success' => false,
                'message' => 'Akun tidak ditemukan.',
            ], 404);
        }

        $account->delete();

        return response()->json([
            'success' => true,
            'message' => 'Akun berhasil dihapus.',
        ], 200);
    }
}