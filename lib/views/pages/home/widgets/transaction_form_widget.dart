import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/language_provider.dart';
import 'scanner_page.dart';

class TransactionFormWidget extends StatefulWidget {
  final String selectedOperation;
  final TextEditingController recipientController;
  final TextEditingController amountController;
  final bool isCreatingTransaction;
  final Function(String) onOperationChanged;
  final VoidCallback onCreateTransaction;

  const TransactionFormWidget({
    super.key,
    required this.selectedOperation,
    required this.recipientController,
    required this.amountController,
    required this.isCreatingTransaction,
    required this.onOperationChanged,
    required this.onCreateTransaction,
  });

  @override
  State<TransactionFormWidget> createState() => _TransactionFormWidgetState();
}

class _TransactionFormWidgetState extends State<TransactionFormWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final primaryBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final secondaryBg = isDark ? const Color(0xFF2D2D2D) : Colors.grey[50];
    final cardText = isDark ? Colors.white : Colors.black87;
    final hintText = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: primaryBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12,
            blurRadius: 10,
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: secondaryBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio buttons Payer / Transférer
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.onOperationChanged('payer');
                      },
                      child: Row(
                        children: [
                          Icon(
                            widget.selectedOperation == 'payer'
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: widget.selectedOperation == 'payer' ? Colors.orange : Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            languageProvider.getText('payer'),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: cardText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    GestureDetector(
                      onTap: () {
                        widget.onOperationChanged('transferer');
                      },
                      child: Row(
                        children: [
                          Icon(
                            widget.selectedOperation == 'transferer'
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: widget.selectedOperation == 'transferer' ? Colors.orange : Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            languageProvider.getText('transferer'),
                            style: TextStyle(color: cardText, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "m",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Espacement (rayures supprimées)
                const SizedBox(height: 8),

                const SizedBox(height: 12),

                // Input fields et Scanner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: widget.recipientController,
                            keyboardType: widget.selectedOperation == 'transferer'
                                ? TextInputType.phone
                                : TextInputType.text,
                            decoration: InputDecoration(
                              hintText: widget.selectedOperation == 'transferer'
                                  ? languageProvider.getText('numero_destinataire')
                                  : languageProvider.getText('code_marchand'),
                              hintStyle: TextStyle(color: hintText),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                ),
                              ),
                              filled: true,
                              fillColor: isDark ? Colors.grey[900] : Colors.grey[50],
                            ),
                            style: TextStyle(color: cardText),
                            enabled: !widget.isCreatingTransaction,
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: widget.amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: languageProvider.getText('saisir_montant'),
                              hintStyle: TextStyle(color: hintText),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                ),
                              ),
                              filled: true,
                              fillColor: isDark ? Colors.grey[900] : Colors.grey[50],
                            ),
                            style: TextStyle(color: cardText),
                            enabled: !widget.isCreatingTransaction,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Scanner section
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ScannerPage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_scanner,
                                size: 40,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                languageProvider.getText('cliquer_scanner'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Espacement (rayures supprimées)
          const SizedBox(height: 8),

          // Bouton Valider
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                onPressed: widget.isCreatingTransaction ? null : widget.onCreateTransaction,
                child: widget.isCreatingTransaction
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        languageProvider.getText('valider'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),

          // Espacement (rayures supprimées)
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}