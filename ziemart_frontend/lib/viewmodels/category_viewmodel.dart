
import 'package:flutter/foundation.dart';
// import '../viewmodels/category_viewmodel.dart';
import '../models/category_model.dart' as model;
import '../models/product_model.dart';
import '../repositories/category_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<model.Category> _categories = [];
  List<model.Category> _popularCategories = [];
  model.Category? _selectedCategory;
  List<Product> _categoryProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<model.Category> get categories => _categories;
  List<model.Category> get popularCategories => _popularCategories;
  model.Category? get selectedCategory => _selectedCategory;
  List<Product> get categoryProducts => _categoryProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all categories
  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch popular categories
  Future<void> fetchPopularCategories() async {
    try {
      _popularCategories = await _repository.getPopularCategories();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Get category by ID
  Future<model.Category?> getCategoryById(int id) async {
    try {
      return await _repository.getCategoryById(id);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Get products by category
  Future<void> fetchProductsByCategory(int categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getProductsByCategory(categoryId);
      _selectedCategory = result['category'];
      _categoryProducts = result['products'];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear selected category
  void clearSelection() {
    _selectedCategory = null;
    _categoryProducts = [];
    notifyListeners();
  }
}