<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Table categories sudah ada, tapi kita pastikan strukturnya benar
        if (!Schema::hasTable('categories')) {
            Schema::create('categories', function (Blueprint $table) {
                $table->id();
                $table->string('category_name');
                $table->text('description')->nullable();
                $table->string('icon')->nullable(); // Untuk icon kategori
                $table->string('color')->nullable(); // Untuk warna kategori
                $table->timestamps();
            });
        } else {
            // Jika table sudah ada, tambahkan kolom icon dan color
            Schema::table('categories', function (Blueprint $table) {
                if (!Schema::hasColumn('categories', 'icon')) {
                    $table->string('icon')->nullable()->after('description');
                }
                if (!Schema::hasColumn('categories', 'color')) {
                    $table->string('color')->nullable()->after('icon');
                }
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('categories');
    }
};