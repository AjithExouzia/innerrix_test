import 'package:flutter/material.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/otp_verification_screen.dart';
import '../views/home/home_screen.dart';
import '../views/home/product_detail_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/otp-verification':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(email: args['email']),
        );
      case '/signup':
      // return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/product-detail':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: args['productId']),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text(
                    'No route defined for ${settings.name}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
        );
    }
  }
}
