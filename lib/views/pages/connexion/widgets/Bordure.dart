import 'package:flutter/material.dart';

class Bordure extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 20); // Start at left top
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      20,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      40,
      size.width,
      20,
    );
    path.lineTo(size.width, size.height); // To bottom-right
    path.lineTo(0, size.height); // To bottom-left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
