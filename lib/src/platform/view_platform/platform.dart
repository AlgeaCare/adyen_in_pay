import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_in_pay/src/models/adyen_keys_configuration.dart' show AdyenKeysConfiguration;
import 'package:payment_client_api/payment_client_api.dart';
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:adyen_in_pay/src/models/shopper.dart' show ShopperPaymentInformation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

import 'stub.dart' if (dart.library.io) 'mobile.dart' if (dart.library.js_interop) 'web_ui.dart';

class AdyenPayWidget extends StatefulWidget {
  final int amount;
  final String reference;
  final AdyenConfiguration configuration;
  final Function(PaymentResult payment) onPaymentResult;
  final Widget Function(Object error)? onErrorSessionPreparationWidget;
  final ShopperPaymentInformation shopperPaymentInformation;
  final AdyenClient client;
  const AdyenPayWidget({
    super.key,
    required this.amount,
    required this.reference,
    required this.configuration,
    required this.onPaymentResult,
    required this.shopperPaymentInformation,
    this.onErrorSessionPreparationWidget,
    required this.client,
  });

  @override
  State<StatefulWidget> createState() => _AdyenPayState();
}

class _AdyenPayState extends State<AdyenPayWidget> {
  late Future<SessionCheckout> futureSession;
  InstantComponentConfiguration? cardComponentConfig;
  DropInConfiguration? dropInConfig;
  late final ValueNotifier<AdyenKeysConfiguration?> adyenKeysConfiguration;
  @override
  void initState() {
    super.initState();
    adyenKeysConfiguration = ValueNotifier(null);
    futureSession = generateSession();
  }

  @override
  void didUpdateWidget(covariant AdyenPayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amount != oldWidget.amount ||
        widget.reference != oldWidget.reference ||
        widget.configuration != oldWidget.configuration) {
      setState(() {
        futureSession = generateSession();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<SessionResponse?> startSession() async => null;
  Future<SessionCheckout> generateSession() => Future.microtask(() async {
    adyenKeysConfiguration.value = widget.configuration.adyenKeysConfiguration;
    final response = await startSession();
    final userAgentStr = await userAgent();
    if (kIsWeb) {
      final paymentMethods = await widget.client.getPaymentMethods(
        data: {
          'invoiceId': widget.reference,
          'browserInfo': {
            'acceptHeader':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
            'userAgentHeader': userAgentStr,
          },
          'channel': 'web',
          'shopperLocale': widget.shopperPaymentInformation.locale,
        },
      );
      return SessionCheckout(
        id: response!.id,
        paymentMethods:
            widget.configuration.acceptOnlyCard
                ? paymentMethods.onlyCards()
                : paymentMethods.toAllMap(),
        sessionData: response.sessionData,
      );
    }
    cardComponentConfig = InstantComponentConfiguration(
      clientKey: adyenKeysConfiguration.value!.clientKey,
      amount: Amount(value: widget.amount, currency: 'EUR'),
      environment: widget.configuration.env == 'test' ? Environment.test : Environment.europe,
      countryCode: 'DE',
    );
    return AdyenCheckout.session.create(
      sessionId: response!.id,
      configuration: cardComponentConfig!,
      sessionData: response.sessionData,
    );
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SessionCheckout>(
      future: futureSession,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return widget.onErrorSessionPreparationWidget != null
              ? widget.onErrorSessionPreparationWidget!(snapshot.error!)
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("error to load checkout form"),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureSession = Future.microtask(() async {
                          final response = await startSession();
                          return AdyenCheckout.session.create(
                            sessionId: response!.id,
                            configuration: cardComponentConfig!,
                            sessionData: response.sessionData,
                          );
                        });
                      });
                    },
                    child: const Text("reload"),
                  ),
                ],
              );
        }
        return PayWidget(
          client: widget.client,
          amount: widget.amount,
          configuration: PayConfiguration(
            clientKey: adyenKeysConfiguration.value!.clientKey,
            sessionId: snapshot.data!.id,
            sessionData: snapshot.data!.sessionData,
            env: widget.configuration.env,
            redirectURL: widget.configuration.redirectURL,
            acceptOnlyCard: widget.configuration.acceptOnlyCard,
          ),
          paymentMethods: snapshot.data!.paymentMethods,
          onPaymentResult: widget.onPaymentResult,
          shopperPaymentInformation: widget.shopperPaymentInformation,
        );
      },
    );
  }
}
