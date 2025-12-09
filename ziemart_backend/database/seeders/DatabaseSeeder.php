<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        $tables = [
            'wishlists','carts','orders','comments',
            'products','categories','sellers','buyers',
            'verifications','accounts'
        ];

        foreach ($tables as $table) {
            if (Schema::hasTable($table)) {
                DB::table($table)->truncate();
            }
        }

        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        $now = now();

        /* ============================================================
         * ACCOUNTS (3)
         * ============================================================ */
        DB::table('accounts')->insert([
            [
                'id' => 1,
                'username' => 'buyer_1',
                'email' => 'buyer@mail.com',
                'role' => 'buyer',
                'password' => Hash::make('password'),
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'username' => 'seller_one',
                'email' => 'seller1@mail.com',
                'role' => 'seller',
                'password' => Hash::make('password'),
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 3,
                'username' => 'seller_two',
                'email' => 'seller2@mail.com',
                'role' => 'seller',
                'password' => Hash::make('password'),
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         * BUYER (1)
         * ============================================================ */
        DB::table('buyers')->insert([
            [
                'id' => 1,
                'fullname' => 'Buyer Satu',
                'phone_number' => '0811111111',
                'account_id' => 1,
                'created_at' => $now,
                'updated_at' => $now,
            ]
        ]);

        /* ============================================================
         * VERIFICATIONS
         * ============================================================ */
        DB::table('verifications')->insert([
            [
                'id' => 1,
                'verification_code' => Str::uuid(),
                'reason' => 'Dokumen lengkap',
                'status' => 'approved',
                'account_id' => 2,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'verification_code' => Str::uuid(),
                'reason' => 'Validasi data selesai',
                'status' => 'approved',
                'account_id' => 3,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         * SELLERS (2)
         * ============================================================ */
        DB::table('sellers')->insert([
            [
                'id' => 1,
                'store_name' => 'Toko Maju Jaya',
                'phone_number' => '081234567890',
                'verification_id' => 1,
                'account_id' => 2,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'store_name' => 'Toko Sukses Selalu',
                'phone_number' => '081234567891',
                'verification_id' => 2,
                'account_id' => 3,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         * CATEGORIES (8) - UPDATED WITH ICONS & COLORS
         * ============================================================ */
        DB::table('categories')->insert([
            [
                'id' => 1, 
                'category_name' => 'Elektronik', 
                'description' => 'Semua produk elektronik',
                'icon' => 'computer',
                'color' => 'blue',
                'created_at' => $now, 
                'updated_at' => $now
            ],
            [
                'id' => 2, 
                'category_name' => 'Fashion', 
                'description' => 'Pakaian dan aksesori',
                'icon' => 'checkroom',
                'color' => 'pink',
                'created_at' => $now, 
                'updated_at' => $now
            ],
            [
                'id' => 3, 
                'category_name' => 'Makanan & Minuman', 
                'description' => 'Produk makanan & minuman',
                'icon' => 'fastfood',
                'color' => 'green',
                'created_at' => $now, 
                'updated_at' => $now
            ],
            [
                'id' => 4, 
                'category_name' => 'Peralatan Rumah', 
                'description' => 'Perabot rumah tangga',
                'icon' => 'chair',
                'color' => 'brown',
                'created_at' => $now, 
                'updated_at' => $now
            ],
            [
                'id' => 5, 
                'category_name' => 'Olahraga', 
                'description' => 'Perlengkapan olahraga',
                'icon' => 'sports_baseball',
                'color' => 'purple',
                'created_at' => $now, 
                'updated_at' => $now
            ],
            [
                'id' => 6, 
                'category_name' => 'Otomotif', 
                'description' => 'Aksesoris kendaraan',
                'icon' => 'directions_car',
                'color' => 'deepOrange',
                'created_at' => $now, 
                'updated_at' => $now
            ],
            [
                'id' => 7, 
                'category_name' => 'Kesehatan', 
                'description' => 'Produk kesehatan',
                'icon' => 'local_hospital',
                'color' => 'red',
                'created_at' => $now, 
                'updated_at' => $now
            ],
            [
                'id' => 8, 
                'category_name' => 'Hobi & Koleksi', 
                'description' => 'Barang hobi',
                'icon' => 'collections',
                'color' => 'amber',
                'created_at' => $now, 
                'updated_at' => $now
            ],
        ]);

        /* ============================================================
         * PRODUCTS (30) - UPDATED CATEGORIES
         * ============================================================ */
        $products = [
            // ELEKTRONIK (Category 1)
            [
                'product_name' => "Kipas Angin Portable USB",
                'description' => "Kipas mini dengan 3 mode kecepatan, cocok untuk meja kerja.",
                'price' => 35000,
                'stock' => 50,
                'img' => "https://images.unsplash.com/photo-1597040272753-0448e4b23cb6?w=500",
                'category_id' => 1,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Headset Bluetooth Bass",
                'description' => "Headset wireless dengan bass kuat dan baterai 10 jam.",
                'price' => 120000,
                'stock' => 25,
                'img' => "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500",
                'category_id' => 1,
                'seller_id' => 2,
            ],
            [
                'product_name' => "Charger Fast Charging 25W",
                'description' => "Charger cepat kompatibel dengan berbagai smartphone.",
                'price' => 85000,
                'stock' => 30,
                'img' => "https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=500",
                'category_id' => 1,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Lampu LED Sensor Gerak",
                'description' => "Lampu otomatis menyala saat ada gerakan, hemat energi.",
                'price' => 60000,
                'stock' => 45,
                'img' => "https://images.unsplash.com/photo-1513506003901-1e6a229e2d15?w=500",
                'category_id' => 1,
                'seller_id' => 2,
            ],

            // FASHION (Category 2)
            [
                'product_name' => "Kemeja Polos Pria",
                'description' => "Kemeja bahan katun nyaman dipakai untuk acara formal maupun casual.",
                'price' => 89000,
                'stock' => 20,
                'img' => "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=500",
                'category_id' => 2,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Kaos Oversize Premium",
                'description' => "Kaos oversize berbahan cotton combed 30s, adem dan tidak panas.",
                'price' => 65000,
                'stock' => 35,
                'img' => "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500",
                'category_id' => 2,
                'seller_id' => 2,
            ],
            [
                'product_name' => "Tas Selempang Wanita",
                'description' => "Tas selempang elegan kulit sintetis premium.",
                'price' => 110000,
                'stock' => 18,
                'img' => "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=500",
                'category_id' => 2,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Cardigan Rajut Wanita",
                'description' => "Cardigan rajut lembut, cocok untuk gaya korean look.",
                'price' => 130000,
                'stock' => 22,
                'img' => "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=500",
                'category_id' => 2,
                'seller_id' => 2,
            ],
            [
                'product_name' => "Celana Jeans Slimfit Pria",
                'description' => "Jeans slimfit dengan bahan stretch, nyaman dipakai.",
                'price' => 150000,
                'stock' => 20,
                'img' => "https://images.unsplash.com/photo-1542272604-787c3835535d?w=500",
                'category_id' => 2,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Hoodie Unisex",
                'description' => "Hoodie nyaman cocok untuk pria dan wanita.",
                'price' => 140000,
                'stock' => 25,
                'img' => "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500",
                'category_id' => 2,
                'seller_id' => 2,
            ],
            [
                'product_name' => "Sepatu Sneakers Wanita",
                'description' => "Sneakers trendy untuk aktivitas sehari-hari.",
                'price' => 160000,
                'stock' => 15,
                'img' => "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=500",
                'category_id' => 2,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Dress Casual Wanita",
                'description' => "Dress casual stylish untuk jalan-jalan.",
                'price' => 175000,
                'stock' => 12,
                'img' => "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500",
                'category_id' => 2,
                'seller_id' => 2,
            ],

            // MAKANAN & MINUMAN (Category 3)
            [
                'product_name' => "Kopi Arabica Gayo 250g",
                'description' => "Kopi arabica premium dari dataran tinggi Gayo, aroma kuat dan cita rasa halus.",
                'price' => 75000,
                'stock' => 30,
                'img' => "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=500",
                'category_id' => 3,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Teh Hijau Premium 200g",
                'description' => "Teh hijau kualitas tinggi dengan aroma segar dan menenangkan.",
                'price' => 45000,
                'stock' => 40,
                'img' => "https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=500",
                'category_id' => 3,
                'seller_id' => 2,
            ],
            [
                'product_name' => "Coklat Almond Premium",
                'description' => "Coklat premium dengan almond roasted, enak dan lumer.",
                'price' => 55000,
                'stock' => 25,
                'img' => "https://images.unsplash.com/photo-1511381939415-e44015466834?w=500",
                'category_id' => 3,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Mi Instan Pedas Level 10",
                'description' => "Mi instan dengan sensasi pedas ekstrem, cocok untuk pecinta pedas.",
                'price' => 12000,
                'stock' => 100,
                'img' => "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500",
                'category_id' => 3,
                'seller_id' => 2,
            ],

            // PERALATAN RUMAH (Category 4)
            [
                'product_name' => "Wajan Anti Lengket 30cm",
                'description' => "Wajan anti lengket kualitas premium, mudah dibersihkan.",
                'price' => 95000,
                'stock' => 32,
                'img' => "https://images.unsplash.com/photo-1584990347449-39f4c11bb37b?w=500",
                'category_id' => 4,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Set Pisau Dapur 6in1",
                'description' => "Set pisau lengkap untuk kebutuhan dapur rumah.",
                'price' => 78000,
                'stock' => 28,
                'img' => "https://images.unsplash.com/photo-1593618998160-e34014e67546?w=500",
                'category_id' => 4,
                'seller_id' => 2,
            ],
            [
                'product_name' => "Rak Buku Kayu Minimalis",
                'description' => "Rak buku bahan kayu kuat dan tahan lama.",
                'price' => 210000,
                'stock' => 10,
                'img' => "https://images.unsplash.com/photo-1594620302200-9a762244a156?w=500",
                'category_id' => 4,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Dispenser Sabun Otomatis",
                'description' => "Dispenser sabun otomatis sensor tangan tanpa sentuh.",
                'price' => 90000,
                'stock' => 35,
                'img' => "https://images.unsplash.com/photo-1585421514738-01798e348b17?w=500",
                'category_id' => 4,
                'seller_id' => 2,
            ],

            // OLAHRAGA (Category 5)
            [
                'product_name' => "Matras Yoga Anti Slip",
                'description' => "Matras yoga premium dengan permukaan anti slip.",
                'price' => 125000,
                'stock' => 20,
                'img' => "https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=500",
                'category_id' => 5,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Dumbbell Set 5kg",
                'description' => "Dumbbell set untuk latihan kekuatan di rumah.",
                'price' => 180000,
                'stock' => 15,
                'img' => "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=500",
                'category_id' => 5,
                'seller_id' => 2,
            ],

            // OTOMOTIF (Category 6)
            [
                'product_name' => "Sarung Jok Mobil Premium",
                'description' => "Sarung jok mobil bahan kulit sintetis berkualitas.",
                'price' => 350000,
                'stock' => 12,
                'img' => "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=500",
                'category_id' => 6,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Air Freshener Mobil",
                'description' => "Pengharum mobil dengan aroma yang tahan lama.",
                'price' => 45000,
                'stock' => 50,
                'img' => "https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=500",
                'category_id' => 6,
                'seller_id' => 2,
            ],

            // KESEHATAN (Category 7)
            [
                'product_name' => "Masker KN95 Box 50pcs",
                'description' => "Masker KN95 standar medis, perlindungan maksimal.",
                'price' => 95000,
                'stock' => 40,
                'img' => "https://images.unsplash.com/photo-1584036561566-baf8f5f1b144?w=500",
                'category_id' => 7,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Termometer Digital",
                'description' => "Termometer digital akurat dan cepat.",
                'price' => 65000,
                'stock' => 30,
                'img' => "https://images.unsplash.com/photo-1584308972272-9e4e7685e80f?w=500",
                'category_id' => 7,
                'seller_id' => 2,
            ],

            // HOBI & KOLEKSI (Category 8)
            [
                'product_name' => "Action Figure Superhero",
                'description' => "Action figure koleksi superhero dengan detail tinggi.",
                'price' => 250000,
                'stock' => 8,
                'img' => "https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=500",
                'category_id' => 8,
                'seller_id' => 1,
            ],
            [
                'product_name' => "Puzzle 1000 Pieces",
                'description' => "Puzzle dengan gambar pemandangan indah.",
                'price' => 85000,
                'stock' => 15,
                'img' => "https://images.unsplash.com/photo-1587731556938-38755b4803a6?w=500",
                'category_id' => 8,
                'seller_id' => 2,
            ],
            // Tambahan produk untuk melengkapi (Contoh)
            [
                'product_name' => "Mouse Wireless Ergonomis",
                'description' => "Mouse tanpa kabel, nyaman untuk penggunaan lama.",
                'price' => 70000,
                'stock' => 40,
                'img' => "https://images.unsplash.com/photo-1527864552089-ce276b25121b?w=500",
                'category_id' => 1, // Elektronik
                'seller_id' => 1,
            ],
            [
                'product_name' => "Blouse Batik Modern",
                'description' => "Blouse batik dengan desain modern, cocok untuk kantor.",
                'price' => 180000,
                'stock' => 15,
                'img' => "https://images.unsplash.com/photo-1563242635-f09b3058c499?w=500",
                'category_id' => 2, // Fashion
                'seller_id' => 2,
            ],
            [
                'product_name' => "Keripik Singkong Balado 500g",
                'description' => "Keripik singkong pedas manis, renyah dan gurih.",
                'price' => 30000,
                'stock' => 60,
                'img' => "https://images.unsplash.com/photo-1603525547900-530e334a1a36?w=500",
                'category_id' => 3, // Makanan & Minuman
                'seller_id' => 1,
            ],
            [
                'product_name' => "Sprei Katun Lembut Ukuran Queen",
                'description' => "Sprei bahan katun lembut, motif elegan.",
                'price' => 150000,
                'stock' => 25,
                'img' => "https://images.unsplash.com/photo-1563914101869-e587042a969f?w=500",
                'category_id' => 4, // Peralatan Rumah
                'seller_id' => 2,
            ],
            [
                'product_name' => "Bola Sepak Standar FIFA",
                'description' => "Bola sepak kualitas standar internasional.",
                'price' => 220000,
                'stock' => 10,
                'img' => "https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=500",
                'category_id' => 5, // Olahraga
                'seller_id' => 1,
            ],
            [
                'product_name' => "Pelindung Lutut Motor",
                'description' => "Pelindung lutut untuk berkendara motor, bahan kuat.",
                'price' => 80000,
                'stock' => 30,
                'img' => "https://images.unsplash.com/photo-1628170881180-2a5b2e67f2e4?w=500",
                'category_id' => 6, // Otomotif
                'seller_id' => 2,
            ],
            [
                'product_name' => "Vitamin C 1000mg Botol 30 Tablet",
                'description' => "Suplemen Vitamin C untuk menjaga daya tahan tubuh.",
                'price' => 50000,
                'stock' => 50,
                'img' => "https://images.unsplash.com/photo-1580228026130-c977259024f7?w=500",
                'category_id' => 7, // Kesehatan
                'seller_id' => 1,
            ],
            [
                'product_name' => "Cat Akrilik Set 12 Warna",
                'description' => "Set cat akrilik untuk melukis, warna cerah.",
                'price' => 90000,
                'stock' => 20,
                'img' => "https://images.unsplash.com/photo-1579783900882-c0d3ce7b25db?w=500",
                'category_id' => 8, // Hobi & Koleksi
                'seller_id' => 2,
            ],
        ];
        
        // Memasukkan data produk ke database
        foreach ($products as $p) {
            DB::table('products')->insert([
                ...$p,
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }
        
        /* ============================================================
         * CARTS (2)
         * ============================================================ */
        DB::table('carts')->insert([
            [
                'id' => 1,
                'account_id' => 1,
                'product_id' => 1, // Kipas Angin Portable USB (Elektronik)
                'quantity' => 2,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'account_id' => 1,
                'product_id' => 3, // Charger Fast Charging 25W (Elektronik)
                'quantity' => 1,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         * WISHLISTS (2)
         * ============================================================ */
        DB::table('wishlists')->insert([
            [
                'id' => 1,
                'account_id' => 1,
                'product_id' => 5, // Kemeja Polos Pria (Fashion)
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'account_id' => 1,
                'product_id' => 7, // Tas Selempang Wanita (Fashion)
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         * ORDERS (5) - Sample orders
         * ============================================================ */
        DB::table('orders')->insert([
            [
                'id' => 1,
                'account_id' => 1,
                'product_id' => 1,
                'quantity' => 2,
                'total_price' => 70000,
                'status' => 'delivered',
                'order_date' => now()->subDays(10),
                'created_at' => now()->subDays(10),
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'account_id' => 1,
                'product_id' => 5,
                'quantity' => 1,
                'total_price' => 89000,
                'status' => 'shipped',
                'order_date' => now()->subDays(3),
                'created_at' => now()->subDays(3),
                'updated_at' => $now,
            ],
            [
                'id' => 3,
                'account_id' => 1,
                'product_id' => 13, // Kopi Arabica Gayo 250g (Makanan & Minuman)
                'quantity' => 3,
                'total_price' => 225000,
                'status' => 'processing',
                'order_date' => now()->subDays(1),
                'created_at' => now()->subDays(1),
                'updated_at' => $now,
            ],
            [
                'id' => 4,
                'account_id' => 1,
                'product_id' => 2,
                'quantity' => 1,
                'total_price' => 120000,
                'status' => 'pending',
                'order_date' => now(),
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 5,
                'account_id' => 1,
                'product_id' => 7,
                'quantity' => 1,
                'total_price' => 110000,
                'status' => 'cancelled',
                'order_date' => now()->subDays(5),
                'created_at' => now()->subDays(5),
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         * COMMENTS (5)
         * ============================================================ */
        DB::table('comments')->insert([
            ['id' => 1, 'comment_text' => 'Produk sangat bagus!', 'account_id' => 1, 'product_id' => 1, 'created_at' => $now, 'updated_at' => $now],
            ['id' => 2, 'comment_text' => 'Mantap sekali', 'account_id' => 1, 'product_id' => 2, 'created_at' => $now, 'updated_at' => $now],
            ['id' => 3, 'comment_text' => 'Pengiriman cepat', 'account_id' => 1, 'product_id' => 3, 'created_at' => $now, 'updated_at' => $now],
            ['id' => 4, 'comment_text' => 'Sesuai deskripsi', 'account_id' => 1, 'product_id' => 4, 'created_at' => $now, 'updated_at' => $now],
            ['id' => 5, 'comment_text' => 'Recommended banget', 'account_id' => 1, 'product_id' => 5, 'created_at' => $now, 'updated_at' => $now],
        ]);
    }
}