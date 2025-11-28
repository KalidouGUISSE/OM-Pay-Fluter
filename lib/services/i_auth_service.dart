import '../models/user.dart';
import '../models/me_response.dart';

abstract class IAuthService {
  Future<Map<String, dynamic>> initiateLogin(String numero);
  Future<Map<String, dynamic>> verifyOtp(String token, String otp);
  Future<Map<String, dynamic>> login(String numero, String pin);
  Future<MeResponse> me();
}