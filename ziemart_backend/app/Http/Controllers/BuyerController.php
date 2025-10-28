<?php

namespace App\Http\Controllers;

use App\Models\Buyer;
use Illuminate\Http\Request;

class BuyerController extends Controller
{
        public function index(){
        $data = Buyer::all();
        return response()->json($data);
    }
}
