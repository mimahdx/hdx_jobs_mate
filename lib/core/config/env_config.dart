// lib/core/config/env_config.dart
enum Environment {
  dev,
  staging,
  prod,
  hotfix
}

class EnvConfig {
  final String apiUrl;
  final String apiKey;
  final bool enableLogging;
  final String envName;
  final bool useLocalDatabase;

  static late EnvConfig _instance;

  EnvConfig._({
    required this.apiUrl,
    required this.apiKey,
    required this.enableLogging,
    required this.envName,
    required this.useLocalDatabase,
  });

  static EnvConfig get instance => _instance;

  static void setupEnv(Environment env) {
    switch (env) {
      case Environment.dev:
        _instance = EnvConfig._(
          apiUrl: 'https://dev-api.hdxincometracker.com',
          apiKey: 'dev_api_key',
          enableLogging: true,
          envName: 'DEV',
          useLocalDatabase: true,
        );
        break;

      case Environment.staging:
        _instance = EnvConfig._(
          apiUrl: 'https://staging-api.hdxincometracker.com',
          apiKey: 'staging_api_key',
          enableLogging: true,
          envName: 'STAGING',
          useLocalDatabase: false,
        );
        break;

      case Environment.prod:
        _instance = EnvConfig._(
          apiUrl: 'https://api.hdxincometracker.com',
          apiKey: 'prod_api_key',
          enableLogging: false,
          envName: 'PROD',
          useLocalDatabase: false,
        );
        break;

      case Environment.hotfix:
        _instance = EnvConfig._(
          apiUrl: 'https://hotfix-api.hdxincometracker.com',
          apiKey: 'hotfix_api_key',
          enableLogging: true,
          envName: 'HOTFIX',
          useLocalDatabase: false,
        );
        break;
    }
  }
}