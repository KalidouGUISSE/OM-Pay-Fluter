import '../../core/services/i_api_client.dart';
import '../i_auth_service.dart';
import '../../core/utils/validators.dart';
import '../../config/exceptions.dart';
import '../../models/me_response.dart';
import '../../models/login_initiate_response.dart';
import '../../models/login_verify_response.dart';
import 'package:flutter/material.dart';

class AuthService implements IAuthService {
    final IApiClient apiClient;
    AuthService(this.apiClient);

    @override
    Future<Map<String, dynamic>> initiateLogin(String numero) async {
        if (!Validator.isValidPhoneNumber(numero)) {
            throw ValidationException('Numéro de téléphone invalide');
        }
        // Format du numéro : convertir format local (9 chiffres) en international (+221)
        final formattedNumber = _formatPhoneNumber(numero);
        final response = await apiClient.post('/api/v1/auth/initiate-login', 
            {'numeroTelephone': formattedNumber});
        print("{}{}{}{}{}{}{}{}{}} \n $response \n");
        final initiateResponse = LoginInitiateResponse.fromJson(response);
        if (!initiateResponse.isValid()) {
            throw ApiException('Réponse invalide du serveur');
        }
        return response;
    }

    @override
    Future<Map<String, dynamic>> verifyOtp(String token, String otp) async {
        if (!Validator.isValidOtp(otp)) {
            throw ValidationException('OTP invalide');
        }
        // Définir temporairement le token pour l'authentification
        apiClient.setToken(token);
        final response = await apiClient.post('/api/v1/auth/verify-otp', {'token': token, 'otp': otp});
        
        print('\n[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[================response===============]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]\n');
        debugPrint("return response: $response");
        print('\n[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[================response===============]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]\n');
        
        final verifyResponse = LoginVerifyResponse.fromJson(response);
        if (!verifyResponse.isValid()) {
            throw ApiException('Réponse invalide du serveur');
        }
        // Stocker le token dans le client API
        if (verifyResponse.data != null) {
            apiClient.setToken(verifyResponse.data!.accessToken);
        }
        return response;
    }

    @override
    Future<Map<String, dynamic>> login(String numero, String pin) async {
        return await apiClient.post('/api/v1/auth/login', 
            {'numeroTelephone': numero, 'pin': pin});
    }

    @override
    Future<MeResponse> me() async{
        final response = await apiClient.get('/api/v1/auth/me');
            
        print('\n[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[================response= api/v1/auth/me =============]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]\n');
        debugPrint("return response: $response");
        print('\n[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[================response== api/v1/auth/me ============]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]\n');
        

        return MeResponse.fromJson(response);
    }

    /// Convertit le numéro de téléphone au format international
    /// Accepte : "123456789" -> "+221123456789"
    /// Accepte : "0123456789" -> "+221123456789"  
    /// Accepte : "+221123456789" -> "+221123456789"
    static String _formatPhoneNumber(String numero) {
        final cleaned = numero.replaceAll(RegExp(r'\D'), '');
        if (cleaned.startsWith('221')) {
            return '+$cleaned';
        } else if (cleaned.startsWith('0')) {
            return '+221${cleaned.substring(1)}';
        } else if (cleaned.length == 9) {
            return '+221$cleaned';
        }
        return '+221$cleaned';
    }
}
