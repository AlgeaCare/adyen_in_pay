import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DropInWidget extends StatefulWidget {
  const DropInWidget({super.key});

  @override
  State<DropInWidget> createState() => _DropInWidgetState();
}

class _DropInWidgetState extends State<DropInWidget> {
  final amount = 10000;
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
              amount: amount,
              reference: '2222',
              acceptOnlyCard: true,
              configuration: AdyenConfiguration(
                clientKey: "test_4ZDD22772FAUDI4BURXBGDXOCY5AO53R",
                adyenAPI: "http://192.168.178.26:3000",
                env: 'test',
                redirectURL:
                    '${kIsWeb || kIsWasm ? 'https://app.staging.bloomwell.de/checkout?shopperOrder=2222' : 'adyenExample://com.example.adyenExample'}/checkout?shopperOrder=2222',
              ),
              onPaymentResult: (payment) {
                switch (payment) {
                  case PaymentAdvancedFinished():
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 64,
                          ),
                          title: const Text('Payment successful'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    break;
                  case PaymentSessionFinished():
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 64,
                          ),
                          title: const Text('Payment successful'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    break;
                  case PaymentCancelledByUser():
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: const Icon(
                            Icons.error,
                            color: Colors.orangeAccent,
                            size: 56,
                          ),
                          title: const Text('Payment cancelled'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    break;
                  case PaymentError():
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 56,
                          ),
                          title: const Text('Payment Failed'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    break;
                }
              },
            );
          },
          child: Text('Pay now ${amount / 100}€'),
        ),
      ),
    );
  }
}
