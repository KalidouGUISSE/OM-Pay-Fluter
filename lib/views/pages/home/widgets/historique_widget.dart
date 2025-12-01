import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/derniere_transaction.dart';
import 'package:flutter_application_1/core/utils/transaction_types.dart';

class HistoriqueWidget extends StatelessWidget {
  final List<DerniereTransaction> transactions;

  const HistoriqueWidget({
    super.key,
    required this.transactions,
  });

  IconData _getIcon(String type) {
    final transactionType = TransactionType.fromString(type);
    if (transactionType == null) return Icons.payment;

    switch (transactionType) {
      case TransactionType.depot:
        return Icons.arrow_downward;
      case TransactionType.transfertArgent:
        return Icons.phone_android;
      case TransactionType.paiementMarchand:
      case TransactionType.achatPass:
        return Icons.shopping_cart;
      case TransactionType.retrait:
        return Icons.arrow_upward;
      case TransactionType.rechargeMobile:
        return Icons.phone_iphone;
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

  String _getTransactionSubtitle(DerniereTransaction transaction) {
    final type = transaction.typeTransaction.toLowerCase();
    final contrepartie = transaction.contrepartie;

    switch (type) {
      case 'transfert d\'argent':
      case 'transfert':
        return contrepartie.isNotEmpty ? contrepartie : 'Transfert';
      case 'paiement marchand':
        return contrepartie.isNotEmpty ? 'Code: $contrepartie' : 'Marchand';
      case 'dépôt d\'argent':
      case 'dépôt':
      case 'depot':
        return contrepartie.isNotEmpty ? contrepartie : 'Dépôt';
      case 'retrait d\'argent':
      case 'retrait':
        return contrepartie.isNotEmpty ? contrepartie : 'Retrait';
      case 'recharge mobile':
      case 'recharge':
        return contrepartie.isNotEmpty ? contrepartie : 'Recharge';
      default:
        return contrepartie.isNotEmpty ? contrepartie : transaction.typeTransaction;
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
                _getTransactionSubtitle(transaction),
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
