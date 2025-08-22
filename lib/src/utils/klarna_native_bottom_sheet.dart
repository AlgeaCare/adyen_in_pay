import 'dart:async';
import 'package:adyen_checkout/adyen_checkout.dart' as adyen show PaymentEvent, Finished, Error;
import 'package:adyen_in_pay/adyen_in_pay.dart' show DetailPaymentResponse, PaymentResultCode;
import 'package:adyen_in_pay/src/models/klarna_native_configuration.dart'
    show KlarnaNativeConfiguration;
import 'package:flutter/material.dart';
import 'package:klarna_flutter_pay/klarna_flutter_pay.dart';

Future<adyen.PaymentEvent> showKlarnaBottomSheet({
  required BuildContext context,
  required KlarnaNativeConfiguration klarnaNativeConfiguration,
  required Future<DetailPaymentResponse> Function(Map<String, dynamic> paymentDetailBody)
  onPaymentDetail,
  required Function() onRetry,
  Widget Function(String url, Function()? onRetry)? topTitleWidget,
  KlarnaEnvironment environment = KlarnaEnvironment.staging,
}) async {
  // final Completer<adyen.PaymentEvent> completer = Completer();
  // final controller
  final result = await showModalBottomSheet<adyen.PaymentEvent>(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    scrollControlDisabledMaxHeightRatio: 0.9,
    builder: (context) {
      return PopScope(
        onPopInvokedWithResult: (isPop, result) {
          if (result is adyen.PaymentEvent) {
            Navigator.of(context).pop(result);
          }
        },
        child: KlarnaWidgetBottomSheet.native(
          klarnaNativeConfiguration: klarnaNativeConfiguration,
          onRetry: onRetry,
          topTitleWidget: topTitleWidget,
          environment: environment,
          onPaymentEvent: (String authToken) async {
            final data = {
              'paymentData': klarnaNativeConfiguration.paymentData,
              'details': {'token': authToken},
            };
            final result = await onPaymentDetail(data);
            if (!context.mounted) {
              return;
            }
            if (result.resultCode.toLowerCase() ==
                    PaymentResultCode.authorised.name.toLowerCase() ||
                result.resultCode.toLowerCase() == PaymentResultCode.pending.name.toLowerCase() ||
                result.resultCode.toLowerCase() == PaymentResultCode.received.name.toLowerCase() ||
                result.resultCode.toLowerCase() == PaymentResultCode.paid.name.toLowerCase()) {
              // completer.complete(adyen.Finished(resultCode: event));
              Navigator.of(context).pop(adyen.Finished(resultCode: result.resultCode.toString()));
            } else {
              Navigator.of(context).pop(adyen.Error(errorMessage: result.resultCode.toString()));
              // completer.complete(adyen.Error(errorMessage: result.resultCode.toString()));
            }
          },
        ),
      );
    },
    constraints: BoxConstraints(
      maxWidth: MediaQuery.sizeOf(context).width,
      maxHeight: MediaQuery.sizeOf(context).height * 0.9,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    elevation: 10,
  );

  return result ?? adyen.Finished(resultCode: "cancelled");
}

class KlarnaWidgetBottomSheet extends StatelessWidget {
  const KlarnaWidgetBottomSheet.webview({
    super.key,
    required this.klarnaNativeConfiguration,
    required this.onPaymentEvent,
    required this.onRetry,
    this.topTitleWidget,
    this.environment = KlarnaEnvironment.staging,
  }) : showWebview = true;
  const KlarnaWidgetBottomSheet.native({
    super.key,
    required this.klarnaNativeConfiguration,
    required this.onPaymentEvent,
    required this.onRetry,
    this.environment = KlarnaEnvironment.staging,
    this.topTitleWidget,
  }) : showWebview = false;
  final KlarnaNativeConfiguration klarnaNativeConfiguration;
  final Function() onRetry;
  final Function(String authToken) onPaymentEvent;
  final Widget Function(String url, Function()? onRetry)? topTitleWidget;
  final bool showWebview;
  final KlarnaEnvironment environment;
  @override
  Widget build(BuildContext context) {
    var isAdditionalDetailLoading = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.9,
          child: Stack(
            children: [
              Opacity(
                opacity: isAdditionalDetailLoading ? 0.0 : 1.0,
                child: KlarnaPaymentWidget(
                  environment: environment,
                  clientToken: klarnaNativeConfiguration.clientToken,
                  returnURL: klarnaNativeConfiguration.redirectUrl,
                  onKlarnaFinished: (authToken, approved) async {
                    if (authToken == null || !approved || authToken.isEmpty) {
                      Navigator.of(context).pop(adyen.Error(errorMessage: "no authtoken"));
                    }
                    setState(() {
                      isAdditionalDetailLoading = true;
                    });
                    await onPaymentEvent(authToken!);
                  },
                  onKlarnaClosed: () {
                    Navigator.of(context).pop(adyen.Finished(resultCode: "cancelled"));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
