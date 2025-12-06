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

  // Cache pour les transactions complètes
  final Map<String, Transaction> _transactionCache = {};
  final Map<String, bool> _loadingTransactions = {};
  final Map<String, String?> _transactionErrors = {};

  // Getters
  double? get balance => _balance;
  bool get isLoadingBalance => _isLoadingBalance;
  String? get balanceError => _balanceError;

  // Getters pour les transactions
  Transaction? getTransaction(String id) => _transactionCache[id];
  bool isLoadingTransaction(String id) => _loadingTransactions[id] ?? false;
  String? getTransactionError(String id) => _transactionErrors[id];

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

  /// Récupère une transaction par ID (avec cache)
  Future<Transaction?> getTransactionById(String id) async {
    // Vérifier le cache d'abord
    if (_transactionCache.containsKey(id)) {
      AppLogger.logger.info('Transaction $id récupérée depuis le cache');
      return _transactionCache[id];
    }

    // Vérifier si déjà en cours de chargement
    if (_loadingTransactions[id] == true) {
      AppLogger.logger.info('Transaction $id déjà en cours de chargement');
      return null;
    }

    _loadingTransactions[id] = true;
    _transactionErrors[id] = null;
    notifyListeners();

    try {
      final transaction = await transactionService.getByIdTransactions(id);
      _transactionCache[id] = transaction;
      _loadingTransactions[id] = false;
      notifyListeners();
      AppLogger.logger.info('Transaction $id récupérée depuis l\'API et mise en cache');
      return transaction;
    } catch (e) {
      _transactionErrors[id] = e.toString();
      _loadingTransactions[id] = false;
      notifyListeners();
      AppLogger.logger.severe('Erreur récupération transaction $id: $e');
      rethrow;
    }
  }

  /// Crée une transaction et invalide le solde
  Future<Transaction?> createTransaction(String numero, double montant, String typeTransaction) async {
    try {
      final transaction = await transactionService.creerTransaction(numero, montant, typeTransaction);
      // Invalider le solde après la transaction
      invalidateBalance();
      // Ajouter la transaction au cache si elle n'y est pas déjà
      if (!_transactionCache.containsKey(transaction.id)) {
        _transactionCache[transaction.id] = transaction;
        notifyListeners();
      }
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

  /// Invalide le cache d'une transaction spécifique
  void invalidateTransaction(String id) {
    _transactionCache.remove(id);
    _loadingTransactions.remove(id);
    _transactionErrors.remove(id);
    notifyListeners();
  }

  /// Invalide tout le cache des transactions
  void invalidateAllTransactions() {
    _transactionCache.clear();
    _loadingTransactions.clear();
    _transactionErrors.clear();
    notifyListeners();
  }

  /// Réinitialise le solde (utile lors de la déconnexion)
  void reset() {
    _balance = null;
    _isLoadingBalance = false;
    _balanceError = null;
    invalidateAllTransactions();
    notifyListeners();
  }
}