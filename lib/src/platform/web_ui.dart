import 'dart:convert';

import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:adyen_web_flutter/adyen_web_flutter.dart';
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
    return SizedBox(
      child: AdyenWebView(
        clientKey: configuration.clientKey,
        sessionId: configuration.sessionId,
        sessionData: configuration.sessionData,
        env: configuration.env,
        redirectURL: configuration.redirectURL,
        onPaymentFailed: () {},
        onPaymentDone: (result) {
          onPaymentResult(
            PaymentSessionFinished(
              resultCode:
                  ResultCode.values.firstWhereOrNull(
                    (e) => e.name == result["resultCode"],
                  ) ??
                  ResultCode.unknown,
              sessionId: result["sessionId"],
              sessionData: configuration.sessionData,
              sessionResult: result['sessionResult'],
            ),
          );
        },
        onStarted: () {},
        onPayment: (Map<String, dynamic> data) async {
          return json.encode({"resultCode": "1"});
        },
        onPaymentDetail: (Map<String, dynamic> data) async {
          return json.encode({"resultCode": "1"});
        },
      ),
    );
  }
}
