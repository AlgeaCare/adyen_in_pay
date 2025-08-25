import 'package:flutter/material.dart';
import 'package:klarna_flutter_pay/klarna_flutter_pay.dart';

class KlarnaExample extends StatefulWidget {
  const KlarnaExample({super.key});

  @override
  State<KlarnaExample> createState() => _KlarnaExampleState();
}

class _KlarnaExampleState extends State<KlarnaExample> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String _status = 'Ready to initialize Klarna';
  bool _isKlarnaStarted = false;

  void _showMessage(String message, {bool isError = false}) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

 
  void _onKlarnaError(Map<String, dynamic> error) {
    setState(() {
      _status = 'Error: ${error['message'] ?? 'Unknown error'}';
    });
    _showMessage('Klarna error: ${error['message'] ?? 'Unknown error'}', isError: true);
  }

  void _onKlarnaFinished(String? authToken, bool approved) {
    setState(() {
      _status = 'Payment ${approved ? 'approved' : 'declined'}';
      if (approved && authToken != null) {
        _status += '\nAuth Token: ${authToken.substring(0, 20)}...'; // Show first 20 chars
      }
    });

    _showMessage(
      'Payment ${approved ? 'approved' : 'declined'}${authToken != null ? ' - Token received' : ''}',
      isError: !approved,
    );

    // You can now use the authToken for your backend processing
    if (approved && authToken != null) {
      print('Payment approved with authToken: $authToken');
      // Send authToken to your backend for order completion
    }
  }

  void _onKlarnaEvent(Map<String, dynamic> event) {
    print('Klarna event: $event');
    // Handle other Klarna events as needed
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Klarna Payment Example'),
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Status bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: $_status',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _isKlarnaStarted ? Icons.check_circle : Icons.pending,
                        color: _isKlarnaStarted ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isKlarnaStarted ? 'Klarna Ready' : 'Initializing...',
                        style: TextStyle(
                          color: _isKlarnaStarted ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Klarna Payment Widget
            Expanded(
              child: KlarnaPaymentWidget(
                clientToken: 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjgyMzA1ZWJjLWI4MTEtMzYzNy1hYTRjLTY2ZWNhMTg3NGYzZCJ9.eyJzZXNzaW9uX2lkIjoiZjJiZTZiZDAtNDI2Yy02NDA0LTg1Y2UtYzhkODFhODc1MTU5IiwiYmFzZV91cmwiOiJodHRwczovL2pzLnBsYXlncm91bmQua2xhcm5hLmNvbS9ldS9rcCIsImRlc2lnbiI6ImtsYXJuYSIsImxhbmd1YWdlIjoiZGUiLCJwdXJjaGFzZV9jb3VudHJ5IjoiREUiLCJlbnZpcm9ubWVudCI6InBsYXlncm91bmQiLCJtZXJjaGFudF9uYW1lIjoiQWR5ZW4iLCJzZXNzaW9uX3R5cGUiOiJQQVlNRU5UUyIsImNsaWVudF9ldmVudF9iYXNlX3VybCI6Imh0dHBzOi8vZXUucGxheWdyb3VuZC5rbGFybmFldnQuY29tIiwic2NoZW1lIjp0cnVlLCJleHBlcmltZW50cyI6W3sibmFtZSI6ImtwYy1vc20td2lkZ2V0IiwidmFyaWF0ZSI6InYxIn0seyJuYW1lIjoia3BjLWFiZSIsInZhcmlhdGUiOiJ2YXJpYXRlLTEifSx7Im5hbWUiOiJrcGMtcHNlbC00NDI5IiwidmFyaWF0ZSI6ImEifSx7Im5hbWUiOiJrcC1jbGllbnQtb25lLXB1cmNoYXNlLWZsb3ciLCJ2YXJpYXRlIjoidmFyaWF0ZS0xIn0seyJuYW1lIjoia3BjLTFrLXNlcnZpY2UiLCJ2YXJpYXRlIjoidmFyaWF0ZS0xIn0seyJuYW1lIjoia3AtY2xpZW50LXV0b3BpYS1zdGF0aWMtd2lkZ2V0IiwidmFyaWF0ZSI6ImluZGV4IiwicGFyYW1ldGVycyI6eyJkeW5hbWljIjoidHJ1ZSJ9fSx7Im5hbWUiOiJrcC1jbGllbnQtdXRvcGlhLWZsb3ciLCJ2YXJpYXRlIjoidmFyaWF0ZS0xIn0seyJuYW1lIjoia3AtY2xpZW50LXV0b3BpYS1zZGstZmxvdyIsInZhcmlhdGUiOiJ2YXJpYXRlLTEifSx7Im5hbWUiOiJrcC1jbGllbnQtdXRvcGlhLXdlYnZpZXctZmxvdyIsInZhcmlhdGUiOiJ2YXJpYXRlLTEifV0sInJlZ2lvbiI6ImV1Iiwib3JkZXJfYW1vdW50IjoxNTc3Niwib2ZmZXJpbmdfb3B0cyI6Miwib28iOiJkMCIsInZlcnNpb24iOiJ2MS4xMC4wLTE1OTAtZzNlYmMzOTA3In0.c8ekc8fyevwTyjgQeighybi_7U145cPwSIyEJK_nSODdFC-T8FaDfxMX83R05Coao-NTiGFMueILbIiIIm78XgzNhCVCXDh78ECEShg8bDldOff2imhE0stv0h4rC6-4h8iLT7ajpt0XneWWqWhezy24OHuVZunOdoMHohW1qx8xyV8HCrIpzQspWSQI6eq02TRkCA6pJLLYViyMgyUVGuwyHC7YuQpeYFFpsOw7tlsMVIISAfcOtEGzd3ZVXUb5eK0oOhkheDhRhty0ILNWugpxCWvaBh0bKzA6OrRGe3kzSNePobinFC-P-tKamAk_o2qsS7qqQxs5NHuAwYvfdg', // Replace with actual client token
                category: 'pay_now',
                returnURL: 'https://app.staging.bloomwell.de',
                environment: KlarnaEnvironment.staging, // Use 'production' for live payments
                region: KlarnaRegion.eu, // or 'US', 'OC'
                loggingLevel: 'verbose',
                onKlarnaError: _onKlarnaError,
                onKlarnaFinished: _onKlarnaFinished,
                onKlarnaEvent: _onKlarnaEvent,
                additionalArgs: {
                  // Add any additional arguments here
                  'customData': 'example_value',
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
