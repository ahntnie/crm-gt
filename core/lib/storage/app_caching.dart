part of core;

final class AppCaching {
  AppCaching._privateConstructor();

  static final AppCaching _instance = AppCaching._privateConstructor();

  factory AppCaching() {
    return _instance;
  }

  final Map<String, dynamic> _cache = {};

  bool containsKey(String key) {
    return _cache.containsKey(key);
  }

  dynamic get(String key) {
    return _cache[key];
  }

  void set(String key, dynamic value) {
    if (containsKey(key)) {
      remove(key);
    }

    _cache[key] = value;
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }
}
