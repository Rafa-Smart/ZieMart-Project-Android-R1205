<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    // Ambil semua komentar dari produk tertentu
    public function getComments($productId)
    {
        $comments = Comment::where('product_id', $productId)
            ->with('account') // agar bisa tampil nama user
            ->latest()
            ->get();

        // Tambahkan informasi "berapa lama yang lalu"
        $comments = $comments->map(function ($comment) {
            $comment->time_ago = $this->getTimeAgo($comment->created_at);
            return $comment;
        });

        return response()->json(['data' => $comments], 200);
    }

    // Tambah komentar baru
    public function addComment(Request $request, $productId)
    {
        $request->validate([
            'account_id' => 'required|integer',
            'comment_text' => 'required|string|max:255',
        ]);

        $comment = Comment::create([
            'account_id' => $request->account_id,
            'comment_text' => $request->comment_text,
            'product_id' => $productId,
        ]);

        // Load relation dan tambahkan time_ago
        $comment->load('account');
        $comment->time_ago = $this->getTimeAgo($comment->created_at);

        return response()->json(['data' => $comment], 201);
    }

    // Helper function untuk menghitung "berapa lama yang lalu"
    private function getTimeAgo($timestamp)
    {
        $now = now();
        $diff = $now->diffInSeconds($timestamp);

        if ($diff < 60) {
            return 'Baru saja';
        } elseif ($diff < 3600) {
            $minutes = floor($diff / 60);
            return $minutes . ' menit yang lalu';
        } elseif ($diff < 86400) {
            $hours = floor($diff / 3600);
            return $hours . ' jam yang lalu';
        } elseif ($diff < 2592000) {
            $days = floor($diff / 86400);
            return $days . ' hari yang lalu';
        } elseif ($diff < 31536000) {
            $months = floor($diff / 2592000);
            return $months . ' bulan yang lalu';
        } else {
            $years = floor($diff / 31536000);
            return $years . ' tahun yang lalu';
        }
    }
}