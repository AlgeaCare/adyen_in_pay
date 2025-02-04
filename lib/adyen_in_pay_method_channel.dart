import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'adyen_in_pay_platform_interface.dart';

/// An implementation of [AdyenInPayPlatform] that uses method channels.
class MethodChannelAdyenInPay extends AdyenInPayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('adyen_in_pay');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
