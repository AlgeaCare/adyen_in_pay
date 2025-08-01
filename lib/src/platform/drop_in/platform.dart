import 'package:adyen_checkout/adyen_checkout.dart' show PaymentResult;
import 'package:payment_client_api/payment_client_api.dart'
    show AdyenClient, PaymentInformation;
import 'package:adyen_in_pay/src/models/configuration_status.dart';
import 'package:adyen_in_pay/src/models/pay_configuration.dart'
    show AdyenConfiguration;
import 'package:adyen_in_pay/src/models/shopper.dart'
    show ShopperPaymentInformation;
import 'package:flutter/material.dart' show BuildContext, Widget;
import 'stub_drop_in.dart'
    if (dart.library.io) 'mobile_drop_in.dart'
    if (dart.library.js_interop) 'web_drop_in.dart';

void dropInPlatform({
  required BuildContext context,
  required AdyenClient client,
  required String reference,
  required AdyenConfiguration configuration,
  required ShopperPaymentInformation shopperPaymentInformation,
  required Function(PaymentResult payment) onPaymentResult,
  required Function(ConfigurationStatus configurationStatus)
  onConfigurationStatus,
  PaymentInformation? paymentInformation,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  bool ignoreGooglePay = false,
  String? webURL,
  Widget Function(String url, Function()? onRetry)? topTitleBottomSheetWidget,
}) => dropIn(
  context: context,
  client: client,
  reference: reference,
  configuration: configuration,
  onPaymentResult: onPaymentResult,
  widgetChildCloseForWeb: widgetChildCloseForWeb,
  acceptOnlyCard: acceptOnlyCard,
  ignoreGooglePay: ignoreGooglePay,
  webURL: webURL,
  shopperPaymentInformation: shopperPaymentInformation,
  onConfigurationStatus: onConfigurationStatus,
  paymentInformation: paymentInformation,
  topTitleBottomSheetWidget: topTitleBottomSheetWidget,
);
