import 'package:flutter/material.dart';

enum KlarnaPayEnum { redirect, sdk, sdkWeb }

class CustomPaymentConfigurationWidget {
  Widget? processingKlarnaWidget;
  Widget? initializationKlarnaWidget;
  KlarnaPayEnum klarnaPayEnum;
  bool defaultKlarnaAction;
  double bottomSheetMaxHeightRatio;

  /// Notes for the mobile Drop-in list, keyed by payment method type (for
  /// example `klarna` or `klarna_account`). Each note goes on a new line
  /// under the name Adyen returns for that type. Types not in the map keep
  /// Adyen's name as it is.
  Map<String, String>? paymentMethodNotes;

  CustomPaymentConfigurationWidget({
    this.processingKlarnaWidget,
    this.initializationKlarnaWidget,
    this.klarnaPayEnum = KlarnaPayEnum.sdk,
    this.defaultKlarnaAction = true,
    this.bottomSheetMaxHeightRatio = 0.6,
    this.paymentMethodNotes,
  });
}
