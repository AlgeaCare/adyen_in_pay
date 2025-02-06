import 'dart:convert';
import 'package:adyen_client_api/adyen_client_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([http.Client])
import 'adyen_client_test.mocks.dart' as mock;

void main() {
  late mock.MockClient mockHttpClient;
  late AdyenClient adyenClient;
  const baseUrl = 'https://test.api.adyen.com';

  setUp(() {
    mockHttpClient = mock.MockClient();
    adyenClient = AdyenClient(baseUrl: baseUrl);
  });

  group('AdyenClient', () {
    group('startSession', () {
      test('returns SessionResponse when successful', () async {
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

        when(mockHttpClient.get(
          Uri.parse('$baseUrl/startSession').replace(
            queryParameters: {
              'amount': '1000',
              'reference': 'test-reference',
              'redirectURL': 'https://test.com/return',
            },
          ),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer(
            (_) async => http.Response(json.encode(mockResponse), 200));

        final response = await adyenClient.startSession(
          amount: 1000,
          reference: 'test-reference',
          redirectURL: 'https://test.com/return',
        );

        expect(response, isA<SessionResponse>());
        expect(response.id, equals('test-session-id'));
        expect(response.amount.value, equals(1000));
      });

      test('throws exception when request fails', () {
        when(mockHttpClient.get(
          Uri.http(""),
          headers: any,
        )).thenAnswer((_) async => http.Response('Server Error', 500));

        expect(
          () => adyenClient.startSession(
            amount: 1000,
            reference: 'test-reference',
            redirectURL: 'https://test.com/return',
          ),
          throwsException,
        );
      });
    });

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

        when(mockHttpClient.get(
          Uri.parse('$baseUrl/paymentMethod'),
          headers: {'Content-Type': 'application/json'},
        )).thenAnswer(
            (_) async => http.Response(json.encode(mockResponse), 200));

        final response = await adyenClient.getPaymentMethods();

        expect(response, isA<PaymentMethodResponse>());
        expect(response.paymentMethods.length, equals(1));
        expect(response.paymentMethods.first.type, equals('scheme'));
      });

      test('throws exception when request fails', () {
        when(mockHttpClient.get(
          Uri.http(""),
          headers: any,
        )).thenAnswer((_) async => http.Response('Server Error', 500));

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

        when(mockHttpClient.post(
          Uri.parse('$baseUrl/payments'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(paymentRequest.toJson()),
        )).thenAnswer(
            (_) async => http.Response(json.encode(mockResponse), 200));

        final response = await adyenClient.makePayment(paymentRequest);

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

        when(mockHttpClient.post(
          Uri.http(""),
          headers: any,
          body: any,
        )).thenAnswer((_) async => http.Response('Server Error', 500));

        expect(
          () => adyenClient.makePayment(paymentRequest),
          throwsException,
        );
      });
    });
  });
}
