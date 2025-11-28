import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner QR Code"),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fenêtre de scan
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // Fond gris pour simuler la caméra
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.qr_code,
                          size: 150,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    // Coin haut-gauche
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.orange, width: 3),
                            left: BorderSide(color: Colors.orange, width: 3),
                          ),
                        ),
                      ),
                    ),
                    // Coin haut-droit
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.orange, width: 3),
                            right: BorderSide(color: Colors.orange, width: 3),
                          ),
                        ),
                      ),
                    ),
                    // Coin bas-gauche
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.orange, width: 3),
                            left: BorderSide(color: Colors.orange, width: 3),
                          ),
                        ),
                      ),
                    ),
                    // Coin bas-droit
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.orange, width: 3),
                            right: BorderSide(color: Colors.orange, width: 3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Positionnez le code QR\ndans la fenêtre",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Fermer le Scanner",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
