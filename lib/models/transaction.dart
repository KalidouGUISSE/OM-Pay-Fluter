class Transaction {
    final String id;
    final String typeTransaction;   // "type de transfere"
    final String expediteur;        // backend -> "Numero"
    final String destinataire;      // backend -> "Numero"
    final double montant;
    final DateTime date;            // backend -> "dateCreation"
    final String reference;         // backend -> "id" ou autre
    final Map<String, dynamic>? metadata;

    Transaction({
        required this.id,
        required this.typeTransaction,
        required this.expediteur,
        required this.destinataire,
        required this.montant,
        required this.date,
        required this.reference,
        this.metadata,
    });

    factory Transaction.fromJson(Map<String, dynamic> json) {
        return Transaction(
        id: json['id'],
        typeTransaction: json['type de transaction'] ?? json['type de transfere'] ?? json['type_transaction'] ?? '',
        expediteur: json['Expediteur'] ?? json['Numero'] ?? json['expediteur'] ?? '',
        destinataire: json['Destinataire'] ?? json['Numero'] ?? json['destinataire'] ?? '',
        montant: double.tryParse(json['montant'].toString()) ?? 0.0,
        date: DateTime.parse(json['Date'] ?? json['dateCreation'] ?? json['date']),
        reference: json['Reference'] ?? json['reference'] ?? json['id'] ?? '',
        metadata: json['metadata'],
        );
    }

    Map<String, dynamic> toJson() {
        return {
        'id': id,
        'type de transfere': typeTransaction,
        'Numero': expediteur,
        'montant': montant,
        'dateCreation': date.toIso8601String(),
        'reference': reference,
        'metadata': metadata,
        };
    }

    bool isValid() {
        return id.isNotEmpty &&
            typeTransaction.isNotEmpty &&
            expediteur.isNotEmpty &&
            montant > 0;
    }

    Transaction copyWith({
        String? id,
        String? typeTransaction,
        String? expediteur,
        String? destinataire,
        double? montant,
        DateTime? date,
        String? reference,
        Map<String, dynamic>? metadata,
    }) {
        return Transaction(
            id: id ?? this.id,
            typeTransaction: typeTransaction ?? this.typeTransaction,
            expediteur: expediteur ?? this.expediteur,
            destinataire: destinataire ?? this.destinataire,
            montant: montant ?? this.montant,
            date: date ?? this.date,
            reference: reference ?? this.reference,
            metadata: metadata ?? this.metadata,
        );
    }

}
