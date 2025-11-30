import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/derniere_transaction.dart';

class HistoriqueWidget extends StatelessWidget {
  final List<DerniereTransaction> transactions;

  const HistoriqueWidget({
    super.key,
    required this.transactions,
  });

  IconData _getIcon(String type) {
    switch (type) {
      case 'Dépôt':
        return Icons.arrow_downward;
      case 'Transfert d\'argent':
        return Icons.phone_android;
      case 'Achat Pass':
        return Icons.home;
      default:
        return Icons.payment;
    }
  }

  String _formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildTransactionItem(DerniereTransaction transaction, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardText = isDark ? Colors.white : Colors.black87;
    final sign = transaction.direction == 'credit' ? '+' : '-';
    final color = transaction.direction == 'credit' ? Colors.green : Colors.red;
    final amountText = '$sign ${transaction.montant.toStringAsFixed(0)} CFA';

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_getIcon(transaction.typeTransaction), size: 28, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.typeTransaction,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cardText,
                  fontSize: 14,
                ),
              ),
              Text(
                transaction.contrepartie,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amountText,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              _formatDate(transaction.date),
              style: TextStyle(color: Colors.grey[600], fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: transactions.isEmpty
            ? [const Text('Aucune transaction')]
            : transactions
                .map((transaction) => _buildTransactionItem(transaction, context))
                .expand((widget) => [widget, const SizedBox(height: 15)])
                .toList()
              ..removeLast(), // Remove the last SizedBox
      ),
    );
  }
}
