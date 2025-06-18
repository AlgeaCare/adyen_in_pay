import 'package:payment_client_api/src/models/shopper_billing_address.dart'
    show ShopperBillingAddress;

class PaymentInformation {
  final String invoiceId;
  final String email;
  final String firstName;
  final String lastName;
  final String paymentStatus;
  final String productType;
  final String? paymentId;
  final String? voucherCode;
  final String invoiceUrl;
  final String zid;
  final String hsId;
  final List<Basket> baskets;
  final int amountDue;
  final String provider;

  PaymentInformation({
    required this.invoiceId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.paymentStatus,
    required this.productType,
    this.paymentId,
    this.voucherCode,
    required this.invoiceUrl,
    required this.zid,
    required this.hsId,
    required this.baskets,
    required this.amountDue,
    required this.provider,
  });

  factory PaymentInformation.fromJson(Map<String, dynamic> json) {
    return PaymentInformation(
      invoiceId: json['invoice_id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      paymentStatus: json['payment_status'],
      productType: json['product_type'],
      paymentId: json['payment_id'],
      voucherCode: json['voucher_code'],
      invoiceUrl: json['invoice_url'],
      zid: json['zid'],
      hsId: json['hs_id'],
      amountDue: json['amount_due'],
      provider: json['provider'],
      baskets: (json['baskets'] as List).map((basketJson) => Basket.fromJson(basketJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_id': invoiceId,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'payment_status': paymentStatus,
      'product_type': productType,
      'payment_id': paymentId,
      'voucher_code': voucherCode,
      'invoice_url': invoiceUrl,
      'zid': zid,
      'hs_id': hsId,
      'amount_due': amountDue,
      'provider': provider,
      'baskets': baskets.map((basket) => basket.toJson()).toList(),
    };
  }

  Map<String, dynamic> toPaymentDataJson({
    String? countryCode,
    String? shopperLocale,
    String? telephoneNumber,
    ShopperBillingAddress? billingAddress,
  }) {
    return {
      'shopperEmail': email,
      'shopperName': {
        'firstName': firstName,
        'lastName': lastName,
      },
      'billingAddress': billingAddress?.toJson(),
      'telephoneNumber': telephoneNumber,
      'countryCode': countryCode,
      'shopperLocale': shopperLocale,
      'shopperReference': invoiceId,
      'lineItems': baskets
          .map((basket) => basket.items.map((item) => item.toPaymentDataJson()))
          .expand((items) => items)
          .toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentInformation &&
        other.invoiceId == invoiceId &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.paymentStatus == paymentStatus &&
        other.productType == productType &&
        other.paymentId == paymentId &&
        other.voucherCode == voucherCode &&
        other.invoiceUrl == invoiceUrl &&
        other.zid == zid &&
        other.hsId == hsId &&
        other.amountDue == amountDue &&
        other.provider == provider &&
        _listEquals(other.baskets, baskets);
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      invoiceId,
      email,
      firstName,
      lastName,
      paymentStatus,
      productType,
      paymentId,
      voucherCode,
      invoiceUrl,
      zid,
      hsId,
      amountDue,
      provider,
      Object.hashAll(baskets),
    );
  }
}

class Basket {
  final String invoiceId;
  final int amountTotalDiscount;
  final int amountTotalGross;
  final String title;
  final String subTitle;
  final String? productType;
  final String? resourceId;
  final String? subMerchantResourceId;
  final bool active;
  final List<BasketItem> items;

  Basket({
    required this.invoiceId,
    required this.amountTotalDiscount,
    required this.amountTotalGross,
    required this.title,
    required this.subTitle,
    this.productType,
    this.resourceId,
    this.subMerchantResourceId,
    required this.active,
    required this.items,
  });

  factory Basket.fromJson(Map<String, dynamic> json) {
    return Basket(
      invoiceId: json['invoice_id'],
      amountTotalDiscount: json['amount_total_discount'],
      amountTotalGross: json['amount_total_gross'],
      title: json['title'],
      subTitle: json['sub_title'],
      productType: json['product_type'],
      resourceId: json['resource_id'],
      subMerchantResourceId: json['sub_merchant_resource_id'],
      active: json['active'],
      items: (json['items'] as List).map((itemJson) => BasketItem.fromJson(itemJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_id': invoiceId,
      'amount_total_discount': amountTotalDiscount,
      'amount_total_gross': amountTotalGross,
      'title': title,
      'sub_title': subTitle,
      'product_type': productType,
      'resource_id': resourceId,
      'sub_merchant_resource_id': subMerchantResourceId,
      'active': active,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Basket &&
        other.invoiceId == invoiceId &&
        other.amountTotalDiscount == amountTotalDiscount &&
        other.amountTotalGross == amountTotalGross &&
        other.title == title &&
        other.subTitle == subTitle &&
        other.productType == productType &&
        other.resourceId == resourceId &&
        other.subMerchantResourceId == subMerchantResourceId &&
        other.active == active &&
        _listEquals(other.items, items);
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      invoiceId,
      amountTotalDiscount,
      amountTotalGross,
      title,
      subTitle,
      productType,
      resourceId,
      subMerchantResourceId,
      active,
      Object.hashAll(items),
    );
  }
}

class BasketItem {
  final int id;
  final int basketId;
  final dynamic basketItemReferenceId;
  final int quantity;
  final int amountDiscount;
  final int amountGross;
  final int amountPerUnit;
  final int amountNet;
  final String title;
  final String subTitle;
  final String type;
  final dynamic imageUrl;

  BasketItem({
    required this.id,
    required this.basketId,
    this.basketItemReferenceId,
    required this.quantity,
    required this.amountDiscount,
    required this.amountGross,
    required this.amountPerUnit,
    required this.amountNet,
    required this.title,
    required this.subTitle,
    required this.type,
    this.imageUrl,
  });

  factory BasketItem.fromJson(Map<String, dynamic> json) {
    return BasketItem(
      id: json['id'],
      basketId: json['basket_id'],
      basketItemReferenceId: json['basket_item_reference_id'],
      quantity: json['quantity'],
      amountDiscount: json['amount_discount'],
      amountGross: json['amount_gross'],
      amountPerUnit: json['amount_per_unit'],
      amountNet: json['amount_net'],
      title: json['title'],
      subTitle: json['sub_title'],
      type: json['type'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'basket_id': basketId,
      'basket_item_reference_id': basketItemReferenceId,
      'quantity': quantity,
      'amount_discount': amountDiscount,
      'amount_gross': amountGross,
      'amount_per_unit': amountPerUnit,
      'amount_net': amountNet,
      'title': title,
      'sub_title': subTitle,
      'type': type,
      'image_url': imageUrl,
    };
  }

  Map<String, dynamic> toPaymentDataJson() {
    return {
      'id': id.toString(),
      'amountIncludingTax': amountGross,
      'description': title,
      'quantity': quantity,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BasketItem &&
        other.id == id &&
        other.basketId == basketId &&
        other.basketItemReferenceId == basketItemReferenceId &&
        other.quantity == quantity &&
        other.amountDiscount == amountDiscount &&
        other.amountGross == amountGross &&
        other.amountPerUnit == amountPerUnit &&
        other.amountNet == amountNet &&
        other.title == title &&
        other.subTitle == subTitle &&
        other.type == type &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      basketId,
      basketItemReferenceId,
      quantity,
      amountDiscount,
      amountGross,
      amountPerUnit,
      amountNet,
      title,
      subTitle,
      type,
      imageUrl,
    );
  }
}
