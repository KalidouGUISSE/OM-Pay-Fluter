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
            );
            return _processResponse(res);
        });
    }

    @override
    Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
        // print('\n{{{{{{{{{{{{{}}}}}}}{{{{{{==========body============}}}}}}}}}}}}}}}}}}}\n');
        // print(body);
        // print('\n{{{{{{{{{{{{{}}}}}}}{{{{{{==========body============}}}}}}}}}}}}}}}}}}}\n');
        // print('\n{{{{{{{{{{{{{}}}}}}}{{{{{{==========headers============}}}}}}}}}}}}}}}}}}}\n');
        // print(_headers);
        // print('\n{{{{{{{{{{{{{}}}}}}}{{{{{{==========headers============}}}}}}}}}}}}}}}}}}}\n');
        return await ErrorHandler.withRetry(() async {
            final res = await http.post(
                Uri.parse('$baseUrl$path'),
                headers: _headers,
                body: jsonEncode(body),
            ).timeout(const Duration(seconds: 30));
            // print('\n{{{{{{{{{{{{{}}}}}}}{{{{{{}}}}}}}}}}}}}}}}}}}\n');
            // print("$baseUrl$path");
            // print('Status Code: ${res.statusCode}');
            // print('Response Body: ${res.body}');
            // print(_processResponse(res));
            // print('\n{{{{{{{{{{{{{}}}}}}}{{{{{{}}}}}}}}}}}}}}}}}}}\n');
            return _processResponse(res);
        });
    }

    Map<String, dynamic> _processResponse(http.Response res) {
        final data = jsonDecode(res.body);
        if (res.statusCode >= 200 && res.statusCode < 300) {
            return data;
        } else {
            final message = data['message'] ?? 'Erreur API';
            ErrorHandler.checkStatusCode(res.statusCode, message);
            throw ApiException(message, statusCode: res.statusCode);
        }
    }
}
