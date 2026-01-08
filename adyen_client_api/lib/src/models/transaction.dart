import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const Transaction._();

  // ignore: invalid_annotation_target
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory Transaction({
    required int id,
    String? pspStatus,
    required String createdAt,
    required String updatedAt,
    required String paymentInvoiceId,
    required int amount,
    required int refundAmount,
    required String status,
    required String transactionDate,
    required String type,
    String? method,
    String? pspNumber,
    String? capturePspNumber,
    required int basketId,
    CostCoverageTransaction? costCoverage,
    int? transferId,
    int? transactionId,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  bool get hasPspNumber =>
      pspNumber != null &&
      pspNumber!.isNotEmpty &&
      pspNumber!.toLowerCase() != 'na' &&
      pspNumber!.toLowerCase() != 'unknown';
  bool get isCostCoverage => type == 'cost_coverage';
}

@freezed
class CostCoverageTransaction with _$CostCoverageTransaction {
  factory CostCoverageTransaction({
    @JsonKey(name: 'amount') required int discountAmount,
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'status') required String status,
  }) = _CostCoverageTransaction;
  factory CostCoverageTransaction.fromJson(Map<String, dynamic> json) =>
      _$CostCoverageTransactionFromJson(json);
}
