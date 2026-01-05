import 'package:payment_client_api/payment_client_api.dart';

class CostCoverageResponse {
  final bool applied;
  final int amount;
  final PaymentInformation paymentInformation;

  const CostCoverageResponse({
    required this.applied,
    required this.amount,
    required this.paymentInformation,
  });

  factory CostCoverageResponse.fromJson(Map<String, dynamic> json) {
    return CostCoverageResponse(
      applied: json['applied'] as bool,
      amount: json['amount'] as int,
      paymentInformation: PaymentInformation.fromJson(json['payment'] as Map<String, dynamic>),
    );
  }

  CostCoverageResponse copyWith({
    bool? applied,
    int? amount,
    PaymentInformation? paymentInformation,
  }) {
    return CostCoverageResponse(
      applied: applied ?? this.applied,
      amount: amount ?? this.amount,
      paymentInformation: paymentInformation ?? this.paymentInformation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostCoverageResponse &&
          runtimeType == other.runtimeType &&
          applied == other.applied &&
          amount == other.amount &&
          paymentInformation == other.paymentInformation;

  @override
  int get hashCode => Object.hash(applied, amount, paymentInformation);

  @override
  String toString() =>
      'CostCoverageResponse(applied: $applied, amount: $amount, paymentInformation: $paymentInformation)';
}
