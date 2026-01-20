class AnalyticsManager {
  AnalyticsManager._internal();

  static final AnalyticsManager _instance = AnalyticsManager._internal();

  factory AnalyticsManager() {
    return _instance;
  }

  void trackEvent(String event) {
    print("Tracking event: $event");
  }
}

enum Environment {
  Production("Production"),
  Development("Development"),
  Testing("Testing");


  const Environment(this.name);

  final String name;

  @override
  String toString() {
    return name;
  }

  static Environment fromString(String name) {
    switch (name) {
      case "Production":
        return Environment.Production;
      case "Development":
        return Environment.Development;
      case "Testing":
        return Environment.Testing;
      default:
        throw ArgumentError("Invalid environment name: $name");
    }
  }
}


class ConfigurationManager {
  ConfigurationManager._();

  static final instance = ConfigurationManager._();

  Environment _environment = Environment.Production;

  Environment get environment => _environment;

  void setEnvironment(Environment environment) {
    _environment = environment;
  }

  Environment getEnvironment() {
    print("Getting environment: $_environment");
    return _environment;
  }


  void loadConfiguration() {
    print("Loading configuration for environment: $_environment");
  }
}

class CacheManager {
  CacheManager._();

  static final instance = CacheManager._();

  factory CacheManager() {
    return instance;
  }

  Map<String, dynamic> _cache = {};

  void setCache(String key, dynamic value) {
  _cache[key] = value;
  }

  Map<String, dynamic> getCache() {
  return _cache;
  }

  void clearCache() {
  _cache.clear();
  }
}

void main() {
  final analytics1 = AnalyticsManager();
  final analytics2 = AnalyticsManager();

  analytics1.trackEvent("PageView");
  analytics2.trackEvent("AddToCart");

  print(identical(analytics1, analytics2));

  ConfigurationManager.instance.getEnvironment();

  ConfigurationManager.instance.setEnvironment(Environment.Development);
  ConfigurationManager.instance.loadConfiguration();

  print(ConfigurationManager.instance.environment);

  print("\n========== CacheManager ==========\n");

  final cacheManager1 = CacheManager.instance;
  cacheManager1.setCache("key1", "value1");
  print(cacheManager1.getCache());
  cacheManager1.clearCache();
  cacheManager1.setCache("key2", "value2");
  print(cacheManager1.getCache());

  final cacheManager2 = CacheManager.instance;
  print(cacheManager2.getCache());
  print(identical(cacheManager1, cacheManager2));
}

