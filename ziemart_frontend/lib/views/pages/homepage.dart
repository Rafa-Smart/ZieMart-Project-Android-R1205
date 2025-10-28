import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/product_viewmodel.dart';
import '../../models/product_model.dart';
import 'package:intl/intl.dart';
import 'detail_product.dart';

// Konstanta Warna untuk konsistensi
const Color primaryColor = Color(0xFF2F5DFE); // Biru
const Color backgroundColor = Colors.white;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instance untuk memformat harga menjadi Rupiah
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductViewModel>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productVM = Provider.of<ProductViewModel>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // AppBar di sini kita buat transparan, tapi kita atur tinggi untuk Header di bawahnya
        backgroundColor: primaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          // 🔵 HEADER / SEARCH SECTION (Dibuat terpisah di luar Padding utama untuk efek full-width)
          _buildHeaderSection(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // 🟣 Kategori (Header 'Kategori' dan List Kategori)
                  const Text(
                    "Kategori Populer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCategoryList(),
                  const SizedBox(height: 10),

                  // 🛍️ GRID PRODUK
                  const Text(
                    "Produk Terbaru",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (productVM.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        }

                        if (productVM.errorMessage != null) {
                          return Center(
                            child: Text(
                              "Terjadi kesalahan:\n${productVM.errorMessage}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final List<Product> products = productVM.products;

                        if (products.isEmpty) {
                          return const Center(
                            child: Text("Belum ada produk ditemukan."),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16, // Spasi antar baris
                                crossAxisSpacing: 16, // Spasi antar kolom
                                childAspectRatio:
                                    0.72, // Tinggi Card sedikit ditingkatkan
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _buildProductCard(product);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🔵 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        selectedItemColor:
            primaryColor, // Warna primer digunakan untuk item terpilih
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
  // ----------------------------------------------------------------------------------

  // 🔹 WIDGET: HEADER DAN SEARCH BAR
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ucapan Selamat Datang
          const Text(
            "Hai, Belanja Yuk! 👋",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Consumer<ProductViewModel>(
              builder: (context, viewModel, child) {
                return TextField(
                  decoration: const InputDecoration(
                    hintText: "Cari produk, kategori, atau toko...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onChanged: (value) {
                    viewModel.searchProducts(
                      value,
                    ); // <-- memanggil fungsi search
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 WIDGET: LIST KATEGORI HORIZONTAL
  Widget _buildCategoryList() {
    return SizedBox(
      height: 90, // Meningkatkan tinggi agar ada ruang
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategory(Icons.checkroom, "Pakaian"),
          const SizedBox(width: 12),
          _buildCategory(Icons.directions_car, "Otomotif"),
          const SizedBox(width: 12),
          _buildCategory(Icons.computer, "Komputer"),
          const SizedBox(width: 12),
          _buildCategory(Icons.fastfood, "Makanan"),
          const SizedBox(width: 12),
          _buildCategory(Icons.sports_baseball, "Olahraga"),
          const SizedBox(width: 12),
          _buildCategory(Icons.chair, "Furnitur"),
        ],
      ),
    );
  }

  // 🔹 WIDGET: KATEGORI BUNDAR
  Widget _buildCategory(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(
              0.1,
            ), // Warna primer yang lebih lembut
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 28,
          ), // Ikon menggunakan warna primer
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // 🔹 WIDGET: KARTU PRODUK (Versi Rapi)
  Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailPage(productId: product.id)),
        );
      },

      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor, // Warna putih
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ), // Border tipis
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GAMBAR PRODUK
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1.1, // AspectRatio sedikit diubah
                child: Image.network(
                  product.img,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // --- DETAIL PRODUK ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA PRODUK
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                  const SizedBox(height: 2),

                  // KATEGORI
                  Text(
                    product.category.categoryName,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),

                  // HARGA DAN RATING
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // HARGA (sudah diformat)
                      Flexible(
                        // Tambahkan Flexible agar harga tidak overflow
                        child: Text(
                          currencyFormatter.format(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      // RATING
                      Row(
                        children: const [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "4.7",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
