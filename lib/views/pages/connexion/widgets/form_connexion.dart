import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme/auth_provider.dart';
import 'Bordure.dart';

class FormConnexion extends StatefulWidget {
  const FormConnexion({super.key});

  @override
  State<FormConnexion> createState() => _FormConnexionState();
}

class _FormConnexionState extends State<FormConnexion> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez saisir votre numéro de téléphone')),
        );
      }
      return;
    }

    // Validation minimale du numéro
    final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^\d{9}$').hasMatch(cleaned)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Numéro invalide. Entrez 9 chiffres.')),
        );
      }
      return;
    }

    // Utiliser AuthProvider pour initier la connexion
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      // Ajouter le préfixe +221 si nécessaire
      final formattedNumber = '+221$cleaned';
      
      final success = await authProvider.initiateLogin(formattedNumber);
      
      if (mounted) {
        if (success) {
          // Navigation vers la page de vérification OTP
          Navigator.of(context).pushReplacementNamed(
            '/verify-otp',
            arguments: cleaned,
          );
        } else {
          // Afficher l'erreur
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${authProvider.error ?? "Erreur de connexion"}'),
              backgroundColor: Colors.red,
            ),
          );
          authProvider.clearError();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipPath(
        clipper: Bordure(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Bienvenue sur OM Pay!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Entrez votre numéro mobile pour vous connecter",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                const Text("🇸🇳+221", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 25,
                            color: Colors.grey.shade300,
                            margin: EdgeInsets.symmetric(horizontal: 6),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              enabled: !authProvider.isLoading,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Saisir mon numéro",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: authProvider.isLoading 
                            ? Colors.grey 
                            : Color(0xFFFF6600), // Orange OM
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: authProvider.isLoading ? null : _handleLogin,
                        child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Se connecter",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "© Copyright - Orange Money Group, tous droits réservés",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
