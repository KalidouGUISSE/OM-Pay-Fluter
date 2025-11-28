import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/router/router.dart';
import 'package:flutter_application_1/theme/theme_provider.dart';

void main() {
  runApp(const OrangeMoneyApp());
}

class OrangeMoneyApp extends StatelessWidget {
  const OrangeMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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