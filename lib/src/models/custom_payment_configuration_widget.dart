import 'package:flutter/material.dart';

enum KlarnaPayEnum { redirect, sdk, sdkWeb }

class CustomPaymentConfigurationWidget {
  Widget? processingKlarnaWidget;
  Widget? initializationKlarnaWidget;
  KlarnaPayEnum klarnaPayEnum;
  bool defaultKlarnaAction;
  double bottomSheetMaxHeightRatio;
  
  CustomPaymentConfigurationWidget({
    this.processingKlarnaWidget,
    this.initializationKlarnaWidget,
    this.klarnaPayEnum = KlarnaPayEnum.sdk,
    this.defaultKlarnaAction = true,
    this.bottomSheetMaxHeightRatio = 0.6,
  });
}
