// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ziemart_frontend/config/app_asset.dart';
// import 'package:gap/gap.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _showError = false;
//   bool _isLoading = false;
//   bool _isResetLoading = false;

//   final String apiBase = 'http://127.0.0.1:8000';

//   Future<void> _login() async {
//     final email = _usernameController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       setState(() => _showError = true);
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _showError = false;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('$apiBase/api/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//       );

//       final result = jsonDecode(response.body);

//       if (response.statusCode == 200 && result['success'] == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message'] ?? 'Login berhasil!')),
//         );

//         Navigator.pushReplacementNamed(context, '/homePage');
//       } else {
//         setState(() => _showError = true);
//       }
//     } catch (e) {
//       debugPrint('Login error: $e');
//       setState(() => _showError = true);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Terjadi kesalahan koneksi ke server.')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _sendForgotPassword() async {
//     final email = _usernameController.text.trim();

//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Masukkan email terlebih dahulu!'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       _isResetLoading = true;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('$apiBase/api/forgot-password'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email}),
//       );

//       final result = jsonDecode(response.body);

//       if (response.statusCode == 200 && result['success'] == true) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message'] ?? 'Password baru dikirim ke email.')),
//         );
//       } else {

//         final msg = result['message'] ?? 'Email tidak ditemukan atau gagal mengirim.';
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(msg), backgroundColor: Colors.red),
//         );
//       }
//     } catch (e) {
//       debugPrint('Forgot password error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Terjadi kesalahan koneksi saat mengirim permintaan.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } finally {
//       setState(() {
//         _isResetLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFFFDD0),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Image.asset(AppAssets.logo, width: 100, height: 100),
//               ),
//               const Gap(20),

//               const Text(
//                 "LOGIN",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF3B6C54),
//                 ),
//               ),
//               const Gap(4),

//               Row(
//                 children: [
//                   const Text(
//                     "Belum punya akun? ",
//                     style: TextStyle(color: Colors.black54, fontSize: 14),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, '/registerPage');
//                     },
//                     child: const Text(
//                       "Register",
//                       style: TextStyle(
//                         color: Color(0xFF3B6C54),
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Gap(25),

//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF4C3E35),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: _usernameController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     prefixIcon: Icon(Icons.person, color: Colors.white),
//                     hintText: "Email",
//                     hintStyle: TextStyle(color: Colors.white70),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//               const Gap(16),

//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF4C3E35),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     prefixIcon: Icon(Icons.lock, color: Colors.white),
//                     hintText: "Password",
//                     hintStyle: TextStyle(color: Colors.white70),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//               const Gap(12),

//               Align(
//                 alignment: Alignment.centerRight,
//                 child: GestureDetector(
//                   onTap: _isResetLoading ? null : _sendForgotPassword,
//                   child: _isResetLoading
//                       ? const SizedBox(
//                           height: 18,
//                           width: 18,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Text(
//                           "Lupa Password",
//                           style: TextStyle(
//                             color: Color(0xFF3B6C54),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                 ),
//               ),
//               const Gap(10),

//               if (_showError)
//                 Row(
//                   children: const [
//                     Icon(Icons.error, color: Colors.red, size: 18),
//                     SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         "Akun tidak ditemukan.\nPastikan email atau password sudah benar.",
//                         style: TextStyle(color: Colors.red, fontSize: 13),
//                       ),
//                     ),
//                   ],
//                 ),
//               const Gap(25),

//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _login,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF4C3E35),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text(
//                           "MASUK",
//                           style: TextStyle(
//                             fontSize: 16,
//                             letterSpacing: 1.2,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ziemart_frontend/config/app_asset.dart';
import '../../viewmodels/login_viewmodel.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDD0),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(AppAssets.logo, width: 100, height: 100),
              ),
              const Gap(20),

              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B6C54),
                ),
              ),
              const Gap(4),

              Row(
                children: [
                  const Text(
                    "Belum punya akun? ",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/registerPage'),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Color(0xFF3B6C54),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(25),

              // EMAIL FIELD
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4C3E35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: viewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Gap(16),

              // PASSWORD FIELD
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4C3E35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: viewModel.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Gap(12),

              // LUPA PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: viewModel.isResetLoading
                      ? null
                      : () async {
                          final success = await viewModel.sendForgotPassword();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? "Email reset password telah dikirim!"
                                    : "Gagal mengirim email reset.",
                              ),
                            ),
                          );
                        },

                  child: viewModel.isResetLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Lupa Password",
                          style: TextStyle(
                            color: Color(0xFF3B6C54),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const Gap(10),

              if (viewModel.showError)
                Row(
                  children: const [
                    Icon(Icons.error, color: Colors.red, size: 18),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Akun tidak ditemukan.\nPastikan email atau password sudah benar.",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              const Gap(25),

              // BUTTON LOGIN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                          final success = await viewModel.login();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login berhasil!')),
                            );
                            Navigator.pushReplacementNamed(
                              context,
                              '/homePage',
                            );
                          } else if (!success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email atau password salah.'),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C3E35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "MASUK",
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
