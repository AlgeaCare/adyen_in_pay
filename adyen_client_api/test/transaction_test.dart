import 'package:payment_client_api/payment_client_api.dart';
import 'package:flutter_test/flutter_test.dart';

/// A70965831953791 on dev: a captured Direktlieferung Retoure whose products
/// were refunded. The refund is booked against the payment, not a basket, so
/// the payment service sends it with `basket_id: null`.
Map<String, dynamic> _transaction({
  required int id,
  required String type,
  required int amount,
  required int? basketId,
}) => {
  'id': id,
  'psp_status': type == 'refund' ? 'REFUND' : 'CAPTURE',
  'created_at': '2026-11-11T09:18:48.824Z',
  'updated_at': '2026-11-11T09:19:25.900Z',
  'payment_invoice_id': 'A70965831953791',
  'amount': amount,
  'refund_amount': 0,
  'status': 'completed',
  'transaction_date': '2026-11-11T09:18:48.830Z',
  'type': type,
  'method': 'credit_card',
  'psp_number': 'GXBKJZWZJHJ6P7W5',
  'capture_psp_number': null,
  'basket_id': basketId,
  'transaction_id': type == 'refund' ? 13893 : null,
  'costCoverage': null,
};

void main() {
  group('Transaction.fromJson', () {
    test('reads a refund without a basket', () {
      final refund = Transaction.fromJson(
        _transaction(id: 13895, type: 'refund', amount: 7990, basketId: null),
      );

      expect(refund.basketId, isNull);
      expect(refund.amount, 7990);
      expect(refund.type, 'refund');
    });

    test('keeps the basket of a payment', () {
      final payment = Transaction.fromJson(
        _transaction(id: 13893, type: 'payment', amount: 10335, basketId: 9610),
      );

      expect(payment.basketId, 9610);
    });
  });

  test('a payment with a refund that has no basket still parses', () {
    final information = PaymentInformation.fromJson({
      'invoice_id': 'A70965831953791',
      'provider': 'adyen',
      'email': '',
      'first_name': '',
      'last_name': '',
      'payment_status': 'refunded',
      'product_type': 'pharmacy_order',
      'product_types': ['pharmacy_order', 'quick_delivery'],
      'zid': '',
      'meta_data': '',
      'preferred_method': 'online',
      'created_at': '',
      'updated_at': '',
      'is_five_gram': false,
      'reverse_transfers': true,
      'baskets': <Object>[],
      'amount_due': 7990,
      'amount_paid': 2345,
      'transactions': [
        _transaction(id: 13893, type: 'payment', amount: 10335, basketId: 9610),
        _transaction(id: 13895, type: 'refund', amount: 7990, basketId: null),
      ],
    });

    expect(information.transactions, hasLength(2));
    expect(information.transactions.last.basketId, isNull);
  });
}
