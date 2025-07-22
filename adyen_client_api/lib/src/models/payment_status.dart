import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'label')
enum AdyenPaymentStatus {
  pending('pending'),
  paid('paid'),
  completed('completed'),
  review('review'),
  cancelled('cancelled'),
  adminCancelled('admin_cancelled'),
  refunded('refunded'),
  debt('debt'),
  authorized('authorized'),
  failed('failed'),
  partial('partial'),
  refundPending('refund_pending'),
  refundFailed('refund_failed'),
  unknown('unknown');

  const AdyenPaymentStatus(this.label);

  final String label;

  @override
  String toString() => label;
}
