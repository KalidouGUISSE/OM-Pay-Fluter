abstract class IApiClient {
  String? token;
  String? numero;
  Future<Map<String, dynamic>> get(String path);
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body);
  void setToken(String token);
}