import 'package:payment_client_api/payment_client_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('CostCoverageResponse', () {
    group('fromJson', () {
      test('parses full response correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);

        expect(response.applied, isTrue);
        expect(response.amount, equals(5000));
        expect(response.transaction, isA<CostCoverageTransaction>());
      });

      test('parses transaction fields correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final transaction = response.transaction;

        expect(transaction.id, equals(12345));
        expect(transaction.paymentInvoiceId, equals('A93106816983249'));
        expect(transaction.amount, equals(5000));
        expect(transaction.status, equals('completed'));
        expect(transaction.transactionDate, equals('2025-12-08T10:30:00.000Z'));
        expect(transaction.type, equals('cost_coverage'));
        expect(transaction.method, isNull);
        expect(transaction.pspNumber, equals('NA'));
        expect(transaction.costCoverageCode, equals('INS-12345'));
        expect(transaction.basketId, equals(789));
        expect(transaction.transferId, isNull);
      });

      test('parses intendedSubMerchantShares correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final shares = response.transaction.intendedSubMerchantShares;

        expect(shares, isNotNull);
        expect(shares!.length, equals(2));

        expect(shares[0].id, equals(1));
        expect(shares[0].amount, equals(1500));
        expect(shares[0].subMerchantResourceId, equals('BW-123'));
        expect(shares[0].subMerchant?.type, equals('bloom'));

        expect(shares[1].id, equals(2));
        expect(shares[1].amount, equals(8500));
        expect(shares[1].subMerchantResourceId, equals('PHM-456'));
        expect(shares[1].subMerchant?.type, equals('pharmacy'));
      });

      test('parses appliedSubMerchantShares correctly', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final shares = response.transaction.appliedSubMerchantShares;

        expect(shares, isNotNull);
        expect(shares!.length, equals(2));

        expect(shares[0].id, equals(3));
        expect(shares[0].amount, equals(0));
        expect(shares[0].subMerchantResourceId, equals('BW-123'));

        expect(shares[1].id, equals(4));
        expect(shares[1].amount, equals(0));
        expect(shares[1].subMerchantResourceId, equals('PHM-456'));
      });

      test('handles null sub merchant shares', () {
        final json = {
          'applied': true,
          'amount': 1000,
          'transaction': {
            'id': 1,
            'payment_invoice_id': 'INV-001',
            'amount': 1000,
            'status': 'completed',
            'transaction_date': '2025-12-08T10:30:00.000Z',
            'type': 'cost_coverage',
            'basket_id': 100,
          },
        };

        final response = CostCoverageResponse.fromJson(json);

        expect(response.transaction.intendedSubMerchantShares, isNull);
        expect(response.transaction.appliedSubMerchantShares, isNull);
      });
    });

    group('copyWith', () {
      test('creates copy with updated applied field', () {
        final response = CostCoverageResponse.fromJson(mockCostCoverageResponse);
        final copy = response.copyWith(applied: false);

        expect(copy.applied, isFalse);
        expect(copy.amount, equals(response.amount));
        expect(copy.transaction, equals(response.transaction));
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
        expect(response.toString(), contains('amount: 5000'));
      });
    });
  });

  group('SubMerchantShare', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 1,
        'amount': 1500,
        'sub_merchant_resource_id': 'BW-123',
        'subMerchant': {'type': 'bloom'},
      };

      final share = SubMerchantShare.fromJson(json);

      expect(share.id, equals(1));
      expect(share.amount, equals(1500));
      expect(share.subMerchantResourceId, equals('BW-123'));
      expect(share.subMerchant?.type, equals('bloom'));
    });

    test('fromJson handles null subMerchant', () {
      final json = {'id': 1, 'amount': 1500, 'sub_merchant_resource_id': 'BW-123'};

      final share = SubMerchantShare.fromJson(json);

      expect(share.subMerchant, isNull);
    });

    test('copyWith creates updated copy', () {
      const share = SubMerchantShare(
        id: 1,
        amount: 1500,
        subMerchantResourceId: 'BW-123',
      );
      final copy = share.copyWith(amount: 2000);

      expect(copy.id, equals(1));
      expect(copy.amount, equals(2000));
      expect(copy.subMerchantResourceId, equals('BW-123'));
    });
  });

  group('SubMerchant', () {
    test('fromJson parses correctly', () {
      final json = {'type': 'pharmacy'};
      final subMerchant = SubMerchant.fromJson(json);

      expect(subMerchant.type, equals('pharmacy'));
    });

    test('toJson serializes correctly', () {
      const subMerchant = SubMerchant(type: 'bloom');
      final json = subMerchant.toJson();

      expect(json, equals({'type': 'bloom'}));
    });

    test('equality works correctly', () {
      const subMerchant1 = SubMerchant(type: 'bloom');
      const subMerchant2 = SubMerchant(type: 'bloom');
      const subMerchant3 = SubMerchant(type: 'pharmacy');

      expect(subMerchant1, equals(subMerchant2));
      expect(subMerchant1, isNot(equals(subMerchant3)));
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
      expect(response.amount, equals(5000));
      expect(response.transaction.id, equals(12345));
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
  'amount': 5000,
  'transaction': {
    'id': 12345,
    'payment_invoice_id': 'A93106816983249',
    'amount': 5000,
    'status': 'completed',
    'transaction_date': '2025-12-08T10:30:00.000Z',
    'type': 'cost_coverage',
    'method': null,
    'psp_number': 'NA',
    'cost_coverage_code': 'INS-12345',
    'basket_id': 789,
    'transfer_id': null,
    'intendedSubMerchantShares': [
      {
        'id': 1,
        'amount': 1500,
        'sub_merchant_resource_id': 'BW-123',
        'subMerchant': {'type': 'bloom'},
      },
      {
        'id': 2,
        'amount': 8500,
        'sub_merchant_resource_id': 'PHM-456',
        'subMerchant': {'type': 'pharmacy'},
      },
    ],
    'appliedSubMerchantShares': [
      {
        'id': 3,
        'amount': 0,
        'sub_merchant_resource_id': 'BW-123',
        'subMerchant': {'type': 'bloom'},
      },
      {
        'id': 4,
        'amount': 0,
        'sub_merchant_resource_id': 'PHM-456',
        'subMerchant': {'type': 'pharmacy'},
      },
    ],
  },
};
