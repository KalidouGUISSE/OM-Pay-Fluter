class AppStrings {
  static const String languageFr = 'fr';
  static const String languageEn = 'en';

  static const Map<String, Map<String, String>> _localizedValues = {
    languageFr: {
      // Scanner
      'scanner_qr_code': 'Scanner QR Code',
      // Pay/Transfer
      'payer': 'Payer',
      'transferer': 'Transférer',
      'valider': 'Valider',
      // Drawer
      'phone_number': '784458786', // Peut-être pas traduire
      'sombre': 'Sombre',
      'scanner': 'Scanner',
      'francais': 'Français',
      'se_deconnecter': 'Se déconnecter',
      'version': 'OMPAY Version - 1.1.0(35)',
      // OTP
      'veuillez_saisir_otp': 'Veuillez saisir le code OTP',
      'otp_6_chiffres': 'Le code OTP doit contenir 6 chiffres',
      'authentification_reussie': 'Authentification réussie',
      'otp_invalide': 'OTP invalide',
      'verifier_code_otp': 'Vérifier le code OTP',
      'code_renvoye': 'Code renvoyé (simulation)',
      'renvoyer_code': 'Renvoyer le code',
      // Connexion
      'veuillez_saisir_telephone': 'Veuillez saisir votre numéro de téléphone',
      'numero_invalide': 'Numéro invalide. Entrez 9 chiffres.',
      'erreur_connexion': 'Erreur de connexion',
      // Home
      'solde_impossible': 'Impossible de récupérer le solde automatiquement. Vous pouvez le consulter manuellement.',
      'saisir_destinataire': 'Veuillez saisir le numéro/code destinataire',
      'saisir_montant': 'Veuillez saisir le montant',
      'montant_invalide': 'Montant invalide',
      'telephone_invalide': 'Numéro de téléphone invalide (format: +221XXXXXXXXX)',
      'code_marchand_invalide': 'Code marchand invalide',
      'transaction_reussie': 'Transaction réussie! Référence: ',
      'erreur_transaction': 'Erreur lors de la transaction: ',
      // Transaction Amount
      'veuillez_saisir_montant': 'Veuillez saisir un montant',
      'montant_du_transfert': 'Montant du transfert',
      // Historique
      'aucune_transaction': 'Aucune transaction',
      // Header
      'erreur': 'Erreur',
      // Router
      'page_non_trouvee': 'Page non trouvée',
      'bonjour': 'Bonjour ',
      'numero_destinataire': 'Numéro destinataire (77XXXXXXX)',
      'code_marchand': 'Code marchand',
      'cliquer_scanner': 'Cliquer et\nscanner',
      'pour_toute_autre_operation': 'Pour toute autre opération',
      'acceder_max_it': 'Accéder à Max it',
      'historique': 'Historique',
    },
    languageEn: {
      // Scanner
      'scanner_qr_code': 'Scan QR Code',
      // Pay/Transfer
      'payer': 'Pay',
      'transferer': 'Transfer',
      'valider': 'Validate',
      // Drawer
      'phone_number': '784458786',
      'sombre': 'Dark',
      'scanner': 'Scanner',
      'francais': 'French',
      'se_deconnecter': 'Log out',
      'version': 'OMPAY Version - 1.1.0(35)',
      // OTP
      'veuillez_saisir_otp': 'Please enter the OTP code',
      'otp_6_chiffres': 'The OTP code must contain 6 digits',
      'authentification_reussie': 'Authentication successful',
      'otp_invalide': 'Invalid OTP',
      'verifier_code_otp': 'Verify OTP code',
      'code_renvoye': 'Code resent (simulation)',
      'renvoyer_code': 'Resend code',
      // Connexion
      'veuillez_saisir_telephone': 'Please enter your phone number',
      'numero_invalide': 'Invalid number. Enter 9 digits.',
      'erreur_connexion': 'Connection error',
      // Home
      'solde_impossible': 'Unable to retrieve balance automatically. You can check it manually.',
      'saisir_destinataire': 'Please enter the recipient number/code',
      'saisir_montant': 'Please enter the amount',
      'montant_invalide': 'Invalid amount',
      'telephone_invalide': 'Invalid phone number (format: +221XXXXXXXXX)',
      'code_marchand_invalide': 'Invalid merchant code',
      'transaction_reussie': 'Transaction successful! Reference: ',
      'erreur_transaction': 'Transaction error: ',
      // Transaction Amount
      'veuillez_saisir_montant': 'Please enter an amount',
      'montant_du_transfert': 'Transfer amount',
      // Historique
      'aucune_transaction': 'No transactions',
      // Header
      'erreur': 'Error',
      // Router
      'page_non_trouvee': 'Page not found',
      'bonjour': 'Hello ',
      'numero_destinataire': 'Recipient number (77XXXXXXX)',
      'code_marchand': 'Merchant code',
      'cliquer_scanner': 'Click and\nscan',
      'pour_toute_autre_operation': 'For any other operation',
      'acceder_max_it': 'Access Max it',
      'historique': 'History',
    },
  };

  static String get(String key, String language) {
    return _localizedValues[language]?[key] ?? key;
  }
}