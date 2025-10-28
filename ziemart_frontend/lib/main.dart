import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import ViewModels
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/product_viewmodel.dart'; // ✅ Tambahkan ini
import 'viewmodels/comment_viewmodel.dart'; // ✅ Tambahkan ini

// Import Pages
import 'views/pages/splashPage.dart';
import 'views/pages/loginPage.dart';
import 'views/pages/registerPage.dart';
import 'views/pages/homePage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()), 
         ChangeNotifierProvider(create: (_) => CommentViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ziemart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashPage(),
        '/loginPage': (_) => const LoginPage(),
        '/registerPage': (_) => const RegisterPage(),
        '/homePage': (_) => const HomePage(),
      },
    );
  }
}
