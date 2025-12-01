import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/routes.dart';
import 'package:flutter_application_1/views/pages/connexion/connexion_page.dart';
import 'package:flutter_application_1/views/pages/connexion/verify_otp_page.dart';
import 'package:flutter_application_1/views/pages/home/home_page.dart';

/// Gestionnaire de routes pour l'application OM Pay
class RouteApp {
  /// Génère une route basée sur les paramètres fournis
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.connexion:
        return MaterialPageRoute(
          builder: (_) => const ConnexionPage(),
          settings: settings,
        );

      case AppRoutes.verifyOtp:
        final phoneNumber = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => VerifyOtpPage(phoneNumber: phoneNumber),
          settings: settings,
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      default:
        // Route non trouvée
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Erreur')),
            body: const Center(child: Text('Page non trouvée')),
          ),
        );
    }
  }

  /// Route initiale de l'application
  static String get initialRoute => AppRoutes.connexion;
}