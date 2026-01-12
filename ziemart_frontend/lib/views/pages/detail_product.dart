import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/product_model.dart';
import '../../models/comment_model.dart';
import '../../viewmodels/product_viewmodel.dart';
import '../../viewmodels/comment_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../viewmodels/wishlist_viewmodel.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../utils/formatter.dart';
import 'package:flutter/services.dart'; // Untuk Clipboard
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Product? product;
  bool isLoading = true;
  int quantity = 1;
  bool isWishlisted = false;
  int? wishlistId;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _loadProductDetail();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommentViewModel>(context, listen: false)
          .fetchComments(widget.productId);
      _checkWishlistStatus();
    });
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showTitle) {
      setState(() => _showTitle = true);
    } else if (_scrollController.offset <= 200 && _showTitle) {
      setState(() => _showTitle = false);
    }
  }

  Future<void> _loadProductDetail() async {
    final vm = Provider.of<ProductViewModel>(context, listen: false);
    final result = await vm.getProductById(widget.productId);
    setState(() {
      product = result;
      isLoading = false;
    });
  }

  Future<void> _checkWishlistStatus() async {
    final loginVm = Provider.of<LoginViewModel>(context, listen: false);
    final user = await loginVm.loadCurrentUser();

    if (user == null) return;

    final wishlistVm = Provider.of<WishlistViewModel>(context, listen: false);
    final wishlisted = await wishlistVm.checkWishlist(user.id!, widget.productId);

    if (mounted) {
      setState(() {
        isWishlisted = wishlisted;
        if (wishlisted) {
          wishlistId = wishlistVm.getWishlistIdByProductId(widget.productId);
        }
      });
    }
  }

  Future<void> _toggleWishlist() async {
    final loginVm = Provider.of<LoginViewModel>(context, listen: false);
    final user = await loginVm.loadCurrentUser();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    final wishlistVm = Provider.of<WishlistViewModel>(context, listen: false);

    if (isWishlisted && wishlistId != null) {
      final success = await wishlistVm.removeFromWishlist(wishlistId!);
      
      if (mounted) {
        setState(() {
          isWishlisted = false;
          wishlistId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Dihapus dari wishlist'
                : 'Gagal menghapus dari wishlist'),
            backgroundColor: success ? Colors.orange : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      final success = await wishlistVm.addToWishlist(user.id!, widget.productId);

      if (mounted) {
        await _checkWishlistStatus();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? '${product!.productName} ditambahkan ke wishlist'
                : 'Gagal menambahkan ke wishlist'),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _increaseQuantity() => setState(() => quantity++);
  
  void _decreaseQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final loginVm = Provider.of<LoginViewModel>(context, listen: false);
    final user = await loginVm.loadCurrentUser();

    if (user == null) return;

    final comment = Comment(
      accountId: user.id!,
      productId: widget.productId,
      commentText: text,
    );

    await Provider.of<CommentViewModel>(context, listen: false)
        .addComment(widget.productId, comment);

    if (!mounted) return;
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  Future<void> _addToCart() async {
    final loginVm = Provider.of<LoginViewModel>(context, listen: false);
    final user = await loginVm.loadCurrentUser();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    final cartVm = Provider.of<CartViewModel>(context, listen: false);
    final success = await cartVm.addToCart(user.id!, product!.id, quantity);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  success
                      ? '${product!.productName} ditambahkan ke keranjang'
                      : 'Gagal menambahkan ke keranjang',
                ),
              ),
            ],
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

Future<void> _orderViaWhatsApp() async {
  final loginVm = Provider.of<LoginViewModel>(context, listen: false);
  final user = await loginVm.loadCurrentUser();

  if (user == null) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return;
  }

  if (product?.seller?.phoneNumber == null || product!.seller!.phoneNumber!.isEmpty) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor WhatsApp seller tidak tersedia'),
          backgroundColor: Colors.red,
        ),
      );
    }
    return;
  }

  // Validasi stok
  if (quantity > product!.stock) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok tidak mencukupi. Stok tersedia: ${product!.stock}'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    return;
  }

  // Simpan ke database dulu (optional)
  final orderVm = Provider.of<OrderViewModel>(context, listen: false);
  final totalPrice = (product!.price * quantity).toDouble();

  final success = await orderVm.createOrder(
    accountId: user.id!,
    productId: product!.id,
    quantity: quantity,
    totalPrice: totalPrice,
  );

  // Format nomor WhatsApp
  String phone = product!.seller!.phoneNumber!.replaceAll(RegExp(r'[^0-9+]'), '');

  // Handle berbagai format nomor
  if (phone.startsWith('0')) {
    phone = '+62${phone.substring(1)}';
  } else if (phone.startsWith('62')) {
    phone = '+$phone';
  } else if (phone.startsWith('+')) {
    // Sudah format internasional
  } else {
    phone = '+62$phone';
  }

  // Hapus spasi dan karakter khusus
  phone = phone.replaceAll(' ', '').replaceAll('-', '');

  // Buat pesan
  final message = '''
Halo, saya tertarik dengan produk:

*${product!.productName}*
Harga: ${formatCurrency(product!.price.toDouble())}
Jumlah: $quantity
Total: ${formatCurrency(totalPrice)}

Apakah produk masih tersedia?

*Data Pembeli:*
Nama: ${user.username}
Email: ${user.email}
''';

  // Encode URL dengan benar
  final encodedMessage = Uri.encodeComponent(message);
  
  // Coba berbagai format URL
  final urlPatterns = [
    'whatsapp://send?phone=$phone&text=$encodedMessage',
    'https://wa.me/$phone?text=$encodedMessage',
    'https://api.whatsapp.com/send?phone=$phone&text=$encodedMessage',
  ];

  bool launched = false;
  
  for (final urlPattern in urlPatterns) {
    try {
      final url = Uri.parse(urlPattern);
      
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
        launched = true;
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Membuka WhatsApp...'),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
        break;
      }
    } catch (e) {
      print('Gagal dengan URL $urlPattern: $e');
      continue;
    }
  }

  if (!launched && mounted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tidak Bisa Membuka WhatsApp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Silakan hubungi seller secara manual:'),
            const SizedBox(height: 10),
            SelectableText(
              'Nomor: $phone',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            SelectableText(
              'Pesan: $message',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: phone));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nomor disalin ke clipboard')),
              );
              Navigator.pop(context);
            },
            child: const Text('Salin Nomor'),
          ),
        ],
      ),
    );
  }
}
  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF2F5DFE))),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2F5DFE),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text("Produk tidak ditemukan")),
      );
    }

    final totalPrice = (product!.price * quantity).toDouble();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProductInfo(),
                _buildQuantitySelector(),
                _buildDescription(),
                _buildCommentSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(totalPrice),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: const Color(0xFF2F5DFE),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2F5DFE)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : const Color(0xFF2F5DFE),
            ),
            onPressed: _toggleWishlist,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Color(0xFF2F5DFE)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur share segera hadir')),
              );
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: _showTitle
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product!.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : null,
        background: Hero(
          tag: 'product_${product!.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                product!.img,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F5DFE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product!.category.categoryName,
                    style: const TextStyle(
                      color: Color(0xFF2F5DFE),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "4.7",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product!.productName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5DFE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.store, color: Color(0xFF2F5DFE), size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product!.seller?.storeName ?? 'Toko',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Penjual Terpercaya',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harga',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(product!.price.toDouble()),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F5DFE),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.8),
                      Colors.green,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inventory, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Stok: ${product!.stock}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Jumlah',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2F5DFE).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _decreaseQuantity,
                  icon: const Icon(Icons.remove_circle),
                  color: const Color(0xFF2F5DFE),
                  iconSize: 28,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F5DFE),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _increaseQuantity,
                  icon: const Icon(Icons.add_circle),
                  color: const Color(0xFF2F5DFE),
                  iconSize: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5DFE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF2F5DFE),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Deskripsi Produk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            product!.description.isEmpty
                ? 'Tidak ada deskripsi produk.'
                : product!.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5DFE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.chat_bubble,
                  color: Color(0xFF2F5DFE),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Komentar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Consumer<CommentViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: Color(0xFF2F5DFE)),
                  ),
                );
              }

              if (vm.comments.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada komentar',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Jadilah yang pertama berkomentar!',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.comments.length,
                separatorBuilder: (_, __) => Divider(
                  height: 32,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final comment = vm.comments[index];
                  return _buildCommentTile(comment);
                },
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Tulis komentar...",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    prefixIcon: const Icon(Icons.edit, color: Color(0xFF2F5DFE)),
                  ),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2F5DFE), Color(0xFF1E45CC)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2F5DFE).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _submitComment,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF2F5DFE).withOpacity(0.2),
                const Color(0xFF2F5DFE).withOpacity(0.1),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Color(0xFF2F5DFE),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      comment.account?.username ?? 'User ${comment.accountId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      comment.timeAgo ?? 'Baru saja',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                comment.commentText,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Harga',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(totalPrice),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F5DFE),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _orderViaWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: Colors.green.withOpacity(0.4),
                    ),
                    icon: const Icon(Icons.chat_bubble, color: Colors.white, size: 22),
                    label: const Text(
                      'Pesan Sekarang',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F5DFE),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0xFF2F5DFE).withOpacity(0.4),
                    ),
                    icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 22),
                    label: const Text(
                      'Keranjang',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
