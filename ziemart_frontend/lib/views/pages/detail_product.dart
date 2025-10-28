import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../models/comment_model.dart';
import '../../viewmodels/product_viewmodel.dart';
import '../../viewmodels/comment_viewmodel.dart';
import '../../utils/formatter.dart';

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  Product? product;
  bool isLoading = true;
  int quantity = 1;
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _loadProductDetail();
    // 🎯 TAMBAH: Ambil komentar saat halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommentViewModel>(
        context,
        listen: false,
      ).fetchComments(widget.productId);
    });
  }

  Future<void> _loadProductDetail() async {
    final vm = Provider.of<ProductViewModel>(context, listen: false);
    final result = await vm.getProductById(widget.productId);
    setState(() {
      product = result;
      isLoading = false;
    });
    _controller.forward();
  }

  void _increaseQuantity() => setState(() => quantity++);
  void _decreaseQuantity() => setState(() {
    if (quantity > 1) quantity--;
  });

  // 🔹 FUNGSI UNTUK MENGIRIM KOMENTAR
  // di _DetailPageState
  Future<void> _submitComment() async {
    print('Tombol kirim komentar ditekan');
    final text = _commentController.text.trim();

    if (text.isEmpty) {
      return;
    }
    
    const int currentAccountId = 1;
    final comment = Comment(
      accountId: currentAccountId,
      productId: widget.productId,
      commentText: text,
    );

    await Provider.of<CommentViewModel>(
      context,
      listen: false,
    ).addComment(widget.productId, comment);

    // **Tambahkan pengecekan mounted di sini**
    if (!mounted) return; // 👈 JIKA HALAMAN SUDAH DITUTUP/DI-DISPOSE

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Produk tidak ditemukan")),
      );
    }

    final double totalPrice = (product!.price * quantity).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            // 🔹 Background gradient di belakang gambar
            Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade700],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // 🔹 Scrollable Content (dengan padding agar tidak tertutup bottom bar)
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 140,
              ), // Padding untuk Bottom Bar
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar produk (hero effect)
                      Hero(
                        tag: product!.id,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          child: Image.network(
                            product!.img,
                            width: double.infinity,
                            height: 350,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 350,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 🔹 Card isi informasi produk
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Produk
                              Text(
                                product!.productName,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Nama Kategori
                              Row(
                                children: [
                                  const Icon(
                                    Icons.category_outlined,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    product!.category.categoryName,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Harga Produk
                              Text(
                                formatCurrency(product!.price.toDouble()),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2F5DFE),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: _decreaseQuantity,
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                        color: Colors.blueAccent,
                                      ),
                                      Text(
                                        '$quantity',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: _increaseQuantity,
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                        color: Colors.blueAccent,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Deskripsi Produk
                              const Text(
                                "Deskripsi Produk",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product!.description.isEmpty
                                    ? "Tidak ada deskripsi produk."
                                    : product!.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 30),

                              // 🔹 Bagian Komentar
                              const Text(
                                "Komentar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // List Komentar menggunakan Consumer
                              Consumer<CommentViewModel>(
                                builder: (context, vm, child) {
                                  if (vm.isLoading) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (vm.comments.isEmpty) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text("Belum ada komentar."),
                                      ),
                                    );
                                  }

                                  // Tampilkan daftar komentar
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: vm.comments.length,
                                    itemBuilder: (context, index) {
                                      final comment = vm.comments[index];
                                      return CommentTile(comment: comment);
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 20),

                              // 🔹 Input Komentar
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _commentController,
                                        decoration: InputDecoration(
                                          hintText: "Tulis komentar...",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                        ),
                                        minLines: 1,
                                        maxLines: 4,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Color(0xFF2F5DFE),
                                      ),
                                      onPressed: () => _submitComment(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Back Button di atas gambar produk
                ],
              ),
            ),

            // 🔹 Bottom Bar: Total Harga & Tombol
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total harga
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Harga",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatCurrency(totalPrice.toDouble()),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F5DFE),
                          ),
                        ),
                      ],
                    ),

                    // Tombol tambah ke keranjang
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${product!.productName} ditambahkan ke keranjang ($quantity item)",
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F5DFE),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Tambah ke Keranjang",
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🧱 Widget terpisah untuk menampilkan satu komentar (Perlu didefinisikan di file yang sama/terpisah)
class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    // Asumsi model Comment memiliki properti seperti 'username' dan 'timestamp'
    // Untuk contoh ini, kita menggunakan placeholder karena model asli tidak disertakan.
    final String username = comment.accountId == 1
        ? "Anda"
        : "User ${comment.accountId}";
    final String timeAgo =
        'Baru saja'; // Ganti dengan logika format waktu yang sesuai

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar/Ikon User
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF2F5DFE),
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 12),
          // Konten Komentar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• $timeAgo',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.commentText, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
