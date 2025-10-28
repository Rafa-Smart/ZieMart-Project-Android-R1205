import '../services/api_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiService _api = ApiService();

  Future<List<Product>> getProducts() async {
    try {
      final response = await _api.get("getProducts");

      // jadi dari api laravel itu harus udah ada key data
      // jadi response dari laravel itu harusny ada key data
      final List<dynamic> productsJson = response['data'];

      // di sini kita akn mapping data dari json, lalu kita buat
      // dia menjadi list
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      // Lemparkan kembali (rethrow) error untuk ditangani di layer UI/BLoC
      rethrow;
    }
  }

  Future<Product> getProductById(int productId) async {
    try {
      final response = await _api.get("getProducts/$productId");
      return Product.fromJson(response['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await _api.get("searchProducts?q=$query");
    final List<dynamic> productsJson = response['data'];
    return productsJson.map((json) => Product.fromJson(json)).toList();
  }
  
}

