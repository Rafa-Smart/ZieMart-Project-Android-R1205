// lib/viewmodels/email_viewmodel.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/email_model.dart';

class EmailViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  Future<bool> sendHelpEmail(EmailData emailData) async {
    _isLoading = true;
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();

    try {
      const String apiUrl = "http://192.168.1.6:8000/api/ziemart/send-help-email";
      // const String apiUrl = 'http://10.0.2.2:8000/api/send-help-email';
      
      print('Mengirim email ke: $apiUrl');
      print('Data: ${json.encode(emailData.toJson())}');
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(emailData.toJson()),
      );

      _isLoading = false;
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          _successMessage = responseData['message'] ?? 'Email berhasil dikirim';
        } else {
          _errorMessage = responseData['message'] ?? 'Gagal mengirim email';
        }
        notifyListeners();
        return responseData['success'] == true;
      } else {
        _errorMessage = 'Gagal mengirim email. Status: ${response.statusCode}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error: $e';
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();
  }
}