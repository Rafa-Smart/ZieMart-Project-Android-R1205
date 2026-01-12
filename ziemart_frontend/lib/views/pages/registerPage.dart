import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../config/app_asset.dart';
import '../../../viewmodels/register_viewmodel.dart';
import 'emailVerifiedPage.dart';
import 'loginPage.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Consumer<RegisterViewModel>(
        builder: (context, vm, _) {
          final formKey = GlobalKey<FormState>();

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2F5DFE),
                    const Color(0xFF2F5DFE).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Card(
                      elevation: 20,
                      shadowColor: Colors.black.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F5DFE).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  AppAssets.logo,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                              const Gap(16),
                              
                              // Title
                              const Text(
                                "Buat Akun Baru",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2F5DFE),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const Gap(8),
                              Text(
                                "Bergabunglah dengan Ziemart sekarang",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Gap(28),

                              // Role Selection - Modern Pills
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildRolePill(
                                        vm,
                                        "buyer",
                                        "👤 Pembeli",
                                        Icons.shopping_bag,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildRolePill(
                                        vm,
                                        "seller",
                                        "🏪 Penjual",
                                        Icons.storefront,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(24),

                              // Nama Lengkap / Toko
                              _buildTextField(
                                controller: vm.extraController,
                                label: vm.role == "buyer" ? "Nama Lengkap" : "Nama Toko",
                                icon: vm.role == "buyer"
                                    ? Icons.person_outline
                                    : Icons.storefront_outlined,
                                validator: (v) => v == null || v.isEmpty
                                    ? (vm.role == "buyer"
                                        ? "Nama lengkap wajib diisi"
                                        : "Nama toko wajib diisi")
                                    : null,
                              ),
                              const Gap(14),

                              // Username
                              _buildTextField(
                                controller: vm.usernameController,
                                label: "Username",
                                icon: Icons.person,
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Username wajib diisi" : null,
                              ),
                              const Gap(14),

                              // Email
                              _buildTextField(
                                controller: vm.emailController,
                                label: "Email",
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Email wajib diisi";
                                  }
                                  //  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!emailRegex.hasMatch(value)) {
                                    return "Format email tidak valid";
                                  }
                                  return null;
                                },
                              ),
                              const Gap(14),

                              // Nomor HP
                              _buildTextField(
                                controller: vm.phoneController,
                                label: "Nomor HP",
                                icon: Icons.phone_android,
                                keyboardType: TextInputType.phone,
                                validator: (v) =>
                                    v == null || v.isEmpty ? "Nomor wajib diisi" : null,
                              ),
                              const Gap(14),

                              // Password
                              _buildTextField(
                                controller: vm.passwordController,
                                label: "Password",
                                icon: Icons.lock_outline,
                                obscureText: true,
                                validator: (v) {
                                  if (v == null || v.isEmpty)
                                    return "Password wajib diisi";
                                  if (v.length < 6) return "Minimal 6 karakter";
                                  return null;
                                },
                              ),
                              const Gap(14),

                              // Konfirmasi Password
                              _buildTextField(
                                controller: vm.confirmPasswordController,
                                label: "Konfirmasi Password",
                                icon: Icons.lock_person_outlined,
                                obscureText: true,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "Konfirmasi password wajib diisi";
                                  }
                                  if (v != vm.passwordController.text) {
                                    return "Password tidak sama";
                                  }
                                  return null;
                                },
                              ),
                              const Gap(28),

                              // Tombol Daftar
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: vm.isLoading
                                      ? null
                                      : () async {
                                          if (formKey.currentState!.validate()) {
                                            final success = await vm.register();
                                            
                                            if (success && context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: const [
                                                      Icon(Icons.check_circle, color: Colors.white),
                                                      SizedBox(width: 8),
                                                      Text("Registrasi berhasil!"),
                                                    ],
                                                  ),
                                                  backgroundColor: Colors.green,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              );
                                              
                                              if (vm.role == "buyer") {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const LoginPage(),
                                                  ),
                                                );
                                              } else {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EmailVerifiedPage(
                                                      email: vm.emailController.text.trim(),
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      const Icon(Icons.error, color: Colors.white),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          vm.errorMessage ?? "Registrasi gagal.",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor: Colors.red,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2F5DFE),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 4,
                                    shadowColor: const Color(0xFF2F5DFE).withOpacity(0.4),
                                  ),
                                  child: vm.isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.person_add, color: Colors.white, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              "DAFTAR",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                              const Gap(24),

                              // Divider
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.grey[300])),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      "atau",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.grey[300])),
                                ],
                              ),
                              const Gap(24),

                              // Login Redirect
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sudah punya akun? ",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 15,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    ),
                                    child: const Text(
                                      "Login di sini",
                                      style: TextStyle(
                                        color: Color(0xFF2F5DFE),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRolePill(
    RegisterViewModel vm,
    String value,
    String label,
    IconData icon,
  ) {
    final isSelected = vm.role == value;
    return InkWell(
      onTap: () => vm.changeRole(value),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F5DFE) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 14,
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
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF2F5DFE), size: 20),
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2F5DFE), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}