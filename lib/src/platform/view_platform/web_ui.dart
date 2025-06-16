import 'dart:convert';

import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:payment_client_api/payment_client_api.dart' show AdyenClient;
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:adyen_in_pay/src/models/shopper.dart';
import 'package:adyen_web_flutter/adyen_web_flutter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PayWidget extends StatelessWidget {
  final int amount;
  final PayConfiguration configuration;
  final Map<String, dynamic> paymentMethods;
  final Function(PaymentResult payment) onPaymentResult;
  final Size? sizeWeb;
  final ShopperPaymentInformation shopperPaymentInformation;
  final AdyenClient client;
  const PayWidget({
    super.key,
    required this.amount,
    required this.configuration,
    required this.paymentMethods,
    required this.onPaymentResult,
    this.sizeWeb = const Size(400, 400),
    required this.shopperPaymentInformation,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    return AdyenWebView(
      configuration: WebConfiguration(
        configurationType: WebConfigurationTypeSession(
          clientKey: configuration.clientKey,
          sessionId: configuration.sessionId,
          sessionData: configuration.sessionData,
          amount: amount,
          currency: 'EUR',
          env: configuration.env,
          redirectURL: configuration.redirectURL,
        ),
        callbacks: WebCallbackConfiguration(
          onPaymentFailed: () {},
          onPaymentDone: (result) {
            onPaymentResult(
              PaymentSessionFinished(
                resultCode:
                    ResultCode.values.firstWhereOrNull((e) => e.name == result["resultCode"]) ??
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
            final bodyPayment = <String, dynamic>{
              'paymentMethod': data['result']['paymentMethod'],
              'amount': {'value': amount, 'currency': 'EUR'},
              'reference': shopperPaymentInformation.invoiceId,
              'channel': 'web',
              'returnUrl': configuration.redirectURL,
            };
            final paymentInformation = await client.paymentInformation(
              invoiceId: shopperPaymentInformation.invoiceId,
            );
            final response = await client.makePayment(paymentInformation, bodyPayment);
            return json.encode(response.toJson());
          },
          onPaymentDetail: (Map<String, dynamic> data) async {
            final response = await client.makeDetailPayment(data);
            return json.encode(response.toJson());
          },
        ),
      ),
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
  final Size? sizeWeb;
  final ShopperPaymentInformation shopperPaymentInformation;
  const DropInWebWidget({
    super.key,
    required this.client,
    required this.amount,
    required this.reference,
    required this.configuration,
    required this.onPaymentResult,
    required this.shopperPaymentInformation,
    this.widgetChildCloseForWeb,
    this.acceptOnlyCard = false,
    this.sizeWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: sizeWeb?.height ?? 600,
          child: Align(
            alignment: Alignment.topCenter,
            child: AdyenWebView(
              configuration: WebConfiguration(
                configurationType: WebConfigurationTypeAdvanced(
                  clientKey: configuration.clientKey,
                  amount: amount,
                  currency: 'EUR',
                  env: configuration.env,
                  redirectURL: configuration.redirectURL,
                ),
                sizeWeb: sizeWeb,
                callbacks: WebCallbackConfiguration(
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
                    try {
                      final bodyPayment = <String, dynamic>{
                        'paymentMethod': paymentData['result']['paymentMethod'],
                        'amount': {'value': amount, 'currency': 'EUR'},
                        'reference': reference,
                        'channel': 'web',
                        'returnUrl': configuration.redirectURL,
                      };
                      final paymentInformation = await client.paymentInformation(
                        invoiceId: reference,
                      );
                      final response = await client.makePayment(
                        paymentInformation,
                        bodyPayment,
                        billingAddress: shopperPaymentInformation.billingAddress,
                        countryCode: shopperPaymentInformation.countryCode,
                        shopperLocale: shopperPaymentInformation.locale,
                        telephoneNumber: shopperPaymentInformation.telephoneNumber,
                      );
                      return json.encode(response.toJson());
                    } catch (e) {
                      debugPrint(e.toString());
                      return json.encode({});
                    }
                  },
                  onPaymentDetail: (paymentDetail) async {
                    try {
                      final response = await client.makeDetailPayment(paymentDetail);
                      return json.encode(response.toJson());
                    } catch (e) {
                      debugPrint(e.toString());
                      return json.encode({});
                    }
                  },
                  onPaymentMethod: () async {
                    final response = await client.getPaymentMethods();
                    final payMethod = acceptOnlyCard ? response.onlyCards() : response.toJson();
                    return json.encode(payMethod);
                  },
                  cardBrands: () async {
                    final response = await client.getPaymentMethods();
                    return response.onlyCardBrands();
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 12,
          child: PointerInterceptor(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  AdyenWebView.of(context)?.unmount();
                  Navigator.pop(context);
                },
                behavior: HitTestBehavior.translucent,
                child:
                    widgetChildCloseForWeb ??
                    SizedBox.square(
                      dimension: 48,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(
                            side: BorderSide(color: Colors.grey.shade100, width: 0.5),
                          ),
                          color: Colors.transparent,
                        ),
                        child: const Icon(Icons.close, size: 24, color: Colors.white),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
