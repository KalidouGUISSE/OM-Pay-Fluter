import 'package:flutter/material.dart';
import '../services/implement/transaction_service.dart';
import '../models/transaction.dart';
import '../core/utils/logger.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService transactionService;

  TransactionProvider({required this.transactionService});

  double? _balance;
  bool _isLoadingBalance = false;
  String? _balanceError;

  // Getters
  double? get balance => _balance;
  bool get isLoadingBalance => _isLoadingBalance;
  String? get balanceError => _balanceError;

  /// Récupère le solde depuis l'API
  Future<bool> fetchBalance() async {
    if (_isLoadingBalance) return false;

    _isLoadingBalance = true;
    _balanceError = null;
    notifyListeners();

    try {
      final fetchedBalance = await transactionService.getSolde();
      _balance = fetchedBalance;
      _isLoadingBalance = false;
      notifyListeners();
      AppLogger.logger.info('Solde récupéré: $_balance');
      return true;
    } catch (e) {
      _balanceError = e.toString();
      _isLoadingBalance = false;
      notifyListeners();
      AppLogger.logger.severe('Erreur récupération solde: $e');
      return false;
    }
  }

  /// Crée une transaction et invalide le solde
  Future<Transaction?> createTransaction(String numero, double montant, String typeTransaction) async {
    try {
      final transaction = await transactionService.creerTransaction(numero, montant, typeTransaction);
      // Invalider le solde après la transaction
      invalidateBalance();
      return transaction;
    } catch (e) {
      // L'erreur sera gérée par l'appelant
      rethrow;
    }
  }

  /// Invalide le cache du solde (à appeler après une transaction)
  void invalidateBalance() {
    _balance = null;
    _balanceError = null;
    notifyListeners();
  }

  /// Réinitialise l'erreur
  void clearBalanceError() {
    _balanceError = null;
    notifyListeners();
  }

  /// Réinitialise le solde (utile lors de la déconnexion)
  void reset() {
    _balance = null;
    _isLoadingBalance = false;
    _balanceError = null;
    notifyListeners();
  }
}