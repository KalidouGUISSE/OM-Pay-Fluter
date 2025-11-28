# 🏗️ Architecture - Documentation Technique

## 🎯 Vue d'ensemble

L'application OM Pay utilise une architecture modulaire en couches avec Provider pour la gestion d'état. Le flux d'authentification est entièrement intégré au backend Laravel.

```
┌─────────────────────────────────────────────────────┐
│               PRESENTATION LAYER                    │
│  (Pages et Widgets Flutter)                         │
├─────────────────────────────────────────────────────┤
│  • connexion_page.dart                              │
│  • verify_otp_page.dart                             │
│  • form_connexion.dart                              │
│  • home_page.dart                                   │
└────────────┬────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────┐
│             STATE MANAGEMENT LAYER                  │
│  (Provider ChangeNotifier)                          │
├─────────────────────────────────────────────────────┤
│  • AuthProvider (authentification + userData)       │
│  • ThemeProvider (thème de l'app)                   │
└────────────┬────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────┐
│              BUSINESS LOGIC LAYER                   │
│  (Services)                                         │
├─────────────────────────────────────────────────────┤
│  • AuthService (implémentation IAuthService)        │
│  • TransactionService (implémentation ITS)          │
│  • IAuthService (interface)                         │
│  • ITransactionService (interface)                  │
└────────────┬────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────┐
│              DATA ACCESS LAYER                      │
│  (API Client + Error Handling)                      │
├─────────────────────────────────────────────────────┤
│  • ApiClient (HTTP client avec retry)               │
│  • ErrorHandler (gestion erreurs + retry logic)     │
│  • Validators (validation input)                    │
└────────────┬────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────┐
│              PERSISTENCE LAYER                      │
├─────────────────────────────────────────────────────┤
│  • SharedPreferences (tokens, numéro téléphone)     │
│  • Config (configuration app)                       │
│  • Models (sérialisation JSON)                      │
└─────────────────────────────────────────────────────┘
```

---

## 📦 Structure des dossiers

```
lib/
├── config/                          # Configuration globale
│   ├── config.dart                  # Chargement config.yaml
│   └── exceptions.dart              # Exception personnalisées
│
├── core/                            # Code partagé / utilitaire
│   ├── services/
│   │   ├── api_client.dart         # Client HTTP principal
│   │   └── i_api_client.dart       # Interface ApiClient
│   │
│   └── utils/
│       ├── error_handler.dart      # Gestion erreurs + retry
│       ├── validators.dart         # Validation input
│       ├── logger.dart             # Logging
│       ├── cache.dart              # Cache local
│       └── constants.dart          # Constantes globales
│
├── models/                          # Modèles de données
│   ├── user.dart
│   ├── compte.dart
│   ├── transaction.dart
│   ├── me_data.dart
│   ├── me_response.dart
│   ├── login_initiate_response.dart  # 🆕
│   └── login_verify_response.dart    # 🆕
│
├── services/                        # Logique métier
│   ├── i_auth_service.dart         # Interface
│   ├── i_transaction_service.dart  # Interface
│   └── implement/
│       ├── auth_service.dart       # Implémentation
│       └── transaction_service.dart # Implémentation
│
├── theme/                           # Thème + État global
│   ├── theme_provider.dart
│   └── auth_provider.dart          # 🆕
│
├── views/                           # Interface utilisateur
│   ├── pages/
│   │   ├── connexion/
│   │   │   ├── connexion_page.dart
│   │   │   ├── verify_otp_page.dart
│   │   │   └── widgets/
│   │   │       ├── form_connexion.dart
│   │   │       ├── carousel_connexion.dart
│   │   │       └── Bordure.dart
│   │   │
│   │   └── home/
│   │       └── home_page.dart
│   │
│   └── router/
│       └── router.dart              # Navigation routes
│
└── main.dart                        # Point d'entrée (main async)

assets/                              # Ressources statiques
├── images/
└── fonts/

config.yaml                          # Configuration app (base_url, timeout, etc.)
```

---

## 🔄 Flux de données - Authentification

### 1. Initialisation (main.dart)

```dart
void main() async {
    Config.load();  // ← Charge config.yaml ou valeurs par défaut
    final prefs = await SharedPreferences.getInstance();
    
    // Création des instances
    final apiClient = ApiClient(baseUrl: Config.baseUrl);
    final authService = AuthService(apiClient);
    
    // AuthProvider se charge de :
    // - Charger les tokens stockés
    // - Initialiser apiClient.token
    // - Écouter les changements
    
    runApp(OrangeMoneyApp(prefs: prefs));
}
```

### 2. Saisie du numéro (FormConnexion)

```
Utilisateur saisit "784458786"
         ↓
Widget valide (9 chiffres)
         ↓
authProvider.initiateLogin("+221784458786")
         ↓
AuthService.initiateLogin()
         ↓
ApiClient.post("/api/v1/auth/initiate-login")
         ↓
Backend reçoit requête
         ↓
Backend envoie OTP par SMS
Backend retourne temp_token
         ↓
ApiClient récupère réponse JSON
         ↓
AuthService valide avec LoginInitiateResponse
         ↓
AuthProvider stocke temp_token
         ↓
Navigation vers /verify-otp
```

### 3. Vérification OTP (VerifyOtpPage)

```
Utilisateur entre OTP "815695"
         ↓
authProvider.verifyOtp("815695")
         ↓
AuthService.verifyOtp(temp_token, otp)
         ↓
ApiClient.post("/api/v1/auth/verify-otp")
         ↓
Backend valide OTP
Backend génère access_token + refresh_token
         ↓
ApiClient récupère réponse JSON
         ↓
AuthService valide avec LoginVerifyResponse
         ↓
AuthProvider :
  - Stocke accessToken, refreshToken
  - Persiste dans SharedPreferences
  - Configure apiClient.setToken(accessToken)
  ↓
authProvider.fetchUserData()
         ↓
AuthService.me()
         ↓
ApiClient.get("/api/v1/auth/me")
  Ajoute header : Authorization: Bearer {accessToken}
         ↓
Backend retourne user data
         ↓
AuthProvider stocke userData
         ↓
Navigation vers /home
```

---

## 🔐 Gestion des tokens

### Access Token
- **Stockage**: SharedPreferences
- **Utilisation**: Header `Authorization: Bearer {token}`
- **Durée de vie**: 3600 secondes (1 heure)
- **Réinitialisation**: `apiClient.setToken()`

### Refresh Token
- **Stockage**: SharedPreferences
- **Utilisation**: À implémenter pour renouveller access_token
- **Durée de vie**: Longue (selon backend)

### Temp Token
- **Stockage**: RAM (AuthProvider)
- **Utilisation**: Pour verifier l'OTP (étape 2)
- **Durée de vie**: 300 secondes (5 minutes)
- **Nettoyage**: Supprimé après vérification OTP

---

## 🛡️ Gestion des erreurs

### ErrorHandler

```dart
// Retry automatique sur erreurs spécifiques
ErrorHandler.withRetry<T>(fn) 
  ├─ Max 3 tentatives
  ├─ Réessai sur 500, 502
  └─ Throw après 3 échecs

// Vérification code HTTP
ErrorHandler.checkStatusCode(code, message)
  ├─ 401 → AuthenticationException
  └─ 400+ → ApiException
```

### Exceptions personnalisées

```dart
ApiException              // Erreur API générale
  ├─ statusCode
  └─ message

AuthenticationException   // Token invalide / expiré
  └─ statusCode: 401

ValidationException       // Données invalides
  └─ statusCode: 400
```

---

## 📊 Modèles de données

### User
```dart
class User {
  final String id;           // UUID
  final String nom;
  final String prenom;
  final String role;         // 'user', 'admin', etc.
}
```

### Compte
```dart
class Compte {
  final String id;           // UUID
  final String numeroCompte; // ex: "221784458786"
  final String? numeroTelephone;
  final String type;         // 'simple' ou 'marchand'
  final String statut;       // 'actif', 'bloque', 'ferme'
  final DateTime dateCreation;
  final Map<String, dynamic>? metadata;
  final String? codeQr;
}
```

### LoginInitiateData
```dart
class LoginInitiateData {
  final String tempToken;    // Token temporaire (5 min)
  final String otp;          // Code OTP à envoyer par SMS
  final String message;
  final int expiresIn;       // Expiration en secondes
}
```

### LoginVerifyData
```dart
class LoginVerifyData {
  final String accessToken;   // Token JWT pour authentifier requêtes
  final String refreshToken;  // Token pour renouveller accessToken
  final String tokenType;     // "Bearer"
  final int expiresIn;        // Expiration en secondes (3600)
}
```

### MeData
```dart
class MeData {
  final User user;
  final Compte compte;
  final List<DerniereTransaction> dernieresTransactions;
}
```

---

## 🔗 Dépendances entre couches

```
UI (Pages)
  ↓ utilise
Provider (AuthProvider)
  ↓ utilise
Services (AuthService)
  ↓ utilise
ApiClient (HTTP)
  ↓ utilise
ErrorHandler + Config + Models
  ↓ utilise
SharedPreferences + Validators
```

### Import dependencies

```dart
// Dans une page
import 'package:provider/provider.dart';
import '../theme/auth_provider.dart';

// Dans un service
import '../core/services/i_api_client.dart';

// Dans ApiClient
import '../config/config.dart';
import '../core/utils/error_handler.dart';

// Dans ErrorHandler
import '../config/exceptions.dart';
```

---

## ⚙️ Configuration

### config.yaml
```yaml
api:
  base_url: "http://localhost:8000"  # URL backend
  timeout: 30000                      # Ms avant timeout
  retry_attempts: 3                   # Retries en cas d'erreur

app:
  token_expiry_minutes: 60            # Durée access_token
  cache_ttl_minutes: 5                # Cache local

logging:
  level: "INFO"                       # Verbosité logs
```

### Valeurs par défaut (si config.yaml manquant)
```dart
static const String _defaultBaseUrl = 'http://localhost:8000';
static const int _defaultTimeout = 30000;
static const int _defaultRetryAttempts = 3;
// ... etc
```

---

## 🧪 Points de test critiques

1. **ApiClient**: Vérifier headers + retry + parsing JSON
2. **AuthService**: Vérifier validation + formatage numéro
3. **AuthProvider**: Vérifier stockage tokens + état
4. **FormConnexion**: Vérifier appel AuthProvider + navigation
5. **VerifyOtpPage**: Vérifier appel fetchUserData + navigation

---

## 📈 Scalabilité future

### À ajouter facilement
- [ ] TransactionService (même architecture)
- [ ] PaymentService
- [ ] NotificationService
- [ ] AnalyticsService

### Amélioration recommandée
- [ ] Migrer SharedPreferences vers Secure Storage
- [ ] Ajouter caching avec Hive ou Drift
- [ ] Implémenter pagination pour transactions
- [ ] Ajouter téléchargement image profil

---

## 🔗 Références

- [Provider Package](https://pub.dev/packages/provider)
- [HTTP Package](https://pub.dev/packages/http)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [Retry Package](https://pub.dev/packages/retry)
- [Flutter Navigation](https://flutter.dev/docs/development/navigation/routing)
