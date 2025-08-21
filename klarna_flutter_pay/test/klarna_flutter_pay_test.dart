import 'package:flutter_test/flutter_test.dart';
import 'package:klarna_flutter_pay/src/interface/klarna_flutter_pay_platform_interface.dart';
import 'package:klarna_flutter_pay/src/channel/klarna_flutter_pay_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKlarnaFlutterPayPlatform
    with MockPlatformInterfaceMixin
    implements KlarnaFlutterPayPlatform {
  @override
  Future<bool> initializePayment({
    required String clientToken,
    required String returnURL,
    String environment = 'staging',
    String region = 'EU',
    String loggingLevel = 'verbose',
    Map<String, dynamic>? additionalArgs,
  }) => Future.value(true);

  @override
  Future<bool> pay() => Future.value(true);

  @override
  Future<bool> authorize({bool autoFinalize = true, String? sessionData}) => Future.value(true);

  @override
  Future<bool> finalize({String? sessionData}) => Future.value(true);

  @override
  String get channelName => 'de.bloomwell/klarna_pay';
}

void main() {
  final KlarnaFlutterPayPlatform initialPlatform = KlarnaFlutterPayPlatform.instance;

  test('$MethodChannelKlarnaFlutterPay is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKlarnaFlutterPay>());
  });
}
