import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/auth_provider.dart';
import '../../../../theme/language_provider.dart';
import 'historique_widget.dart';

class HistorySectionWidget extends StatelessWidget {
  const HistorySectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardText = isDark ? Colors.white : Colors.black87;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Column(
      children: [
        // Titre Historique
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                languageProvider.getText('historique'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cardText,
                ),
              ),
              const Icon(Icons.refresh, color: Colors.orange, size: 20),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Historique
        Expanded(
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final transactions = authProvider.userData?.dernieresTransactions ?? [];
              return HistoriqueWidget(transactions: transactions);
            },
          ),
        ),
      ],
    );
  }
}