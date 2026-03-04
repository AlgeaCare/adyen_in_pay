import 'package:payment_client_api/payment_client_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('CostCoverageResponse', () {
    group('fromJson', () {
      test('parses full response correctly', () {
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );

        expect(response.applied, isTrue);
        expect(response.amount, equals(4900));
        expect(response.paymentInformation, isA<PaymentInformation>());
      });

      test('parses payment information fields correctly', () {
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
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
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
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
        expect(
          transactions[0].transactionDate,
          equals('2025-12-08T10:30:00.000Z'),
        );
      });

      test('parses cost coverage transaction fields correctly', () {
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
        final transaction = response.paymentInformation.transactions[0];
        final hasCostCoverage = response.paymentInformation.hasCostCoverage;
        expect(hasCostCoverage, isTrue);
        expect(transaction.costCoverage, isNotNull);
        expect(transaction.costCoverage!.code, equals('INS-12345'));
        expect(transaction.costCoverage!.status, equals('completed'));
      });

      test('verifies transaction is linked to basket and invoice', () {
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
        final transaction = response.paymentInformation.transactions[0];
        final basket = response.paymentInformation.baskets[0];

        expect(transaction.basketId, equals(basket.id));
        expect(
          transaction.paymentInvoiceId,
          equals(response.paymentInformation.invoiceId),
        );
        expect(basket.invoiceId, equals(response.paymentInformation.invoiceId));
      });

      test('verifies payment status after cost coverage', () {
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
        final payment = response.paymentInformation;

        expect(payment.paymentStatus, equals(AdyenPaymentStatus.paid));
        expect(response.applied, isTrue);
        expect(payment.transactions.isNotEmpty, isTrue);
        expect(payment.transactions.first.isCostCoverage, isTrue);
      });

      test('parses baskets correctly', () {
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
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
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
        final copy = response.copyWith(applied: false);

        expect(copy.applied, isFalse);
        expect(copy.amount, equals(response.amount));
        expect(copy.paymentInformation, equals(response.paymentInformation));
      });

      test('creates copy with updated amount field', () {
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
        final copy = response.copyWith(amount: 9999);

        expect(copy.applied, equals(response.applied));
        expect(copy.amount, equals(9999));
      });
    });

    group('equality', () {
      test('two responses with same data are equal', () {
        final response1 = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
        final response2 = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );

        expect(response1, equals(response2));
        expect(response1.hashCode, equals(response2.hashCode));
      });

      test('two responses with different data are not equal', () {
        final response1 = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );
        final response2 = response1.copyWith(amount: 9999);

        expect(response1, isNot(equals(response2)));
      });
    });

    group('toString', () {
      test('returns readable string representation', () {
        final response = CostCoverageResponse.fromJson(
          mockCostCoverageResponse,
        );

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
        data: {
          'invoiceId': 'A93106816983249',
          'costCoverageCode': 'INS-12345',
        },
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

    test(
      'verifies complete payment information after successful cost coverage',
      () async {
        dioAdapter.onPost(
          '/apply-cost-coverage',
          data: {
            'invoiceId': 'A93106816983249',
            'costCoverageCode': 'INS-12345',
          },
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
      },
    );

    test('throws exception when request fails', () {
      dioAdapter.onPost(
        '/apply-cost-coverage',
        data: {
          'invoice_id': 'invalid-invoice',
          'cost_coverage_code': 'INVALID',
        },
        (server) =>
            server.reply(400, {'message': 'Invalid cost coverage code'}),
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
        data: {
          'invoice_id': 'A93106816983249',
          'cost_coverage_code': 'INS-12345',
        },
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

  group('AdyenClient.removeCostCoverage', () {
    late AdyenClient adyenClient;
    late DioAdapter dioAdapter;

    const baseUrl = 'https://test.api.adyen.com';

    setUp(() {
      adyenClient = AdyenClient(baseUrl: baseUrl);
      dioAdapter = DioAdapter(dio: adyenClient.dio);
    });

    test('returns PaymentInformation when successfully removed', () async {
      dioAdapter.onPost(
        '/remove-cost-coverage',
        data: {'invoice_id': 'A93106816983249'},
        (server) => server.reply(200, mockRemoveCostCoverageResponse),
      );

      final response = await adyenClient.removeCostCoverage(
        invoiceId: 'A93106816983249',
      );

      expect(response, isA<PaymentInformation>());
      expect(response.invoiceId, equals('A93106816983249'));
      expect(response.paymentStatus, equals(AdyenPaymentStatus.pending));
      expect(response.amountDue, equals(4900));
    });

    test('verifies payment information after cost coverage removal', () async {
      dioAdapter.onPost(
        '/remove-cost-coverage',
        data: {'invoice_id': 'A93106816983249'},
        (server) => server.reply(200, mockRemoveCostCoverageResponse),
      );

      final response = await adyenClient.removeCostCoverage(
        invoiceId: 'A93106816983249',
      );

      expect(response.transactions.isNotEmpty, isTrue);
      expect(response.transactions.length, equals(2));
      expect(
        response.transactions.first.costCoverage?.status,
        equals('completed'),
      );
      expect(
        response.transactions.last.costCoverage?.status,
        equals('replaced'),
      );
      expect(response.hasCostCoverage, isFalse);
      expect(response.baskets.isNotEmpty, isTrue);
      expect(response.baskets.first.amountDue, equals(4900));
    });

    test('throws exception when removed field is false', () {
      dioAdapter.onPost(
        '/remove-cost-coverage',
        data: {'invoice_id': 'A93106816983249'},
        (server) => server.reply(200, {
          'removed': false,
          'payment': mockPaymentInformationJson,
        }),
      );

      expect(
        () => adyenClient.removeCostCoverage(
          invoiceId: 'A93106816983249',
        ),
        throwsException,
      );
    });

    test('throws exception when removed field is missing', () {
      dioAdapter.onPost(
        '/remove-cost-coverage',
        data: {'invoice_id': 'A93106816983249'},
        (server) => server.reply(200, {
          'payment': mockPaymentInformationJson,
        }),
      );

      expect(
        () => adyenClient.removeCostCoverage(
          invoiceId: 'A93106816983249',
        ),
        throwsException,
      );
    });

    test('throws exception when request fails with 400', () {
      dioAdapter.onPost(
        '/remove-cost-coverage',
        data: {'invoice_id': 'invalid-invoice'},
        (server) => server.reply(400, {'message': 'Invalid invoice ID'}),
      );

      expect(
        () => adyenClient.removeCostCoverage(
          invoiceId: 'invalid-invoice',
        ),
        throwsException,
      );
    });

    test('throws exception on server error', () {
      dioAdapter.onPost(
        '/remove-cost-coverage',
        data: {'invoice_id': 'A93106816983249'},
        (server) => server.reply(500, {'message': 'Internal Server Error'}),
      );

      expect(
        () => adyenClient.removeCostCoverage(
          invoiceId: 'A93106816983249',
        ),
        throwsException,
      );
    });

    test('throws exception when response data is null', () {
      dioAdapter.onPost(
        '/remove-cost-coverage',
        data: {'invoice_id': 'A93106816983249'},
        (server) => server.reply(200, null),
      );

      expect(
        () => adyenClient.removeCostCoverage(
          invoiceId: 'A93106816983249',
        ),
        throwsException,
      );
    });
  });

  group('PaymentInformation.hasCostCoverage', () {
    test(
      'returns true when only completed cost coverage transaction exists',
      () {
        final paymentInfo = PaymentInformation.fromJson({
          ...mockBasePaymentJson,
          'transactions': [mockCompletedCostCoverageTransaction],
        });

        expect(paymentInfo.hasCostCoverage, isTrue);
      },
    );

    test(
      'returns false when only replaced cost coverage transaction exists',
      () {
        final paymentInfo = PaymentInformation.fromJson({
          ...mockBasePaymentJson,
          'transactions': [mockReplacedCostCoverageTransaction],
        });

        expect(paymentInfo.hasCostCoverage, isFalse);
      },
    );

    test('returns false when completed then replaced (latest is replaced)', () {
      final paymentInfo = PaymentInformation.fromJson({
        ...mockBasePaymentJson,
        'transactions': [
          mockCompletedCostCoverageTransaction,
          mockReplacedCostCoverageTransaction,
        ],
      });

      expect(paymentInfo.hasCostCoverage, isFalse);
    });

    test(
      'returns true when completed then replaced then completed (latest is completed)',
      () {
        final paymentInfo = PaymentInformation.fromJson({
          ...mockBasePaymentJson,
          'transactions': [
            mockCompletedCostCoverageTransaction,
            mockReplacedCostCoverageTransaction,
            mockSecondCompletedCostCoverageTransaction,
          ],
        });

        expect(paymentInfo.hasCostCoverage, isTrue);
      },
    );

    test('returns false when no transactions exist', () {
      final paymentInfo = PaymentInformation.fromJson({
        ...mockBasePaymentJson,
        'transactions': <Map<String, dynamic>>[],
      });

      expect(paymentInfo.hasCostCoverage, isFalse);
    });

    test(
      'returns false when transactions exist but none are cost_coverage type',
      () {
        final paymentInfo = PaymentInformation.fromJson({
          ...mockBasePaymentJson,
          'transactions': [mockNonCostCoverageTransaction],
        });

        expect(paymentInfo.hasCostCoverage, isFalse);
      },
    );

    test(
      'returns false when cost_coverage transaction has no costCoverage object',
      () {
        final paymentInfo = PaymentInformation.fromJson({
          ...mockBasePaymentJson,
          'transactions': [
            mockCostCoverageTransactionWithoutCostCoverageObject,
          ],
        });

        expect(paymentInfo.hasCostCoverage, isFalse);
      },
    );
  });

  group('PaymentInformation.fromJson payload compatibility', () {
    test(
      'parses payload without product_types and with snake_case cost_coverage',
      () {
        final paymentInfo = PaymentInformation.fromJson(
          mockAppliedCostCoverageResponse['payment'] as Map<String, dynamic>,
        );

        expect(paymentInfo.invoiceId, equals('A08380190590506'));
        expect(paymentInfo.productType, equals('pharmacy_order'));
        expect(paymentInfo.productTypes, equals(['pharmacy_order']));
        expect(paymentInfo.amountDue, equals(12980));
        expect(paymentInfo.transactions.length, equals(3));
        expect(paymentInfo.hasCostCoverage, isTrue);

        final costCoverageTransaction = paymentInfo.transactions.firstWhere(
          (transaction) => transaction.type == 'cost_coverage',
        );
        expect(costCoverageTransaction.costCoverage, isNotNull);
        expect(costCoverageTransaction.costCoverage!.code, equals('CC_10'));
        expect(
          costCoverageTransaction.costCoverage!.discountAmount,
          equals(1000),
        );

        final costCoverageAmount = paymentInfo.costCoverageAmount;
        expect(costCoverageAmount, isNotNull);
        expect(costCoverageAmount!.discountAmount, equals(1000));
        expect(costCoverageAmount.code, equals('CC_10'));
      },
    );

    test('keeps amount due from top-level cost coverage response', () {
      final response = CostCoverageResponse.fromJson(
        mockAppliedCostCoverageResponse,
      );

      expect(response.applied, isTrue);
      expect(response.amount, equals(1000));
      expect(response.paymentInformation.amountDue, equals(12980));
    });
  });
}

final mockPaymentInformationJson = {
  'invoice_id': 'A93106816983249',
  'email': 'test@example.com',
  'first_name': 'John',
  'last_name': 'Doe',
  'payment_status': 'pending',
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
      'sub_title': 'Pending Payment',
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
      'method': null,
      'psp_number': 'NA',
      'basket_id': 789,
      'transfer_id': null,
      'cost_coverage': {
        'id': 8,
        'createdAt': '2026-01-08T10:10:50.851Z',
        'updatedAt': '2026-01-08T10:10:50.851Z',
        'code': 'INS-12345',
        'amount': 4900,
        'status': 'completed',
        'invoice_id': 'A93106816983249',
        'basket_id': 789,
      },
    },
    {
      'id': 12346,
      'created_at': '2025-12-08T11:30:00.000Z',
      'updated_at': '2025-12-08T11:30:00.000Z',
      'payment_invoice_id': 'A93106816983249',
      'amount': 4900,
      'refund_amount': 0,
      'status': 'replaced',
      'transaction_date': '2025-12-08T11:30:00.000Z',
      'type': 'cost_coverage',
      'method': null,
      'psp_number': 'NA',
      'basket_id': 789,
      'transfer_id': null,
      'cost_coverage': {
        'id': 9,
        'createdAt': '2026-01-08T11:10:50.851Z',
        'updatedAt': '2026-01-08T11:10:50.851Z',
        'code': 'INS-12345',
        'amount': 4900,
        'status': 'replaced',
        'invoice_id': 'A93106816983249',
        'basket_id': 789,
      },
    },
  ],
};

final mockRemoveCostCoverageResponse = {
  'removed': true,
  'payment': mockPaymentInformationJson,
};

final mockCostCoverageResponse = {
  'applied': true,
  'amount': 4900,
  'amount_due': 4900,
  'payment': {
    'invoice_id': 'A93106816983249',
    'email': 'test@example.com',
    'first_name': 'John',
    'last_name': 'Doe',
    'payment_status': 'paid',
    'product_type': 'prescription',
    'zid': 'Z123',
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

final mockBasePaymentJson = {
  'invoice_id': 'A93106816983249',
  'email': 'test@example.com',
  'first_name': 'John',
  'last_name': 'Doe',
  'payment_status': 'pending',
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
      'sub_title': 'Pending Payment',
      'active': true,
      'items': [],
    },
  ],
};

final mockCompletedCostCoverageTransaction = {
  'id': 12345,
  'created_at': '2025-12-08T10:30:00.000Z',
  'updated_at': '2025-12-08T10:30:00.000Z',
  'payment_invoice_id': 'A93106816983249',
  'amount': 4900,
  'refund_amount': 0,
  'status': 'completed',
  'transaction_date': '2025-12-08T10:30:00.000Z',
  'type': 'cost_coverage',
  'method': null,
  'psp_number': 'NA',
  'basket_id': 789,
  'transfer_id': null,
  'cost_coverage': {
    'id': 8,
    'createdAt': '2026-01-08T10:10:50.851Z',
    'updatedAt': '2026-01-08T10:10:50.851Z',
    'code': 'INS-12345',
    'amount': 4900,
    'status': 'completed',
    'invoice_id': 'A93106816983249',
    'basket_id': 789,
  },
};

final mockReplacedCostCoverageTransaction = {
  'id': 12346,
  'created_at': '2025-12-08T11:30:00.000Z',
  'updated_at': '2025-12-08T11:30:00.000Z',
  'payment_invoice_id': 'A93106816983249',
  'amount': 4900,
  'refund_amount': 0,
  'status': 'replaced',
  'transaction_date': '2025-12-08T11:30:00.000Z',
  'type': 'cost_coverage',
  'method': null,
  'psp_number': 'NA',
  'basket_id': 789,
  'transfer_id': null,
  'cost_coverage': {
    'id': 9,
    'createdAt': '2026-01-08T11:10:50.851Z',
    'updatedAt': '2026-01-08T11:10:50.851Z',
    'code': 'INS-12345',
    'amount': 4900,
    'status': 'replaced',
    'invoice_id': 'A93106816983249',
    'basket_id': 789,
  },
};

final mockSecondCompletedCostCoverageTransaction = {
  'id': 12347,
  'created_at': '2025-12-08T12:30:00.000Z',
  'updated_at': '2025-12-08T12:30:00.000Z',
  'payment_invoice_id': 'A93106816983249',
  'amount': 4900,
  'refund_amount': 0,
  'status': 'completed',
  'transaction_date': '2025-12-08T12:30:00.000Z',
  'type': 'cost_coverage',
  'method': null,
  'psp_number': 'NA',
  'basket_id': 789,
  'transfer_id': null,
  'cost_coverage': {
    'id': 10,
    'createdAt': '2026-01-08T12:10:50.851Z',
    'updatedAt': '2026-01-08T12:10:50.851Z',
    'code': 'INS-67890',
    'amount': 4900,
    'status': 'completed',
    'invoice_id': 'A93106816983249',
    'basket_id': 789,
  },
};

final mockNonCostCoverageTransaction = {
  'id': 12348,
  'created_at': '2025-12-08T10:30:00.000Z',
  'updated_at': '2025-12-08T10:30:00.000Z',
  'payment_invoice_id': 'A93106816983249',
  'amount': 4900,
  'refund_amount': 0,
  'status': 'completed',
  'transaction_date': '2025-12-08T10:30:00.000Z',
  'type': 'payment',
  'method': 'card',
  'psp_number': 'PSP123',
  'basket_id': 789,
  'transfer_id': null,
};

final mockCostCoverageTransactionWithoutCostCoverageObject = {
  'id': 12349,
  'created_at': '2025-12-08T10:30:00.000Z',
  'updated_at': '2025-12-08T10:30:00.000Z',
  'payment_invoice_id': 'A93106816983249',
  'amount': 4900,
  'refund_amount': 0,
  'status': 'completed',
  'transaction_date': '2025-12-08T10:30:00.000Z',
  'type': 'cost_coverage',
  'method': null,
  'psp_number': 'NA',
  'basket_id': 789,
  'transfer_id': null,
  'cost_coverage': null,
};

final mockAppliedCostCoverageResponse = {
  'applied': true,
  'amount': 1000,
  'amount_due': 12980,
  'payment': {
    'invoice_id': 'A08380190590506',
    'provider': 'adyen',
    'email': 'sabina.lauth+stg11@bloomwell.de',
    'first_name': 'Sabina',
    'last_name': 'elf',
    'payment_status': 'pending',
    'completed_at': null,
    'completed_at_first': null,
    'product_type': 'pharmacy_order',
    'zid': 'Z16269763975460',
    'meta_data': '{}',
    'warnings': null,
    'hs_id': '413922335975',
    'comment': null,
    'reminder_date': null,
    'next_reminder': null,
    'preferred_method': 'online',
    'ignored_items': null,
    'created_at': '2026-03-04T12:56:29.863Z',
    'updated_at': '2026-03-04T13:00:14.504Z',
    'payment_id': null,
    'voucher_code': null,
    'invoice_url': null,
    'is_five_gram': false,
    'reverse_transfers': true,
    'adyen_ignore_fixed_share': false,
    'adyen_no_payment_just_share': false,
    'has_active_chargeback': false,
    'chargeback_status': null,
    'chargeback_reason': null,
    'chargeback_created_at': null,
    'has_dispute': false,
    'dispute_created_at': null,
    'pause_chargeback_reminder': false,
    'is_adjustment': false,
    'amount_due': 12980,
    'baskets': [
      {
        'id': 15,
        'invoice_id': 'A08380190590506',
        'amount_total_discount': 0,
        'amount_total_gross': 13980,
        'title': 'Pharmacy Order',
        'sub_title': '1918745020532613120/A-RIDXUSJYUB',
        'product_type': 'pharmacy_order',
        'resource_id': '413922335975',
        'order_id': '1918745020532613120',
        'sub_merchant_resource_id': '1844870509653671936',
        'active': true,
        'replaces_basket': false,
        'amount_due': 13980,
        'created_at': '2026-03-04T12:56:29.863Z',
        'updated_at': '2026-03-04T12:56:30.170Z',
        'telephone_consultation': false,
        'prescription_created': false,
        'cancellation_fee': false,
        'appointment_noshow': false,
        'items': [
          {
            'id': 29,
            'basket_id': 15,
            'basket_item_reference_id': '1852418248145739776',
            'quantity': 20,
            'amount_discount': 0,
            'amount_gross': 13980,
            'amount_per_unit': 699,
            'amount_net': 13980,
            'title': 'Green Bliss OG',
            'sub_title': 'White Lemon X Marakabei Local',
            'type': '',
            'image_url': '',
            'created_at': '0001-01-01T00:00:00.000Z',
            'updated_at': '0001-01-01T00:00:00.000Z',
          },
          {
            'id': 30,
            'basket_id': 15,
            'basket_item_reference_id': 'shippingFee',
            'quantity': 1,
            'amount_discount': 0,
            'amount_gross': 0,
            'amount_per_unit': 0,
            'amount_net': 0,
            'title': 'DHL',
            'sub_title': '',
            'type': '',
            'image_url': '',
            'created_at': '0001-01-01T00:00:00.000Z',
            'updated_at': '0001-01-01T00:00:00.000Z',
          },
        ],
      },
    ],
    'transactions': [
      {
        'id': 23,
        'psp_status': null,
        'created_at': '2026-03-04T13:01:21.247Z',
        'updated_at': '2026-03-04T13:01:21.247Z',
        'payment_invoice_id': 'A08380190590506',
        'amount': 12980,
        'refund_amount': 0,
        'status': 'initiated',
        'transaction_date': '2026-03-04T13:01:21.246Z',
        'type': 'payment',
        'method': null,
        'psp_number': 'NA',
        'capture_psp_number': null,
        'dispute_metadata': null,
        'basket_id': 15,
        'transfer_id': null,
        'transaction_id': 17,
        'cost_coverage_id': null,
      },
      {
        'id': 22,
        'psp_status': null,
        'created_at': '2026-03-04T13:01:21.247Z',
        'updated_at': '2026-03-04T13:01:21.247Z',
        'payment_invoice_id': 'A08380190590506',
        'amount': 1000,
        'refund_amount': 0,
        'status': 'pending',
        'transaction_date': '2026-03-04T13:01:21.246Z',
        'type': 'cost_coverage',
        'method': null,
        'psp_number': 'NA',
        'capture_psp_number': null,
        'dispute_metadata': null,
        'basket_id': 15,
        'transfer_id': null,
        'transaction_id': null,
        'cost_coverage_id': 4,
        'cost_coverage': {
          'id': 4,
          'createdAt': '2026-03-04T13:01:21.247Z',
          'updatedAt': '2026-03-04T13:01:21.247Z',
          'code': 'CC_10',
          'amount': 1000,
          'status': 'pending',
          'invoice_id': 'A08380190590506',
          'basket_id': 15,
        },
      },
      {
        'id': 17,
        'psp_status': null,
        'created_at': '2026-03-04T12:56:29.901Z',
        'updated_at': '2026-03-04T13:01:21.247Z',
        'payment_invoice_id': 'A08380190590506',
        'amount': 13980,
        'refund_amount': 0,
        'status': 'replaced',
        'transaction_date': '2026-03-04T12:56:29.893Z',
        'type': 'payment',
        'method': null,
        'psp_number': 'NA',
        'capture_psp_number': null,
        'dispute_metadata': null,
        'basket_id': 15,
        'transfer_id': null,
        'transaction_id': null,
        'cost_coverage_id': null,
      },
    ],
  },
};
