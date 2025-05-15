import 'dart:convert';

import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:adyen_web_flutter/adyen_web_flutter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
    return AdyenWebView(
      clientKey: configuration.clientKey,
      sessionId: configuration.sessionId,
      sessionData: configuration.sessionData,
      amount: amount,
      currency: 'EUR',
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
      onPaymentMethod: () async {
        debugPrint("paymentMethods: ${json.encode(paymentMethods)}");
        return json.encode(paymentMethods);
      },
      cardBrands: () async {
        final brands =
            (paymentMethods["paymentMethods"] as List<Map<String, dynamic>>)
                .where((item) => item['type'] == 'scheme')
                .map((entry) => entry['brand'])
                .toList()
                .whereType<String>()
                .toList();
        debugPrint(brands.toString());
        return brands;
      },
      onPayment: (Map<String, dynamic> data) async {
        return json.encode({"resultCode": "1"});
      },
      onPaymentDetail: (Map<String, dynamic> data) async {
        return json.encode({"resultCode": "1"});
      },
    );
  }
}

class DropInWebWidget extends StatelessWidget {
  final AdyenClient client;
  final int amount;
  final String reference;
  final AdyenConfiguration configuration;
  final Function(PaymentResult payment) onPaymentResult;
  final Widget? widgetChildCloseForWeb;
  final bool acceptOnlyCard;
  const DropInWebWidget({
    super.key,
    required this.client,
    required this.amount,
    required this.reference,
    required this.configuration,
    required this.onPaymentResult,
    this.widgetChildCloseForWeb,
    this.acceptOnlyCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: AdyenWebView.advancedFlow(
            clientKey: configuration.clientKey,
            amount: amount,
            currency: 'EUR',
            env: configuration.env,
            redirectURL: configuration.redirectURL,
            onStarted: () {},
            onPaymentDone: (result) {
              onPaymentResult(
                PaymentAdvancedFinished(
                  resultCode:
                      ResultCode.values.firstWhereOrNull(
                        (e) => e.name == result['resultCode'],
                      ) ??
                      ResultCode.unknown,
                ),
              );
            },
            onPaymentFailed: () {
              onPaymentResult(PaymentError(reason: 'Payment failed'));
            },
            onPayment: (paymentData) async {
              final bodyPayment = <String, dynamic>{
                'paymentMethod': paymentData['result']['paymentMethod'],
                'amount': {'value': amount, 'currency': 'EUR'},
                'reference': reference,
                'channel': 'web',
                'returnUrl': configuration.redirectURL,
              };
              final response = await client.makePayment(bodyPayment);
              return json.encode(response.toJson());
            },
            onPaymentDetail: (paymentDetail) async {
              final response = await client.makeDetailPayment(paymentDetail);
              return json.encode(response.toJson());
            },
            onPaymentMethod: () async {
              final response = await client.getPaymentMethods();
              final payMethod =
                  acceptOnlyCard ? response.onlyCards() : response.toJson();
              return json.encode(payMethod);
            },
            cardBrands: () async {
              final response = await client.getPaymentMethods();
              return response.onlyCardBrands();
            },
          ),
        ),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: PointerInterceptor(
            child: GestureDetector(
              onTap: () {
                AdyenWebView.of(context)?.unmount();
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.translucent,
              child: widgetChildCloseForWeb ?? const Text('Close'),
            ),
          ),
        ),
      ],
    );
  }
}
