import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PayWidget extends StatelessWidget {
  final int amount;
  final PayConfiguration configuration;

  final Map<String, dynamic> paymentMethods;
  final Function(PaymentResult payment) onPaymentResult;
  const PayWidget({
    super.key,
    required this.amount,
    required this.configuration,
    required this.paymentMethods,
    required this.onPaymentResult,
  });

  @override
  Widget build(BuildContext context) {
    final paymentM = _extractPaymentMethod(
      paymentMethods,
    );
    return AdyenCardComponent(
      checkout: SessionCheckout(
        id: configuration.sessionId,
        sessionData: configuration.sessionData,
        paymentMethods: paymentM,
      ),
      configuration: CardComponentConfiguration(
        clientKey: configuration.clientKey,
        amount: Amount(
          value: amount,
          currency: 'EUR',
        ),
        environment:
            configuration.env == 'test' ? Environment.test : Environment.europe,
        countryCode: 'DE',
      ),
      paymentMethod: paymentM,
      onPaymentResult: (paymentResult) async {
        if (paymentResult is PaymentSessionFinished) {
          debugPrint(paymentResult.resultCode.name);
        }
        onPaymentResult(paymentResult);
      },
    );
  }
}

Map<String, dynamic> _extractPaymentMethod(
    Map<String, dynamic> paymentMethods) {
  if (paymentMethods.isEmpty) {
    return <String, String>{};
  }

  List paymentMethodList = paymentMethods["paymentMethods"] as List;
  Map<String, dynamic> paymentMethod = paymentMethodList.firstWhereOrNull(
          (paymentMethod) => paymentMethod["type"] == "scheme") ??
      <String, String>{};

  // List storedPaymentMethodList =
  //     paymentMethods.containsKey("storedPaymentMethods")
  //         ? paymentMethods["storedPaymentMethods"] as List
  //         : [];
  // Map<String, dynamic> storedPaymentMethod =
  //     storedPaymentMethodList.firstOrNull ?? <String, String>{};

  return paymentMethod;
}
