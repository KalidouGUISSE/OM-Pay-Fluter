import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/theme_provider.dart';
import 'scanner_page.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 10),
            const Text(
              "Kalidou Guisse",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("784458786"),
            const SizedBox(height: 30),

            SwitchListTile(
              title: const Text("Sombre"),
              value: themeProvider.isDark,
              activeColor: Colors.orange,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),

            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text("Scanner"),
              value: true,
              activeColor: Colors.orange,
              onChanged: (_) {
                Navigator.pop(context); // Fermer le drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScannerPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            const ListTile(
              leading: Icon(Icons.language),
              title: Text("Français"),
            ),

            const Spacer(),

            const ListTile(
              leading: Icon(Icons.logout),
              title: Text("Se déconnecter"),
            ),
            const Text("OMPAY Version - 1.1.0(35)"),
          ],
        ),
      ),
    );
  }
}
