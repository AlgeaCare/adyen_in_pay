import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DropInWidget extends StatefulWidget {
  const DropInWidget({super.key});

  @override
  State<DropInWidget> createState() => _DropInWidgetState();
}

class _DropInWidgetState extends State<DropInWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            DropInPlatform.dropInAdvanced(
              client: AdyenClient(
                baseUrl: 'http://192.168.178.26:3000',
              ),
              amount: 10000,
              reference: '2222',
              configuration: AdyenConfiguration(
                clientKey: "test_4ZDD22772FAUDI4BURXBGDXOCY5AO53R",
                adyenAPI: "http://192.168.178.26:3000",
                env: 'test',
                redirectURL:
                    '${kIsWeb || kIsWasm ? 'https://app.staging.bloomwell.de/checkout?shopperOrder=2222' : 'adyenExample://com.example.adyenExample'}/checkout?shopperOrder=2222',
              ),
              onPaymentResult: (payment) {},
            );
          },
          child: const Text('Drop-in widget'),
        ),
      ),
    );
  }
}
