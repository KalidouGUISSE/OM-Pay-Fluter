import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/views/router/router.dart';
import 'package:flutter_application_1/theme/theme_provider.dart';
import 'package:flutter_application_1/theme/auth_provider.dart';
import 'package:flutter_application_1/theme/transaction_provider.dart';
import 'package:flutter_application_1/core/services/api_client.dart';
import 'package:flutter_application_1/services/implement/auth_service.dart';
import 'package:flutter_application_1/services/implement/transaction_service.dart';
import 'package:flutter_application_1/config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Config depuis config.yaml
  Config.load();
  
  // Initialiser SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  runApp(OrangeMoneyApp(prefs: prefs));
}

class OrangeMoneyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const OrangeMoneyApp({required this.prefs, super.key});

  @override
  Widget build(BuildContext context) {
    // Créer l'ApiClient avec l'URL depuis Config
    final apiClient = ApiClient(baseUrl: Config.baseUrl);
    
    // Créer l'AuthService
    final authService = AuthService(apiClient);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService, prefs: prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(transactionService: TransactionService(apiClient)),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Orange Money',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xFFFF7900),
              fontFamily: 'Roboto',
              scaffoldBackgroundColor: Colors.white,
            ),
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/connexion',
            onGenerateRoute: RouteApp.generateRoute,
          );
        },
      ),
    );
  }
}