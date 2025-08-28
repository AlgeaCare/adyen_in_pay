import 'package:flutter/material.dart';

enum KlarnaPayEnum { redirect, sdk, sdkWeb }

class CustomPaymentConfigurationWidget {
  Widget? processingKlarnaWidget;
  Widget? initializationKlarnaWidget;
  KlarnaPayEnum klarnaPayEnum;
  CustomPaymentConfigurationWidget({
    this.processingKlarnaWidget,
    this.initializationKlarnaWidget,
    this.klarnaPayEnum = KlarnaPayEnum.sdk,
  });
}
