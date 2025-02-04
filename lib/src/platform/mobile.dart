import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:flutter/material.dart';

class PayWidget extends StatelessWidget {
  const PayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AdyenCardWidget();
  }
}

class AdyenCardWidget extends StatefulWidget {
  const AdyenCardWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AdyenCardState();
}

class _AdyenCardState extends State<AdyenCardWidget> {
  late Future<SessionCheckout> futureSession;
  late CardComponentConfiguration cardConfig;
  @override
  void initState() {
    super.initState();
    cardConfig = CardComponentConfiguration(
      clientKey: "",
      environment: Environment.test,
      countryCode: "DE",
      amount: Amount(
        value: 20,
        currency: "EUR",
      ),
    );
    futureSession = AdyenCheckout.session.create(
      sessionId: "",
      configuration: cardConfig,
      sessionData: "",
    );
  }

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
                    futureSession = AdyenCheckout.session.create(
                      sessionId: "",
                      configuration: cardConfig,
                      sessionData: "",
                    );
                  });
                },
                child: const Text("reload"),
              )
            ],
          );
        }
        return AdyenCardComponent(
          checkout: snapshot.data!,
          configuration: cardConfig,
          paymentMethod: snapshot.data!.paymentMethods,
          onPaymentResult: (paymentResult) async {},
        );
      },
    );
  }
}
