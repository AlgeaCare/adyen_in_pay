import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:flutter/material.dart' show BuildContext, Widget;

void dropIn({
  required BuildContext context,
  required AdyenClient client,
  required String reference,
  required AdyenConfiguration configuration,
  required ShopperPaymentInformation shopperPaymentInformation,
  required Function(PaymentResult payment) onPaymentResult,
  required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,
  PaymentMethodResponse Function(PaymentMethodResponse paymentMethods)? skipPaymentMethodCallback,
  PaymentInformation? paymentInformation,
  CustomPaymentConfigurationWidget? customPaymentConfigurationWidget,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  bool ignoreGooglePay = false,
  String? webURL,
}) => UnimplementedError();

Future<void> closeAdyenDropIn() => throw UnimplementedError();
