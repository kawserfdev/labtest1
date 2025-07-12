import 'package:flutter/material.dart';
import 'package:labtest1/screens/homepage.dart';
import 'package:labtest1/screens/loginpage.dart';
import 'package:labtest1/screens/repos_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String repositories = '/repositories';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
              return MaterialPageRoute(builder: (_) => const LandDevelopmentLoginPage());

      case login:
        return MaterialPageRoute(builder: (_) =>  LoginPage());
      case repositories:
      return MaterialPageRoute(builder: (_) => const RepositoriesScreen());

      default:
        return _errorRoute('Page not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text(message)),
        );
      },
    );
  }
}
