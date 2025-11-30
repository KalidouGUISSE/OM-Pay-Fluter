import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselConnexion extends StatelessWidget {
  const CarouselConnexion({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: CarouselSlider(
        items: [
          buildItem(
            "assets/images/image1.jpg",
            title: "Orange money",
            subtitle: "Consulter votre solde",
            description:
                "Accédez au solde de votre compte Orange Money dès votre authentification. Affichez ou masquez-le à votre convenance.",
            logoPath: "assets/images/logo.png",
          ),
          buildItem(
            "assets/images/image3.png",
            title: "Orange Money",
            subtitle: "Envoyez de l'argent",
            description:
                "Envoyez ou recevez de l'argent  et en toute sécurité de l'argent  à un proche  qui possede  un compte  OrangeMoney",
            logoPath: "assets/images/logo.png",
          ),
          buildItem(
            "assets/images/image2.png",
            title: "Orange Money",
            subtitle: "Payez vos factures",
            description:
                "Payez  plus rapidement vos courses  en scannant  le QR code  chez tous les commerçants agrées Orange MOney",
            logoPath: "assets/images/logo.png",
          ),
        ],

        options: CarouselOptions(
          autoPlay: true,
          viewportFraction: 1,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }

  Widget buildItem(
    String imagePath, {
    required String title,
    required String subtitle,
    required String description,
    required String logoPath,
  }) {
    return Stack(
      children: [
        // IMAGE DE FOND
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              opacity: 1,
            ),
          ),
        ),

        // OVERLAY NOIR
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
        ),

        // CONTENU : LOGO + TEXTES
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO OM
              Image.asset(logoPath, width: 100),
              const SizedBox(height: 15),

              // TITRE : "Orange Money"
              Row(
                children: [
                  Text(
                    "Orange ",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6600), // ORANGE
                    ),
                  ),
                  Text(
                    "Money",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // SOUS-TITRE (orange)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFF6600), // ORANGE
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // DESCRIPTION (blanc et petit)
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
