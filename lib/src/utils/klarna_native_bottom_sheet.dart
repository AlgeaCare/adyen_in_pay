import 'dart:async';
import 'package:adyen_checkout/adyen_checkout.dart' as adyen show PaymentEvent, Finished, Error;
import 'package:adyen_in_pay/adyen_in_pay.dart' show DetailPaymentResponse, PaymentResultCode;
import 'package:adyen_in_pay/src/models/custom_payment_configuration_widget.dart';
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
  KlarnaEnvironment environment = KlarnaEnvironment.staging,
  KlarnaPayEnum klarnaPayEnum = KlarnaPayEnum.sdk,
  double bottomSheetMaxHeightRatio = 0.6,
}) async {
  final result = await showModalBottomSheet<adyen.PaymentEvent>(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    scrollControlDisabledMaxHeightRatio: bottomSheetMaxHeightRatio,
    builder: (context) {
      return PopScope(
        onPopInvokedWithResult: (isPop, result) {
          // if (result is adyen.PaymentEvent) {
          //   if(context.mounted){
          //     Navigator.of(context).pop(result);
          //   }
          // }
        },
        child: KlarnaWidgetBottomSheet(
          klarnaNativeConfiguration: klarnaNativeConfiguration,
          onRetry: onRetry,
          environment: environment,
          klarnaPayEnum: klarnaPayEnum,
          bottomSheetMaxHeightRatio: bottomSheetMaxHeightRatio,
          onPaymentEvent: (String authToken) async {
            try {
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
                  result.resultCode.toLowerCase() ==
                      PaymentResultCode.received.name.toLowerCase() ||
                  result.resultCode.toLowerCase() == PaymentResultCode.paid.name.toLowerCase()) {
                // completer.complete(adyen.Finished(resultCode: event));
                Navigator.of(context).pop(adyen.Finished(resultCode: result.resultCode.toString()));
              } else {
                Navigator.of(context).pop(adyen.Error(errorMessage: result.resultCode.toString()));
                // completer.complete(adyen.Error(errorMessage: result.resultCode.toString()));
              }
            } catch (e) {
              Navigator.of(context).pop(adyen.Error(errorMessage: e.toString()));
            }
          },
        ),
      );
    },
    constraints: BoxConstraints(
      maxWidth: MediaQuery.sizeOf(context).width,
      maxHeight: MediaQuery.sizeOf(context).height * bottomSheetMaxHeightRatio,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    elevation: 10,
  );

  return result ?? adyen.Finished(resultCode: "cancelled");
}

class KlarnaWidgetBottomSheet extends StatelessWidget {
  const KlarnaWidgetBottomSheet({
    super.key,
    required this.klarnaNativeConfiguration,
    required this.onPaymentEvent,
    required this.onRetry,
    this.environment = KlarnaEnvironment.staging,
    this.klarnaPayEnum = KlarnaPayEnum.sdk,
    this.bottomSheetMaxHeightRatio = 0.6,
  });

  final KlarnaNativeConfiguration klarnaNativeConfiguration;
  final Function() onRetry;
  final Function(String authToken) onPaymentEvent;
  final KlarnaEnvironment environment;
  final KlarnaPayEnum klarnaPayEnum;
  final double bottomSheetMaxHeightRatio;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * bottomSheetMaxHeightRatio,
      child: KlarnaPaymentWidget(
        environment: environment,
        clientToken: klarnaNativeConfiguration.clientToken,
        returnURL: klarnaNativeConfiguration.redirectUrl,
        category: klarnaNativeConfiguration.category,
        processingWidget: klarnaNativeConfiguration.processingWidget,
        initializationWidget: klarnaNativeConfiguration.initializationWidget,
        onKlarnaFinished: (authToken, approved) async {
          if (authToken == null || !approved || authToken.isEmpty) {
            Navigator.of(context).pop(adyen.Error(errorMessage: "no authtoken"));
            return;
          }

          await onPaymentEvent(authToken);
        },
        onKlarnaClosed: () {
          Navigator.of(context).pop(adyen.Finished(resultCode: "cancelled"));
        },
      ),
    );
  }
}
