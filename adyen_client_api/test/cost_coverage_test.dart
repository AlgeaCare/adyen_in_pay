import 'package:payment_client_api/payment_client_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('CostCoverageResponse', () {
    group('fromJson', () {
      test('parses full response correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);

        expect(response.applied, isTrue);
        expect(response.amount, equals(4900));
        expect(response.paymentInformation, isA<PaymentInformation>());
      });

      test('parses payment information fields correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final payment = response.paymentInformation;

        expect(payment.invoiceId, equals('A93106816983249'));
        expect(payment.email, equals('test@example.com'));
        expect(payment.firstName, equals('John'));
        expect(payment.lastName, equals('Doe'));
        expect(payment.amountDue, equals(4900));
        expect(payment.zid, equals('Z123'));
        expect(payment.productType, equals('prescription'));
      });

      test('parses transactions correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final transactions = response.paymentInformation.transactions;

        expect(transactions, isNotNull);
        expect(transactions.length, equals(1));

        expect(transactions[0].id, equals(12345));
        expect(transactions[0].amount, equals(4900));
        expect(transactions[0].refundAmount, equals(0));
        expect(transactions[0].status, equals('completed'));
        expect(transactions[0].type, equals('cost_coverage'));
        expect(transactions[0].paymentInvoiceId, equals('A93106816983249'));
        expect(transactions[0].basketId, equals(789));
        expect(transactions[0].transactionDate, equals('2025-12-08T10:30:00.000Z'));
      });

      test('parses cost coverage transaction fields correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final transaction = response.paymentInformation.transactions[0];
        final hasCostCoverage = response.paymentInformation.hasCostCoverage;
        expect(hasCostCoverage, isTrue);
        expect(transaction.costCoverage, isNotNull);
        expect(transaction.costCoverage!.code, equals('INS-12345'));
        expect(transaction.costCoverage!.status, equals('completed'));
      });

      test('verifies transaction is linked to basket and invoice', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final transaction = response.paymentInformation.transactions[0];
        final basket = response.paymentInformation.baskets[0];

        expect(transaction.basketId, equals(basket.id));
        expect(transaction.paymentInvoiceId, equals(response.paymentInformation.invoiceId));
        expect(basket.invoiceId, equals(response.paymentInformation.invoiceId));
      });

      test('verifies payment status after cost coverage', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final payment = response.paymentInformation;

        expect(payment.paymentStatus, equals(AdyenPaymentStatus.paid));
        expect(response.applied, isTrue);
        expect(payment.transactions.isNotEmpty, isTrue);
        expect(payment.transactions.first.isCostCoverage, isTrue);
      });

      test('parses baskets correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final baskets = response.paymentInformation.baskets;

        expect(baskets, isNotNull);
        expect(baskets.length, equals(1));

        expect(baskets[0].id, equals(789));
        expect(baskets[0].amountDue, equals(4900));
        expect(baskets[0].invoiceId, equals('A93106816983249'));
      });

      test('handles empty transactions and baskets', () {
        final json = {
          'applied': false,
          'amount': 0,
          'payment': {
            'invoice_id': 'INV-001',
            'email': 'test@example.com',
            'first_name': 'Jane',
            'last_name': 'Smith',
            'payment_status': 'pending',
            'product_type': 'prescription',
            'zid': 'Z456',
            'amount_due': 1000,
            'provider': 'adyen',
            'created_at': '2025-12-08T10:30:00.000Z',
            'meta_data': '{}',
            'updated_at': '2025-12-08T10:30:00.000Z',
            'is_five_gram': false,
            'reverse_transfers': false,
            'product_types': ['prescription'],
            'baskets': [],
          },
        };

        final response = CostCoverageResponse.fromJson(json);

        expect(response.paymentInformation.transactions, isEmpty);
        expect(response.paymentInformation.baskets, isEmpty);
      });
    });

    group('copyWith', () {
      test('creates copy with updated applied field', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final copy = response.copyWith(applied: false);

        expect(copy.applied, isFalse);
        expect(copy.amount, equals(response.amount));
        expect(copy.paymentInformation, equals(response.paymentInformation));
      });

      test('creates copy with updated amount field', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final copy = response.copyWith(amount: 9999);

        expect(copy.applied, equals(response.applied));
        expect(copy.amount, equals(9999));
      });
    });

    group('equality', () {
      test('two responses with same data are equal', () {
        final response1 = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final response2 = CostCoverageResponse.fromJson(mockCostCoverageResponse);

        expect(response1, equals(response2));
        expect(response1.hashCode, equals(response2.hashCode));
      });

      test('two responses with different data are not equal', () {
        final response1 = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final response2 = response1.copyWith(amount: 9999);

        expect(response1, isNot(equals(response2)));
      });
    });

    group('toString', () {
      test('returns readable string representation', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);

        expect(response.toString(), contains('CostCoverageResponse'));
        expect(response.toString(), contains('applied: true'));
        expect(response.toString(), contains('amount: 4900'));
      });
    });
  });

  group('AdyenClient.applyCostCoverage', () {
    late AdyenClient adyenClient;
    late DioAdapter dioAdapter;

    const baseUrl = 'https://test.api.adyen.com';

    setUp(() {
      adyenClient = AdyenClient(baseUrl: baseUrl);
      dioAdapter = DioAdapter(dio: adyenClient.dio);
    });

    test('returns CostCoverageResponse when successful', () async {
      dioAdapter.onPost(
        '/apply-cost-coverage',
        data: {'invoice_id': 'A93106816983249', 'cost_coverage_code': 'INS-12345'},
        (server) => server.reply(200, mockCostCoverageResponse),
      );

      final response = await adyenClient.applyCostCoverage(
        invoiceId: 'A93106816983249',
        costCoverageCode: 'INS-12345',
      );

      expect(response, isA<CostCoverageResponse>());
      expect(response.applied, isTrue);
      expect(response.amount, equals(4900));
      expect(response.paymentInformation.invoiceId, equals('A93106816983249'));
    });

    test('verifies complete payment information after successful cost coverage', () async {
      dioAdapter.onPost(
        '/apply-cost-coverage',
        data: {'invoice_id': 'A93106816983249', 'cost_coverage_code': 'INS-12345'},
        (server) => server.reply(200, mockCostCoverageResponse),
      );

      final response = await adyenClient.applyCostCoverage(
        invoiceId: 'A93106816983249',
        costCoverageCode: 'INS-12345',
      );

      final payment = response.paymentInformation;
      expect(payment.invoiceId, equals('A93106816983249'));
      expect(payment.paymentStatus, equals(AdyenPaymentStatus.paid));
      expect(payment.amountDue, equals(4900));
      expect(payment.transactions.isNotEmpty, isTrue);
      expect(payment.transactions.first.isCostCoverage, isTrue);
      expect(payment.transactions.first.amount, equals(response.amount));
      expect(payment.baskets.isNotEmpty, isTrue);
      expect(payment.baskets.first.amountDue, equals(response.amount));
    });

    test('throws exception when request fails', () {
      dioAdapter.onPost(
        '/apply-cost-coverage',
        data: {'invoice_id': 'invalid-invoice', 'cost_coverage_code': 'INVALID'},
        (server) => server.reply(400, {'message': 'Invalid cost coverage code'}),
      );

      expect(
        () => adyenClient.applyCostCoverage(
          invoiceId: 'invalid-invoice',
          costCoverageCode: 'INVALID',
        ),
        throwsException,
      );
    });

    test('throws exception on server error', () {
      dioAdapter.onPost(
        '/apply-cost-coverage',
        data: {'invoice_id': 'A93106816983249', 'cost_coverage_code': 'INS-12345'},
        (server) => server.reply(500, {'message': 'Internal Server Error'}),
      );

      expect(
        () => adyenClient.applyCostCoverage(
          invoiceId: 'A93106816983249',
          costCoverageCode: 'INS-12345',
        ),
        throwsException,
      );
    });
  });
}

final mockCostCoverageResponse = {
  'applied': true,
  'amount': 4900,
  'payment': {
    'invoice_id': 'A93106816983249',
    'email': 'test@example.com',
    'first_name': 'John',
    'last_name': 'Doe',
    'payment_status': 'paid',
    'product_type': 'prescription',
    'zid': 'Z123',
    'amount_due': 4900,
    'provider': 'adyen',
    'created_at': '2025-12-08T10:30:00.000Z',
    'meta_data': '{}',
    'updated_at': '2025-12-08T10:30:00.000Z',
    'is_five_gram': false,
    'reverse_transfers': false,
    'product_types': ['prescription'],
    'baskets': [
      {
        'id': 789,
        'order_id': null,
        'replaces_basket': false,
        'amount_due': 4900,
        'created_at': '2025-12-08T10:30:00.000Z',
        'updated_at': '2025-12-08T10:30:00.000Z',
        'invoice_id': 'A93106816983249',
        'amount_total_discount': 0,
        'amount_total_gross': 4900,
        'title': 'Prescription',
        'sub_title': 'Cost Coverage',
        'active': true,
        'items': [],
      },
    ],
    'transactions': [
      {
        'id': 12345,
        'created_at': '2025-12-08T10:30:00.000Z',
        'updated_at': '2025-12-08T10:30:00.000Z',
        'payment_invoice_id': 'A93106816983249',
        'amount': 4900,
        'refund_amount': 0,
        'status': 'completed',
        'transaction_date': '2025-12-08T10:30:00.000Z',
        'type': 'cost_coverage',
        // 'cost_coverage_code': 'INS-12345',
        // 'discount_amount_cents': 100,
        // 'final_amount_cents': 1000,
        'method': null,
        'psp_number': 'NA',
        'basket_id': 789,
        'transfer_id': null,
        'cost_coverage': {
          "id": 8,
          "createdAt": "2026-01-08T10:10:50.851Z",
          "updatedAt": "2026-01-08T10:10:50.851Z",
          "code": "INS-12345",
          "amount": 100,
          "status": "completed",
          "invoice_id": "A43102150947240",
          "basket_id": 4,
        },
      },
    ],
  },
};
