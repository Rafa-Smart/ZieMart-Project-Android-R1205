import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class CategoryRepository {
  final ApiService _api = ApiService();

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _api.get("categories");
      
      if (response["data"] != null) {
        return (response["data"] as List)
            .map((json) => Category.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Get category by ID
  Future<Category?> getCategoryById(int id) async {
    try {
      final response = await _api.get("categories/$id");
      
      if (response["data"] != null) {
        return Category.fromJson(response["data"]);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Get products by category
  Future<Map<String, dynamic>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _api.get("categories/$categoryId/products");
      
      Category? category;
      List<Product> products = [];

      if (response["category"] != null) {
        category = Category.fromJson(response["category"]);
      }

      if (response["products"] != null) {
        products = (response["products"] as List)
            .map((json) => Product.fromJson(json))
            .toList();
      }

      return {
        'category': category,
        'products': products,
      };
    } catch (e) {
      rethrow;
    }
  }

  // Get popular categories
  Future<List<Category>> getPopularCategories() async {
    try {
      final response = await _api.get("categories/popular/list");
      
      if (response["data"] != null) {
        return (response["data"] as List)
            .map((json) => Category.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}