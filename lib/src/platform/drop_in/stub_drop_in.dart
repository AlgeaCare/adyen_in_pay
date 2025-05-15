import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:flutter/material.dart' show BuildContext, Widget,Size;

void dropIn({
  required BuildContext context,
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  Size? sizeWeb,
}) => UnimplementedError();
