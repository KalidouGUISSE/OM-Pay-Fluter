class Compte {
    final String id;               // UUID
    final String numeroCompte;
    final String? numeroTelephone;
    final String type;             // simple | marchand
    final String statut;           // actif | bloque | ferme
    final DateTime dateCreation;
    final Map<String, dynamic>? metadata;
    final String? codeQr;

    Compte({
        required this.id,
        required this.numeroCompte,
        this.numeroTelephone,
        required this.type,
        required this.statut,
        required this.dateCreation,
        this.metadata,
        this.codeQr,
    });

    factory Compte.fromJson(Map<String, dynamic> json) {
        return Compte(
        id: json['id'] as String? ?? '',
        numeroCompte: json['numero_compte'] as String? ?? json['numeroCompte'] as String? ?? '',
        numeroTelephone: json['numeroTelephone'] as String?,
        type: json['type'] as String? ?? '',
        statut: json['statut'] as String? ?? '',
        dateCreation: DateTime.tryParse(json['date_creation'] as String? ?? json['dateCreation'] as String? ?? '') ?? DateTime.now(),
        metadata: json['metadata'] as Map<String, dynamic>?,
        codeQr: json['code_qr'] as String? ?? json['codeQr'] as String?,
        );
    }

    Map<String, dynamic> toJson() {
        return {
        'id': id,
        'numeroCompte': numeroCompte,
        'numeroTelephone': numeroTelephone,
        'type': type,
        'statut': statut,
        'dateCreation': dateCreation.toIso8601String(),
        'metadata': metadata,
        'code_qr': codeQr,
        };
    }
}
