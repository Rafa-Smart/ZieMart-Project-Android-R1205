// lib/viewmodels/settings_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  // Pengaturan notifikasi
  bool _notificationsEnabled = true;
  bool _promoNotifications = true;
  bool _orderUpdates = true;
  bool _stockAlerts = true;
  
  // Pengaturan tampilan
  bool _darkMode = false;
  String _language = 'id';
  
  // Pengaturan keamanan
  bool _twoFactorAuth = false;
  bool _saveLoginInfo = true;
  
  // Pengaturan lainnya
  bool _autoUpdate = true;
  bool _cacheImages = true;

  bool _isLoading = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get promoNotifications => _promoNotifications;
  bool get orderUpdates => _orderUpdates;
  bool get stockAlerts => _stockAlerts;
  bool get darkMode => _darkMode;
  String get language => _language;
  bool get twoFactorAuth => _twoFactorAuth;
  bool get saveLoginInfo => _saveLoginInfo;
  bool get autoUpdate => _autoUpdate;
  bool get cacheImages => _cacheImages;

  SettingsViewModel() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _promoNotifications = prefs.getBool('promoNotifications') ?? true;
      _orderUpdates = prefs.getBool('orderUpdates') ?? true;
      _stockAlerts = prefs.getBool('stockAlerts') ?? true;
      _darkMode = prefs.getBool('darkMode') ?? false;
      _language = prefs.getString('language') ?? 'id';
      _twoFactorAuth = prefs.getBool('twoFactorAuth') ?? false;
      _saveLoginInfo = prefs.getBool('saveLoginInfo') ?? true;
      _autoUpdate = prefs.getBool('autoUpdate') ?? true;
      _cacheImages = prefs.getBool('cacheImages') ?? true;
    } catch (e) {
      print('Error loading settings: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Setters
  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setPromoNotifications(bool value) {
    _promoNotifications = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setOrderUpdates(bool value) {
    _orderUpdates = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setStockAlerts(bool value) {
    _stockAlerts = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setLanguage(String value) {
    _language = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setTwoFactorAuth(bool value) {
    _twoFactorAuth = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setSaveLoginInfo(bool value) {
    _saveLoginInfo = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setAutoUpdate(bool value) {
    _autoUpdate = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  void setCacheImages(bool value) {
    _cacheImages = value;
    _saveToSharedPreferences();
    notifyListeners();
  }

  Future<void> _saveToSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('notificationsEnabled', _notificationsEnabled);
      await prefs.setBool('promoNotifications', _promoNotifications);
      await prefs.setBool('orderUpdates', _orderUpdates);
      await prefs.setBool('stockAlerts', _stockAlerts);
      await prefs.setBool('darkMode', _darkMode);
      await prefs.setString('language', _language);
      await prefs.setBool('twoFactorAuth', _twoFactorAuth);
      await prefs.setBool('saveLoginInfo', _saveLoginInfo);
      await prefs.setBool('autoUpdate', _autoUpdate);
      await prefs.setBool('cacheImages', _cacheImages);
      
      print('Settings saved successfully');
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  Future<void> clearCache() async {
    // Implementasi clear cache
    print('Cache cleared');
    
    // Contoh clear data cache
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Jangan hapus pengaturan, hanya cache aplikasi
      // Bisa tambahkan logika lain di sini
    } catch (e) {
      print('Error clearing cache: $e');
    }
    
    notifyListeners();
  }

  Future<void> clearData() async {
    // Implementasi clear semua data
    print('All data cleared');
    
    // Reset semua pengaturan ke default
    _notificationsEnabled = true;
    _promoNotifications = true;
    _orderUpdates = true;
    _stockAlerts = true;
    _darkMode = false;
    _language = 'id';
    _twoFactorAuth = false;
    _saveLoginInfo = true;
    _autoUpdate = true;
    _cacheImages = true;
    
    await _saveToSharedPreferences();
    notifyListeners();
  }

  Future<void> exportData() async {
    // Implementasi export data
    print('Data exported');
    
    // Contoh implementasi export
    final data = {
      'notificationsEnabled': _notificationsEnabled,
      'promoNotifications': _promoNotifications,
      'orderUpdates': _orderUpdates,
      'stockAlerts': _stockAlerts,
      'darkMode': _darkMode,
      'language': _language,
      'twoFactorAuth': _twoFactorAuth,
      'saveLoginInfo': _saveLoginInfo,
      'autoUpdate': _autoUpdate,
      'cacheImages': _cacheImages,
    };
    
    print('Exported data: $data');
    notifyListeners();
  }

  // Reset semua pengaturan ke default
  Future<void> resetAllSettings() async {
    await clearData();
  }
}