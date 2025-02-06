import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:flutter/widgets.dart';

class PayWidget extends StatelessWidget {
  final int amount;
  final PayConfiguration configuration;
  final Map<String, dynamic> paymentMethods;
  final Function(PaymentResult payment) onPaymentResult;
  const PayWidget({
    super.key,
    required this.amount,
    required this.configuration,
    required this.paymentMethods,
    required this.onPaymentResult,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
