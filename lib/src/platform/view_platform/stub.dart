import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:payment_client_api/payment_client_api.dart' show AdyenClient;
import 'package:adyen_in_pay/src/models/pay_configuration.dart';
import 'package:adyen_in_pay/src/models/shopper.dart'
    show ShopperPaymentInformation;
import 'package:flutter/widgets.dart';

class PayWidget extends StatelessWidget {
  final int amount;
  final PayConfiguration configuration;
  final Map<String, dynamic> paymentMethods;
  final Function(PaymentResult payment) onPaymentResult;
  final ShopperPaymentInformation shopperPaymentInformation;
  final Size? sizeWeb;
  final AdyenClient client;
  const PayWidget({
    super.key,
    required this.amount,
    required this.configuration,
    required this.paymentMethods,
    required this.onPaymentResult,
    required this.shopperPaymentInformation,
    this.sizeWeb,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
