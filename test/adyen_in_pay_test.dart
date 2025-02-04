import 'package:flutter_test/flutter_test.dart';
import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/adyen_in_pay_platform_interface.dart';
import 'package:adyen_in_pay/adyen_in_pay_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdyenInPayPlatform
    with MockPlatformInterfaceMixin
    implements AdyenInPayPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AdyenInPayPlatform initialPlatform = AdyenInPayPlatform.instance;

  test('$MethodChannelAdyenInPay is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdyenInPay>());
  });

  test('getPlatformVersion', () async {
    AdyenInPay adyenInPayPlugin = AdyenInPay();
    MockAdyenInPayPlatform fakePlatform = MockAdyenInPayPlatform();
    AdyenInPayPlatform.instance = fakePlatform;

    expect(await adyenInPayPlugin.getPlatformVersion(), '42');
  });
}
