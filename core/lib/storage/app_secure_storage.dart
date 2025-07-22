part of '../core.dart';

final class AppSecureStorageKeys {
  AppSecureStorageKeys._();

  static const String token = 'token';
  static const String encToken = 'encToken';
}

class AppSecureStorage {
  static FlutterSecureStorage init() {
    const iosOptions = IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    );
    const androidOptions = AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    );

    return const FlutterSecureStorage(
      iOptions: iosOptions,
      aOptions: androidOptions,
    );
  }

  static Future<void> setToken(TokenData? value) async {
    final storage = getIt.get<FlutterSecureStorage>();
    final rawToken = jsonEncode(value?.toJson());

    await storage.write(key: AppSecureStorageKeys.token, value: rawToken);
  }

  static Future<TokenData?> getToken() async {
    final storage = getIt.get<FlutterSecureStorage>();
    final rawToken = await storage.read(key: AppSecureStorageKeys.token);

    if (rawToken == null) {
      return null;
    }

    final Map<String, dynamic>? tokenData = jsonDecode(rawToken);

    if (tokenData == null || tokenData.isEmpty == true) {
      return null;
    }

    return TokenData.fromJson(tokenData);
  }

  static Future clearToken() async {
    final tokenData = await getToken();

    // Remove refresh token
    final newToken = tokenData?.copyWith(
      refreshToken: '',
    );

    await setToken(newToken);
  }

  static Future<void> resetToken() async {
    final storage = getIt.get<FlutterSecureStorage>();

    await storage.delete(key: AppSecureStorageKeys.token);
  }

  static Future setEncToken(String? token) async {
    final storage = getIt.get<FlutterSecureStorage>();

    await storage.write(key: AppSecureStorageKeys.encToken, value: token);
  }

  static Future<String?> getEncToken() async {
    final storage = getIt.get<FlutterSecureStorage>();
    final rawEncToken = await storage.read(key: AppSecureStorageKeys.encToken);

    return rawEncToken;
  }
}
