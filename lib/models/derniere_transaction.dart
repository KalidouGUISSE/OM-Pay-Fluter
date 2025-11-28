class DerniereTransaction {
  final String id;
  final String typeTransaction;
  final double montant;
  final String date;
  final String reference;
  final String contrepartie;
  final String direction;

  DerniereTransaction({
    required this.id,
    required this.typeTransaction,
    required this.montant,
    required this.date,
    required this.reference,
    required this.contrepartie,
    required this.direction,
  });

  factory DerniereTransaction.fromJson(Map<String, dynamic> json) {
    return DerniereTransaction(
      id: json['id'] as String? ?? '',
      typeTransaction: json['type_transaction'] as String? ?? '',
      montant: double.tryParse(json['montant']?.toString() ?? '0') ?? 0.0,
      date: json['date'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      contrepartie: json['contrepartie'] as String? ?? '',
      direction: json['direction'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_transaction': typeTransaction,
      'montant': montant,
      'date': date,
      'reference': reference,
      'contrepartie': contrepartie,
      'direction': direction,
    };
  }

  /// Valide la cohérence de la transaction
  bool isValid() {
    return id.isNotEmpty &&
           typeTransaction.isNotEmpty &&
           reference.isNotEmpty &&
           direction.isNotEmpty;
  }
}