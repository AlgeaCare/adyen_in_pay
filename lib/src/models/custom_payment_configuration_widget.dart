import 'package:flutter/material.dart';
import 'package:payment_client_api/payment_client_api.dart'
    show PaymentMethodConfig;

enum KlarnaPayEnum { redirect, sdk, sdkWeb }

/// Lets the app show its own payment method list before the mobile Drop-in
/// opens. Gets the methods this device can pay with and returns the one the
/// shopper picked, or `null` when the shopper closed the list.
typedef PaymentMethodSelector =
    Future<PaymentMethodConfig?> Function(
      List<PaymentMethodConfig> paymentMethods,
    );

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

  /// When set, the mobile Drop-in starts with only the method this returns,
  /// so Drop-in skips its own list. When `null`, Drop-in shows its own list.
  PaymentMethodSelector? selectPaymentMethod;

  /// Types that start right away through Adyen's Instant Component when
  /// [selectPaymentMethod] returns them, without opening Drop-in. Only list
  /// types that need no input from the shopper (for example `klarna` or
  /// `paypal`). Other types open Drop-in with just that method.
  Set<String> instantPaymentMethodTypes;

  CustomPaymentConfigurationWidget({
    this.processingKlarnaWidget,
    this.initializationKlarnaWidget,
    this.klarnaPayEnum = KlarnaPayEnum.sdk,
    this.defaultKlarnaAction = true,
    this.bottomSheetMaxHeightRatio = 0.6,
    this.paymentMethodNotes,
    this.selectPaymentMethod,
    this.instantPaymentMethodTypes = const {},
  });
}
