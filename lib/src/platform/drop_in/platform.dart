import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:flutter/material.dart' show BuildContext, Widget;
import 'stub_drop_in.dart'
    if (dart.library.io) 'mobile_drop_in.dart'
    if (dart.library.js_interop) 'web_drop_in.dart';

void dropInPlatform({
  required BuildContext context,
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
}) => dropIn(
  context: context,
  client: client,
  amount: amount,
  reference: reference,
  configuration: configuration,
  onPaymentResult: onPaymentResult,
  widgetChildCloseForWeb: widgetChildCloseForWeb,
  acceptOnlyCard: acceptOnlyCard,
);
