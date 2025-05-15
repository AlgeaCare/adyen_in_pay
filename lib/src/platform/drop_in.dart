import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/platform/drop_in/platform.dart';
import 'package:flutter/material.dart' show BuildContext, Widget;

class DropInPlatform {
  static String? _paymentData;
  static Future<void> dropInAdvancedFlowPlatform({
    required BuildContext context,
    required AdyenClient client,
    required int amount,
    required String reference,
    required AdyenConfiguration configuration,
    required Function(PaymentResult payment) onPaymentResult,
    Widget? widgetChildCloseForWeb,
    bool acceptOnlyCard = false,
  }) async => dropInPlatform(
    context: context,
    client: client,
    amount: amount,
    reference: reference,
    configuration: configuration,
    onPaymentResult: onPaymentResult,
    acceptOnlyCard: acceptOnlyCard,
    widgetChildCloseForWeb: widgetChildCloseForWeb,
  );
}

String? get paymentData => DropInPlatform._paymentData;

void setPaymentData(String? value) {
  DropInPlatform._paymentData = value;
}
