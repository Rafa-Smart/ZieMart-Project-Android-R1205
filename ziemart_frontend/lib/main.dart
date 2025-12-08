import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import ViewModels
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/product_viewmodel.dart';
import 'viewmodels/comment_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/cart_viewmodel.dart';
import 'viewmodels/wishlist_viewmodel.dart';
import 'viewmodels/order_viewmodel.dart';

// Import Pages
import 'views/pages/splashPage.dart';
import 'views/pages/loginPage.dart';
import 'views/pages/registerPage.dart';
import 'views/pages/homePage.dart';
import 'views/pages/profile_page.dart';
import 'views/pages/cart_page.dart';
import 'views/pages/wishlist_page.dart';
import 'views/pages/orders_page.dart';

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
      onGenerateRoute: (settings) {
        // Handle route dengan arguments
        if (settings.name == '/profilePage') {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => ProfilePage(userId: userId),
          );
        }
        
        // Handle route biasa
        return null;
      },
      routes: {
        '/splash': (_) => const SplashPage(),
        '/loginPage': (_) => const LoginPage(),
        '/registerPage': (_) => const RegisterPage(),
        '/homePage': (_) => const HomePage(),
        '/cartPage': (_) => const CartPage(),
        '/wishlistPage': (_) => const WishlistPage(),
        '/ordersPage': (_) => const OrdersPage(),
      },
    );
  }
}