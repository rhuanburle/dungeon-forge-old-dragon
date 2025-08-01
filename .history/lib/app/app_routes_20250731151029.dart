import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String auth = '/auth';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Home Page')),
          ),
        );
      case auth:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Auth Page')),
          ),
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Profile Page')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}
