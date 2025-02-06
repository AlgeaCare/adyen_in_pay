import 'package:adyen_client_api/src/models/session_response.dart';

enum PaymentResultCode {
  authorised,
  refused,
  redirectShopper,
  identifyShopper,
  challengeShopper,
  pending,
  received,
  presentToShopper,
  cancelled,
  error;

  factory PaymentResultCode.fromString(String value) {
    return PaymentResultCode.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
      orElse: () => PaymentResultCode.error,
    );
  }
}

class PaymentResponse {
  final String? pspReference;
  final PaymentResultCode resultCode;
  final Map<String, dynamic>? additionalData;
  final PaymentAction? action;
  final SessionAmount? amount;
  final String? donationToken;
  final String? merchantReference;

  PaymentResponse({
    this.pspReference,
    required this.resultCode,
    this.additionalData,
    this.action,
    this.amount,
    this.donationToken,
    this.merchantReference,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      pspReference: json['pspReference'] as String?,
      resultCode: PaymentResultCode.fromString(json['resultCode'] as String),
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      action: json['action'] != null
          ? PaymentAction.fromJson(json['action'] as Map<String, dynamic>)
          : null,
      amount: json['amount'] != null
          ? SessionAmount.fromJson(json['amount'] as Map<String, dynamic>)
          : null,
      donationToken: json['donationToken'] as String?,
      merchantReference: json['merchantReference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (pspReference != null) 'pspReference': pspReference,
      'resultCode': resultCode.toString().split('.').last,
      if (additionalData != null) 'additionalData': additionalData,
      if (action != null) 'action': action!.toJson(),
      if (amount != null) 'amount': amount!.toJson(),
      if (donationToken != null) 'donationToken': donationToken,
      if (merchantReference != null) 'merchantReference': merchantReference,
    };
  }
}

class PaymentAction {
  final String? paymentMethodType;
  final String? url;
  final String? method;
  final String type;
  final String? paymentData;
  final String? authorisationToken;
  final String? subtype;
  final String? token;

  PaymentAction({
    this.paymentMethodType,
    this.url,
    this.method,
    required this.type,
    this.paymentData,
    this.authorisationToken,
    this.subtype,
    this.token,
  });

  factory PaymentAction.fromJson(Map<String, dynamic> json) {
    return PaymentAction(
      paymentMethodType: json['paymentMethodType'] as String?,
      url: json['url'] as String?,
      method: json['method'] as String?,
      type: json['type'] as String,
      paymentData: json['paymentData'] as String?,
      authorisationToken: json['authorisationToken'] as String?,
      subtype: json['subtype'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (paymentMethodType != null) 'paymentMethodType': paymentMethodType,
      if (url != null) 'url': url,
      if (method != null) 'method': method,
      'type': type,
      if (paymentData != null) 'paymentData': paymentData,
      if (authorisationToken != null) 'authorisationToken': authorisationToken,
      if (subtype != null) 'subtype': subtype,
      if (token != null) 'token': token,
    };
  }
}
