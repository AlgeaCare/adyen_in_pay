class PaymentMethodResponse {
  final List<PaymentMethodConfig> paymentMethods;

  PaymentMethodResponse({
    required this.paymentMethods,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResponse(
      paymentMethods: (json['paymentMethods'] as List)
          .map((e) => PaymentMethodConfig.fromJson(e))
          .toList(),
    );
  }
}

class PaymentMethodConfig {
  final String type;
  final String name;
  final List<String>? brand;

  PaymentMethodConfig({
    required this.type,
    required this.name,
    this.brand,
  });

  factory PaymentMethodConfig.fromJson(Map<String, dynamic> json) {
    return PaymentMethodConfig(
      type: json['type'],
      name: json['name'],
      brand: json['brand'],
    );
  }
}
