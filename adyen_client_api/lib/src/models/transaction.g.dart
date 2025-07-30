// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num).toInt(),
      pspStatus: json['psp_status'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      paymentInvoiceId: json['payment_invoice_id'] as String,
      amount: (json['amount'] as num).toInt(),
      refundAmount: (json['refund_amount'] as num).toInt(),
      status: json['status'] as String,
      transactionDate: json['transaction_date'] as String,
      type: json['type'] as String,
      method: json['method'] as String?,
      pspNumber: json['psp_number'] as String?,
      capturePspNumber: json['capture_psp_number'] as String?,
      basketId: (json['basket_id'] as num).toInt(),
      transferId: (json['transfer_id'] as num?)?.toInt(),
      transactionId: (json['transaction_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'psp_status': instance.pspStatus,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'payment_invoice_id': instance.paymentInvoiceId,
      'amount': instance.amount,
      'refund_amount': instance.refundAmount,
      'status': instance.status,
      'transaction_date': instance.transactionDate,
      'type': instance.type,
      'method': instance.method,
      'psp_number': instance.pspNumber,
      'capture_psp_number': instance.capturePspNumber,
      'basket_id': instance.basketId,
      'transfer_id': instance.transferId,
      'transaction_id': instance.transactionId,
    };
