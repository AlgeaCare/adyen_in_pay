import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:payment_client_api/payment_client_api.dart';

extension ExtSessionAmoubt on SessionAmount {
  Amount toAmount() => Amount.fromJson(toJson());
}
