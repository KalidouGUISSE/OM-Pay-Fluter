import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/theme_provider.dart';
import '../../../../theme/language_provider.dart';
import '../../../../theme/auth_provider.dart';
import '../../../../theme/transaction_provider.dart';
import '../../../../core/utils/routes.dart';
import 'scanner_page.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

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
              title: Text(languageProvider.getText('sombre')),
              value: themeProvider.isDark,
              activeColor: Colors.orange,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),

            const SizedBox(height: 10),

            SwitchListTile(
              title: Text(languageProvider.getText('scanner')),
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

            ListTile(
              leading: Icon(Icons.language),
              title: Text(languageProvider.getText('francais')),
              onTap: () {
                languageProvider.setLanguage(
                  languageProvider.currentLanguage == 'fr' ? 'en' : 'fr'
                );
              },
            ),

            const Spacer(),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text(languageProvider.getText('se_deconnecter')),
              onTap: () async {
                // Fermer le drawer d'abord
                Navigator.pop(context);

                try {
                  // Récupérer les providers
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

                  // Effectuer la déconnexion
                  await authProvider.logout();
                  transactionProvider.reset();

                  // Naviguer vers la page de connexion
                  Navigator.of(context).pushReplacementNamed(AppRoutes.connexion);
                } catch (e) {
                  // Afficher un message d'erreur en cas de problème
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la déconnexion: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            Text(languageProvider.getText('version')),
          ],
        ),
      ),
    );
  }
}
