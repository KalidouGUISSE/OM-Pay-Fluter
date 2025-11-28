import 'dart:io';
import 'package:yaml/yaml.dart';

/// Classe pour charger la configuration depuis config.yaml.
class Config {
  static late Map<String, dynamic> _config;
  
  // Valeurs par défaut
  static const String _defaultBaseUrl = 'http://localhost:8000';
  static const int _defaultTimeout = 30000;
  static const int _defaultRetryAttempts = 3;
  static const int _defaultTokenExpiryMinutes = 60;
  static const int _defaultCacheTtlMinutes = 5;
  static const String _defaultLogLevel = 'INFO';

  static void load() {
    try {
      final file = File('config.yaml');
      if (file.existsSync()) {
        final yamlString = file.readAsStringSync();
        final yamlDoc = loadYamlDocument(yamlString);
        _config = _yamlToDart(yamlDoc.contents) as Map<String, dynamic>;
      } else {
        _initDefaultConfig();
      }
    } catch (e) {
      // En cas d'erreur, utiliser la configuration par défaut
      _initDefaultConfig();
    }
  }

  static void _initDefaultConfig() {
    _config = {
      'api': {
        'base_url': _defaultBaseUrl,
        'timeout': _defaultTimeout,
        'retry_attempts': _defaultRetryAttempts,
      },
      'app': {
        'token_expiry_minutes': _defaultTokenExpiryMinutes,
        'cache_ttl_minutes': _defaultCacheTtlMinutes,
      },
      'logging': {
        'level': _defaultLogLevel,
      },
    };
  }

  static dynamic _yamlToDart(dynamic node) {
    if (node is YamlMap) {
      return node.map((key, value) => MapEntry(key.toString(), _yamlToDart(value)));
    } else if (node is YamlList) {
      return node.map(_yamlToDart).toList();
    } else if (node is YamlNode) {
      return node.value;
    } else {
      return node;
    }
  }

  static String get baseUrl => 
    _config['api']?['base_url'] as String? ?? _defaultBaseUrl;
  
  static int get timeout => 
    _config['api']?['timeout'] as int? ?? _defaultTimeout;
  
  static int get retryAttempts => 
    _config['api']?['retry_attempts'] as int? ?? _defaultRetryAttempts;
  
  static int get tokenExpiryMinutes => 
    _config['app']?['token_expiry_minutes'] as int? ?? _defaultTokenExpiryMinutes;
  
  static int get cacheTtlMinutes => 
    _config['app']?['cache_ttl_minutes'] as int? ?? _defaultCacheTtlMinutes;
  
  static String get logLevel => 
    _config['logging']?['level'] as String? ?? _defaultLogLevel;
}