import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = "http://127.0.0.1:8000/api/ziemart";

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse("$_baseUrl/$endpoint");
    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal: ${response.statusCode} - ${response.body}");
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse("$_baseUrl/$endpoint");
    final response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Gagal: ${response.statusCode} - ${response.body}");
    }
  }

  
}
