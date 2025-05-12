import 'dart:convert';
import 'package:adyen_client_api/src/models/payment_response.dart';
import 'package:adyen_client_api/src/models/session_response.dart';
import 'package:adyen_client_api/src/models/payment_method_response.dart';
// import 'package:adyen_client_api/src/models/payment_request.dart';
import 'package:http/http.dart' as http;

class AdyenClient {
  final String baseUrl;
  // final String apiKey;

  AdyenClient({
    required this.baseUrl,
    //  required this.apiKey,
  });

  Future<SessionResponse> startSession({
    required int amount,
    required String reference,
    required String redirectURL,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/startSession').replace(
          queryParameters: {
            'amount': amount.toString(),
            'reference': reference,
            'redirectURL': redirectURL,
          },
        ),
        headers: {
          // 'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return SessionResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to start session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error starting session: $e');
    }
  }

  Future<PaymentMethodResponse> getPaymentMethods() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/paymentMethod'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return PaymentMethodResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to get payment methods: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting payment methods: $e');
    }
  }

  Future<PaymentResponse> makePayment(
      Map<String, dynamic> data /* PaymentRequest request */) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data /* request.toJson() */),
      );

      if (response.statusCode == 200) {
        return PaymentResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error processing payment: $e');
    }
  }

  Future<DetailPaymentResponse> makeDetailPayment(
      Map<String, dynamic> data /* PaymentRequest request */) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/detail'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data /* request.toJson() */),
      );

      if (response.statusCode == 200) {
        return DetailPaymentResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error processing payment: $e');
    }
  }
}
