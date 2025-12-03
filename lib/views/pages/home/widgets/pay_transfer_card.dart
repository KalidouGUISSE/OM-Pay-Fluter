import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/language_provider.dart';

class PayTransferCard extends StatefulWidget {
  const PayTransferCard({super.key});

  @override
  State<PayTransferCard> createState() => _PayTransferCardState();
}

class _PayTransferCardState extends State<PayTransferCard> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => selected = 0),
                child: Row(
                  children: [
                    Icon(
                      selected == 0 ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Text(languageProvider.getText('payer')),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () => setState(() => selected = 1),
                child: Row(
                  children: [
                    Icon(
                      selected == 1 ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 5),
                    Text(languageProvider.getText('transferer')),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          TextField(decoration: InputDecoration(labelText: languageProvider.getText('saisir_destinataire'))),
          const SizedBox(height: 10),
          TextField(decoration: InputDecoration(labelText: languageProvider.getText('saisir_montant'))),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {},
              child: Text(languageProvider.getText('valider')),
            ),
          )
        ],
      ),
    );
  }
}
