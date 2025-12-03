import '../../core/services/i_api_client.dart';
import '../i_transaction_service.dart';
import '../../core/utils/validators.dart';
import '../../config/exceptions.dart';
import '../../core/utils/cache.dart';
import '../../core/utils/logger.dart';
import '../../config/config.dart';
import '../../models/transaction.dart';

class TransactionService implements ITransactionService{
    final IApiClient apiClient;
    TransactionService(this.apiClient);

    @override
    Future<List<Transaction>> getAllTransactions() async {
        final cacheKey = 'transactions_${apiClient.numero}';
        final cached = SimpleCache.get<List<Transaction>>(cacheKey);
        if (cached != null) {
            return cached;
        }

        try {
            final encodedNumero = Uri.encodeComponent(apiClient.numero!);
            final response = await apiClient.get('/api/v1/compte/$encodedNumero/transactions');
            final transactionsData = response['data']['transactions'] as List<dynamic>? ?? [];
            final transactions = transactionsData.map((json) {
                try {
                    final transaction = Transaction.fromJson(json as Map<String, dynamic>);
                    if (!transaction.isValid()) {
                        AppLogger.logger.warning('Transaction invalide détectée: ${transaction.id}');
                    }
                    return transaction;
                } catch (e) {
                    AppLogger.logger.severe('Erreur parsing transaction: $e, data: $json');
                    throw ValidationException('Erreur lors du parsing d\'une transaction');
                }
            }).toList();

            // Cacher pour 10 minutes
            SimpleCache.set(cacheKey, transactions, Duration(minutes: 10));
            return transactions;
        } catch (e) {
            AppLogger.logger.severe('Erreur récupération transactions: $e');
            rethrow;
        }
    }

    @override
    Future<double> getSolde() async {
        final cacheKey = 'solde_${apiClient.numero}';
        final cached = SimpleCache.get<double>(cacheKey);
        if (cached != null) {
            AppLogger.logger.info('Solde récupéré depuis le cache: $cached');
            return cached;
        }

        if (apiClient.numero == null || apiClient.numero!.isEmpty) {
            AppLogger.logger.severe('Numéro de téléphone non défini pour récupération solde');
            throw Exception('Numéro de téléphone requis pour récupérer le solde');
        }

        AppLogger.logger.info('Récupération du solde pour le numéro: ${apiClient.numero}');
        final result = await apiClient.get('/api/v1/compte/${apiClient.numero}/solde');

        AppLogger.logger.info('Réponse API solde: $result');

        // Essayer différentes structures de réponse possibles
        dynamic soldeValue = result['data']?['solde'] ?? result['solde'] ?? result['balance'] ?? result['montant'];

        String? soldeStr;
        if (soldeValue != null) {
            soldeStr = soldeValue.toString();
            AppLogger.logger.info('Valeur solde trouvée: $soldeStr');
        } else {
            AppLogger.logger.warning('Aucune valeur solde trouvée dans la réponse');
            soldeStr = '0';
        }

        // Convertir proprement en double
        final solde = double.tryParse(soldeStr) ?? 0.0;

        if (solde == 0.0 && soldeStr != '0') {
            AppLogger.logger.warning('Échec du parsing du solde: "$soldeStr" -> 0.0');
        }

        SimpleCache.set(cacheKey, solde, Duration(minutes: Config.cacheTtlMinutes));
        AppLogger.logger.info('Solde mis en cache: $solde');

        return solde;
    }

    @override
    Future<Transaction> creerTransaction(String numero, double montant, String typeTransaction) async {
      
        if (!Validator.isValidPhoneNumber(numero)) {
            throw ValidationException('Numéro de téléphone invalide');
        }
        if (!Validator.isValidAmount(montant.toString())) {
            throw ValidationException('Montant invalide');
        }
              print("{{{{{{{{{{{{{{{{{{{{{===========creerTransaction=== response =======}}}}}}}}}}}}}}}}}}}}}");
        if (!Validator.isValidTransactionType(typeTransaction)) {
            throw ValidationException('Type de transaction invalide');
        }

        try {
            final requestBody = {
                'numero du destinataire': numero,
                'montant': montant,
                'type_transaction': typeTransaction,
                'date': ''
            };

            print('🔄 Creating transaction with body: $requestBody');
            print('🔗 API URL: /api/v1/transactions/${apiClient.numero}');

            final response = await apiClient.post('/api/v1/compte/${apiClient.numero}/transactions', requestBody);

              print("{{{{{{{{{{{{{{{{{{{{{===========creerTransaction=== response =======}}}}}}}}}}}}}}}}}}}}}");
              print(response);
              print("{{{{{{{{{{{{{{{{{{{{{===========creerTransaction==== response =====}}}}}}}}}}}}}}}}}}}}}"); 

            final transaction = Transaction.fromJson(response['data']);
            if (!transaction.isValid()) {
                AppLogger.logger.warning('Transaction créée invalide: ${transaction.id}');
            }

            // Invalider le cache du solde et des transactions après transaction
            SimpleCache.remove('solde_${apiClient.numero}');
            SimpleCache.remove('transactions_${apiClient.numero}');
            AppLogger.logger.info('Cache solde et transactions invalidé après transaction ${transaction.id}');

            return transaction;
        } catch (e) {
            AppLogger.logger.severe('Erreur création transaction: $e');
            // Re-throw with more context
            if (e.toString().contains('Session expirée') || e.toString().contains('401') || e.toString().contains('403')) {
                throw Exception('Votre session a expiré. Veuillez vous reconnecter.');
            }
            if (e.toString().contains('500')) {
                throw Exception('Erreur du serveur. Veuillez réessayer plus tard.');
            }
            rethrow;
        }
    }

    @override
    Future<Transaction> getByIdTransactions(String id) async {
        if (!Validator.isValidId(id)) {
            throw ValidationException('ID invalide');
        }
        final response = await apiClient.get('/api/v1/transactions/$id');
        return Transaction.fromJson(response['data']);
    }

}