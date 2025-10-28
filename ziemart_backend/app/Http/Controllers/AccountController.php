<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\Buyer;
use App\Models\Seller;
use App\Models\Verification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class AccountController extends Controller
{

    public function store(Request $request)
    {

        $request->validate([
            'username' => 'required|string|max:100|unique:accounts,username',
            'email' => 'required|email|unique:accounts,email',
            'password' => 'required|min:6',
            'role' => 'required|in:buyer,seller',
            'phone_number' => 'required|string|max:20',
        ]);


        // disama ratain dulul, biar semaunya lowercase
        $role = strtolower($request->input('role'));
        if ($role === 'pembeli') $role = 'buyer';
        if ($role === 'penjual') $role = 'seller';


        $account = Account::create([
            'username' => $request->input('username'),
            'email' => $request->input('email'),
            'role' => $role,
            'password' => bcrypt($request->input('password')),
        ]);

        if ($role === 'buyer') {
            Buyer::create([
                'fullname' => $request->input('fullName'),
                'phone_number' => $request->input('phone_number'),
                'account_id' => $account->id,
            ]);
        }


        if ($role === 'seller') {

            $verification = Verification::create([
                'verification_code' => Str::uuid(),
                'reason' => 'kolom ini harusnya dihapus aje',
                'status' => 'pending',
                'account_id' => $account->id,
            ]);

    
            Seller::create([
                'store_name' => $request->input('store_name'), 
                'phone_number' => $request->input('phone_number'),
                'verification_id' => $verification->id,
                'account_id' => $account->id,
            ]);

            try {
                Mail::raw(
                    "Halo, terima kasih telah mendaftar sebagai Seller di Ziemart.\n\nKode verifikasi kamu adalah: {$verification->verification_code}\n\nGunakan kode ini untuk memverifikasi akunmu.",
                    function ($message) use ($account) {
                        $message->to($account->email)
                                ->subject('Kode Verifikasi Akun Seller Ziemart');
                    }
                );
            } catch (\Exception $e) {
                return response()->json([
                    'message' => 'Akun dibuat, tapi gagal mengirim email verifikasi',
                    'error' => $e->getMessage(),
                ], 500);
            }
        }

        return response()->json([
             'success' => true,
             'status'=>'ok',
            'message' => 'Akun berhasil dibuat!',
            'account' => $account,
        ], 200);
    }

  
    public function verifyCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'code' => 'required|string',
        ]);

        $account = Account::where('email', $request->email)->first();
        if (! $account) {
            return response()->json(['message' => 'Akun tidak ditemukan'], 404);
        }

        $verification = Verification::where('account_id', $account->id)
            ->where('verification_code', $request->code)
            ->first();

        if (! $verification) {
            return response()->json(['message' => 'Kode verifikasi salah'], 400);
        }

        $verification->update(['status' => 'approved']);

        return response()->json([
            'message' => 'Verifikasi berhasil! Akun kamu sudah aktif.',
            'account' => $account,
        ], 200);
    }


    public function index()
    {
        $data = Account::with(['buyer', 'seller'])->get();
        return response()->json($data);
    }


    public function update(Request $request, $id)
    {
        $account = Account::with(['buyer', 'seller'])->findOrFail($id);

        $account->update([
            'username' => $request->input('username'),
            'email' => $request->input('email'),
            'role' => $request->input('role'),
            'password' => bcrypt($request->input('password')),
        ]);

        if ($account->role === 'buyer' && $account->buyer) {
            $account->buyer->update([
                'phone_number' => $request->input('phone_number'),
                'fullname' => $request->input('fullname'),
            ]);
        }

        if ($account->role === 'seller' && $account->seller) {
            $account->seller->update([
                'store_name' => $request->input('fullName'),
                'phone_number' => $request->input('phone_number'),
            ]);
        }

        return response()->json([
            'message' => 'Data berhasil diupdate',
            'account' => $account->load(['buyer', 'seller']),
        ]);
    }

    public function destroy($id)
    {
        Account::where('id', $id)->delete();

        return response()->json([
            'message' => 'Berhasil menghapus akun',
        ], 200);
    }
}
