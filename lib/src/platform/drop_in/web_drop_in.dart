import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/utils/commons.dart' show resultCodeFromString;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:local_storage_web/local_storage_web.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  bool ignoreGooglePay = false,
  String? webURL,
  CustomPaymentConfigurationWidget? customPaymentConfigurationWidget,
}) {
  if (webURL == null || webURL.isEmpty) {
    throw Exception('webURL should not be empty or null');
  }
  dropInAdvancedWeb(
    context: context,
    client: client,
    reference: reference,
    configuration: configuration,
    onPaymentResult: onPaymentResult,
    widgetChildCloseForWeb: widgetChildCloseForWeb,
    shopperPaymentInformation: shopperPaymentInformation,
    acceptOnlyCard: acceptOnlyCard,
    webURL: webURL,
    paymentInformation: paymentInformation,
  );
}

Future<void> dropInAdvancedWeb({
  required BuildContext context,
  required AdyenClient client,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  required ShopperPaymentInformation shopperPaymentInformation,
  PaymentInformation? paymentInformation,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  required String webURL,
}) async {
  platformListenToState('pay-$reference-result', (Map input) {
    onPaymentResult(PaymentAdvancedFinished(resultCode: resultCodeFromString(input['resultCode'])));
  });
  await launchUrl(
    Uri.parse(webURL),
    mode: LaunchMode.externalApplication,
    browserConfiguration: const BrowserConfiguration(showTitle: true),
    webOnlyWindowName: defaultTargetPlatform == TargetPlatform.iOS ? '_self' : null,
  );
  // return showDialog(
  //   context: context,
  //   builder: (context) {
  //     return SizedBox(
  //       width: MediaQuery.sizeOf(context).width,
  //       height: MediaQuery.sizeOf(context).height,
  //       child: DropInWebWidget(
  //         client: client,
  //         amount: amount,
  //         reference: reference,
  //         configuration: configuration,
  //         onPaymentResult: onPaymentResult,
  //         acceptOnlyCard: acceptOnlyCard,
  //         widgetChildCloseForWeb: widgetChildCloseForWeb,
  //         sizeWeb: sizeWeb,
  //       ),
  //     );
  //   },
  // );
}

Future<void> closeAdyenDropIn() async {}
