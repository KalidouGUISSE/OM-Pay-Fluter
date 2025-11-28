# Guide de Connexion au Backend - OM Pay Flutter

## 📋 Vue d'ensemble du flux de connexion

Votre application Flutter implémente maintenant un flux de connexion complet en 3 étapes :

1. **Initiation de connexion** : L'utilisateur saisit son numéro de téléphone
2. **Vérification OTP** : L'utilisateur reçoit un code OTP par SMS et le saisit
3. **Authentification** : Récupération automatique des données utilisateur après vérification

## 🔄 Architecture du système

### Composants principaux

```
┌─────────────────────────────────────────────────────────┐
│                    UI Layer                              │
│  ┌──────────────┐              ┌─────────────────────┐  │
│  │ FormConnexion│              │ VerifyOtpPage       │  │
│  └──────────────┘              └─────────────────────┘  │
│         │                               │                 │
│         └───────────────┬───────────────┘                │
└─────────────────────────┼──────────────────────────────┘
                          │
┌─────────────────────────┼──────────────────────────────┐
│                 State Management Layer                   │
│         ┌──────────────────────────────┐                │
│         │  AuthProvider (ChangeNotifier)│                │
│         │  - tempToken                  │                │
│         │  - accessToken                │                │
│         │  - refreshToken               │                │
│         │  - userData                   │                │
│         └──────────────────────────────┘                │
└─────────────────────────┼──────────────────────────────┘
                          │
┌─────────────────────────┼──────────────────────────────┐
│                  Service Layer                          │
│  ┌──────────────────────┐                              │
│  │   AuthService        │                              │
│  │ - initiateLogin()    │                              │
│  │ - verifyOtp()        │                              │
│  │ - login()            │                              │
│  │ - me()               │                              │
│  └──────────────────────┘                              │
└─────────────────────────┼──────────────────────────────┘
                          │
┌─────────────────────────┼──────────────────────────────┐
│                    Network Layer                        │
│         ┌──────────────────────────┐                   │
│         │    ApiClient             │                   │
│         │ - HTTP POST/GET          │                   │
│         │ - Token Management       │                   │
│         │ - Error Handling & Retry │                   │
│         └──────────────────────────┘                   │
└─────────────────────────┼──────────────────────────────┘
                          │
        ┌─────────────────┴──────────────────┐
        │                                    │
        ▼                                    ▼
    Backend API                    SharedPreferences
  (http://localhost:8000)           (Local Storage)
```

## 🔐 Flux détaillé d'authentification

### Étape 1 : Initiation de connexion

**User Input**: Utilisateur entre son numéro de téléphone (ex: `784458786` ou `0784458786`)

**Code Flow**:
```dart
// Dans FormConnexion._handleLogin()
1. Validation du numéro (9 chiffres)
2. Appel authProvider.initiateLogin('+221784458786')
```

**Request HTTP**:
```bash
POST http://localhost:8000/api/v1/auth/initiate-login
Content-Type: application/json

{
  "numeroTelephone": "+221784458786"
}
```

**Response**:
```json
{
  "success": true,
  "message": "OTP envoyé avec succès",
  "data": {
    "temp_token": "eyJpdiI6IjNQUEtrNTFqTzlOMHYzQ3BKNkhJVFE9PSIsInZhbHVl...",
    "otp": "815695",
    "message": "OTP envoyé avec succès",
    "expires_in": 300
  }
}
```

**Stockage**:
```dart
// Dans AuthProvider.initiateLogin()
_tempToken = response['data']['temp_token'];
_numeroTelephone = numero;
```

---

### Étape 2 : Vérification OTP

**User Input**: Utilisateur reçoit un SMS avec le code OTP et le saisit

**Code Flow**:
```dart
// Dans VerifyOtpPage._verifyOtp()
1. Validation de l'OTP (6 chiffres)
2. Appel authProvider.verifyOtp(otp)
```

**Request HTTP**:
```bash
POST http://localhost:8000/api/v1/auth/verify-otp
Content-Type: application/json

{
  "token": "eyJpdiI6IjNQUEtrNTFqTzlOMHYzQ3BKNkhJVFE9PSIsInZhbHVl...",
  "otp": "815695"
}
```

**Response**:
```json
{
  "success": true,
  "message": "Authentification réussie",
  "data": {
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

**Stockage**:
```dart
// Dans AuthProvider.verifyOtp()
_accessToken = response['data']['access_token'];
_refreshToken = response['data']['refresh_token'];

// Stocker dans SharedPreferences
await prefs.setString('access_token', _accessToken!);
await prefs.setString('refresh_token', _refreshToken!);

// Configurer l'ApiClient avec le token
apiClient.setToken(_accessToken!);
```

---

### Étape 3 : Récupération des données utilisateur

**Code Flow**:
```dart
// Dans VerifyOtpPage._verifyOtp() après verifyOtp()
Appel authProvider.fetchUserData()
```

**Request HTTP**:
```bash
GET http://localhost:8000/api/v1/auth/me
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...
```

**Response**:
```json
{
  "success": true,
  "message": "Utilisateur récupéré",
  "data": {
    "user": {
      "id": "c450-81c9-96d5-4d22-b38d",
      "nom": "Gueisse",
      "prenom": "Kalidou",
      "role": "user"
    },
    "compte": {
      "id": "acc-123",
      "numero_compte": "221784458786",
      "numeroTelephone": "+221784458786",
      "type": "simple",
      "statut": "actif",
      "date_creation": "2024-01-01T00:00:00Z"
    },
    "dernieres_transactions": [
      {
        "id": "txn-1",
        "type_transaction": "Transfert d'argent",
        "montant": 5000,
        "date": "2024-11-28",
        "reference": "TXN001",
        "contrepartie": "Jean Dupont",
        "direction": "out"
      }
    ]
  }
}
```

**Stockage**:
```dart
// Dans AuthProvider.fetchUserData()
_userData = response.data;
```

---

## 📁 Structure des fichiers modifiés

```
lib/
├── config/
│   ├── config.dart                     # ✅ MODIFIÉ - Config avec valeurs par défaut
│   └── exceptions.dart
├── core/
│   ├── services/
│   │   ├── api_client.dart             # ✅ MODIFIÉ - Headers et formatage améliorés
│   │   └── i_api_client.dart
│   └── utils/
│       ├── error_handler.dart
│       └── validators.dart
├── models/
│   ├── login_initiate_response.dart    # ✨ NOUVEAU - Modèle pour réponse initiate-login
│   ├── login_verify_response.dart      # ✨ NOUVEAU - Modèle pour réponse verify-otp
│   ├── me_response.dart
│   ├── me_data.dart
│   ├── user.dart
│   ├── compte.dart
│   └── derniere_transaction.dart
├── services/
│   ├── i_auth_service.dart
│   └── implement/
│       └── auth_service.dart           # ✅ MODIFIÉ - Appels réels API
├── theme/
│   ├── auth_provider.dart              # ✨ NOUVEAU - Gestionnaire d'état auth
│   └── theme_provider.dart
├── views/
│   └── pages/
│       ├── connexion/
│       │   ├── connexion_page.dart
│       │   ├── verify_otp_page.dart    # ✅ MODIFIÉ - Intégration AuthProvider
│       │   └── widgets/
│       │       └── form_connexion.dart # ✅ MODIFIÉ - Intégration AuthProvider
│       └── home/
│           └── home_page.dart
└── main.dart                           # ✅ MODIFIÉ - Initialisation async & Providers
```

---

## 🚀 Installation & Configuration

### 1. Dépendances (déjà dans pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.6.0
  provider: ^6.1.2
  shared_preferences: ^2.2.3
  yaml: ^3.1.3
  retry: ^3.1.2
```

### 2. Configuration du backend

**Modifier `config.yaml`** (déjà fait):
```yaml
api:
  base_url: "http://localhost:8000"  # URL de votre backend
  timeout: 30000
  retry_attempts: 3
```

**⚠️ IMPORTANT**: Assurez-vous que votre backend tourne sur `http://localhost:8000`

### 3. Exécuter l'application

```bash
flutter run
```

---

## 🔍 Debugging & Logs

### Afficher les requêtes HTTP

Ajoutez ceci pour voir les requêtes en direct:

```dart
// Dans core/services/api_client.dart (optionnel)
@override
Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    print('📤 POST: $baseUrl$path');
    print('📋 Body: $body');
    print('🔐 Headers: $_headers');
    // ... reste du code
}
```

### Vérifier les données stockées

```dart
// Dans un widget de debug
final prefs = await SharedPreferences.getInstance();
print('Token: ${prefs.getString('access_token')}');
print('Numéro: ${prefs.getString('numero_telephone')}');
```

---

## ✅ Checklist pour le déploiement

- [ ] Backend running sur `http://localhost:8000`
- [ ] Endpoints API configurés :
  - [ ] `POST /api/v1/auth/initiate-login`
  - [ ] `POST /api/v1/auth/verify-otp`
  - [ ] `GET /api/v1/auth/me`
- [ ] `config.yaml` pointe vers le bon backend
- [ ] SharedPreferences fonctionne (automatiquement sur mobile)
- [ ] Tous les modèles sont créés (LoginInitiateResponse, LoginVerifyResponse, etc.)
- [ ] AuthProvider est fourni dans MultiProvider du main.dart

---

## 🎯 Prochaines étapes

### À court terme
1. Tester le flux complet de connexion
2. Gérer les cas d'erreur (réseau, OTP expiré, etc.)
3. Implémenter la déconnexion
4. Afficher les données utilisateur dans la page d'accueil

### À moyen terme
1. Implémenter le refresh token automatique
2. Ajouter une page de profil utilisateur
3. Afficher le solde du compte
4. Implémenter les transactions

### À long terme
1. Ajouter la biométrie (Face ID/Touch ID)
2. Implémenter le PIN de sécurité
3. Ajouter des notifications push
4. Persister les transactions en cache local

---

## 🐛 Troubleshooting

### "Connection refused"
**Cause**: Le backend n'est pas lancé  
**Solution**: Vérifier que `http://localhost:8000` est accessible

### "OTP invalide"
**Cause**: Le token temporaire a expiré (>5 min)  
**Solution**: Recommencer depuis la page de connexion

### "Token expiré"
**Cause**: L'access_token a expiré (>1 heure)  
**Solution**: Implémenter le refresh token automatique

### SharedPreferences vide
**Cause**: Première installation ou données supprimées  
**Solution**: Normal au premier lancement

---

## 📞 Support

Pour toute question sur l'intégration:
- Vérifiez la console Flutter pour les logs d'erreur
- Testez les endpoints avec Postman d'abord
- Consultez la documentation de votre backend
