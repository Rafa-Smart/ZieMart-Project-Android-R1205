class CartItem {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final double subtotal;
  final String? sellerPhone;
  final String? sellerName;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.subtotal,
    this.sellerPhone,
    this.sellerName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productImage: json['product_image'],
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      subtotal: double.parse(json['subtotal'].toString()),
      sellerPhone: json['seller_phone'],
      sellerName: json['seller_name'],
    );
  }
}

class CartData {
  final List<CartItem> items;
  final double total;
  final int itemCount;

  CartData({
    required this.items,
    required this.total,
    required this.itemCount,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: double.parse(json['total'].toString()),
      itemCount: json['item_count'],
    );
  }
}