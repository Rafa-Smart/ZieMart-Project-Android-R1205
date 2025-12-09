// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import ViewModels
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/comment_viewmodel.dart';
import 'viewmodels/category_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'viewmodels/wishlist_viewmodel.dart';
import 'viewmodels/order_viewmodel.dart';
import 'viewmodels/email_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';

// Import Pages
import 'views/pages/splashPage.dart';
import 'views/pages/loginPage.dart';
import 'views/pages/registerPage.dart';
import 'views/pages/homePage.dart';
import 'views/pages/profile_page.dart';
import 'views/pages/cart_page.dart';
import 'views/pages/wishlist_page.dart';
import 'views/pages/orders_page.dart';
import 'views/pages/help_page.dart';
import 'views/pages/settings_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => CommentViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => WishlistViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => EmailViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
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
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      initialRoute: '/splash',
      // ========== PERBAIKAN DI SINI ==========
      // 1. Gunakan onGenerateRoute untuk handle arguments
      onGenerateRoute: (settings) {
        print('🚀 Route dipanggil: ${settings.name}, arguments: ${settings.arguments}');
        
        switch (settings.name) {
          case '/profilePage':
            final args = settings.arguments;
            int userId;
            
            // Handle arguments yang berbeda
            if (args is int) {
              userId = args;
            } else if (args is Map<String, dynamic>) {
              userId = args['userId'] ?? 0;
            } else {
              // Coba ambil dari LoginViewModel
              final loginVM = Provider.of<LoginViewModel>(context, listen: false);
              userId = loginVM.currentUser?.id ?? 0;
            }
            
            print('👤 Membuka ProfilePage dengan userId: $userId');
            
            return MaterialPageRoute(
              builder: (_) => ProfilePage(userId: userId),
            );
            
          // Tambahkan case lain jika perlu
          default:
            return null;
        }
      },
      // =======================================
      
      // 2. Routes yang tidak butuh arguments
      routes: {
        '/splash': (_) => const SplashPage(),
        '/loginPage': (_) => const LoginPage(),
        '/registerPage': (_) => const RegisterPage(),
        '/': (_) => const HomePage(),
        '/homePage': (_) => const HomePage(),  
        '/cartPage': (_) => const CartPage(),
        '/wishlistPage': (_) => const WishlistPage(),
        '/ordersPage': (_) => const OrdersPage(),
        '/helpPage': (_) => HelpPageWrapper(),
        '/settingsPage': (_) => const SettingsPage(),
        // TAMBAHKAN INI JIKA MASIH ERROR:
        '/profilePage': (_) => ProfilePageWrapper(
          userId: Provider.of<LoginViewModel>(context, listen: false).currentUser?.id ?? 0,
        ),
      },
    );
  }
}

// Wrapper untuk HelpPage
class HelpPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginVM, child) {
        print('📞 HelpPageWrapper - User ID: ${loginVM.currentUser?.id}');
        return HelpPage(currentUser: loginVM.currentUser);
      },
    );
  }
}

// Wrapper untuk ProfilePage
class ProfilePageWrapper extends StatelessWidget {
  final int userId;

  const ProfilePageWrapper({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    print('👤 ProfilePageWrapper diinisialisasi dengan userId: $userId');
    return ProfilePage(userId: userId);
  }
}