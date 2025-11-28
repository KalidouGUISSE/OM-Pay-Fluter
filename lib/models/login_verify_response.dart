class LoginVerifyResponse {
  final bool success;
  final String message;
  final LoginVerifyData? data;

  LoginVerifyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginVerifyResponse.fromJson(Map<String, dynamic> json) {
    return LoginVerifyResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null 
          ? LoginVerifyData.fromJson(json['data'] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  bool isValid() => success && data != null && data!.isValid();
}

class LoginVerifyData {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  LoginVerifyData({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory LoginVerifyData.fromJson(Map<String, dynamic> json) {
    return LoginVerifyData(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }

  bool isValid() => accessToken.isNotEmpty && refreshToken.isNotEmpty && expiresIn > 0;
}
