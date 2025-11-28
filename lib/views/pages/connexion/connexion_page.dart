import 'package:flutter/material.dart';
import 'widgets/carousel_connexion.dart';
import 'widgets/form_connexion.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> with WidgetsBindingObserver {
  // base top offset (matches the previous static value)
  static const double _baseTop = 160.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final inset = media.viewInsets.bottom; // keyboard height when visible

    // Move the whole FormConnexion up by keyboard height, but clamp so it doesn't go off-screen
    final screenHeight = media.size.height;
    double top = _baseTop - inset;
    // ensure top is within reasonable bounds
    top = top.clamp(10.0, screenHeight - 620.0) as double;

    return Scaffold(
      body: Stack(
        children: [
            // AnimatedPositioned(
            //   duration: const Duration(milliseconds: 250),
            //   curve: Curves.easeOut,
            //   top: top - 312, // Décale CarouselConnexion vers le haut avec le clavier
            //   left: 0,
            //   right: 0,
            //   child: const CarouselConnexion(),
            // ),
            CarouselConnexion(),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              top: top + 312,
              left: 0,
              right: 0,
              child: FormConnexion(),
            ),
        ],
      ),
    );
  }
}
