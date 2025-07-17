class AdyenKeysConfiguration {
  final String clientKey;
  final String appleMerchantId;
  final String merchantName;
  final String googleMerchantId;
  const AdyenKeysConfiguration({
    required this.clientKey,
    required this.appleMerchantId,
    required this.merchantName,
    required this.googleMerchantId,
  });

  factory AdyenKeysConfiguration.fromJson(Map<String, dynamic> json) => AdyenKeysConfiguration(
        clientKey: json['ADYEN_CLIENT_KEY'],
        appleMerchantId: json['APPLE_MERCHANT_ID'],
        merchantName: json['MERCHANT_NAME'],
        googleMerchantId: json['GOOGLE_MERCHANT_ID'],
      );

  @override
  String toString() {
    return 'AdyenConfiguration(clientKey: $clientKey, appleMerchantId: $appleMerchantId, merchantName: $merchantName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdyenKeysConfiguration &&
        clientKey == other.clientKey &&
        appleMerchantId == other.appleMerchantId &&
        merchantName == other.merchantName;
  }

  @override
  int get hashCode {
    return clientKey.hashCode ^ appleMerchantId.hashCode ^ merchantName.hashCode;
  }
}
