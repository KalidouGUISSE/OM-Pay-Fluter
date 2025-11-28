import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_application_1/core/services/i_api_client.dart';
import 'package:flutter_application_1/services/implement/auth_service.dart';

@GenerateMocks([IApiClient])
import 'auth_flow_test.mocks.dart';

void main() {
  group('AuthFlow', () {
    late MockIApiClient mockApiClient;
    late AuthService authService;

    setUp(() {
      mockApiClient = MockIApiClient();
      authService = AuthService(mockApiClient);
    });

    test('initiateLogin should format phone number correctly for 784457686', () async {
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
      final result = await authService.initiateLogin('784457686');

      // Assert
      expect(result['success'], true);
      expect(result['data']['temp_token'], 'test_token');

      // Verify que la requête a été appelée avec le numéro formaté
      verify(mockApiClient.post(
        '/api/v1/auth/initiate-login',
        {'numeroTelephone': '+221784457686'},
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