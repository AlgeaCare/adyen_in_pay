import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/models/shopper.dart' show ShopperPaymentInformation;
import 'package:flutter/widgets.dart';
import 'package:local_storage_web/local_storage_web.dart';
import 'package:url_launcher/url_launcher.dart';

void dropIn({
  required BuildContext context,
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required ShopperPaymentInformation shopperPaymentInformation,
  required Function(PaymentResult payment) onPaymentResult,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  String? webURL,
}) {
  if (webURL == null || webURL.isEmpty) {
    throw Exception('webURL should not be empty or null');
  }
  dropInAdvancedWeb(
    context: context,
    client: client,
    amount: amount,
    reference: reference,
    configuration: configuration,
    onPaymentResult: onPaymentResult,
    widgetChildCloseForWeb: widgetChildCloseForWeb,
    acceptOnlyCard: acceptOnlyCard,
    webURL: webURL,
  );
}

Future<void> dropInAdvancedWeb({
  required BuildContext context,
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  required String webURL,
}) async {
  platformListenToState('pay-$reference-result', (Map input) {
    onPaymentResult(
      PaymentAdvancedFinished(resultCode: ResultCode.fromString(input['resultCode'])),
    );
  });
  await launchUrl(Uri.parse('https://payments.dev.bloomwell.de/pay/$reference'));
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
