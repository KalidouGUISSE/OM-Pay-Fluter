class QrData {
  final String id;
  final String numeroCompte;
  final String numeroTelephone;
  final String type;

  QrData({
    required this.id,
    required this.numeroCompte,
    required this.numeroTelephone,
    required this.type,
  });

  factory QrData.fromJson(Map<String, dynamic> json) {
    return QrData(
      id: json['id'] as String? ?? '',
      numeroCompte: json['numero_compte'] as String? ?? '',
      numeroTelephone: json['numero_telephone'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_compte': numeroCompte,
      'numero_telephone': numeroTelephone,
      'type': type,
    };
  }

  bool isValid() {
    return id.isNotEmpty &&
           numeroCompte.isNotEmpty &&
           numeroTelephone.isNotEmpty &&
           (type == 'simple' || type == 'marchand');
  }
}