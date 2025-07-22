part of 'core.dart';

final getIt = GetIt.instance;

class Di {
  static final Di _singleton = Di._internal();

  factory Di() {
    return _singleton;
  }

  Di._internal();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    getIt.registerSingleton(AppSecureStorage.init());
    getIt.registerSingleton(prefs);
  }
}
