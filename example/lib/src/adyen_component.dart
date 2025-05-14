import 'dart:math';

import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay_example/src/commons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyAdyenComponentApp extends StatefulWidget {
  const MyAdyenComponentApp({super.key});

  @override
  State<MyAdyenComponentApp> createState() => _MyAdyenComponentAppState();
}

class _MyAdyenComponentAppState extends State<MyAdyenComponentApp> {
  String? paymentStatus;
  var amount = Random().nextInt(100) * 1000;
  bool isError = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (paymentStatus != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      paymentStatus!.contains('error') ||
                              paymentStatus!.contains('cancelled') ||
                              paymentStatus!.contains('failed')
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      color: paymentStatus!.contains('error') ||
                              paymentStatus!.contains('cancelled') ||
                              paymentStatus!.contains('failed')
                          ? Colors.red
                          : Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        paymentStatus!,
                        style: TextStyle(
                          fontSize: 16,
                          color: paymentStatus!.contains('error') ||
                                  paymentStatus!.contains('cancelled') ||
                                  paymentStatus!.contains('failed')
                              ? Colors.red
                              : Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    isError = false;
                    setState(() {
                      paymentStatus = null;
                    });
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        amount = Random().nextInt(100) * 1000;
                      });
                    });
                  },
                  child: const Text('Start New Payment'),
                ),
              ],
            ),
          ),
        if (!isError) ...[
          Center(
            child: AdyenPayWidget(
              amount: amount * 100,
              reference: generateRandomString(10),
              configuration: AdyenConfiguration(
                clientKey: "test_4ZDD22772FAUDI4BURXBGDXOCY5AO53R",
                adyenAPI: "http://localhost:3001",
                env: 'test',
                redirectURL:
                    '${kIsWeb || kIsWasm ? 'https://app.staging.bloomwell.de/checkout?shopperOrder=2222' : 'adyenExample://com.example.adyenExample'}/checkout?shopperOrder=2222',
              ),
              onPaymentResult: (PaymentResult payment) {
                setState(() {
                  switch (payment) {
                    case PaymentAdvancedFinished():
                      paymentStatus =
                          "Your payment has been completed successfully!";
                    case PaymentSessionFinished():
                      if (payment.resultCode == ResultCode.authorised ||
                          payment.resultCode == ResultCode.received) {
                        paymentStatus =
                            "Payment session completed successfully!";
                      } else {
                        paymentStatus =
                            "Payment session failed: ${payment.resultCode.name}";
                        isError = true;
                      }
                    case PaymentCancelledByUser():
                      paymentStatus = "Payment was cancelled";
                      isError = true;
                    case PaymentError():
                      paymentStatus =
                          "An error occurred during payment processing";
                      isError = true;
                  }
                });
              },
            ),
          ),
        ]
      ],
    );
  }
}
