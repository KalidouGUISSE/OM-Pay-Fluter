class LoginInitiateData {
  final String tempToken;
  final String otp;
  final String message;
  final int expiresIn;

  LoginInitiateData({
    required this.tempToken,
    required this.otp,
    required this.message,
    required this.expiresIn,
  });

  factory LoginInitiateData.fromJson(Map<String, dynamic> json) {
    return LoginInitiateData(
      tempToken: json['temp_token'] as String? ?? '',
      otp: json['otp'] as String? ?? '',
      message: json['message'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_token': tempToken,
      'otp': otp,
      'message': message,
      'expires_in': expiresIn,
    };
  }

  bool isValid() => tempToken.isNotEmpty && expiresIn > 0;
}

class LoginInitiateResponse {
  final bool success;
  final String message;
  final LoginInitiateData? data;

  LoginInitiateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginInitiateResponse.fromJson(Map<String, dynamic> json) {
    return LoginInitiateResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null 
          ? LoginInitiateData.fromJson(json['data'] as Map<String, dynamic>) 
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
