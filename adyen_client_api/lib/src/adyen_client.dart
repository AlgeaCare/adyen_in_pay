import 'package:payment_client_api/src/models/common.dart';
import 'package:payment_client_api/src/models/payments_page_response.dart';
import 'package:payment_client_api/src/models/payment_information.dart';
import 'package:payment_client_api/src/models/payment_response.dart';
import 'package:payment_client_api/src/models/payment_method_response.dart';
import 'package:payment_client_api/src/models/shopper_billing_address.dart'
    show ShopperBillingAddress;
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class AdyenClient {
  final String baseUrl;
  // final String apiKey;
  final Dio dio;
  AdyenClient({
    required this.baseUrl,
    List<Interceptor> interceptors = const [],
    //  required this.apiKey,
  }) : dio = Dio(BaseOptions(baseUrl: '$baseUrl/payments'))..interceptors.addAll(interceptors);

  Future<PaymentMethodResponse> getPaymentMethods({Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post<Map<String, dynamic>>('/methods', data: data!);

      if (response.statusCode == 200 && response.data != null) {
        return PaymentMethodResponse.fromJson(response.data!);
      } else {
        throw Exception('Failed to get payment methods: ${response.statusCode}');
      }
    } catch (e, trace) {
      debugPrint(trace.toString());
      debugPrint(e.toString());
      throw Exception('Error getting payment methods: $e');
    }
  }

  Future<VoucherApplied> applyVoucher(
      {required String invoiceId, required String voucherCode}) async {
    try {
      final response = await dio.post<Map<String, dynamic>>('/$invoiceId/apply-voucher',
          data: {'voucher_code': voucherCode});

      if (response.statusCode == 200 && response.data != null) {
        return (
          amountDue: response.data!['amount_due'] as int,
          applied: response.data!['applied'] as bool,
          discount: response.data!['discount'] as int,
        );
      } else {
        throw Exception('Failed to apply voucher: ${response.statusCode}');
      }
    } catch (e, trace) {
      debugPrint(trace.toString());
      debugPrint(e.toString());
      throw Exception('Error applying voucher: $e');
    }
  }

  Future<PaymentsPageResponse> getPayments(int page) async {
    try {
      final response =
          await dio.get<Map<String, dynamic>>('/', queryParameters: {'page': page, 'pageSize': 10});

      return PaymentsPageResponse.fromJson(response.data!);
    } catch (e, trace) {
      throw Exception('Error getting payments: $e,$trace');
    }
  }

  Future<PaymentInformation> paymentInformation({
    required String invoiceId,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        '/$invoiceId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return PaymentInformation.fromJson(response.data!);
      } else {
        throw Exception('Failed to get payment information: ${response.statusCode}');
      }
    } catch (e, trace) {
      throw Exception('Error getting payment methods: $e,$trace');
    }
  }

  Future<PaymentResponse> makePayment(
    PaymentInformation paymentInformation,
    Map<String, dynamic> paymentData, {
    String? countryCode,
    String? shopperLocale,
    String? telephoneNumber,
    ShopperBillingAddress? billingAddress,
  }) async {
    try {
      final data = {};
      data.addAll(paymentInformation.toPaymentDataJson(
        countryCode: countryCode,
        shopperLocale: shopperLocale,
        telephoneNumber: telephoneNumber,
        billingAddress: billingAddress,
      ));
      final browserInfo = {'userAgent': paymentData['browserInfo']['userAgent']};
      paymentData['browserInfo'] = browserInfo;
      data.addAll(paymentData);
      final response = await dio.post<Map<String, dynamic>>(
        '/make-payment',
        data: {
          'provider': data,
          'payment': {
            'invoiceId': paymentInformation.invoiceId,
          }
        },
      );
      if (response.statusCode == 200 && response.data != null) {
        return PaymentResponse.fromJson(response.data!);
      } else {
        debugPrint(response.data.toString());
        debugPrint(response.statusMessage.toString());
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e, trace) {
      debugPrint(trace.toString());
      debugPrint(e.toString());
      throw Exception('Error processing payment: $e');
    }
  }

  Future<DetailPaymentResponse> makeDetailPayment(
      Map<String, dynamic> data /* PaymentRequest request */) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '/handle-details',
        data: data /* request.toJson() */,
      );

      if (response.statusCode == 200 && response.data != null) {
        return DetailPaymentResponse.fromJson(response.data!);
      } else {
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error processing payment: $e');
    }
  }
}
