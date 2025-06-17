import 'package:payment_client_api/payment_client_api.dart';

class ShopperPaymentInformation {
  final String invoiceId;
  final ShopperBillingAddress billingAddress;
  final String locale;
  final String telephoneNumber;
  final String countryCode;
  final String appleMerchantId;
  final String merchantName;
  ShopperPaymentInformation({
    required this.invoiceId,
    required this.billingAddress,
    required this.locale,
    required this.telephoneNumber,
    required this.countryCode,
    required this.appleMerchantId,
    this.merchantName = 'BloomwellECOM',
  });
}
