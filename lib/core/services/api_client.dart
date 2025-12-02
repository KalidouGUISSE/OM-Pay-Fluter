import 'dart:convert';
import 'package:http/http.dart' as http;
import 'i_api_client.dart';
import '../utils/error_handler.dart';
import '../../config/exceptions.dart';
import '../../config/config.dart';

class ApiClient implements IApiClient {
    final String baseUrl;
    @override
    String? token;
    @override
    String? numero;
    DateTime? tokenExpiry;

    ApiClient({required this.baseUrl, this.token});

    /// Définit le token avec une expiration configurable.
    @override
    void setToken(String newToken) {
        token = newToken;
        tokenExpiry = DateTime.now().add(Duration(minutes: Config.tokenExpiryMinutes));
    }

    /// Vérifie si le token est expiré.
    bool get isTokenExpired => tokenExpiry != null && DateTime.now().isAfter(tokenExpiry!);

    Map<String, String> get _headers {
        final headers = {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': '',
        };
        if (token != null && !isTokenExpired) {
            headers['Authorization'] = 'Bearer $token';
            headers['X-Temp-Token'] = token!;
        }
        return headers;
    }

    @override
    Future<Map<String, dynamic>> get(String path) async {
        return await ErrorHandler.withRetry(() async {
            final res = await http.get(
                Uri.parse('$baseUrl$path'),
                headers: _headers,
            ).timeout(Duration(milliseconds: Config.timeout));
            print('\n{{{{{{{{{{{{{}}}}}}}{{{{{{==========baseUrl============}}}}}}}}}}}}}}}}}}}\n');
            print('$baseUrl$path');
            print('\n{{{{{{{{{{{{{}}}}}}}{{{{{{==========baseUrl============}}}}}}}}}}}}}}}}}}}\n');
            return _processResponse(res);
        });
    }

    @override
    Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
        print('\n📤 POST REQUEST: $baseUrl$path');
        print('📋 Body: $body');
        print('🔐 Headers: $_headers');
        return await ErrorHandler.withRetry(() async {
            final res = await http.post(
                Uri.parse('$baseUrl$path'),
                headers: _headers,
                body: jsonEncode(body),
            ).timeout(Duration(milliseconds: Config.timeout));
            print('📥 RESPONSE Status: ${res.statusCode}');
            print('📄 Response Body: ${res.body}');
            return _processResponse(res);
        });
    }

    Map<String, dynamic> _processResponse(http.Response res) {
        // Check for authentication errors (401, 403, or redirect to login)
        if (res.statusCode == 401 || res.statusCode == 403) {
            throw AuthenticationException('Session expirée. Veuillez vous reconnecter.');
        }

        try {
            final data = jsonDecode(res.body);
            if (res.statusCode >= 200 && res.statusCode < 300) {
                return data;
            } else {
                final message = data['message'] ?? 'Erreur API';
                ErrorHandler.checkStatusCode(res.statusCode, message);
                throw ApiException(message, statusCode: res.statusCode);
            }
        } catch (e) {
            // If response is not valid JSON (e.g., HTML error page), create a meaningful error
            if (e is FormatException) {
                // Check if response contains login-related content
                if (res.body.contains('login') || res.body.contains('auth')) {
                    throw AuthenticationException('Session expirée. Veuillez vous reconnecter.');
                }
                final errorMessage = 'Erreur serveur: ${res.statusCode} - ${res.reasonPhrase ?? "Réponse invalide"}';
                throw ApiException(errorMessage, statusCode: res.statusCode);
            }
            rethrow;
        }
    }
}
