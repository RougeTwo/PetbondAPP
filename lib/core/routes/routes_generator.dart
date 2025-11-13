import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'package:petbond_uk/modules/auth/signup/sign_up.dart';
import 'package:petbond_uk/modules/auth/signup/signup_selection_screen.dart';
import 'package:petbond_uk/modules/breeder/breeder_dashboard.dart';
import 'package:petbond_uk/modules/charity/charity_dashboard.dart';
import 'package:petbond_uk/modules/qr_scanner/qr_scanner_screen_web.dart'
  if (dart.library.io) 'package:petbond_uk/modules/qr_scanner/qr_scanner_screen.dart';
import 'package:petbond_uk/modules/splash/splash_screen.dart';
import 'package:petbond_uk/modules/auth/login.dart';
import 'package:petbond_uk/modules/veterinarian/vet_dashboard.dart';


class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case scannerScreen:
        return MaterialPageRoute(
            builder: (_) => const ConnectBreederScanScreen());
      case signUpScreen:
        return MaterialPageRoute(
            builder: (_) => SignUpScreen(
                  index: args,
                ));
      case signUpSelectionScreen:
        return MaterialPageRoute(builder: (_) => const SignUpSelectionScreen());
      case vetDashBoardScreen:
        return MaterialPageRoute(builder: (_) => const VetDashBoardScreen());
      case breederDashBoardScreen:
        return MaterialPageRoute(builder: (_) => const BreederDashBoardScreen());
      case charityDashBoardScreen:
        return MaterialPageRoute(builder: (_) => const CharityDashBoardScreen());
    }
    return null;
  }
}
