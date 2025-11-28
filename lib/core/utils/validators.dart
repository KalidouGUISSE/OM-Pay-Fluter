/// Classe utilitaire pour les validations d'entrée utilisateur.
class Validator {
    /// Valide un numéro de téléphone (format international +221 ou local).
    static bool isValidPhoneNumber(String numero) {
        // Accepte +221XXXXXXXXX (12 caractères) ou 0XXXXXXXXX (10 caractères)
        final regex = RegExp(r'^(\+221[0-9]{9}|0[0-9]{9})$');
        return regex.hasMatch(numero);
    }

    /// Valide un montant (nombre positif avec optionnellement 2 décimales).
    static bool isValidAmount(String montant) {
        final regex = RegExp(r'^\d+(\.\d{1,2})?$');
        return regex.hasMatch(montant) && double.tryParse(montant) != null && double.parse(montant) > 0;
    }

    /// Valide un type de transaction.
    static bool isValidTransactionType(String type) {
        const validTypes = ['transfert', "Transfert d'argent", 'dépôt', 'retrait'];
        return validTypes.contains(type);
    }

    /// Valide un ID (chaîne non vide).
    static bool isValidId(String id) {
        return id.isNotEmpty;
    }

    /// Valide un OTP (code numérique de 4-6 chiffres).
    static bool isValidOtp(String otp) {
        final regex = RegExp(r'^\d{4,6}$');
        return regex.hasMatch(otp);
    }
}