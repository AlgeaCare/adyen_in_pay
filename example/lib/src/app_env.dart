// ignore_for_file: constant_identifier_names

enum AppEnvironment {
  DEV(
    envName: 'dev',
    appName: 'Example Development',
    splashDurationSeconds: 3,
  ),
  PROD(envName: 'prod', appName: 'Example', splashDurationSeconds: 3),
  STAGING(
    envName: 'staging',
    appName: 'Example Staging',
    splashDurationSeconds: 3,
  );

  final String envName;
  final String appName;
  final int splashDurationSeconds;

  const AppEnvironment({
    required this.envName,
    required this.appName,
    required this.splashDurationSeconds,
  });
}

abstract class EnvInfo {
  static AppEnvironment _environment = AppEnvironment.DEV;

  static Future<void> initialize(AppEnvironment environment) async {
    EnvInfo._environment = environment;
  }

  static String get envName => _environment.envName;
  static AppEnvironment get environment => _environment;

  static bool get isProduction => _environment == AppEnvironment.PROD;
  static bool get isStaging => _environment == AppEnvironment.STAGING;

  static String get adyenClientKey =>
      const String.fromEnvironment('ADYEN_CLIENT_KEY');

  static String get adyenAppleMerchantId =>
      const String.fromEnvironment('APPLE_ADYEN_MERCHANT_ID');

  static String get adyenMerchantName =>
      const String.fromEnvironment('ADYEN_MERCHANT_NAME');

  static String get adyenGoogleMerchantId =>
      const String.fromEnvironment('GOOGLE_ADYEN_MERCHANT_ID');
}
