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
            backgroundColor: const Color(0xFF19253D),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Card(
                    elevation: 12,
                    shadowColor: Colors.blueAccent.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AppAssets.logo, width: 90, height: 90),
                            const Gap(16),
                            const Text(
                              "Buat Akun Ziemart",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                            const Gap(28),

                            // Username
                            buildTextField(
                              controller: vm.usernameController,
                              label: "Username",
                              icon: Icons.person,
                              validator: (v) => v == null || v.isEmpty
                                  ? "Username wajib diisi"
                                  : null,
                            ),
                            const Gap(14),

                            // Email & Phone
                            Row(
                              children: [
                                Expanded(
                                  child: buildTextField(
                                    controller: vm.emailController,
                                    label: "Email",
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email wajib diisi";
                                      }
                                      final emailRegex = RegExp(
                                        r'^[^@]+@[^@]+\.[^@]+',
                                      );
                                      if (!emailRegex.hasMatch(value)) {
                                        return "Format email tidak valid";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: buildTextField(
                                    controller: vm.phoneController,
                                    label: "Nomor HP",
                                    icon: Icons.phone_android,
                                    keyboardType: TextInputType.phone,
                                    validator: (v) => v == null || v.isEmpty
                                        ? "Nomor wajib diisi"
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(14),

                            // Password
                            buildTextField(
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
                            buildTextField(
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
                            const Gap(18),

                            // Role
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildRadio(vm, "buyer", "Pembeli"),
                                const Gap(14),
                                buildRadio(vm, "seller", "Penjual"),
                              ],
                            ),
                            const Gap(14),

                            // Nama Lengkap / Toko
                            buildTextField(
                              controller: vm.extraController,
                              label: vm.role == "buyer"
                                  ? "Nama Lengkap"
                                  : "Nama Toko",
                              icon: vm.role == "buyer"
                                  ? Icons.person_outline
                                  : Icons.storefront_outlined,
                              validator: (v) => v == null || v.isEmpty
                                  ? (vm.role == "buyer"
                                        ? "Nama lengkap wajib diisi"
                                        : "Nama toko wajib diisi")
                                  : null,
                            ),
                            const Gap(28),

                            // Tombol Daftar
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: vm.isLoading
                                    ? null
                                    : () async {
                                        if (formKey.currentState!.validate()) {
                                          final success = await vm.register();
                                          if (success) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Registrasi berhasil!",
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            if (vm.role == "buyer") {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage(),
                                                ),
                                              );
                                            } else {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EmailVerifiedPage(
                                                        email: vm
                                                            .emailController
                                                            .text
                                                            .trim(),
                                                      ),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Registrasi gagal.",
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 6,
                                ),
                                child: vm.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                    : const Text(
                                        "DAFTAR",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            const Gap(20),

                            // Login Redirect
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Sudah punya akun? "),
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
                                      color: Color(0xFF1565C0),
                                      fontWeight: FontWeight.bold,
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
          );
        },
      ),
    );
  }

  Widget buildTextField({
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
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        labelStyle: const TextStyle(color: Colors.black87),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent.shade200, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget buildRadio(RegisterViewModel vm, String value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: vm.role,
          activeColor: Colors.blueAccent,
          onChanged: (val) => vm.changeRole(val.toString()),
        ),
        Text(label, style: const TextStyle(color: Color(0xFF1565C0))),
      ],
    );
  }
}