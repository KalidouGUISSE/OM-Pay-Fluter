import 'package:flutter/material.dart';
// import 'package:fronted/pages/connexion/connexion_page.dart';
import 'package:flutter_application_1/views/pages/connexion/connexion_page.dart';
import 'package:flutter_application_1/views/pages/connexion/verify_otp_page.dart';
import 'package:flutter_application_1/views/pages/home/home_page.dart';

class RouteApp {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case "/connexion":
        return MaterialPageRoute(builder: (_) => const ConnexionPage());
      case "/verify-otp":
        final args = setting.arguments as String?;
        return MaterialPageRoute(builder: (_) => VerifyOtpPage(phoneNumber: args));
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
            const Scaffold(body: Center(child: Text("PAGE NOT FOUND"))),
        );
    }
  }
}