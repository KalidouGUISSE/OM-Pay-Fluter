import 'dart:io';
import 'package:yaml/yaml.dart';

/// Classe pour charger la configuration depuis config.yaml.
class Config {
  static late Map<String, dynamic> _config;

  static void load() {
    final file = File('config.yaml');
    if (!file.existsSync()) {
      throw Exception('Fichier config.yaml introuvable');
    }
    final yamlString = file.readAsStringSync();
    final yamlDoc = loadYamlDocument(yamlString);
    _config = _yamlToDart(yamlDoc.contents) as Map<String, dynamic>;
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

  static String get baseUrl => _config['api']['base_url'];
  static int get timeout => _config['api']['timeout'];
  static int get retryAttempts => _config['api']['retry_attempts'];
  static int get tokenExpiryMinutes => _config['app']['token_expiry_minutes'];
  static int get cacheTtlMinutes => _config['app']['cache_ttl_minutes'];
  static String get logLevel => _config['logging']['level'];
}