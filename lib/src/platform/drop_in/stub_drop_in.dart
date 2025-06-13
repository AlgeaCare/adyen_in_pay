import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/models/shopper.dart' show ShopperPaymentInformation;
import 'package:flutter/material.dart' show BuildContext, Widget;

void dropIn({
  required BuildContext context,
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required ShopperPaymentInformation shopperPaymentInformation,
  required Function(PaymentResult payment) onPaymentResult,
  required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  String? webURL,
}) => UnimplementedError();
