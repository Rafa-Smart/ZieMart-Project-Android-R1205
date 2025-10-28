<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use App\Mail\SendMail;

class EmailController extends Controller
{
    // menampilkan form
    public function index()
    {
        return view('email-form');
    }

    // mengirim email
    public function send(Request $request)
    {
        // validasi
        $request->validate([
            'email' => 'required|email',
        ]);

        $recipient = $request->input('email');

        // kirim email
        Mail::to($recipient)->send(new SendMail());

        return back()->with('success', 'Email berhasil dikirim ke ' . $recipient);
    }
}
