// Constantes pour les choix de menu
class MenuConstants {
  static const int initiateLogin = 1;
  static const int listAccounts = 2;
  static const int makeTransaction = 3;
  static const int quit = 0;
}

// Classe centralisée pour tous les messages de l'application
class Messages {
  // Messages d'erreur
  static const String invalidChoice = "❌ Veuillez entrer un chiffre.";
  static const String invalidOtp = "❌ OTP invalide";
  static const String incorrectOtp = "❌ OTP incorrect";
  static const String apiError = "❌ Erreur : ";
  static const String invalidChoiceDefault = "❌ Choix invalide.";
  static const String requiredField = "❌ Tous les champs sont requis";
  static const String invalidAmount = "❌ Montant invalide";
  static const String requiredId = "❌ ID requis";
  static const String apiErrorGeneric = "❌ Erreur API : ";

  // Messages de succès
  static const String validNumber = "✅ Numero valide : ";
  static const String otpCorrect = "🔑 OTP correct, connexion en cours...";
  static const String loginSuccess = "🎉 Connexion réussie ! ";
  static const String goodbye = "👋 Au revoir !";
  static const String transactionCreated = "📄 Transaction créée avec succès:";

  // Messages d'information
  static const String accountsNotImplemented = "👉 Liste des comptes (à implémenter)";
  static const String transactionsNotImplemented = "👉 Effectuer une transaction (à implémenter)";
  static const String backToMainMenu = "👋 Retour au menu principal...";

  // Messages du menu principal
  static const String mainMenuTitle = "\n=== MENU PRINCIPAL ===";
  static const String mainMenuOption1 = "1. Initier la connexion avec OTP";
  static const String mainMenuOption2 = "2. TRANSACTION";
  static const String mainMenuOption0 = "0. Quitter";
  static const String mainMenuPrompt = "Votre choix : ";

  // Messages du menu transaction
  static const String transactionMenuTitle = "\n=== MENU TRANSACTION ===";
  static const String transactionMenuOption1 = "1. Lister les transactions";
  static const String transactionMenuOption2 = "2. Faire une transaction";
  static const String transactionMenuOption3 = "3. Récupérer une transaction";
  static const String transactionMenuOption4 = "4. Voir solde";
  static const String transactionMenuOption0 = "0. Quitter";

  // Messages pour les transactions
  static const String transactionListTitle = "📄 Liste des transactions";
  static const String transactionNotFound = "📄 Aucune transaction trouvée";
  static const String transactionFound = "📄 Transaction trouvée:";
  static const String transactionBalance = "📄 Solde : ";
  static const String transactionCreatePrompt = "\n📌 Effectuer une transactions";
  static const String transactionCreateRecipientPrompt = "Saisir le numéro du destinataire : ";
  static const String transactionCreateAmountPrompt = "Saisir le montant : ";
  static const String transactionCreateTypePrompt = "Type de transaction ?: transfert, Transfert d'argent, dépôt ou retrait : \n";
  static const String transactionByIdPrompt = "\n📌 Récupérer une Transaction par id";
  static const String transactionByIdIdPrompt = "Saisir l'id : ";

  // Messages pour la connexion
  static const String loginPhonePrompt = "Saisir votre numéro de téléphone : ";
  static const String loginOtpPrompt = "Saisir le code OTP : ";
  static const String loginOtpDisplay = "Code OTP : ";

  // Labels pour l'affichage des transactions
  static const String labelId = "ID: ";
  static const String labelType = "Type: ";
  static const String labelSender = "Expéditeur: ";
  static const String labelRecipient = "Destinataire: ";
  static const String labelPhone = "Numéro: ";
  static const String labelAmount = "Montant: ";
  static const String labelDate = "Date: ";
  static const String labelReference = "Référence: ";
  static const String labelMetadata = "Métadonnées: ";
  static const String currency = " FCFA";

  // Fonctions utilitaires pour les messages
  static String transactionCount(int count) => "📄 Liste des transactions ($count):";
  static String otpDisplay(String otp) => "Code OTP : $otp";
  static String balanceDisplay(double balance) => "📄 Solde : $balance";

  // Fonctions d'affichage
  static void showSuccess(String message) {
    print("✅ $message");
  }

  static void showError(String message) {
    print("❌ $message");
  }

  static void showInfo(String message) {
    print("ℹ️ $message");
  }

  static void showWarning(String message) {
    print("⚠️ $message");
  }
}

// Alias pour la compatibilité descendante
class ErrorMessages {
  static const String invalidChoice = Messages.invalidChoice;
  static const String invalidOtp = Messages.invalidOtp;
  static const String incorrectOtp = Messages.incorrectOtp;
  static const String apiError = Messages.apiError;
  static const String invalidChoiceDefault = Messages.invalidChoiceDefault;
}

class SuccessMessages {
  static const String validNumber = Messages.validNumber;
  static const String otpCorrect = Messages.otpCorrect;
  static const String loginSuccess = Messages.loginSuccess;
  static const String goodbye = Messages.goodbye;
}

class InfoMessages {
  static const String accountsNotImplemented = Messages.accountsNotImplemented;
  static const String transactionsNotImplemented = Messages.transactionsNotImplemented;
}