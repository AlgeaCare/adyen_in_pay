import 'package:flutter/material.dart';
import 'package:klarna_flutter_pay/klarna_flutter_pay.dart';

class KlarnaExample extends StatefulWidget {
  const KlarnaExample({Key? key}) : super(key: key);

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

  void _onKlarnaStarted() {
    setState(() {
      _status = 'Klarna started successfully!';
      _isKlarnaStarted = true;
    });
    _showMessage('Klarna payment view is ready');
  }

  void _onKlarnaError(Map<String, dynamic> error) {
    setState(() {
      _status = 'Error: ${error['message'] ?? 'Unknown error'}';
    });
    _showMessage('Klarna error: ${error['message'] ?? 'Unknown error'}', isError: true);
  }

  void _onKlarnaFinished(Map<String, dynamic> result) {
    final bool approved = result['approved'] == true;
    final String? authToken = result['authToken'];
    
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
                clientToken: 'your_client_token_here', // Replace with actual client token
                returnURL: 'your-app://klarna-payment',
                environment: KlarnaEnvironment.staging, // Use 'production' for live payments
                region: KlarnaRegion.eu, // or 'US', 'OC'
                loggingLevel: 'verbose',
                onKlarnaStarted: _onKlarnaStarted,
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
