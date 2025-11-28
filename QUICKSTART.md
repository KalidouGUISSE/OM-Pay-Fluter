# ⚡ Quick Start - Démarrage Rapide

## 🎯 Vous êtes ici

Vous avez une application Flutter connectée à un backend Laravel avec un flux d'authentification OTP en 3 étapes.

## 🚀 Pour démarrer immédiatement

### 1. Vérifiez votre backend (2 min)

```bash
# Assurez-vous que Laravel tourne
# Sur votre serveur Laravel :
php artisan serve

# Devrait afficher : 
# Starting Laravel development server: http://127.0.0.1:8000
```

### 2. Lancez l'app Flutter (5 min)

```bash
# Dans le répertoire du projet
cd /home/kalidou-guisse/Bureau/Flutter\ Dart/flutter/flutter_application_1

# Lancez l'app
flutter run

# Ou sur un émulateur Android/iOS spécifique
flutter run -d emulator-5554    # Android
flutter run -d iPhone\ 14\ Pro  # iOS
```

### 3. Testez le flux (3 min)

1. **Page de connexion** :
   - Entrez : `784458786` (ou votre numéro de test)
   - Cliquez : "Se connecter"

2. **Vérification OTP** :
   - Vérifiez la console/logs du backend pour l'OTP
   - Entrez : Le code OTP (ex: `123456`)
   - Cliquez : "Vérifier"

3. **Page d'accueil** :
   - Vous devriez voir vos données utilisateur !

---

## 📝 Configuration

### Si vous changez l'URL du backend

Modifier `config.yaml` :
```yaml
api:
  base_url: "http://votre-nouveau-backend.com"
```

Puis relancez `flutter run`.

### Si vous voulez voir les logs HTTP

Décommentez les `print()` dans `lib/core/services/api_client.dart`.

---

## 🔍 Dépannage rapide

| Problème | Solution |
|----------|----------|
| "Connection refused" | Vérifier que Laravel tourne sur 8000 |
| Compilation échoue | `flutter clean && flutter pub get` |
| Token expiré en local | Normal (5 min pour OTP), recommencer |
| SharedPreferences vide | Normal à la 1ère fois |
| "Page not found" | Vérifier le routeur dans `router.dart` |

---

## 📁 Fichiers importants

| Fichier | Rôle |
|---------|------|
| `main.dart` | Point d'entrée, initialise tout |
| `lib/theme/auth_provider.dart` | Gestion état authentification |
| `lib/config/config.yaml` | URL backend + timeouts |
| `lib/views/pages/connexion/` | Pages de login |
| `BACKEND_INTEGRATION_GUIDE.md` | Documentation complète |
| `API_TESTING_GUIDE.md` | Guide test endpoints |
| `ARCHITECTURE.md` | Architecture technique |

---

## ✅ Avant de partir en production

- [ ] Changer base_url vers votre domaine de production
- [ ] Tester tous les 3 endpoints avec Postman
- [ ] Implémenter le refresh_token automatique
- [ ] Ajouter gestion session timeout
- [ ] Tester sur vrai appareil
- [ ] Implémenter biométrie (optionnel)

---

## 🆘 Besoin d'aide ?

1. Consultez `BACKEND_INTEGRATION_GUIDE.md` pour le flux complet
2. Consultez `API_TESTING_GUIDE.md` pour tester les endpoints
3. Consultez `ARCHITECTURE.md` pour comprendre le code
4. Vérifiez les logs Flutter : `flutter logs`
5. Vérifiez les logs Laravel : `tail -f storage/logs/laravel.log`

---

## 🎓 Prochaines étapes

Après cette intégration de base :

1. **Implémenter HomePage** pour afficher les données utilisateur
2. **Ajouter logout** avec suppression des tokens
3. **Implémenter refresh_token** automatique
4. **Ajouter pagination** pour les transactions
5. **Implémenter les transactions** (envoi d'argent, etc.)

---

## 📞 Questions fréquentes

### Q: Où sont stockés les tokens ?
R: Dans SharedPreferences (persiste après fermeture app)

### Q: Combien de temps dure l'OTP ?
R: 5 minutes (300 secondes)

### Q: Combien de temps dure l'access_token ?
R: 1 heure (3600 secondes)

### Q: Comment me déconnecter ?
R: Appeler `authProvider.logout()` (à implémenter dans HomePage)

### Q: Comment tester hors ligne ?
R: La persiste du token permet les tests locaux

---

**Vous êtes prêt ! 🎉 Lancez `flutter run` et testez !**
