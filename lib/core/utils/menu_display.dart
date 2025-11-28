// import 'dart:io';
// import 'package:dart_console/dart_console.dart';
// import '../core/constants.dart';

// class MenuDisplay {
//   final Console console = Console();

//   void display() {
//     console.clearScreen();
//     console.writeLine(Messages.mainMenuTitle, TextAlignment.center);
//     console.writeLine(Messages.mainMenuOption1);
//     console.writeLine(Messages.mainMenuOption2);
//     console.writeLine(Messages.mainMenuOption0);
//     console.write(Messages.mainMenuPrompt);
//   }

//   void showSuccess(String message) {
//     console.setForegroundColor(ConsoleColor.green);
//     console.writeLine('✓ $message');
//     console.resetColorAttributes();
//   }

//   void showError(String message) {
//     console.setForegroundColor(ConsoleColor.red);
//     console.writeLine('✗ $message');
//     console.resetColorAttributes();
//   }
// }