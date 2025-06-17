import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/platform/drop_in/platform.dart';
import 'package:flutter/material.dart' show BuildContext, Widget;

class DropInPlatform {
  static String? _paymentData;
  static Future<void> dropInAdvancedFlowPlatform({
    required BuildContext context,
    required AdyenClient client,
    required String reference,
    required AdyenConfiguration configuration,
    required ShopperPaymentInformation shopperPaymentInformation,
    required Function(PaymentResult payment) onPaymentResult,
    required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,
    Widget? widgetChildCloseForWeb,
    bool acceptOnlyCard = false,
    String? webURL,
  }) async => dropInPlatform(
    context: context,
    client: client,
    reference: reference,
    configuration: configuration,
    onPaymentResult: onPaymentResult,
    onConfigurationStatus: onConfigurationStatus,
    acceptOnlyCard: acceptOnlyCard,
    shopperPaymentInformation: shopperPaymentInformation,
    widgetChildCloseForWeb: widgetChildCloseForWeb,
    webURL: webURL,
  );
}

String? get paymentData => DropInPlatform._paymentData;

void setPaymentData(String? value) {
  DropInPlatform._paymentData = value;
}
