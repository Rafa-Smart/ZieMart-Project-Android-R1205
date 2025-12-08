import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../utils/formatter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final loginVm = Provider.of<LoginViewModel>(context, listen: false);
    final user = await loginVm.loadCurrentUser();
    
    if (user != null && mounted) {
      Provider.of<CartViewModel>(context, listen: false).loadCart(user.id!);
    }
  }

  Future<void> _checkoutViaWhatsApp() async {
    final cartVm = Provider.of<CartViewModel>(context, listen: false);
    
    if (cartVm.cartItems.isEmpty) return;

    // Group by seller
    Map<String, List> itemsBySeller = {};
    for (var item in cartVm.cartItems) {
      final sellerKey = '${item.sellerName}|${item.sellerPhone}';
      if (!itemsBySeller.containsKey(sellerKey)) {
        itemsBySeller[sellerKey] = [];
      }
      itemsBySeller[sellerKey]!.add(item);
    }

    // Kirim ke setiap seller
    for (var entry in itemsBySeller.entries) {
      final parts = entry.key.split('|');
      final sellerName = parts[0];
      String? sellerPhone = parts[1];
      final items = entry.value;

      if (sellerPhone == 'null' || sellerPhone.isEmpty) continue;

      String phone = sellerPhone.replaceAll(RegExp(r'[^0-9]'), '');
      if (!phone.startsWith('62')) {
        if (phone.startsWith('0')) {
          phone = '62${phone.substring(1)}';
        } else {
          phone = '62$phone';
        }
      }

      String message = 'Halo *$sellerName*, saya ingin memesan:\n\n';
      double subtotal = 0;
      
      for (var item in items) {
        message += '• ${item.productName}\n';
        message += '  Jumlah: ${item.quantity}\n';
        message += '  Harga: ${formatCurrency(item.subtotal)}\n\n';
        subtotal += item.subtotal;
      }
      
      message += '*Total: ${formatCurrency(subtotal)}*\n\n';
      message += 'Mohon konfirmasi ketersediaan produk. Terima kasih!';

      final url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F5DFE),
        elevation: 0,
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Consumer<CartViewModel>(
            builder: (context, vm, _) {
              if (vm.cartItems.isEmpty) return const SizedBox();
              
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () => _showClearCartDialog(),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2F5DFE)),
            );
          }

          if (vm.cartItems.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = vm.cartItems[index];
                    return _buildCartItem(item, vm);
                  },
                ),
              ),
              _buildBottomBar(vm),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'Keranjang Kosong',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Yuk, mulai belanja sekarang!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2F5DFE),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            label: const Text(
              'Mulai Belanja',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(item, CartViewModel vm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.productImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.store, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.sellerName ?? 'Toko',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(item.price),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F5DFE),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Quantity Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final loginVm = Provider.of<LoginViewModel>(
                                  context,
                                  listen: false,
                                );
                                final user = await loginVm.loadCurrentUser();
                                if (user != null && item.quantity > 1) {
                                  vm.updateCartItem(
                                    user.id!,
                                    item.id,
                                    item.quantity - 1,
                                  );
                                }
                              },
                              icon: const Icon(Icons.remove, size: 18),
                              padding: const EdgeInsets.all(4),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final loginVm = Provider.of<LoginViewModel>(
                                  context,
                                  listen: false,
                                );
                                final user = await loginVm.loadCurrentUser();
                                if (user != null) {
                                  vm.updateCartItem(
                                    user.id!,
                                    item.id,
                                    item.quantity + 1,
                                  );
                                }
                              },
                              icon: const Icon(Icons.add, size: 18),
                              padding: const EdgeInsets.all(4),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final loginVm = Provider.of<LoginViewModel>(
                            context,
                            listen: false,
                          );
                          final user = await loginVm.loadCurrentUser();
                          if (user != null) {
                            vm.removeFromCart(user.id!, item.id);
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
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

  Widget _buildBottomBar(CartViewModel vm) {
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
                      'Total (${vm.itemCount} item)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(vm.totalPrice),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F5DFE),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _checkoutViaWhatsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
                label: const Text(
                  'Checkout via WhatsApp',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kosongkan Keranjang'),
        content: const Text(
          'Apakah Anda yakin ingin mengosongkan semua item di keranjang?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final loginVm = Provider.of<LoginViewModel>(
                context,
                listen: false,
              );
              final user = await loginVm.loadCurrentUser();
              
              if (user != null) {
                final cartVm = Provider.of<CartViewModel>(
                  context,
                  listen: false,
                );
                await cartVm.clearCart(user.id!);
              }
              
              if (mounted) Navigator.pop(context);
            },
            child: const Text(
              'Kosongkan',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}