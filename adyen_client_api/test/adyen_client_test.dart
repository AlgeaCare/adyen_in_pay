import 'package:payment_client_api/payment_client_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late AdyenClient adyenClient;
  late DioAdapter dioAdapter;

  const baseUrl = 'http://localhost:8080';

  setUp(() {
    adyenClient = AdyenClient(baseUrl: baseUrl);
    dioAdapter = DioAdapter(dio: adyenClient.dio);

    dioAdapter.onGet(
      '$baseUrl/payments/startSession',
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
              'brand': ['visa', 'mc'],
            },
          ],
        };
        dioAdapter.onPost(
          '/methods',
          data: {},
          (server) => server.reply(
            200,
            mockResponse,
            // Reply would wait for one-sec before returning data.
            delay: const Duration(seconds: 1),
          ),
        );

        final response = await adyenClient.getPaymentMethods(data: {});

        expect(response, isA<PaymentMethodResponse>());
        expect(response.paymentMethods.length, equals(1));
        expect(response.paymentMethods.first.type, equals('scheme'));
      });

      test('throws exception when request fails', () {
        dioAdapter.onPost(
          '/methods',
          data: {},
          (server) => server.reply(
            500,
            {'message': 'Server Error'},
            // Reply would wait for one-sec before returning data.
            delay: const Duration(seconds: 1),
          ),
        );
        expect(() => adyenClient.getPaymentMethods(data: {}), throwsException);
      });
    });

    group('makePayment', () {
      test('returns PaymentResponse when successful', () async {
        final mockResponse = {
          'pspReference': 'test-psp-ref',
          'resultCode': 'Authorised',
          'amount': {'value': 1000, 'currency': 'EUR'},
          'merchantReference': 'test-merchant-ref',
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
          paymentStatus: AdyenPaymentStatus.paid,
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
          transactions: [],
        );
        final extraData = paymentRequest.toJson();
        extraData['browserInfo'] = {'userAgent': 'test-user-agent'};

        final dataRequest = paymentInformation.toPaymentDataJson()..addAll(extraData);
        dioAdapter.onPost(
          '/make-payment',
          data: {
            'payment': {'invoiceId': paymentInformation.invoiceId},
            'provider': dataRequest,
          },
          (server) => server.reply(
            200,
            mockResponse,
            // Reply would wait for one-sec before returning data.
            delay: const Duration(seconds: 1),
          ),
        );

        final response = await adyenClient.makePayment(
          paymentInformation,
          paymentRequest.toJson(),
          userAgent: 'test-user-agent',
        );

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
          paymentStatus: AdyenPaymentStatus.paid,
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
          transactions: [],
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
  test('test parse payment response', () async {
    final paymentResponse = PaymentResponse.fromJson(mockResponse2);
    expect(paymentResponse, isA<PaymentResponse>());
    expect(paymentResponse.resultCode, PaymentResultCode.authorised);
    expect(paymentResponse.pspReference, equals('WGXGLBM9SRW6VLG3'));
    expect(paymentResponse.amount, isA<SessionAmount>());
    expect(paymentResponse.amount?.value, isA<int>());
    expect(paymentResponse.amount?.value, 1000);
    expect(paymentResponse.amount?.currency, 'EUR');
    expect(paymentResponse.merchantReference, equals('A32814019647000'));
  });
  test('test parse apple payment response 3', () async {
    final paymentResponse = PaymentResponse.fromJson(mockResponse3);
    expect(paymentResponse, isA<PaymentResponse>());
    expect(paymentResponse.resultCode, PaymentResultCode.authorised);
    expect(paymentResponse.resultCode.label, PaymentResultCode.authorised.label);
    expect(paymentResponse.pspReference, equals('C8T2BNG6NVTV7VV5'));
    expect(paymentResponse.amount, isA<SessionAmount>());
    expect(paymentResponse.amount?.value, isA<int>());
    expect(paymentResponse.amount?.value, 1995);
    expect(paymentResponse.amount?.currency, 'EUR');
    expect(paymentResponse.merchantReference, equals('A10549107469739'));
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
  'shopperLocale': 'en-US',
};
final mockResponse2 = {
  "additionalData": {"cardFunction": "Consumer", "isCardCommercial": "false"},
  "amount": {"currency": "EUR", "value": 1000},
  "merchantReference": "A32814019647000",
  "paymentMethod": {"brand": "visa_applepay", "type": "applepay"},
  "pspReference": "WGXGLBM9SRW6VLG3",
  "resultCode": "Authorised",
};

final mockResponse3 = {
  "additionalData": {
    "paymentMethod": "mc_applepay",
    "networkTxReference": "Z0CEOTKJ00924",
    "isCardCommercial": "unknown",
  },
  "amount": {"currency": "EUR", "value": 1995},
  "merchantReference": "A10549107469739",
  "paymentMethod": {"brand": "mc_applepay", "type": "applepay"},
  "pspReference": "C8T2BNG6NVTV7VV5",
  "resultCode": "Authorised",
};
