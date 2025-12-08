import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/profile_viewmodel.dart';
import '../../viewmodels/login_viewmodel.dart';

const Color primaryColor = Color(0xFF2F5DFE);

class ProfilePage extends StatefulWidget {
  final int userId;
  
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProfileViewModel>(context, listen: false).loadProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadProfile(widget.userId),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.currentUser == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: primaryColor)),
            );
          }

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: primaryColor,
                elevation: 0,
                title: const Text(
                  "Profil Saya",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: "Info Profil"),
                    Tab(text: "Keamanan"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _buildProfileTab(vm),
                  _buildSecurityTab(vm),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // TAB 1: Profile Info
  Widget _buildProfileTab(ProfileViewModel vm) {
    final formKey = GlobalKey<FormState>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              child: Text(
                (vm.currentUser?.username ?? "U").substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              vm.currentUser?.username ?? "U" ,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Username
            _buildTextField(
              controller: vm.usernameController,
              label: "Username",
              icon: Icons.person,
              validator: (v) => v == null || v.isEmpty ? "Username wajib diisi" : null,
            ),
            const SizedBox(height: 16),

            // Email
            _buildTextField(
              controller: vm.emailController,
              label: "Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return "Email wajib diisi";
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(v)) return "Format email tidak valid";
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone
            _buildTextField(
              controller: vm.phoneController,
              label: "Nomor HP",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.isEmpty ? "Nomor HP wajib diisi" : null,
            ),
            const SizedBox(height: 16),

            // Full Name / Store Name
            _buildTextField(
              controller: vm.extraController,
              label: vm.currentUser?.role == 'buyer' ? "Nama Lengkap" : "Nama Toko",
              icon: vm.currentUser?.role == 'buyer' ? Icons.badge : Icons.storefront,
              validator: (v) => v == null || v.isEmpty
                  ? (vm.currentUser?.role == 'buyer' 
                      ? "Nama lengkap wajib diisi" 
                      : "Nama toko wajib diisi")
                  : null,
            ),
            const SizedBox(height: 30),

            // Error Message
            if (vm.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vm.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            // Button Update
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          final success = await vm.updateProfile();
                          
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Profile berhasil diupdate!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (mounted && vm.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(vm.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: vm.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Button Delete Account
            TextButton(
              onPressed: () => _showDeleteConfirmation(vm),
              child: const Text(
                "Hapus Akun",
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB 2: Security (Change Password)
  Widget _buildSecurityTab(ProfileViewModel vm) {
    final formKey = GlobalKey<FormState>();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ubah Password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Pastikan password baru minimal 6 karakter dan mudah diingat.",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Old Password
            _buildTextField(
              controller: vm.oldPasswordController,
              label: "Password Lama",
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (v) => v == null || v.isEmpty ? "Password lama wajib diisi" : null,
            ),
            const SizedBox(height: 16),

            // New Password
            _buildTextField(
              controller: vm.newPasswordController,
              label: "Password Baru",
              icon: Icons.lock,
              obscureText: true,
              validator: (v) {
                if (v == null || v.isEmpty) return "Password baru wajib diisi";
                if (v.length < 6) return "Minimal 6 karakter";
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirm Password
            _buildTextField(
              controller: vm.confirmPasswordController,
              label: "Konfirmasi Password Baru",
              icon: Icons.lock_person,
              obscureText: true,
              validator: (v) {
                if (v == null || v.isEmpty) return "Konfirmasi password wajib diisi";
                if (v != vm.newPasswordController.text) return "Password tidak sama";
                return null;
              },
            ),
            const SizedBox(height: 30),

            // Error Message
            if (vm.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vm.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            // Button Change Password
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: vm.isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          final success = await vm.changePassword();
                          
                          if (success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Password berhasil diubah!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (mounted && vm.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(vm.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: vm.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Ubah Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryColor),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Akun"),
        content: const Text(
          "Apakah Anda yakin ingin menghapus akun? "
          "Tindakan ini tidak dapat dibatalkan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final success = await vm.deleteAccount();
              
              if (success && mounted) {
                // Logout dan kembali ke login
                final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
                await loginViewModel.logout();
                
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/loginPage',
                    (route) => false,
                  );
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Akun berhasil dihapus"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(vm.errorMessage ?? "Gagal menghapus akun"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}