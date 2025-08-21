import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../interface/klarna_flutter_pay_platform_interface.dart';

/// An implementation of [KlarnaFlutterPayPlatform] that uses method channels.
class MethodChannelKlarnaFlutterPay extends KlarnaFlutterPayPlatform {
  /// The method channel used to interact with the native platform.
  MethodChannelKlarnaFlutterPay(super.channelName) : methodChannel = MethodChannel(channelName);

  @visibleForTesting
  final MethodChannel methodChannel;

  @override
  Future<bool> initializePayment({
    required String clientToken,
    required String returnURL,
    String environment = 'staging',
    String region = 'EU',
    String loggingLevel = 'verbose',
    Map<String, dynamic>? additionalArgs,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('initializePayment', {
        'clientToken': clientToken,
        'returnURL': returnURL,
        'environment': environment,
        'region': region,
        'loggingLevel': loggingLevel,
        ...?additionalArgs,
      });
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> pay() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('pay');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authorize({bool autoFinalize = true, String? sessionData}) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('authorize', {
        'autoFinalize': autoFinalize,
        'sessionData': sessionData,
      });
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> finalize({String? sessionData}) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('finalize', {
        'sessionData': sessionData,
      });
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
}
