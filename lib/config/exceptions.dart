/// Exception de base pour les erreurs API.
class ApiException implements Exception {
    final String message;
    final int? statusCode;

    ApiException(this.message, {this.statusCode});

    @override
    String toString() => 'ApiException: $message${statusCode != null ? ' (Code: $statusCode)' : ''}';
}

/// Exception pour les erreurs d'authentification.
class AuthenticationException extends ApiException {
    AuthenticationException(super.message) : super(statusCode: 401);
}

/// Exception pour les erreurs de validation.
class ValidationException extends ApiException {
    ValidationException(super.message) : super(statusCode: 400);
}