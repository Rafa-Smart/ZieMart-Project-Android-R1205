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
         *  ACCOUNTS (3)
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
         *  BUYER (1)
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
         *  VERIFICATIONS (HARUS ADA account_id!)
         * ============================================================ */
        DB::table('verifications')->insert([
            [
                'id' => 1,
                'verification_code' => Str::uuid(),
                'reason' => 'Dokumen lengkap',
                'status' => 'approved',
                'account_id' => 2, // seller_one
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'verification_code' => Str::uuid(),
                'reason' => 'Validasi data selesai',
                'status' => 'approved',
                'account_id' => 3, // seller_two
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         *  SELLERS (2)
         * ============================================================ */
        DB::table('sellers')->insert([
            [
                'id' => 1,
                'store_name' => 'Toko Maju Jaya',
                'phone_number' => '0812222222',
                'verification_id' => 1,
                'account_id' => 2,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'store_name' => 'Toko Sukses Selalu',
                'phone_number' => '0813333333',
                'verification_id' => 2,
                'account_id' => 3,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         *  CATEGORIES (5)
         * ============================================================ */
        DB::table('categories')->insert([
            ['id' => 1, 'category_name' => 'Elektronik', 'description' => 'Semua produk elektronik', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 2, 'category_name' => 'Fashion', 'description' => 'Pakaian dan aksesori', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 3, 'category_name' => 'Makanan', 'description' => 'Produk makanan & minuman', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 4, 'category_name' => 'Peralatan Rumah', 'description' => 'Perabot rumah tangga', 'created_at' => $now, 'updated_at' => $now],
            ['id' => 5, 'category_name' => 'Gaming', 'description' => 'Perlengkapan gaming', 'created_at' => $now, 'updated_at' => $now],
        ]);

        /* ============================================================
         *  PRODUCTS (20)
         * ============================================================ */
        $products = [
            [
                'product_name' => "Kopi Arabica Gayo 250g",
                'description' => "Kopi arabica premium dari dataran tinggi Gayo, aroma kuat dan cita rasa halus.",
                'price' => 75000,
                'stock' => 30,
                'img' => "kopi_gayo.jpg",
                'category_id' => 1,
            ],
            [
                'product_name' => "Teh Hijau Premium 200g",
                'description' => "Teh hijau kualitas tinggi dengan aroma segar dan menenangkan.",
                'price' => 45000,
                'stock' => 40,
                'img' => "teh_hijau.jpg",
                'category_id' => 1,
            ],
            [
                'product_name' => "Kipas Angin Portable USB",
                'description' => "Kipas mini dengan 3 mode kecepatan, cocok untuk meja kerja.",
                'price' => 35000,
                'stock' => 50,
                'img' => "kipas_portable.jpg",
                'category_id' => 2,
            ],
            [
                'product_name' => "Headset Bluetooth Bass",
                'description' => "Headset wireless dengan bass kuat dan baterai 10 jam.",
                'price' => 120000,
                'stock' => 25,
                'img' => "headset_bt.jpg",
                'category_id' => 2,
            ],
            [
                'product_name' => "Kemeja Polos Pria",
                'description' => "Kemeja bahan katun nyaman dipakai untuk acara formal maupun casual.",
                'price' => 89000,
                'stock' => 20,
                'img' => "kemeja_pria.jpg",
                'category_id' => 3,
            ],
            [
                'product_name' => "Kaos Oversize Premium",
                'description' => "Kaos oversize berbahan cotton combed 30s, adem dan tidak panas.",
                'price' => 65000,
                'stock' => 35,
                'img' => "kaos_oversize.jpg",
                'category_id' => 3,
            ],
            [
                'product_name' => "Tas Selempang Wanita",
                'description' => "Tas selempang elegan kulit sintetis premium.",
                'price' => 110000,
                'stock' => 18,
                'img' => "tas_wanita.jpg",
                'category_id' => 4,
            ],
            [
                'product_name' => "Cardigan Rajut Wanita",
                'description' => "Cardigan rajut lembut, cocok untuk gaya korean look.",
                'price' => 130000,
                'stock' => 22,
                'img' => "cardigan_rajut.jpg",
                'category_id' => 4,
            ],
            [
                'product_name' => "Wajan Anti Lengket 30cm",
                'description' => "Wajan anti lengket kualitas premium, mudah dibersihkan.",
                'price' => 95000,
                'stock' => 32,
                'img' => "wajan_anti_lengket.jpg",
                'category_id' => 5,
            ],
            [
                'product_name' => "Set Pisau Dapur 6in1",
                'description' => "Set pisau lengkap untuk kebutuhan dapur rumah.",
                'price' => 78000,
                'stock' => 28,
                'img' => "pisau_set.jpg",
                'category_id' => 5,
            ],
            [
                'product_name' => "Coklat Almond Premium",
                'description' => "Coklat premium dengan almond roasted, enak dan lumer.",
                'price' => 55000,
                'stock' => 25,
                'img' => "coklat_almond.jpg",
                'category_id' => 1,
            ],
            [
                'product_name' => "Mi Instan Pedas Level 10",
                'description' => "Mi instan dengan sensasi pedas ekstrem, cocok untuk pecinta pedas.",
                'price' => 12000,
                'stock' => 100,
                'img' => "mi_pedas.jpg",
                'category_id' => 1,
            ],
            [
                'product_name' => "Charger Fast Charging 25W",
                'description' => "Charger cepat kompatibel dengan berbagai smartphone.",
                'price' => 85000,
                'stock' => 30,
                'img' => "charger_fast.jpg",
                'category_id' => 2,
            ],
            [
                'product_name' => "Lampu LED Sensor Gerak",
                'description' => "Lampu otomatis menyala saat ada gerakan, hemat energi.",
                'price' => 60000,
                'stock' => 45,
                'img' => "lampu_sensor.jpg",
                'category_id' => 2,
            ],
            [
                'product_name' => "Celana Jeans Slimfit Pria",
                'description' => "Jeans slimfit dengan bahan stretch, nyaman dipakai.",
                'price' => 150000,
                'stock' => 20,
                'img' => "jeans_pria.jpg",
                'category_id' => 3,
            ],
            [
                'product_name' => "Hoodie Unisex",
                'description' => "Hoodie nyaman cocok untuk pria dan wanita.",
                'price' => 140000,
                'stock' => 25,
                'img' => "hoodie_unisex.jpg",
                'category_id' => 3,
            ],
            [
                'product_name' => "Sepatu Sneakers Wanita",
                'description' => "Sneakers trendy untuk aktivitas sehari-hari.",
                'price' => 160000,
                'stock' => 15,
                'img' => "sneakers_wanita.jpg",
                'category_id' => 4,
            ],
            [
                'product_name' => "Dress Casual Wanita",
                'description' => "Dress casual stylish untuk jalan-jalan.",
                'price' => 175000,
                'stock' => 12,
                'img' => "dress_wanita.jpg",
                'category_id' => 4,
            ],
            [
                'product_name' => "Rak Buku Kayu Minimalis",
                'description' => "Rak buku bahan kayu kuat dan tahan lama.",
                'price' => 210000,
                'stock' => 10,
                'img' => "rak_buku.jpg",
                'category_id' => 5,
            ],
            [
                'product_name' => "Dispenser Sabun Otomatis",
                'description' => "Dispenser sabun otomatis sensor tangan tanpa sentuh.",
                'price' => 90000,
                'stock' => 35,
                'img' => "dispenser_otomatis.jpg",
                'category_id' => 5,
            ],
        ];

          foreach ($products as $index => $p) {
            DB::table('products')->insert([
                ...$p,
                'seller_id' => ($index % 2 === 0) ? 1 : 2,
                'created_at' => $now,
                'updated_at' => $now,
            ]);
        }

        /* ============================================================
         *  CARTS (2)
         * ============================================================ */
        DB::table('carts')->insert([
            [
                'id' => 1,
                'account_id' => 1,
                'product_id' => 1,
                'quantity' => 2,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'account_id' => 1,
                'product_id' => 3,
                'quantity' => 1,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         *  WISHLISTS (2)
         * ============================================================ */
        DB::table('wishlists')->insert([
            [
                'id' => 1,
                'account_id' => 1,
                'product_id' => 5,
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'id' => 2,
                'account_id' => 1,
                'product_id' => 7,
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);

        /* ============================================================
         *  ORDERS (10)
         * ============================================================ */
        $orders = [];
        for ($i = 1; $i <= 10; $i++) {
            $qty = ($i % 3) + 1;
            $price = 10000 * ($i + 1);

            $orders[] = [
                'id' => $i,
                'account_id' => 1,
                'product_id' => $i,
                'quantity' => $qty,
                'total_price' => $qty * $price,
                'status' => 'pending',
                'order_date' => $now,
                'created_at' => $now,
                'updated_at' => $now,
            ];
        }

        DB::table('orders')->insert($orders);

        /* ============================================================
         *  COMMENTS (5)
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
