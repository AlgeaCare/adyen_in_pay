import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../channel/klarna_flutter_pay_method_channel.dart';

abstract class KlarnaFlutterPayPlatform extends PlatformInterface {
  /// Constructs a KlarnaFlutterPayPlatform.
  KlarnaFlutterPayPlatform(this.channelName) : super(token: _token);
  final String channelName;
  static final Object _token = Object();

  static KlarnaFlutterPayPlatform? _instance;

  /// The default instance of [KlarnaFlutterPayPlatform] to use.
  ///
  /// Defaults to [MethodChannelKlarnaFlutterPay].
  static KlarnaFlutterPayPlatform get instance =>
      _instance ?? MethodChannelKlarnaFlutterPay('de.bloomwell/klarna_pay');

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KlarnaFlutterPayPlatform] when
  /// they register themselves.
  static set instance(KlarnaFlutterPayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance ??= MethodChannelKlarnaFlutterPay(instance.channelName);
  }

  /// Initialize Klarna payment with client token and configuration
  Future<bool> initializePayment({
    required String clientToken,
    required String returnURL,
    String environment = 'staging',
    String region = 'EU',
    String loggingLevel = 'verbose',
    Map<String, dynamic>? additionalArgs,
  }) {
    throw UnimplementedError('initializePayment() has not been implemented.');
  }

  /// Start payment process
  Future<bool> pay() {
    throw UnimplementedError('pay() has not been implemented.');
  }

  /// Authorize payment
  Future<bool> authorize({bool autoFinalize = true, String? sessionData}) {
    throw UnimplementedError('authorize() has not been implemented.');
  }

  /// Finalize payment
  Future<bool> finalize({String? sessionData}) {
    throw UnimplementedError('finalize() has not been implemented.');
  }
}
