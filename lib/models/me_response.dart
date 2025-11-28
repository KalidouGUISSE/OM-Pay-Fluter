import 'me_data.dart';

class MeResponse {
  final bool success;
  final String message;
  final MeData? data;

  MeResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    return MeResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? MeData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  /// Vérifie si la réponse est valide et contient des données
  bool isValid() {
    return success && data != null && data!.isValid();
  }

  /// Récupère l'utilisateur depuis les données (avec vérification)
  MeData? get safeData => isValid() ? data : null;
}