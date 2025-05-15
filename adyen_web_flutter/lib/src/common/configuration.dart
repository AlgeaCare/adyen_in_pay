import 'package:flutter/material.dart' show VoidCallback, Size;

class WebConfiguration {
  final WebConfigurationType configurationType;
  final WebCallbackConfiguration callbacks;
  final Size? sizeWeb;
  const WebConfiguration({
    required this.callbacks,
    required this.configurationType,
    this.sizeWeb,
  });
}

class WebCallbackConfiguration {
  final VoidCallback onStarted;
  final Function(Map<String, dynamic>) onPaymentDone;
  final VoidCallback onPaymentFailed;
  final Future<String> Function(Map<String, dynamic>) onPayment;
  final Future<String> Function(Map<String, dynamic>) onPaymentDetail;
  final Future<String> Function() onPaymentMethod;
  final Future<List<String>> Function() cardBrands;

  const WebCallbackConfiguration({
    required this.onStarted,
    required this.onPaymentDone,
    required this.onPaymentFailed,
    required this.onPayment,
    required this.onPaymentDetail,
    required this.onPaymentMethod,
    required this.cardBrands,
  });
}

sealed class WebConfigurationType {
  final String clientKey;
  final String redirectURL;
  final String env;
  final String currency;
  final int amount;
  const WebConfigurationType({
    required this.clientKey,
    required this.redirectURL,
    required this.env,
    required this.currency,
    required this.amount,
  });
}

class WebConfigurationTypeSession extends WebConfigurationType {
  final String sessionId;
  final String sessionData;
  const WebConfigurationTypeSession({
    required super.clientKey,
    required this.sessionId,
    required this.sessionData,
    required super.redirectURL,
    required super.env,
    required super.currency,
    required super.amount,
  });
}

class WebConfigurationTypeAdvanced extends WebConfigurationType {
  const WebConfigurationTypeAdvanced({
    required super.clientKey,
    required super.redirectURL,
    required super.env,
    required super.currency,
    required super.amount,
  });
}
