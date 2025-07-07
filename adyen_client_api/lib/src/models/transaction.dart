import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
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
    int? transferId,
    int? transactionId,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}
