import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_client_api/adyen_client_api.dart' show AdyenClient;
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:adyen_in_pay/src/models/shopper.dart' show ShopperPaymentInformation;
import 'package:flutter/material.dart';

class PayWidget extends StatelessWidget {
  final int amount;
  final PayConfiguration configuration;
  final Map<String, dynamic> paymentMethods;
  final Function(PaymentResult payment) onPaymentResult;
  final ShopperPaymentInformation shopperPaymentInformation;
  final Size? sizeWeb;
  final AdyenClient client;
  const PayWidget({
    super.key,
    required this.amount,
    required this.configuration,
    required this.paymentMethods,
    required this.onPaymentResult,
    required this.shopperPaymentInformation,
    this.sizeWeb,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    final paymentM = _extractPaymentMethod(paymentMethods);
    return AdyenCardComponent(
      checkout: SessionCheckout(
        id: configuration.sessionId,
        sessionData: configuration.sessionData,
        paymentMethods: paymentM,
      ),
      configuration: CardComponentConfiguration(
        clientKey: configuration.clientKey,
        amount: Amount(value: amount, currency: 'EUR'),
        environment:
            configuration.env == 'test' ? Environment.test : Environment.europe,
        countryCode: 'DE',
      ),
      paymentMethod: paymentM,
      onPaymentResult: (paymentResult) async {
        if (paymentResult is PaymentSessionFinished) {
          debugPrint(paymentResult.resultCode.name);
        } else {
          debugPrint(paymentResult.toString());
        }
        onPaymentResult(paymentResult);
      },
    );
  }
}

Map<String, dynamic> _extractPaymentMethod(
  Map<String, dynamic> paymentMethods,
) {
  if (paymentMethods.isEmpty) {
    return <String, String>{};
  }

  // List paymentMethodList = paymentMethods["paymentMethods"] as List;
  Map<String, dynamic> paymentMethod =
      (paymentMethods['paymentMethods'] as List).first as Map<String, dynamic>;
  // paymentMethodList.firstWhereOrNull(
  //         (paymentMethod) => paymentMethod["type"] == "scheme")
  //      ??
  // <String, String>{};

  return paymentMethod;
}
