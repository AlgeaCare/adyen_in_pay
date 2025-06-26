class ShopperBillingAddress {
  final String street;
  final String houseNumberOrName;
  final String city;
  final String postalCode;
  final String country;

  ShopperBillingAddress({
    required this.street,
    required this.houseNumberOrName,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  factory ShopperBillingAddress.fromJson(Map<String, dynamic> json) {
    return ShopperBillingAddress(
      street: json['street'] ?? '',
      houseNumberOrName: json['houseNumberOrName'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'houseNumberOrName': houseNumberOrName,
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
        other.houseNumberOrName == houseNumberOrName &&
        other.city == city &&
        other.postalCode == postalCode &&
        other.country == country;
  }

  @override
  int get hashCode {
    return Object.hash(
      street,
      houseNumberOrName,
      city,
      postalCode,
      country,
    );
  }
}
