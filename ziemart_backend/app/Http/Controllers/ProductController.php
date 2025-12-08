<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
public function getProduct()
{
    $product = Product::with(['category', 'comments', 'seller'])->get();

    return response()->json([
        'data' => $product,
    ], 200);
}

public function getProductById($id)
{
    $product = Product::with(['category', 'comments', 'seller'])->find($id);

    if (! $product) {
        return response()->json([
            'message' => 'Product not found',
        ], 404);
    }

    return response()->json([
        'data' => $product,
    ], 200);
}


    public function searchProduct(Request $request)
    {
        $query = $request->query('q');

        $product = Product::with('category')
            ->where('product_name', 'like', "%{$query}%")
            ->orWhereHas('category', function ($q) use ($query) {
                $q->where('category_name', 'like', "%{$query}%");
            })
            ->get();

        return response()->json([
            'data' => $product,
        ], 200);
    }

    
}
