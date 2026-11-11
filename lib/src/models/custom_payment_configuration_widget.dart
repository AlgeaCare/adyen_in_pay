import 'package:flutter/material.dart';

enum KlarnaPayEnum { redirect, sdk, sdkWeb }

class CustomPaymentConfigurationWidget {
  Widget? processingKlarnaWidget;
  Widget? initializationKlarnaWidget;
  KlarnaPayEnum klarnaPayEnum;
  bool defaultKlarnaAction;
  double bottomSheetMaxHeightRatio;

  /// Display names for the mobile Drop-in list, keyed by payment method type
  /// (for example `klarna` or `klarna_account`). Types not in the map keep
  /// Adyen's default name.
  Map<String, String>? paymentMethodNames;

  CustomPaymentConfigurationWidget({
    this.processingKlarnaWidget,
    this.initializationKlarnaWidget,
    this.klarnaPayEnum = KlarnaPayEnum.sdk,
    this.defaultKlarnaAction = true,
    this.bottomSheetMaxHeightRatio = 0.6,
    this.paymentMethodNames,
  });
}
