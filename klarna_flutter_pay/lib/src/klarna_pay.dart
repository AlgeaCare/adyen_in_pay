import 'package:klarna_flutter_pay/src/interface/klarna_flutter_pay_platform_interface.dart' show KlarnaFlutterPayPlatform;


class KlarnaFlutterPay {
  /// Initialize Klarna payment with client token and configuration
  Future<bool> initializePayment({
    required String clientToken,
    required String returnURL,
    String environment = 'staging',
    String region = 'EU',
    String loggingLevel = 'verbose',
    Map<String, dynamic>? additionalArgs,
  }) {
    return KlarnaFlutterPayPlatform.instance.initializePayment(
      clientToken: clientToken,
      returnURL: returnURL,
      environment: environment,
      region: region,
      loggingLevel: loggingLevel,
      additionalArgs: additionalArgs,
    );
  }

  /// Start payment process
  Future<bool> pay() {
    return KlarnaFlutterPayPlatform.instance.pay();
  }

  /// Authorize payment
  Future<bool> authorize({bool autoFinalize = true, String? sessionData}) {
    return KlarnaFlutterPayPlatform.instance.authorize(
      autoFinalize: autoFinalize,
      sessionData: sessionData,
    );
  }

  /// Finalize payment
  Future<bool> finalize({String? sessionData}) {
    return KlarnaFlutterPayPlatform.instance.finalize(sessionData: sessionData);
  }
}
