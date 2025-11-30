import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/auth_provider.dart';

class VerifyOtpPage extends StatefulWidget {
  final String? phoneNumber;
  const VerifyOtpPage({super.key, this.phoneNumber});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir le code OTP')),
      );
      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le code OTP doit contenir 6 chiffres')),
      );
      return;
    }

    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      
      // Vérifier l'OTP
      final success = await authProvider.verifyOtp(otp);

      print('\n[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[================success===============]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]\n');
      print('\n     $success             \n');
      
      if (mounted) {
        if (success) {
          // L'OTP est vérifié et on a obtenu l'access_token
          // Maintenant, charger les données utilisateur
          final userDataLoaded = await authProvider.fetchUserData();
          
          if (mounted) {
            if (userDataLoaded) {
              // Succès ! Naviguer vers la page d'accueil
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Authentification réussie')),
              );
              Navigator.of(context).pushReplacementNamed('/home');
            } else {
              // Erreur lors du chargement des données utilisateur
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erreur: ${authProvider.error ?? "Impossible de charger les données utilisateur"}'),
                  backgroundColor: Colors.red,
                ),
              );
              authProvider.clearError();
            }
          }
        } else {
          // OTP invalide ou erreur réseau
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${authProvider.error ?? "OTP invalide"}'),
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
    final phone = widget.phoneNumber ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérifier le code OTP'),
        backgroundColor: const Color(0xFFFF6600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Nous avons envoyé un code à :',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  phone.isNotEmpty ? '+221 $phone' : 'Numéro non fourni',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  enabled: !authProvider.isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Code OTP',
                    hintText: 'Entrez le code à 6 chiffres',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: authProvider.isLoading ? null : _verifyOtp,
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Vérifier', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: authProvider.isLoading ? null : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code renvoyé (simulation)')),
                    );
                  },
                  child: const Text('Renvoyer le code'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
