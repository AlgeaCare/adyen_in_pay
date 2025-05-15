import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/platform/web_ui.dart';
import 'package:flutter/material.dart' show BuildContext, Widget,showDialog;

void dropIn({
  required BuildContext context,
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
}) => dropInAdvancedWeb(
  context: context,
  client: client,
  amount: amount,
  reference: reference,
  configuration: configuration,
  onPaymentResult: onPaymentResult,
  widgetChildCloseForWeb: widgetChildCloseForWeb,
  acceptOnlyCard: acceptOnlyCard,
);

Future<void> dropInAdvancedWeb({
  required BuildContext context,
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return DropInWebWidget(
        client: client,
        amount: amount,
        reference: reference,
        configuration: configuration,
        onPaymentResult: onPaymentResult,
        acceptOnlyCard: acceptOnlyCard,
        widgetChildCloseForWeb: widgetChildCloseForWeb,
      );
    },
  );
}
