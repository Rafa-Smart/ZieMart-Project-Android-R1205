// lib/views/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ziemart_frontend/viewmodels/settings_viewmodel.dart';

const Color primaryColor = Color(0xFF2F5DFE);
const Color backgroundColor = Color(0xFFF8F9FD);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsVM = Provider.of<SettingsViewModel>(context);

    if (settingsVM.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.8), primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pengaturan Aplikasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola preferensi Anda',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Notifikasi
          _buildSectionHeader('Notifikasi'),
          _buildSettingSwitch(
            title: 'Aktifkan Notifikasi',
            subtitle: 'Terima notifikasi penting',
            value: settingsVM.notificationsEnabled,
            onChanged: settingsVM.setNotificationsEnabled,
          ),
          _buildSettingSwitch(
            title: 'Promo & Diskon',
            subtitle: 'Informasi promo terbaru',
            value: settingsVM.promoNotifications,
            onChanged: settingsVM.setPromoNotifications,
          ),
          _buildSettingSwitch(
            title: 'Update Pesanan',
            subtitle: 'Status pengiriman pesanan',
            value: settingsVM.orderUpdates,
            onChanged: settingsVM.setOrderUpdates,
          ),
          _buildSettingSwitch(
            title: 'Peringatan Stok',
            subtitle: 'Stok produk favorit habis',
            value: settingsVM.stockAlerts,
            onChanged: settingsVM.setStockAlerts,
          ),

          const SizedBox(height: 24),

          // Tampilan
          _buildSectionHeader('Tampilan'),
          _buildSettingSwitch(
            title: 'Mode Gelap',
            subtitle: 'Tampilan lebih nyaman di malam hari',
            value: settingsVM.darkMode,
            onChanged: settingsVM.setDarkMode,
          ),
          _buildSettingOption(
            title: 'Bahasa',
            subtitle: 'Pilih bahasa aplikasi',
            value: settingsVM.language == 'id' ? 'Indonesia' : 'English',
            icon: Icons.language_rounded,
            onTap: () {
              _showLanguageDialog(context, settingsVM);
            },
          ),

          const SizedBox(height: 24),

          // Keamanan
          _buildSectionHeader('Keamanan'),
          _buildSettingSwitch(
            title: 'Two-Factor Auth',
            subtitle: 'Tingkatkan keamanan akun',
            value: settingsVM.twoFactorAuth,
            onChanged: settingsVM.setTwoFactorAuth,
          ),
          _buildSettingSwitch(
            title: 'Simpan Info Login',
            subtitle: 'Login otomatis di perangkat ini',
            value: settingsVM.saveLoginInfo,
            onChanged: settingsVM.setSaveLoginInfo,
          ),

          const SizedBox(height: 24),

          // Aplikasi
          _buildSectionHeader('Aplikasi'),
          _buildSettingSwitch(
            title: 'Update Otomatis',
            subtitle: 'Update aplikasi secara otomatis',
            value: settingsVM.autoUpdate,
            onChanged: settingsVM.setAutoUpdate,
          ),
          _buildSettingSwitch(
            title: 'Cache Gambar',
            subtitle: 'Simpan gambar untuk akses cepat',
            value: settingsVM.cacheImages,
            onChanged: settingsVM.setCacheImages,
          ),
          _buildSettingOption(
            title: 'Bersihkan Cache',
            subtitle: 'Hapus data cache aplikasi',
            icon: Icons.cleaning_services_rounded,
            onTap: () {
              _showClearCacheDialog(context, settingsVM);
            },
          ),
          _buildSettingOption(
            title: 'Reset Pengaturan',
            subtitle: 'Kembalikan ke pengaturan default',
            icon: Icons.restore_rounded,
            onTap: () {
              _showResetDialog(context, settingsVM);
            },
          ),

          const SizedBox(height: 24),

          // Tentang
          _buildSectionHeader('Tentang'),
          _buildSettingOption(
            title: 'Versi Aplikasi',
            subtitle: 'ZieMart v1.0.0',
            icon: Icons.info_outline_rounded,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tentang Aplikasi'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ZieMart - Toko Online'),
                      SizedBox(height: 8),
                      Text('Versi: 1.0.0'),
                      SizedBox(height: 4),
                      Text('Build: 2024.01.01'),
                      SizedBox(height: 4),
                      Text('© 2024 ZieMart Team'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Tutup'),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2B2B2B),
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
          activeTrackColor: primaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    String? value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null)
              Text(
                value,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsViewModel settingsVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Indonesia'),
              leading: Icon(
                Icons.check,
                color: settingsVM.language == 'id' ? primaryColor : Colors.transparent,
              ),
              onTap: () {
                settingsVM.setLanguage('id');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              leading: Icon(
                Icons.check,
                color: settingsVM.language == 'en' ? primaryColor : Colors.transparent,
              ),
              onTap: () {
                settingsVM.setLanguage('en');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, SettingsViewModel settingsVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bersihkan Cache'),
        content: const Text('Apakah Anda yakin ingin membersihkan cache aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              settingsVM.clearCache();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache berhasil dibersihkan'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text('Bersihkan'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, SettingsViewModel settingsVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Pengaturan'),
        content: const Text('Apakah Anda yakin ingin mengembalikan semua pengaturan ke nilai default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              settingsVM.resetAllSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pengaturan berhasil direset'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}