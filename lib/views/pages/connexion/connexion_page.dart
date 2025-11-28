import 'package:flutter/material.dart';
import 'widgets/carousel_connexion.dart';
import 'widgets/form_connexion.dart';

class ConnexionPage extends StatelessWidget {
  const ConnexionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green[200],
      body: Stack(
        children: [
          CarouselConnexion(),
          Positioned(
            top: 360,
            left: 0,
            right: 0,
            bottom: 0,
            child: FormConnexion(),
          ),
        ],
      ),
    );
  }
}
