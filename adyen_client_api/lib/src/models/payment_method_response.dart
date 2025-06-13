class PaymentMethodResponse {
  final List<PaymentMethodConfig> paymentMethods;

  PaymentMethodResponse({
    required this.paymentMethods,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResponse(
      paymentMethods: (json['paymentMethods'] as List)
          .map((e) => PaymentMethodConfig.fromJson(Map.castFrom(e)))
          .toList(),
    );
  }
  Map<String, dynamic> onlyCards() {
    return {
      "paymentMethods": [paymentMethods.firstWhere((e) => e.name == 'Cards').toAllMap()],
    };
  }

  List<String> onlyCardBrands() {
    return <String>[
      'applepay',
      'googlepay',
      'visa',
      'mc',
      'amex',
      'diners',
      'jcb',
      'discover',
      'klarna_paynow'
    ]
        /*   paymentMethods
            .where((e) => e.type == 'scheme')
            .map((e) => e.brand)
            .toList()
            .reduce((value, element) {
          final list = List<String>.from(value ?? []);
          list.addAll(element ?? []);
          return list;
        }) ?? */
        ;
  }

  Map<String, dynamic> onlyKlarna() {
    return {
      "paymentMethods": paymentMethods
          .where((e) => e.type.toLowerCase().contains('klarna'))
          .map((e) => e.toAllMap())
          .toList(),
    };
  }

  Map<String, dynamic> onlyKlarnaPaynow() {
    return {
      "paymentMethods": paymentMethods
          .where((e) => e.type.toLowerCase().contains('klarna_paynow'))
          .map((e) => e.toAllMap())
          .toList(),
    };
  }

  Map<String, dynamic> onlyCustom(String typeName) {
    return {
      "paymentMethods": paymentMethods
          .where((e) => e.type.toLowerCase().contains(typeName))
          .map((e) => e.toAllMap())
          .toList(),
    };
  }

  Map<String, dynamic> toAllMap() {
    return {
      "paymentMethods":
          paymentMethods.where((e) => e.type != 'multibanco').map((e) => e.toAllMap()).toList(),
    };
  }

  Map<String, dynamic> toJson() => {
        'paymentMethods':
            paymentMethods.where((e) => e.type != 'multibanco').map((e) => e.toJson()).toList(),
      };
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
      brand: json['brands'] is List
          ? (json['brands'] as List).map((e) => e.toString()).toList()
          : null,
    );
  }

  Map<String, String> toMap() {
    final map = <String, String>{};

    map[type] = name;
    return map;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map["type"] = type;
    map["name"] = name;
    if (brand != null) {
      map['brands'] = brand!;
    }
    return map;
  }

  Map<String, String> toAllMap() {
    final map = <String, String>{};

    map["type"] = type;
    map["name"] = name;
    if (brand != null) {
      map['brands'] = brand!.join(',');
    }
    return map;
  }
}
