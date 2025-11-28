# 🧪 Guide de Test - Endpoints API

Ce guide vous permet de tester les endpoints directement avant de lancer l'app Flutter.

## 📋 Configuration préalable

Assurez-vous que :
1. Votre backend Laravel tourne sur `http://localhost:8000`
2. Les endpoints API sont correctement configurés

## 🔗 Endpoints à tester

### 1️⃣ Initiate Login
**URL**: `POST http://localhost:8000/api/v1/auth/initiate-login`

#### Headers:
```
Accept: application/json
Content-Type: application/json
X-CSRF-TOKEN: 
```

#### Body:
```json
{
  "numeroTelephone": "+221784458786"
}
```

#### Réponse attendue (200 OK):
```json
{
  "success": true,
  "message": "OTP envoyé avec succès",
  "data": {
    "temp_token": "eyJpdiI6IjNQUEtrNTFqTzlOMHYzQ3BKNkhJVFE9PSIsInZhbHVlIjoidzlqZ04rYngzUW9EU3NqU0cvY0ZKRU1KTUY3eTh0UU9FQlZXTXpwYlhRMUtNNElzVHBRSFFRSVFxNGtpRkVRNG5zVkF5azd0MEJVN0JUbEJGSjJuaElRTDRyQ21peWNDTjZJRDdYdE44eXUzOTNQenV3RkhEc2d3TEM3V3Z0T1EiLCJtYWMiOiJlZDNmNDE0ZTY3NDE4MWQ4YTYyZmNiMTNjY2E4NWZjZDk3ODAwMGZmYWVhZWI3MzZmNWVmZDk1ZDgxZjhjZTVhIiwidGFnIjoiIn0=",
    "otp": "815695",
    "message": "OTP envoyé avec succès",
    "expires_in": 300
  }
}
```

#### Erreurs possibles:
| Code | Erreur | Solution |
|------|--------|----------|
| 400 | Numéro invalide | Vérifier le format +221XXXXXXXXX |
| 404 | Compte non trouvé | S'assurer que le numéro existe |
| 500 | Erreur serveur | Vérifier les logs du backend |

#### Curl:
```bash
curl -X 'POST' \
  'http://localhost:8000/api/v1/auth/initiate-login' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'X-CSRF-TOKEN: ' \
  -d '{
  "numeroTelephone": "+221784458786"
}'
```

---

### 2️⃣ Verify OTP
**URL**: `POST http://localhost:8000/api/v1/auth/verify-otp`

#### Headers:
```
Accept: application/json
Content-Type: application/json
X-CSRF-TOKEN: 
```

#### Body:
```json
{
  "token": "<TEMP_TOKEN_DE_L_ETAPE_1>",
  "otp": "815695"
}
```

#### Réponse attendue (200 OK):
```json
{
  "success": true,
  "message": "Authentification réussie",
  "data": {
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiMjhlYTZjM2FiMDNjYzc4MzEwYTViZTA5OTgzOTNhNGEzMzMzMWNjNjJjNzIzZjljNTM0MDgxOTI0NDc2NDM5ZjBkYWJiOTJkZmVjZDZmMmNiIiwiaWF0IjoxNzY0MzMyOTY1LjgwNzg0LCJuYmYiOjE3NjQzMzI5NjUuODA3ODQ4LCJleHAiOjE3OTU4Njg5NjQuOTAzNzg4LCJzdWIiOiJjNDUwODFjOS05NmQ1LTRkMjItYjM4ZC1mYTg3NzA4Mjc0MmYiLCJzY29wZXMiOltdfQ.cKwt4cTdoLlg1R2NTQ8DgLXrvvMDSTyKyQAb8v3bkeqrWIKVCB6tf--iYosvgLb_m_Kn5VME5_CYZzGBlzUdh2g3nCBV6WpjhbIvlfHLtmS44w1bU0V74kgUc_MqpfpasVY3h1yYbSpJfHrjsmLHXCOwxDLODtcE_EGRoc-LCDhjyGQJ6HdFw2WzHjgUIgGuwOAT1MudjoPJnqEfvyP6izLRnz8A7ReaWmAnA8dr20CNWOyVY61Cs6LHSPDvRlFsNKDLyBFt-l2FAX5T1OsT7IPE5R4UOPXRHEFWzJ1pKBMy1eZ6Tbu5Ge1tkh3xeVuDufdcoPXl3VEjqC9Nvto9C1-5OmTc1Z2Gbn_5gLuwI3LNigfwRKMZ6LGpNm9Aoyatv7XhzWO6UaDo5TP8Ir1CkfX5EygD2qDIqPEKlrKcsKQz_ekKBfwyRzDQUHYsdlKzOoXR9eiEP_U0WK87fJ1dmTedN90Jg0eont2_y1gJvHbp-y13o1WTFtgVaPTEuPNOu8lnq64DFRTL9O4p0KRuayFFQVKn6BC1pK28vnF7rrrFipUefY6W0PGk6DTu7F-hvq4FgxKTxlnYNLJD72uhrYEU0DVdZBZGOPGZF6MRfbUrsI9lSSGVQDPu3dfh8TjCBxsBu9uKA7Lj4M4fItWBZnmUEjvxMAc0gqzpzHz7yEk",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiMDU2YWUzMjI5NTM0YTljYWNkOWU4ZDI1NGE4Zjg1MTUzZmE5ZDJjYzQyMTNiMGM1Y2ZlYjUzYmVjZDJkYzY5NjZmMTllMTQxM2JhZTM1NGIiLCJpYXQiOjE3NjQzMzI5NzQuODE2MjA2LCJuYmYiOjE3NjQzMzI5NzQuODE2MjE0LCJleHAiOjE3OTU4Njg5NzMuODkxNjAyLCJzdWIiOiJjNDUwODFjOS05NmQ1LTRkMjItYjM4ZC1mYTg3NzA4Mjc0MmYiLCJzY29wZXMiOltdfQ.FB-HjJymUX_ne8MGNqO3FnbmW1QvyuALvfKSESeAGdEc00sB-ToDmPaCSJjE40bUaH8vQUg2iO0xyHfqNnp6V8NSHVycJuApRX-SKwgbQriqdUXRSA3QTAQqlfWUUnAkl6EFKI9zD2SmrcYdHOAdz4fCm7c8GL0bWsljgEG_bId1IYWwovSdiHf-SOVfFmGFulX5PkHsyCj3cFCzqLlhCTggLMhGyyiph6XTfM0IyTre3oBhzDdQplThdSirg-WqZpF9_iyPbQzOGsYfphRPzzJ-4mB0dcOXLwA0LGB2k0WSJuBbCxFy3s-r8esTHTrRJVr7NyZMvOQsdcoEqb2yjw1lMcT-Y8zzslfigJHiUmfHmctVoCvXqvLFQjpHaF2FQQGtrbUrRGLRcf6Y72EHg94TrSDVnrl2MD_wUj3uD3W8iVWbs4sHqL9YrxLwwDMf5yW7Ce3HPILrOWzj_BX1bNBZ_KECayzRd5UPC_GOMC6P2RTB7f6QVYxVoDECwMk9CHNDtumQmC5y1UnHE0l_L6Vnj8IViQx8j1I2PY_KOHQfPKm5o_RZKqEhORAnel6g9RnnD6FREDaFP6we4QyGegXRzvuVWlrUx3E9goXJ1kIEcuDBdB72NVfIch1WOtVQ_WHOyf7tvupDN4E6tKP682c8gR5V4WGd6dLZKEC3KzA",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

#### Erreurs possibles:
| Code | Erreur | Solution |
|------|--------|----------|
| 400 | OTP invalide | Vérifier l'OTP entré |
| 410 | Token expiré | L'OTP dure 5 min, recommencer depuis l'étape 1 |
| 404 | Token non trouvé | Vérifier que le token_temp est correct |
| 500 | Erreur serveur | Vérifier les logs du backend |

#### Curl:
```bash
curl -X 'POST' \
  'http://localhost:8000/api/v1/auth/verify-otp' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'X-CSRF-TOKEN: ' \
  -d '{
  "token": "eyJpdiI6IjNQUEtrNTFqTzlOMHYzQ3BKNkhJVFE9PSIsInZhbHVlIjoidzlqZ04rYngzUW9EU3NqU0cvY0ZKRU1KTUY3eTh0UU9FQlZXTXpwYlhRMUtNNElzVHBRSFFRSVFxNGtpRkVRNG5zVkF5azd0MEJVN0JUbEJGSjJuaElRTDRyQ21peWNDTjZJRDdYdE44eXUzOTNQenV3RkhEc2d3TEM3V3Z0T1EiLCJtYWMiOiJlZDNmNDE0ZTY3NDE4MWQ4YTYyZmNiMTNjY2E4NWZjZDk3ODAwMGZmYWVhZWI3MzZmNWVmZDk1ZDgxZjhjZTVhIiwidGFnIjoiIn0=",
  "otp": "815695"
}'
```

---

### 3️⃣ Get User Data (Me)
**URL**: `GET http://localhost:8000/api/v1/auth/me`

#### Headers:
```
Accept: application/json
Authorization: Bearer <ACCESS_TOKEN_DE_L_ETAPE_2>
X-CSRF-TOKEN: 
```

#### Réponse attendue (200 OK):
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
      "date_creation": "2024-01-01T00:00:00Z",
      "metadata": {
        "solde": 50000,
        "plafond": 500000
      },
      "code_qr": "qr_code_data"
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
      },
      {
        "id": "txn-2",
        "type_transaction": "Dépôt",
        "montant": 10000,
        "date": "2024-11-27",
        "reference": "TXN002",
        "contrepartie": "Agent Guichet",
        "direction": "in"
      }
    ]
  }
}
```

#### Erreurs possibles:
| Code | Erreur | Solution |
|------|--------|----------|
| 401 | Non authentifié | Le token est manquant ou invalide |
| 403 | Token expiré | Utiliser le refresh_token pour obtenir un nouveau token |
| 404 | Utilisateur non trouvé | Token invalide |
| 500 | Erreur serveur | Vérifier les logs du backend |

#### Curl:
```bash
curl -X 'GET' \
  'http://localhost:8000/api/v1/auth/me' \
  -H 'accept: application/json' \
  -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...' \
  -H 'X-CSRF-TOKEN: '
```

---

## 📱 Test avec Flutter

### Étapes pour tester l'intégration :

1. **Assurez-vous que le backend est lancé**:
```bash
# Sur votre serveur Laravel
php artisan serve  # ou votre commande habituelle
# Devrait écouter sur http://localhost:8000
```

2. **Lancez l'application Flutter**:
```bash
flutter run
```

3. **Testez le flux complet**:
   - [ ] Entrez un numéro valide dans FormConnexion
   - [ ] Cliquez "Se connecter"
   - [ ] Vérifiez dans les logs que la requête POST est envoyée
   - [ ] Vous devriez être redirigé vers VerifyOtpPage
   - [ ] Entrez l'OTP reçu (check la console du backend)
   - [ ] Cliquez "Vérifier"
   - [ ] Vous devriez être redirigé vers HomePage avec les données utilisateur

---

## 🐛 Debugging

### Activer les logs HTTP

Modifiez `lib/core/services/api_client.dart`:

```dart
@override
Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    print('📤 [POST] $baseUrl$path');
    print('📋 Headers: $_headers');
    print('💾 Body: $body');
    
    final response = await ErrorHandler.withRetry(() async {
        final res = await http.post(
            Uri.parse('$baseUrl$path'),
            headers: _headers,
            body: jsonEncode(body),
        );
        print('📥 Response Status: ${res.statusCode}');
        print('📥 Response Body: ${res.body}');
        return _processResponse(res);
    });
    
    return response;
}
```

### Vérifier le token dans SharedPreferences

```dart
// Dans un widget de debug
Future<void> debugPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  for (var key in keys) {
    print('$key: ${prefs.get(key)}');
  }
}
```

---

## ✅ Checklist de configuration

- [ ] Backend Laravel tourne sur http://localhost:8000
- [ ] Endpoint POST /api/v1/auth/initiate-login fonctionnel
- [ ] Endpoint POST /api/v1/auth/verify-otp fonctionnel
- [ ] Endpoint GET /api/v1/auth/me fonctionnel
- [ ] config.yaml pointe vers http://localhost:8000
- [ ] Tous les modèles Dart sont créés et compilent
- [ ] AuthProvider est fourni dans main.dart
- [ ] Pas d'erreurs de compilation (`flutter analyze`)
