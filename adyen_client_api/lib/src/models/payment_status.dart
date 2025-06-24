import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'label')
enum PaymentStatus {
  pending('pending'),
  paid('paid'),
  completed('completed'),
  review('review'),
  canceled('canceled'),
  refunded('refunded'),
  debt('debt'),
  authorized('authorized'),
  failed('failed'),
  partial('partial'),
  refundPending('refund_pending'),
  refundFailed('refund_failed');

  const PaymentStatus(this.label);

  final String label;

  @override
  String toString() => label;
}
