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
  const AdyenPayWidget({
    super.key,
    required this.amount,
    required this.reference,
    required this.configuration,
    required this.onPaymentResult,
  });

  @override
  State<StatefulWidget> createState() => _AdyenPayState();
}

class _AdyenPayState extends State<AdyenPayWidget> {
  late Future<SessionCheckout> futureSession;
  late InstantComponentConfiguration cardConfig;
  late final AdyenClient client;
  @override
  void initState() {
    super.initState();
    client = AdyenClient(
      baseUrl: widget.configuration.adyenAPI,
    );
    cardConfig = InstantComponentConfiguration(
      clientKey: widget.configuration.clientKey,
      amount: Amount(
        value: widget.amount,
        currency: 'EUR',
      ),
      environment: widget.configuration.env == 'test'
          ? Environment.test
          : Environment.europe,
      countryCode: 'DE',
    );
    futureSession = generateSession();
  }

  @override
  void didUpdateWidget(covariant AdyenPayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amount != oldWidget.amount) {
      setState(() {
        futureSession = generateSession();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<SessionResponse> startSession() async => client.startSession(
        amount: widget.amount,
        reference: widget.reference,
        redirectURL: widget.configuration.redirectURL,
      );
  Future<SessionCheckout> generateSession() => Future.microtask(() async {
        final response = await startSession();
        if (kIsWeb) {
          return SessionCheckout(
            id: response.id,
            paymentMethods: {},
            sessionData: response.sessionData,
          );
        }
        // final dropIn = DropInConfiguration(
        //   clientKey: widget.configuration.clientKey,
        //   amount: Amount(
        //     value: widget.amount,
        //     currency: 'EUR',
        //   ),
        //   environment: widget.configuration.env == 'test'
        //       ? Environment.test
        //       : Environment.europe,
        //   countryCode: 'DE',
        // );
        final session = await AdyenCheckout.session.create(
          sessionId: response.id,
          // configuration: dropIn,
          configuration: cardConfig,

          sessionData: response.sessionData,
        );
        // await AdyenCheckout.session.startDropIn(
        //   dropInConfiguration: dropIn,
        //   checkout: session,
        // );
        return session;
      });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SessionCheckout>(
      future: futureSession,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Column(
            children: [
              const Text("error to load checkout form"),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    futureSession = Future.microtask(() async {
                      final response = await startSession();
                      return AdyenCheckout.session.create(
                        sessionId: response.id,
                        configuration: cardConfig,
                        sessionData: response.sessionData,
                      );
                    });
                  });
                },
                child: const Text("reload"),
              )
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
          ),
          paymentMethods: snapshot.data!.paymentMethods,
          onPaymentResult: widget.onPaymentResult,
        );
      },
    );
  }
}
