enum Flavor { qc, uat, prod }

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required String baseUrl,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      baseUrl,
    );
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.baseUrl,
  );

  final Flavor flavor;
  final String baseUrl;

  static FlavorConfig? _instance;

  static FlavorConfig? get instance => _instance;

  static bool isProd() => _instance!.flavor == Flavor.prod;

  static bool isUAT() => _instance!.flavor == Flavor.uat;

  static bool isQC() => _instance!.flavor == Flavor.qc;
}
