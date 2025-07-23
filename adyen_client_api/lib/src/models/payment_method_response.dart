import 'package:collection/collection.dart';

class PaymentMethodResponse {
  final List<PaymentMethodConfig> paymentMethods;

  PaymentMethodResponse({required this.paymentMethods});

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodResponse(
      paymentMethods:
          (json['paymentMethods'] as List)
              .map((e) => PaymentMethodConfig.fromJson(Map.castFrom(e)))
              .toList(),
    );
  }
  Map<String, dynamic> onlyCards() {
    return {
      "paymentMethods": [paymentMethods.firstWhere((e) => e.type == 'scheme').toAllMap()],
    };
  }

  Map<String, String>? get applePayConfiguration =>
      paymentMethods.firstWhereOrNull((e) => e.type.toLowerCase() == 'applepay')?.configuration;

  Map<String, String>? get googlePayConfiguration =>
      paymentMethods.firstWhereOrNull((e) => e.type.toLowerCase() == 'googlepay')?.configuration;

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
      'klarna_paynow',
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
      "paymentMethods":
          paymentMethods
              .where((e) => e.type.toLowerCase().contains('klarna'))
              .map((e) => e.toAllMap())
              .toList(),
    };
  }

  Map<String, dynamic> onlyKlarnaPaynow() {
    return {
      "paymentMethods":
          paymentMethods
              .where((e) => e.type.toLowerCase().contains('klarna_paynow'))
              .map((e) => e.toAllMap())
              .toList(),
    };
  }

  Map<String, dynamic> onlyCustom(String typeName) {
    return {
      "paymentMethods":
          paymentMethods
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

  Map<String, dynamic> toJson({bool ignoreGooglePay = false}) => {
    'paymentMethods':
        paymentMethods
            .where(
              (e) => e.type != 'multibanco' && (ignoreGooglePay ? e.type != 'googlepay' : true),
            )
            .map((e) => e.toJson())
            .toList(),
  };
}

class PaymentMethodConfig {
  final String type;
  final String name;
  final List<String>? brand;
  final Map<String, String>? configuration;

  PaymentMethodConfig({required this.type, required this.name, this.brand, this.configuration});

  factory PaymentMethodConfig.fromJson(Map<String, dynamic> json) {
    return PaymentMethodConfig(
      type: json['type'],
      name: json['name'],
      brand:
          json['brands'] is List
              ? (json['brands'] as List).map((e) => e.toString()).toList()
              : null,
      configuration:
          json['configuration'] is Map
              ? (json['configuration'] as Map).map((key, value) => MapEntry(key, value.toString()))
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
    if (configuration != null) {
      map['configuration'] = configuration!;
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
