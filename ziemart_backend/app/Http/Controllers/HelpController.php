<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use App\Mail\HelpRequestMail;
use Illuminate\Support\Facades\Log;

class HelpController extends Controller
{
    public function sendHelpEmail(Request $request)
    {
        Log::info('Help email request received:', $request->all());
        
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'subject' => 'required|string|max:255',
            'message' => 'required|string',
        ]);

        try {
            Log::info('Validated data:', $validated);
            
            // Kirim email ke admin
            $adminEmail = env('MAIL_FROM_ADDRESS', 'rafatesting1@gmail.com');
            Log::info('Admin email:', ['email' => $adminEmail]);
            
            // Test email configuration
            Log::info('Mail config:', [
                'driver' => config('mail.default'),
                'host' => config('mail.mailers.smtp.host'),
                'port' => config('mail.mailers.smtp.port'),
                'username' => config('mail.mailers.smtp.username'),
                'encryption' => config('mail.mailers.smtp.encryption'),
            ]);
            
            // Kirim email
            Mail::to($adminEmail)->send(new HelpRequestMail($validated));
            
            Log::info('Email sent successfully');

            return response()->json([
                'success' => true,
                'message' => 'Email berhasil dikirim. Tim kami akan menghubungi Anda dalam 1x24 jam.'
            ], 200);
            
        } catch (\Exception $e) {
            Log::error('Error sending help email:', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengirim email. Silakan coba lagi nanti.',
                'error' => $e->getMessage() // Hanya untuk debugging
            ], 500);
        }
    }
}