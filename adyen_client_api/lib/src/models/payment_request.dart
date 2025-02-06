class PaymentRequest {
  final int amount;
  final String currency;
  final String reference;
  final String redirectURL;
  final PaymentMethod paymentMethod;

  PaymentRequest({
    required this.amount,
    required this.currency,
    required this.reference,
    required this.redirectURL,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': {
        'value': amount,
        'currency': currency,
      },
      'reference': reference,
      'returnUrl': redirectURL,
      'paymentMethod': paymentMethod.toJson(),
    };
  }
}

class PaymentMethod {
  final String type;
  final String encryptedCardNumber;
  final String encryptedExpiryMonth;
  final String encryptedExpiryYear;
  final String encryptedSecurityCode;
  final String holderName;

  PaymentMethod({
    required this.type,
    required this.encryptedCardNumber,
    required this.encryptedExpiryMonth,
    required this.encryptedExpiryYear,
    required this.encryptedSecurityCode,
    required this.holderName,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'encryptedCardNumber': encryptedCardNumber,
      'encryptedExpiryMonth': encryptedExpiryMonth,
      'encryptedExpiryYear': encryptedExpiryYear,
      'encryptedSecurityCode': encryptedSecurityCode,
      'holderName': holderName,
    };
  }
}
