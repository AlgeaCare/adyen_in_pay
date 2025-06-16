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

class DetailPaymentResponse {
  final String resultCode;
  final String? pspReference;
  DetailPaymentResponse({
    required this.resultCode,
    this.pspReference,
  });

  factory DetailPaymentResponse.fromJson(Map<String, dynamic> json) {
    return DetailPaymentResponse(
      resultCode: json['resultCode'] as String,
      pspReference: json['pspReference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultCode': resultCode,
      if (pspReference != null) 'pspReference': pspReference,
    };
  }
}

class PaymentResponse {
  final String? pspReference;
  final PaymentResultCode resultCode;
  final Map<String, dynamic>? additionalData;
  final Map<String, dynamic>? action;
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
      action: json['action'] as Map<String, dynamic>?,
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
      if (action != null) 'action': action!,
      if (amount != null) 'amount': amount!.toJson(),
      if (donationToken != null) 'donationToken': donationToken,
      if (merchantReference != null) 'merchantReference': merchantReference,
    };
  }

  String get actionType => action?['type'] ?? '';
}
