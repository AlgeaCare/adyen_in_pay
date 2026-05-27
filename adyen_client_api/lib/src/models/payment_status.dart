import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'label')
enum AdyenPaymentStatus {
  pending('pending'),
  waiting('waiting'),
  adminWaiting('admin_waiting'),
  paid('paid'),
  completed('completed'),
  adminCompleted('admin_completed'),
  review('review'),
  cancelled('canceled'),
  adminCancelled('admin_canceled'),
  refunded('refunded'),
  adminChargeback('admin_chargeback'),
  debt('debt'),
  debtCollectionDone('debt_collection_done'),
  debtCollectionUncollectible('debt_collection_uncollectible'),
  debtCollection('debt_collection'),
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
