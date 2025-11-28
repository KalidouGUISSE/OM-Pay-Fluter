import '../../core/services/i_api_client.dart';
import '../i_auth_service.dart';
import '../../core/utils/validators.dart';
import '../../config/exceptions.dart';
import '../../models/user.dart';
import '../../models/me_response.dart';

class AuthService implements IAuthService {
    final IApiClient apiClient;
    AuthService(this.apiClient);

    @override
    Future<Map<String, dynamic>> initiateLogin(String numero) async {
        if (!Validator.isValidPhoneNumber(numero)) {
            throw ValidationException('Numéro de téléphone invalide');
        }
        return await apiClient.post('/api/v1/auth/initiate-login', {'numeroTelephone': numero});
    }

    @override
    Future<Map<String, dynamic>> verifyOtp(String token, String otp) async {
        if (!Validator.isValidOtp(otp)) {
            throw ValidationException('OTP invalide');
        }
        return await apiClient.post('/api/v1/auth/verify-otp', {'token': token, 'otp': otp});
    }

    @override
    Future<Map<String, dynamic>> login(String numero, String pin) async {
        return await apiClient.post('/api/v1/auth/login', {'numeroTelephone': numero, 'pin': pin});
    }

    @override
    Future<MeResponse> me() async{
        final response = await apiClient.get('/api/v1/auth/me') as Map<String, dynamic>;
        return MeResponse.fromJson(response);
    }
}
