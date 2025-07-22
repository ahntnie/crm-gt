part of '../core.dart';

class EnvironmentConfig {
  static void setEnvironment(String value) {
    AppSP.set(AppSP.environment, value);
  }

  static String? getEnvironment() {
    return AppSP.get(AppSP.environment);
  }
}

class Environments {
  static const String production = 'PROD';
  static const String qa = 'QA';
  static const String dev = 'DEV';
  static final String _currentEnvironments = EnvironmentConfig.getEnvironment() ?? qa;
  static final List<Map<String, String>> _availableEnvironments = [
    {
      'env': Environments.dev,
      'url': 'http://192.168.2.103:3028/',
      'realmId': 'z113-dev',
      'clientSecret': 'fPmp2WREl4xBCLPhkoXFJOBofUoEejU9',
      'urlHrmNoti': 'http://dev-evotek-hcm-api.evotek.vn/',
    },
    {
      'env': Environments.qa,
      'url': 'http://172.31.2.121:3021/',
      'realmId': 'z113-qa',
      'clientSecret': 'R2LS4m2ilhtcCEXK2b6yEulrkxGY4L6x',
      'urlHrmNoti': 'http://qa-evotek-hcm-api.evotek.vn/',
    },
    {
      'env': Environments.production,
      'url': 'https://opencity.vn/api/',
      'realmId': 'z113-dev',
      'clientSecret': 'fPmp2WREl4xBCLPhkoXFJOBofUoEejU9',
      'urlHrmNoti': 'http://dev-evotek-hcm-api.evotek.vn/',
    },
  ];

  static String getUrl() {
    return _availableEnvironments.firstWhere(
          (d) => d['env'] == _currentEnvironments,
        )['url'] ??
        '';
  }

  static String getUrlHrmNoti() {
    return _availableEnvironments.firstWhere(
          (d) => d['env'] == _currentEnvironments,
        )['urlHrmNoti'] ??
        '';
  }

  static String getEnvironment() {
    return _availableEnvironments.firstWhere(
          (d) => d['env'] == _currentEnvironments,
        )['env'] ??
        Environments.dev;
  }

  static String getRealmId() {
    return _availableEnvironments.firstWhere(
          (d) => d['env'] == _currentEnvironments,
        )['realmId'] ??
        '';
  }

  static String getClientSecret() {
    return _availableEnvironments.firstWhere(
          (d) => d['env'] == _currentEnvironments,
        )['clientSecret'] ??
        '';
  }
}
