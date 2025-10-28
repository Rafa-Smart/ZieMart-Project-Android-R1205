// file comment_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../models/comment_model.dart';
import '../repositories/comment_repository.dart';

class CommentViewModel extends ChangeNotifier {
  final CommentRepository _repository = CommentRepository();
  List<Comment> _comments = [];
  bool _isLoading = false;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  Future<void> fetchComments(int productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _comments = await _repository.getComments(productId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> addComment(int productId, Comment comment) async {
    // 1. Panggil repository untuk menyimpan komentar ke backend
    final newComment = await _repository.addComment(productId, comment);
    
    // 2. Perbarui list lokal
    _comments.insert(0, newComment);
    
    // 3. Beri tahu semua widget Consumer bahwa data telah berubah
    notifyListeners(); 
  }
}