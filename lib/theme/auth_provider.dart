import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/me_data.dart';
import '../services/implement/auth_service.dart';
import '../config/exceptions.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  final SharedPreferences prefs;

  String? _tempToken;
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
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get numeroTelephone => _numeroTelephone;
  MeData? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _accessToken != null && _accessToken!.isNotEmpty;

  /// Charge les données stockées depuis SharedPreferences
  void _loadStoredData() {
    _accessToken = prefs.getString('access_token');
    _refreshToken = prefs.getString('refresh_token');
    _numeroTelephone = prefs.getString('numero_telephone');
    
    if (_accessToken != null) {
      authService.apiClient.setToken(_accessToken!);
    }
  }

  /// Étape 1 : Initier la connexion avec le numéro de téléphone
  Future<bool> initiateLogin(String numero) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.initiateLogin(numero);
      _tempToken = response['data']['temp_token'];
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

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.verifyOtp(_tempToken!, otp);
      _accessToken = response['data']['access_token'];
      _refreshToken = response['data']['refresh_token'];
      
      // Stocker les tokens
      await prefs.setString('access_token', _accessToken!);
      await prefs.setString('refresh_token', _refreshToken!);
      if (_numeroTelephone != null) {
        await prefs.setString('numero_telephone', _numeroTelephone!);
      }
      
      _tempToken = null; // Nettoyer le token temporaire
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

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await authService.me();
      if (response.isValid()) {
        _userData = response.data;
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
    _userData = null;
    _numeroTelephone = null;
    _error = null;
    
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('numero_telephone');
    
    authService.apiClient.token = null;
    notifyListeners();
  }

  /// Réinitialiser l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
