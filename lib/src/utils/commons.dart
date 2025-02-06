import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_client_api/adyen_client_api.dart';

extension ExtSessionAmoubt on SessionAmount {
  Amount toAmount() => Amount.fromJson(toJson());
}
