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

        return response()->json(['data' => $comment], 200);
    }
}
