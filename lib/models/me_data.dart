import 'user.dart';
import 'compte.dart';
import 'derniere_transaction.dart';

class MeData {
  final User user;
  final Compte compte;
  final List<DerniereTransaction> dernieresTransactions;

  MeData({
    required this.user,
    required this.compte,
    required this.dernieresTransactions,
  });

  factory MeData.fromJson(Map<String, dynamic> json) {
    return MeData(
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      compte: Compte.fromJson(json['compte'] as Map<String, dynamic>? ?? {}),
      dernieresTransactions: (json['dernieres_transactions'] as List<dynamic>? ?? [])
          .map((item) => DerniereTransaction.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'compte': compte.toJson(),
      'dernieres_transactions': dernieresTransactions.map((t) => t.toJson()).toList(),
    };
  }

  /// Valide la cohérence des données
  bool isValid() {
    return user.id.isNotEmpty &&
           compte.id.isNotEmpty &&
           dernieresTransactions.every((t) => t.isValid());
  }
}