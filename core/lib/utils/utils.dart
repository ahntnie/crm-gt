part of '../core.dart';

class Utils {
  static AppLocalizations languageOf(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static isNullOrEmpty(dynamic object) {
    if (object == null) {
      return true;
    }
    if (object is String && (object.isEmpty || (object.isNotEmpty && object.trim() == ""))) {
      return true;
    }
    if (object is List && object.isEmpty) {
      return true;
    }
    if (object is bool && object == false) {
      return true;
    }
    return false;
  }

  static Future<String> getEncryptToken() async {
    try {
      final tokenData = await AppSecureStorage.getToken();
      final secretKey = tokenData?.secretKey;
      final accessToken = tokenData?.accessToken;

      if (secretKey == null || accessToken == null) return '';
      final publicKey = '-----BEGIN PUBLIC KEY-----\n$secretKey\n-----END PUBLIC KEY-----';
      final tokenParts = accessToken.split('.');
      final data = "${tokenParts[0]}.${tokenParts[1]}";
      final encrypted = await RSA.encryptPKCS1v15(data, publicKey);

      return '$encrypted.${tokenParts[2]}';
    } catch (e) {
      Log.e(e.toString());
      return '';
    }
  }

  //count noti on home screen
  static String getCountNotify(int count) {
    if (count < 100) {
      return "$count";
    }
    return "99+";
  }

  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
