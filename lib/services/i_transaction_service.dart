import '../models/transaction.dart';

abstract class ITransactionService {
    Future<List<Transaction>> getAllTransactions();
    Future<Transaction> getByIdTransactions(String id);
    Future<double> getSolde();
    Future<Transaction> creerTransaction(String numero, double montant, String typeTransaction);
}