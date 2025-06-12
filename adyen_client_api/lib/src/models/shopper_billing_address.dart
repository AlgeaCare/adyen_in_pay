class ShopperBillingAddress {
  final String street;
  final String city;
  final String postalCode;
  final String country;

  ShopperBillingAddress({
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory ShopperBillingAddress.fromJson(Map<String, dynamic> json) {
    return ShopperBillingAddress(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShopperBillingAddress &&
        other.street == street &&
        other.city == city &&
        other.postalCode == postalCode &&
        other.country == country;
  }

  @override
  int get hashCode {
    return Object.hash(
      street,
      city,
      postalCode,
      country,
    );
  }
}
