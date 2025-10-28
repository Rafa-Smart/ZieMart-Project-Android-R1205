<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class WelcomeMail extends Mailable
{
    use Queueable, SerializesModels;

    public $user; // akan tersedia di view

    public function __construct($user)
    {
        $this->user = $user;
    }

    public function build()
    {
        return $this
            ->subject('Selamat datang di Aplikasi Kami')
            ->view('emails.welcome'); // atau ->markdown('emails.welcome_markdown')
    }
}
