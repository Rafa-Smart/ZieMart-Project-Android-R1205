<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    /**
     * Get all categories
     */
    public function getCategories()
    {
        $categories = Category::withCount('products')->get();

        return response()->json([
            'data' => $categories,
        ], 200);
    }

    /**
     * Get category by ID
     */
    public function getCategoryById($id)
    {
        $category = Category::withCount('products')->find($id);

        if (!$category) {
            return response()->json([
                'message' => 'Category not found',
            ], 404);
        }

        return response()->json([
            'data' => $category,
        ], 200);
    }

    /**
     * Get products by category
     */
    public function getProductsByCategory($categoryId)
    {
        $category = Category::find($categoryId);

        if (!$category) {
            return response()->json([
                'message' => 'Category not found',
            ], 404);
        }

        $products = Product::where('category_id', $categoryId)
            ->with(['category', 'seller'])
            ->get();

        return response()->json([
            'category' => $category,
            'products' => $products,
        ], 200);
    }

    /**
     * Get popular categories (with most products)
     */
    public function getPopularCategories()
    {
        $categories = Category::withCount('products')
            ->orderBy('products_count', 'desc')
            ->limit(6)
            ->get();

        return response()->json([
            'data' => $categories,
        ], 200);
    }
}