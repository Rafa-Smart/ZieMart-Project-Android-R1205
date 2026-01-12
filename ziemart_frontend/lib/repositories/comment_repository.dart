import '../services/api_service.dart';
import '../models/comment_model.dart';

class CommentRepository {
  final ApiService _api = ApiService();

  Future<List<Comment>> getComments(int productId) async {
    final response = await _api.get("comments/$productId");
    final List<dynamic> data = response["data"];
    return data.map((e) => Comment.fromJson(e)).toList();
  }


  Future<Comment> addComment(int productId, Comment comment) async {
    final response = await _api.post("comments/$productId", {
      "account_id": comment.accountId.toString(),
      "comment_text": comment.commentText,
      "product_id": comment.productId.toString(),
    });
    print('dapet response dari addComment: $response');
    return Comment.fromJson(response["data"]);
  }
}
