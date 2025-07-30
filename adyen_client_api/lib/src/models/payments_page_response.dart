import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:payment_client_api/src/models/payment_information.dart';

part 'payments_page_response.freezed.dart';
part 'payments_page_response.g.dart';

@freezed
class PaymentsPageResponse with _$PaymentsPageResponse {
  factory PaymentsPageResponse({
    required List<PaymentInformation> payments,
    required int count,
    required int page,
  }) = _PaymentsPageResponse;

  factory PaymentsPageResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentsPageResponseFromJson(json);
}
