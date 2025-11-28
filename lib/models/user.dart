class User {
  final String id;
  final String nom;
  final String prenom;
  final String role;

  User({required this.id, required this.nom, required this.prenom, required this.role});

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String? ?? '',
    nom: json['nom'] as String? ?? '',
    prenom: json['prenom'] as String? ?? '',
    role: json['role'] as String? ?? '',
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'role': role,
    };
  }
}
