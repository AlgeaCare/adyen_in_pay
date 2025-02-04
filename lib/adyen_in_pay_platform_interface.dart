import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'adyen_in_pay_method_channel.dart';

abstract class AdyenInPayPlatform extends PlatformInterface {
  /// Constructs a AdyenInPayPlatform.
  AdyenInPayPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdyenInPayPlatform _instance = MethodChannelAdyenInPay();

  /// The default instance of [AdyenInPayPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdyenInPay].
  static AdyenInPayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdyenInPayPlatform] when
  /// they register themselves.
  static set instance(AdyenInPayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
