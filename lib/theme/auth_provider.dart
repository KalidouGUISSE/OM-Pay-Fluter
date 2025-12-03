import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/me_data.dart';
import '../services/implement/auth_service.dart';
import '../config/exceptions.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  final SharedPreferences prefs;

  // Constantes pour le cache
  static const String _userDataCacheKey = 'cached_user_data';
  static const String _userDataTimestampKey = 'cached_user_data_timestamp';
  static const Duration _userDataCacheDuration = Duration(minutes: 30);

  String? _tempToken;
  DateTime? _tempTokenExpiry;
  String? _accessToken;
  String? _refreshToken;
  String? _numeroTelephone;
  MeData? _userData;
  bool _isLoading = false;
  String? _error;

  AuthProvider({required this.authService, required this.prefs}) {
    _loadStoredData();
  }

  // Getters
  String? get tempToken => _tempToken;
  DateTime? get tempTokenExpiry => _tempTokenExpiry;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get numeroTelephone => _numeroTelephone;
  MeData? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;
  bool get isTempTokenExpired => _tempTokenExpiry != null && DateTime.now().isAfter(_tempTokenExpiry!);

  /// Charge les données stockées depuis SharedPreferences
  void _loadStoredData() {
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    _numeroTelephone = prefs.getString('numero_telephone');

    // Charger MeData depuis cache si valide
    _loadUserDataFromCache();

    if (_accessToken != null) {
      authService.apiClient.setToken(_accessToken!);
      // Le numéro sera défini lors de fetchUserData()
    }
  }

  /// Charge les données utilisateur depuis le cache
  void _loadUserDataFromCache() {
    final cachedData = prefs.getString(_userDataCacheKey);
    final timestampStr = prefs.getString(_userDataTimestampKey);

    if (cachedData != null && timestampStr != null) {
      final timestamp = DateTime.tryParse(timestampStr);
      if (timestamp != null && DateTime.now().difference(timestamp) < _userDataCacheDuration) {
        try {
          final jsonData = jsonDecode(cachedData);
          _userData = MeData.fromJson(jsonData);
          // Définir le numéro dans le client API depuis les données cachées
          if (_userData?.compte.numero_telephone != null) {
            authService.apiClient.numero = _userData!.compte.numero_telephone;
          }
        } catch (e) {
          // Cache corrompu, ignorer
          _clearUserDataCache();
        }
      } else {
        // Cache expiré
        _clearUserDataCache();
      }
    }
  }

  /// Sauvegarde les données utilisateur en cache
  Future<void> _saveUserDataToCache(MeData data) async {
    final jsonData = jsonEncode(data.toJson());
    await prefs.setString(_userDataCacheKey, jsonData);
    await prefs.setString(_userDataTimestampKey, DateTime.now().toIso8601String());
  }

  /// Vide le cache des données utilisateur
  Future<void> _clearUserDataCache() async {
    await prefs.remove(_userDataCacheKey);
    await prefs.remove(_userDataTimestampKey);
  }

  /// Étape 1 : Initier la connexion avec le numéro de téléphone
  Future<bool> initiateLogin(String numero) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.initiateLogin(numero);
      _tempToken = response['data']['temp_token'];
      _tempTokenExpiry = DateTime.now().add(Duration(seconds: response['data']['expires_in']));
      _numeroTelephone = numero;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Étape 2 : Vérifier l'OTP et obtenir les tokens
  Future<bool> verifyOtp(String otp) async {
    if (_tempToken == null) {
      _error = 'Token temporaire manquant';
      notifyListeners();
      return false;
    }

    if (isTempTokenExpired) {
      _error = 'Token temporaire expiré. Veuillez recommencer la connexion.';
      _tempToken = null;
      _tempTokenExpiry = null;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.verifyOtp(_tempToken!, otp);

      _accessToken = response['data']['access_token'];
      _refreshToken = response['data']['refresh_token'];

      // Définir le token d'accès dans le client API
      authService.apiClient.setToken(_accessToken!);

      // Stocker les tokens
      await prefs.setString('access_token', _accessToken!);
      await prefs.setString('refresh_token', _refreshToken!);
      if (_numeroTelephone != null) {
        await prefs.setString('numero_telephone', _numeroTelephone!);
      }

      _tempToken = null; // Nettoyer le token temporaire
      _tempTokenExpiry = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Étape 3 : Charger les données utilisateur après authentification
  Future<bool> fetchUserData() async {
    if (!isAuthenticated) {
      _error = 'Non authentifié';
      notifyListeners();
      return false;
    }

    // Vérifier si données en cache sont encore valides
    if (_userData != null) {
      final timestampStr = prefs.getString(_userDataTimestampKey);
      if (timestampStr != null) {
        final timestamp = DateTime.tryParse(timestampStr);
        if (timestamp != null && DateTime.now().difference(timestamp) < _userDataCacheDuration) {
          // Cache valide, pas besoin de refetch
          return true;
        }
      }
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.me();
      if (response.isValid()) {
        _userData = response.data;
        // Sauvegarder en cache
        await _saveUserDataToCache(_userData!);
        // Définir le numéro de compte dans le client API
        if (_userData?.compte.numero_telephone != null) {
          authService.apiClient.numero = _userData!.compte.numero_telephone;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw ApiException('Données utilisateur invalides');
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _tempToken = null;
    _tempTokenExpiry = null;
    _userData = null;
    _numeroTelephone = null;
    _error = null;

    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('numero_telephone');
    await _clearUserDataCache();

    authService.apiClient.token = null;
    authService.apiClient.numero = null;
    notifyListeners();
  }

  /// Réinitialiser l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
