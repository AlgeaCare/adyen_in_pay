class SessionResponse {
  final SessionAmount amount;
  final String countryCode;
  final String expiresAt;
  final String id;
  final String merchantAccount;
  final String mode;
  final String reference;
  final String returnUrl;
  final String sessionData;
  final String shopperLocale;

  SessionResponse({
    required this.amount,
    required this.countryCode,
    required this.expiresAt,
    required this.id,
    required this.merchantAccount,
    required this.mode,
    required this.reference,
    required this.returnUrl,
    required this.sessionData,
    required this.shopperLocale,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      amount: SessionAmount.fromJson(json['amount'] as Map<String, dynamic>),
      countryCode: json['countryCode'] as String,
      expiresAt: json['expiresAt'] as String,
      id: json['id'] as String,
      merchantAccount: json['merchantAccount'] as String,
      mode: json['mode'] as String,
      reference: json['reference'] as String,
      returnUrl: json['returnUrl'] as String,
      sessionData: json['sessionData'] as String,
      shopperLocale: json['shopperLocale'] as String,
    );
  }
}

class SessionAmount {
  final int value;
  final String currency;

  SessionAmount({required this.value, required this.currency});

  factory SessionAmount.fromJson(Map<String, dynamic> json) {
    return SessionAmount(
      value: json['value'] as int,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'value': value, 'currency': currency};
}
