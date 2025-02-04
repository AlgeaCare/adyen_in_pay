import 'package:flutter/material.dart';

class PayWidget extends StatelessWidget {
  const PayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(
      viewType: "AdyenPay",
    );
  }
}
