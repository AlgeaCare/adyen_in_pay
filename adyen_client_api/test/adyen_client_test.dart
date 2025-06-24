import 'package:payment_client_api/payment_client_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late AdyenClient adyenClient;
  late DioAdapter dioAdapter;

  const baseUrl = 'https://test.api.adyen.com';

  setUp(() {
    adyenClient = AdyenClient(
      baseUrl: baseUrl,
    );
    dioAdapter = DioAdapter(dio: adyenClient.dio);

    dioAdapter.onGet(
      '$baseUrl/startSession',
      (server) => server.reply(
        200,
        {'message': 'Success!'},
        // Reply would wait for one-sec before returning data.
        delay: const Duration(seconds: 1),
      ),
    );
  });

  group('AdyenClient', () {
    group('getPaymentMethods', () {
      test('returns PaymentMethodResponse when successful', () async {
        final mockResponse = {
          'paymentMethods': [
            {
              'type': 'scheme',
              'name': 'Credit Card',
              'brand': ['visa', 'mc']
            }
          ]
        };
        dioAdapter.onPost(
          '/methods',
          (server) => server.reply(
            200,
            mockResponse,
            // Reply would wait for one-sec before returning data.
            delay: const Duration(seconds: 1),
          ),
        );

        final response = await adyenClient.getPaymentMethods();

        expect(response, isA<PaymentMethodResponse>());
        expect(response.paymentMethods.length, equals(1));
        expect(response.paymentMethods.first.type, equals('scheme'));
      });

      test('throws exception when request fails', () {
        dioAdapter.onPost(
          '/methods',
          (server) => server.reply(
            500,
            {'message': 'Server Error'},
            // Reply would wait for one-sec before returning data.
            delay: const Duration(seconds: 1),
          ),
        );
        expect(
          () => adyenClient.getPaymentMethods(),
          throwsException,
        );
      });
    });

    group('makePayment', () {
      test('returns PaymentResponse when successful', () async {
        final mockResponse = {
          'pspReference': 'test-psp-ref',
          'resultCode': 'Authorised',
          'amount': {'value': 1000, 'currency': 'EUR'},
          'merchantReference': 'test-merchant-ref'
        };

        final paymentRequest = PaymentRequest(
          amount: 1000,
          currency: 'EUR',
          reference: 'test-reference',
          redirectURL: 'https://test.com/return',
          paymentMethod: PaymentMethod(
            type: 'scheme',
            encryptedCardNumber: 'test-card-number',
            encryptedExpiryMonth: 'test-expiry-month',
            encryptedExpiryYear: 'test-expiry-year',
            encryptedSecurityCode: 'test-security-code',
            holderName: 'Test User',
          ),
        );
        final paymentInformation = PaymentInformation(
          invoiceId: 'test-invoice-id',
          email: 'test-email',
          firstName: 'Test',
          lastName: 'User',
          paymentStatus: PaymentStatus.paid,
          productType: 'Test Product',
          paymentId: 'test-payment-id',
          voucherCode: 'test-voucher-code',
          invoiceUrl: 'https://test.com/invoice',
          provider: PaymentProvider.adyen,
          zid: 'test-zid',
          hsId: 'test-hs-id',
          baskets: [],
          amountDue: 2500,
          createdAt: '2024-01-01T00:00:00Z',
          metaData: 'test-meta-data',
          updatedAt: '2024-01-01T00:00:00Z',
          isFiveGram: false,
          reverseTransfers: false,
          productTypes: ['test-product-type'],
        );

        dioAdapter.onPost(
          '/make-payment',
          data: paymentInformation.toPaymentDataJson()..addAll(paymentRequest.toJson()),
          (server) => server.reply(
            200,
            mockResponse,
            // Reply would wait for one-sec before returning data.
            delay: const Duration(seconds: 1),
          ),
        );

        final response = await adyenClient.makePayment(paymentInformation, paymentRequest.toJson());

        expect(response, isA<PaymentResponse>());
        expect(response.resultCode, equals(PaymentResultCode.authorised));
        expect(response.pspReference, equals('test-psp-ref'));
      });

      test('throws exception when request fails', () {
        final paymentRequest = PaymentRequest(
          amount: 1000,
          currency: 'EUR',
          reference: 'test-reference',
          redirectURL: 'https://test.com/return',
          paymentMethod: PaymentMethod(
            type: 'scheme',
            encryptedCardNumber: 'test-card-number',
            encryptedExpiryMonth: 'test-expiry-month',
            encryptedExpiryYear: 'test-expiry-year',
            encryptedSecurityCode: 'test-security-code',
            holderName: 'Test User',
          ),
        );
        final paymentInformation = PaymentInformation(
          invoiceId: 'test-invoice-id',
          email: 'test-email',
          firstName: 'Test',
          lastName: 'User',
          paymentStatus: PaymentStatus.paid,
          productType: 'Test Product',
          paymentId: 'test-payment-id',
          voucherCode: 'test-voucher-code',
          invoiceUrl: 'https://test.com/invoice',
          provider: PaymentProvider.adyen,
          zid: 'test-zid',
          hsId: 'test-hs-id',
          baskets: [],
          amountDue: 1500,
          createdAt: '2024-01-01T00:00:00Z',
          metaData: 'test-meta-data',
          updatedAt: '2024-01-01T00:00:00Z',
          isFiveGram: false,
          reverseTransfers: false,
          productTypes: ['test-product-type'],
        );
        dioAdapter.onPost(
          '/make-payment',
          data: paymentInformation.toPaymentDataJson()..addAll(paymentRequest.toJson()),
          (server) => server.reply(
            500,
            {'message': 'Server Error'},
            // Reply would wait for one-sec before returning data.
            delay: const Duration(seconds: 1),
          ),
        );

        expect(
          () => adyenClient.makePayment(paymentInformation, paymentRequest.toJson()),
          throwsException,
        );
      });
    });
  });
}

final mockResponse = {
  'amount': {'value': 1000, 'currency': 'EUR'},
  'countryCode': 'NL',
  'expiresAt': '2024-01-01T00:00:00Z',
  'id': 'test-session-id',
  'merchantAccount': 'TestMerchant',
  'mode': 'test',
  'reference': 'test-reference',
  'returnUrl': 'https://test.com/return',
  'sessionData': 'test-session-data',
  'shopperLocale': 'en-US'
};
