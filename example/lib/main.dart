import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:adyen_in_pay/adyen_in_pay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? paymentStatus;
  var amout = Random().nextInt(100) * 1000;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adyen integration app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (paymentStatus != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      paymentStatus!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          paymentStatus = null;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            amout = Random().nextInt(100) * 1000;
                          });
                        });
                      },
                      child: const Text('Start New Payment'),
                    ),
                  ],
                ),
              ),
            Center(
              child: AdyenPayWidget(
                amount: amout,
                reference: "2222",
                configuration: AdyenConfiguration(
                  clientKey: "test_4ZDD22772FAUDI4BURXBGDXOCY5AO53R",
                  adyenAPI: "http://localhost:3001",
                  env: 'test',
                  redirectURL:
                      '${kIsWeb || kIsWasm ? 'https://app.staging.bloomwell.de' : 'adyenExample://com.example.adyenExample'}/checkout?shopperOrder=2222',
                ),
                onPaymentResult: (PaymentResult payment) {
                  setState(() {
                    switch (payment) {
                      case PaymentAdvancedFinished():
                        paymentStatus = "Payment completed successfully";
                      case PaymentSessionFinished():
                        paymentStatus = "Payment session finished";
                      case PaymentCancelledByUser():
                        paymentStatus = "Payment cancelled by user";
                      case PaymentError():
                        paymentStatus = "Payment error occurred";
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
