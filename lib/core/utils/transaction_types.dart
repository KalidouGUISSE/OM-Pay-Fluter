/// Énumération des types de transactions supportés par l'API OM Pay
enum TransactionType {
  /// Transfert d'argent entre comptes Orange Money
  transfertArgent('Transfert d\'argent'),

  /// Paiement vers un marchand via code marchand
  paiementMarchand('Paiement marchand'),

  /// Dépôt d'argent sur le compte
  depot('Dépôt d\'argent'),

  /// Retrait d'argent du compte
  retrait('Retrait d\'argent'),

  /// Recharge de crédit téléphonique
  rechargeMobile('Recharge mobile'),

  /// Achat de pass (abonnement)
  achatPass('Achat Pass');

  const TransactionType(this.displayName);

  /// Nom d'affichage pour l'interface utilisateur
  final String displayName;

  /// Liste de toutes les valeurs d'affichage pour validation
  static List<String> get allDisplayNames => values.map((e) => e.displayName).toList();

  /// Liste de toutes les valeurs en minuscules pour validation flexible
  static List<String> get allLowerCaseNames => values.map((e) => e.displayName.toLowerCase()).toList();

  /// Trouve le type d'énumération depuis une chaîne (insensible à la casse)
  static TransactionType? fromString(String value) {
    final lowerValue = value.toLowerCase();
    for (final type in values) {
      if (type.displayName.toLowerCase() == lowerValue) {
        return type;
      }
    }
    return null;
  }

  /// Vérifie si une chaîne correspond à un type de transaction valide
  static bool isValid(String value) {
    return fromString(value) != null;
  }
}