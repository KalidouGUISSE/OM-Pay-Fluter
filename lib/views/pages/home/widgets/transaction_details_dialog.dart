import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/theme/language_provider.dart';
import 'package:flutter_application_1/theme/transaction_provider.dart';

class TransactionDetailsDialog extends StatefulWidget {
  final String transactionId;

  const TransactionDetailsDialog({
    super.key,
    required this.transactionId,
  });

  @override
  State<TransactionDetailsDialog> createState() => _TransactionDetailsDialogState();
}

class _TransactionDetailsDialogState extends State<TransactionDetailsDialog> {
  bool _hasInitiatedLoad = false;

  @override
  void initState() {
    super.initState();
    // Le chargement sera initié dans build() via Consumer
  }

  void _initiateTransactionLoad(TransactionProvider transactionProvider) {
    if (_hasInitiatedLoad) return;

    _hasInitiatedLoad = true;

    // Vérifier d'abord le cache
    final cachedTransaction = transactionProvider.getTransaction(widget.transactionId);
    if (cachedTransaction != null) {
      return; // La transaction est déjà disponible
    }

    // Si pas en cache, récupérer depuis l'API
    transactionProvider.getTransactionById(widget.transactionId);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        // Initier le chargement si nécessaire
        _initiateTransactionLoad(transactionProvider);

        // Obtenir les données actuelles du provider
        final transaction = transactionProvider.getTransaction(widget.transactionId);
        final isLoading = transactionProvider.isLoadingTransaction(widget.transactionId);
        final error = transactionProvider.getTransactionError(widget.transactionId);

        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text(
            languageProvider.getText('details_transaction'),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Text(
                        'Erreur: $error',
                        style: TextStyle(color: Colors.red),
                      )
                    : transaction == null
                        ? const Text('Transaction non trouvée')
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('Type', transaction.typeTransaction),
                                _buildDetailRow('Expéditeur', transaction.expediteur),
                                _buildDetailRow('Destinataire', transaction.destinataire),
                                _buildDetailRow('Montant', '${transaction.montant.toStringAsFixed(0)} CFA'),
                                _buildDetailRow('Date', _formatDate(transaction.date)),
                                _buildDetailRow('Référence', transaction.reference),
                              ],
                            ),
                          ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                languageProvider.getText('fermer'),
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}