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
    int? discountAmountCents,
    int? finalAmountCents,
    required int basketId,
    int? transferId,
    int? transactionId,
  }) = _Transaction;

  bool get hasPspNumber =>
      pspNumber != null &&
      pspNumber!.isNotEmpty &&
      pspNumber!.toLowerCase() != 'na' &&
      pspNumber!.toLowerCase() != 'unknown';

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

   bool get isCostCoverage => type == 'cost_coverage';   
}
