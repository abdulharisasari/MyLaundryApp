import 'package:flutter/material.dart';
import '../pages/main/index.dart';
import 'constants.dart';
import '../pages/auth/forgot-password/index.dart';
import '../pages/auth/sign-in/index.dart';
import '../pages/auth/sign-up/index.dart';
import '../pages/main/root.dart';

class Router {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var uri = Uri.parse(settings.name ?? '');
    debugPrint('uri $uri');
    debugPrint('setName ${settings.name}');

    switch (uri.path) {
      case rootRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Root(),
        );
      
      case signInRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SignInPage(),
        );
      
      case signUpRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SignUpPage(),
        );
      
      case forgotPasswordRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ForgotPasswordPage(),
        );
      case mainRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => MainPage());
      
      default:
        return null;
    }
  }
}
