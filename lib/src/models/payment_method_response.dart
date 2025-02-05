class PaymentMethodResponse {
  final List<PaymentMethod> paymentMethods;

  PaymentMethodResponse({required this.paymentMethods});

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResponse(
      paymentMethods: (json['paymentMethods'] as List)
          .map((e) => PaymentMethod.fromJson(e))
          .toList(),
    );
  }
}

class PaymentMethod {
  final String type;
  final String name;
  final List<String>? brand;

  PaymentMethod({
    required this.type,
    required this.name,
    this.brand,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      type: json['type'],
      name: json['name'],
      brand: json['brand'],
    );
  }
}
