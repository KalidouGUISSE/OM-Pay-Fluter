import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/language_provider.dart';

class OtherOperationsWidget extends StatelessWidget {
  const OtherOperationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardText = isDark ? Colors.white : Colors.black87;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Column(
      children: [
        // Pour toute autre opération - Texte
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              languageProvider.getText('pour_toute_autre_operation'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: cardText,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Max it Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF404040) : Colors.grey[800],
            borderRadius: BorderRadius.circular(14),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "Max it",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      languageProvider.getText('acceder_max_it'),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}