import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klarna_flutter_pay/src/commons/klarna_commons.dart'
    show KlarnaEnvironment, KlarnaRegion;

class KlarnaPaymentWidget extends StatefulWidget {
  const KlarnaPaymentWidget({
    super.key,
    required this.clientToken,
    required this.returnURL,
    this.environment = KlarnaEnvironment.staging,
    this.region = KlarnaRegion.eu,
    this.loggingLevel = 'verbose',
    this.additionalArgs,
    this.onKlarnaStarted,
    this.onKlarnaError,
    this.onKlarnaFinished,
    this.onKlarnaEvent,
    this.category = 'klarna',
  });

  final String clientToken;
  final String category;
  final String returnURL;
  final KlarnaEnvironment environment;
  final KlarnaRegion region;
  final String loggingLevel;
  final Map<String, dynamic>? additionalArgs;
  final VoidCallback? onKlarnaStarted;
  final Function(Map<String, dynamic>)? onKlarnaError;
  final Function(String? authToken, bool approved)? onKlarnaFinished;
  final Function(Map<String, dynamic>)? onKlarnaEvent;
  static const String viewType = 'de.bloomwell/klarna_pay';

  @override
  State<KlarnaPaymentWidget> createState() => _KlarnaPaymentWidgetState();
}

class _KlarnaPaymentWidgetState extends State<KlarnaPaymentWidget> {
  MethodChannel? _methodChannel;
  bool _isKlarnaStarted = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Platform View
        if (defaultTargetPlatform == TargetPlatform.android)
          AndroidView(
            viewType: KlarnaPaymentWidget.viewType,
            creationParams: _getCreationParams(),
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          )
        else if (defaultTargetPlatform == TargetPlatform.iOS)
          UiKitView(
            viewType: KlarnaPaymentWidget.viewType,
            creationParams: _getCreationParams(),
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          )
        else
          const Center(
            child: Text(
              'Klarna Payment is not supported on this platform',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),

        // Loading overlay with circular progress indicator
        if (_isLoading && !_isKlarnaStarted)
          Container(
            color: Colors.white.withValues(alpha: 0.9),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
                  SizedBox(height: 16),
                  Text(
                    'Initializing Klarna Payment...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),

        // Error overlay
        if (_errorMessage != null)
          Container(
            color: Colors.white.withValues(alpha: 0.9),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: $_errorMessage',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _retry, child: const Text('Retry')),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Map<String, dynamic> _getCreationParams() {
    return {
      'clientToken': widget.clientToken,
      'returnURL': widget.returnURL,
      'environment': widget.environment,
      'region': widget.region.value,
      'category': widget.category,
      'loggingLevel': widget.loggingLevel,
    };
  }

  void _onPlatformViewCreated(int id) {
    _methodChannel = MethodChannel('${KlarnaPaymentWidget.viewType}_$id');
    _methodChannel?.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'initKlarna':
        setState(() {
          _isLoading = false;
        });
        break;

      case 'startedKlarna':
        setState(() {
          _isKlarnaStarted = true;
          _isLoading = false;
        });
        widget.onKlarnaStarted?.call();
        break;

      case 'errorKlarna':
        final errorData = call.arguments as Map<String, dynamic>;
        setState(() {
          _errorMessage = errorData['message'] ?? 'Unknown error occurred';
          _isLoading = false;
        });
        widget.onKlarnaError?.call(errorData);
        break;

      case 'finishKlarna':
        final finishData = call.arguments as Map<String, dynamic>;
        widget.onKlarnaFinished?.call(finishData['authToken'], finishData['approved']);
        break;

      case 'onLoadedKlarna':
      case 'loadPaymentReviewKlarna':
      case 'reauthorizedKlarna':
      case 'klarnaEvent':
      case 'klarnaRedirect':
        final eventData = call.arguments as Map<String, dynamic>?;
        widget.onKlarnaEvent?.call(eventData ?? {});
        break;

      default:
        break;
    }
  }

  void _retry() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
      _isKlarnaStarted = false;
    });
    // The platform view will reinitialize automatically
  }

  Future<void> pay() async {
    if (_methodChannel != null) {
      try {
        await _methodChannel!.invokeMethod('pay');
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to initiate payment: $e';
        });
      }
    }
  }

  Future<void> authorize({bool autoFinalize = true, String? sessionData}) async {
    if (_methodChannel != null) {
      try {
        await _methodChannel!.invokeMethod('authorize', {
          'autoFinalize': autoFinalize,
          'sessionData': sessionData,
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to authorize: $e';
        });
      }
    }
  }

  Future<void> finalize({String? sessionData}) async {
    if (_methodChannel != null) {
      try {
        await _methodChannel!.invokeMethod('finalize', {'sessionData': sessionData});
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to finalize: $e';
        });
      }
    }
  }
}
