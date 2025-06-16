import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_client_api/adyen_client_api.dart';
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:adyen_in_pay/src/platform/stub.dart'
    if (dart.library.io) 'package:adyen_in_pay/src/platform/mobile.dart'
    if (dart.library.js_interop) 'package:adyen_in_pay/src/platform/web_ui.dart';

class AdyenPayWidget extends StatefulWidget {
  final int amount;
  final String reference;
  final AdyenConfiguration configuration;
  final Function(PaymentResult payment) onPaymentResult;
  final Widget Function(Object error)? onErrorSessionPreparationWidget;

  const AdyenPayWidget({
    super.key,
    required this.amount,
    required this.reference,
    required this.configuration,
    required this.onPaymentResult,
    this.onErrorSessionPreparationWidget,
  });

  @override
  State<StatefulWidget> createState() => _AdyenPayState();
}

class _AdyenPayState extends State<AdyenPayWidget> {
  late Future<SessionCheckout> futureSession;
  InstantComponentConfiguration? cardComponentConfig;
  DropInConfiguration? dropInConfig;
  late final AdyenClient client = AdyenClient(baseUrl: 'widget.configuration.adyenAPI');
  @override
  void initState() {
    super.initState();
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
    final response = await startSession();
    if (kIsWeb) {
      final paymentMethods = await client.getPaymentMethods();
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
      clientKey: widget.configuration.clientKey,
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
          amount: widget.amount,
          configuration: PayConfiguration(
            clientKey: widget.configuration.clientKey,
            sessionId: snapshot.data!.id,
            sessionData: snapshot.data!.sessionData,
            env: widget.configuration.env,
            redirectURL: widget.configuration.redirectURL,
            acceptOnlyCard: widget.configuration.acceptOnlyCard,
          ),
          paymentMethods: snapshot.data!.paymentMethods,
          onPaymentResult: widget.onPaymentResult,
        );
      },
    );
  }
}
