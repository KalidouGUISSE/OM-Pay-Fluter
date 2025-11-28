# 🧪 Guide de test unitaire et d'intégration

## Configuration des tests

### Fichiers de test existants
```
test/
└── widget_test.dart         # Test widget basique
```

### Pour ajouter des tests

```bash
# Lancer les tests
flutter test

# Lancer les tests avec coverage
flutter test --coverage

# Lancer un test spécifique
flutter test test/my_test.dart
```

---

## Exemple : Test du flux d'authentification

Créez `test/auth_flow_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/core/services/api_client.dart';
import 'package:flutter_application_1/services/implement/auth_service.dart';
import 'package:flutter_application_1/theme/auth_provider.dart';

// Mock des dépendances
class MockApiClient extends Mock implements IApiClient {
  @override
  String? token;
  
  @override
  void setToken(String newToken) {
    token = newToken;
  }
}

void main() {
  group('AuthFlow', () {
    late MockApiClient mockApiClient;
    late AuthService authService;

    setUp(() {
      mockApiClient = MockApiClient();
      authService = AuthService(mockApiClient);
    });

    test('initiateLogin should format phone number correctly', () async {
      // Arrange
      when(mockApiClient.post(
        '/api/v1/auth/initiate-login',
        any,
      )).thenAnswer((_) async => {
        'success': true,
        'data': {
          'temp_token': 'test_token',
          'otp': '123456',
          'expires_in': 300,
        }
      });

      // Act
      final result = await authService.initiateLogin('784458786');

      // Assert
      expect(result['success'], true);
      expect(result['data']['temp_token'], 'test_token');
      
      // Verify que la requête a été appelée
      verify(mockApiClient.post(
        '/api/v1/auth/initiate-login',
        {'numeroTelephone': '+221784458786'},
      )).called(1);
    });

    test('verifyOtp should set token correctly', () async {
      // Arrange
      when(mockApiClient.post(
        '/api/v1/auth/verify-otp',
        any,
      )).thenAnswer((_) async => {
        'success': true,
        'data': {
          'access_token': 'jwt_token_123',
          'refresh_token': 'refresh_token_456',
          'token_type': 'Bearer',
          'expires_in': 3600,
        }
      });

      // Act
      final result = await authService.verifyOtp('temp_token', '123456');

      // Assert
      expect(result['success'], true);
      expect(result['data']['access_token'], 'jwt_token_123');
      
      // Verify que setToken a été appelé
      verify(mockApiClient.setToken('jwt_token_123')).called(1);
    });
  });
}
```

---

## Test du AuthProvider

Créez `test/auth_provider_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_application_1/services/implement/auth_service.dart';
import 'package:flutter_application_1/theme/auth_provider.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('AuthProvider', () {
    late MockAuthService mockAuthService;
    late SharedPreferences prefs;

    setUp(() async {
      mockAuthService = MockAuthService();
      
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('initiateLogin should store tempToken', () async {
      // Arrange
      when(mockAuthService.initiateLogin('+221784458786'))
          .thenAnswer((_) async => {
        'success': true,
        'data': {
          'temp_token': 'test_temp_token',
          'otp': '123456',
          'expires_in': 300,
        }
      });

      final authProvider = AuthProvider(
        authService: mockAuthService,
        prefs: prefs,
      );

      // Act
      final result = await authProvider.initiateLogin('+221784458786');

      // Assert
      expect(result, true);
      expect(authProvider.tempToken, 'test_temp_token');
      expect(authProvider.numeroTelephone, '+221784458786');
    });

    test('verifyOtp should persist tokens in SharedPreferences', () async {
      // Arrange
      when(mockAuthService.verifyOtp('temp_token', '123456'))
          .thenAnswer((_) async => {
        'success': true,
        'data': {
          'access_token': 'jwt_token',
          'refresh_token': 'refresh_token',
          'token_type': 'Bearer',
          'expires_in': 3600,
        }
      });

      final authProvider = AuthProvider(
        authService: mockAuthService,
        prefs: prefs,
      );
      
      authProvider._tempToken = 'temp_token';

      // Act
      final result = await authProvider.verifyOtp('123456');

      // Assert
      expect(result, true);
      expect(authProvider.accessToken, 'jwt_token');
      expect(prefs.getString('access_token'), 'jwt_token');
      expect(prefs.getString('refresh_token'), 'refresh_token');
    });

    test('logout should clear all data', () async {
      // Arrange
      final authProvider = AuthProvider(
        authService: mockAuthService,
        prefs: prefs,
      );

      // Set some data
      await prefs.setString('access_token', 'token');
      authProvider._accessToken = 'token';

      // Act
      await authProvider.logout();

      // Assert
      expect(authProvider.accessToken, null);
      expect(authProvider.isAuthenticated, false);
      expect(prefs.getString('access_token'), null);
    });
  });
}
```

---

## Test des modèles

Créez `test/models_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/models/login_initiate_response.dart';
import 'package:flutter_application_1/models/login_verify_response.dart';

void main() {
  group('LoginInitiateResponse', () {
    test('should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'OTP sent',
        'data': {
          'temp_token': 'token123',
          'otp': '123456',
          'message': 'OTP sent',
          'expires_in': 300,
        }
      };

      // Act
      final response = LoginInitiateResponse.fromJson(json);

      // Assert
      expect(response.success, true);
      expect(response.message, 'OTP sent');
      expect(response.data?.tempToken, 'token123');
      expect(response.data?.otp, '123456');
      expect(response.data?.expiresIn, 300);
    });

    test('isValid should return true for valid response', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'OTP sent',
        'data': {
          'temp_token': 'token123',
          'otp': '123456',
          'message': 'OTP sent',
          'expires_in': 300,
        }
      };

      // Act & Assert
      expect(LoginInitiateResponse.fromJson(json).isValid(), true);
    });

    test('isValid should return false for invalid response', () {
      // Arrange
      final json = {
        'success': false,
        'message': 'Error',
        'data': null
      };

      // Act & Assert
      expect(LoginInitiateResponse.fromJson(json).isValid(), false);
    });
  });

  group('LoginVerifyResponse', () {
    test('should parse valid JSON correctly', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Authenticated',
        'data': {
          'access_token': 'jwt_token',
          'refresh_token': 'refresh_token',
          'token_type': 'Bearer',
          'expires_in': 3600,
        }
      };

      // Act
      final response = LoginVerifyResponse.fromJson(json);

      // Assert
      expect(response.success, true);
      expect(response.data?.accessToken, 'jwt_token');
      expect(response.data?.refreshToken, 'refresh_token');
      expect(response.data?.tokenType, 'Bearer');
      expect(response.data?.expiresIn, 3600);
    });

    test('isValid should return true for valid response', () {
      // Arrange
      final json = {
        'success': true,
        'message': 'Authenticated',
        'data': {
          'access_token': 'jwt_token',
          'refresh_token': 'refresh_token',
          'token_type': 'Bearer',
          'expires_in': 3600,
        }
      };

      // Act & Assert
      expect(LoginVerifyResponse.fromJson(json).isValid(), true);
    });
  });
}
```

---

## Test du formatage du numéro de téléphone

Créez `test/phone_formatting_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/services/implement/auth_service.dart';

void main() {
  group('Phone number formatting', () {
    test('should format 9 digits to +221', () {
      expect(AuthService._formatPhoneNumber('784458786'), '+221784458786');
    });

    test('should format 0-prefixed number correctly', () {
      expect(AuthService._formatPhoneNumber('0784458786'), '+221784458786');
    });

    test('should keep already formatted number', () {
      expect(
        AuthService._formatPhoneNumber('+221784458786'),
        '+221784458786',
      );
    });

    test('should handle 221-prefixed number', () {
      expect(
        AuthService._formatPhoneNumber('221784458786'),
        '+221784458786',
      );
    });
  });
}
```

---

## Test du Config

Créez `test/config_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/config/config.dart';

void main() {
  group('Config', () {
    test('should load with default values if file missing', () {
      // Act
      Config.load();

      // Assert
      expect(Config.baseUrl, 'http://localhost:8000');
      expect(Config.timeout, 30000);
      expect(Config.retryAttempts, 3);
      expect(Config.tokenExpiryMinutes, 60);
    });

    test('should have correct defaults', () {
      // Act
      Config.load();

      // Assert
      expect(Config.baseUrl, isNotEmpty);
      expect(Config.timeout, greaterThan(0));
      expect(Config.retryAttempts, greaterThan(0));
    });
  });
}
```

---

## Lancer tous les tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/auth_flow_test.dart

# Run with coverage
flutter test --coverage

# View coverage report (Linux/Mac)
open coverage/index.html  # Mac
firefox coverage/index.html  # Linux
```

---

## Commandes utiles

```bash
# Nettoyer et refaire les tests
flutter clean && flutter pub get && flutter test

# Tester en watchmode (rerun on file change)
flutter test --watch

# Tester avec output verbose
flutter test -v

# Tester un pattern spécifique
flutter test -k "AuthFlow"
```

---

## Checklist pour les tests

- [ ] Tests unitaires des modèles
- [ ] Tests unitaires des services
- [ ] Tests du AuthProvider
- [ ] Tests d'intégration du flux complet
- [ ] Tests de gestion d'erreurs
- [ ] Coverage > 80%
