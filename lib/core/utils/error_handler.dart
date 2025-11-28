import 'dart:async';
import 'package:retry/retry.dart';
import '../../config/exceptions.dart';
import '../../config/config.dart';

/// Classe utilitaire pour la gestion des erreurs et retry.
class ErrorHandler {
  /// Exécute une fonction avec retry automatique en cas d'échec.
  static Future<T> withRetry<T>(Future<T> Function() fn) async {
    final r = RetryOptions(maxAttempts: Config.retryAttempts);
    return r.retry(fn, retryIf: (e) => e is ApiException && (e.statusCode == 500 || e.statusCode == 502));
  }

  /// Gère les erreurs API et lance des exceptions personnalisées.
  static void handleApiError(dynamic error) {
    if (error is ApiException) {
      throw error;
    }
    throw ApiException('Erreur API inconnue: $error');
  }

  /// Vérifie le code de statut et lance une exception si nécessaire.
  static void checkStatusCode(int statusCode, String message) {
    if (statusCode == 401) {
      throw AuthenticationException('Authentification requise');
    } else if (statusCode >= 400) {
      throw ApiException(message, statusCode: statusCode);
    }
  }
}