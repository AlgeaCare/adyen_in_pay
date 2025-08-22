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
    this.onKlarnaClosed,
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
  final Function()? onKlarnaClosed;
  final Function(Map<String, dynamic>)? onKlarnaError;
  final Function(String? authToken, bool approved)? onKlarnaFinished;
  final Function(Map<String, dynamic>)? onKlarnaEvent;
  static const String viewType = 'de.bloomwell/klarna_pay';

  @override
  State<KlarnaPaymentWidget> createState() => _KlarnaPaymentWidgetState();
}

class _KlarnaPaymentWidgetState extends State<KlarnaPaymentWidget> {
  MethodChannel? _methodChannel;
  late final ValueNotifier<bool> _isKlarnaStarted;
  late final ValueNotifier<bool> _isLoading;
  late final ValueNotifier<bool> _isProcessingPayment;
  late final ValueNotifier<String?> _errorMessage;

  @override
  void initState() {
    super.initState();
    _isKlarnaStarted = ValueNotifier(false);
    _isLoading = ValueNotifier(true);
    _isProcessingPayment = ValueNotifier(false);
    _errorMessage = ValueNotifier(null);
  }

  @override
  void dispose() {
    _isKlarnaStarted.dispose();
    _isLoading.dispose();
    _isProcessingPayment.dispose();
    _errorMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        switch (defaultTargetPlatform) {
          TargetPlatform.android => AndroidView(
            viewType: KlarnaPaymentWidget.viewType,
            creationParams: _getCreationParams(),
            creationParamsCodec: const StandardMethodCodec().messageCodec,
            onPlatformViewCreated: _onPlatformViewCreated,
          ),
          TargetPlatform.iOS => UiKitView(
            viewType: KlarnaPaymentWidget.viewType,
            creationParams: _getCreationParams(),
            creationParamsCodec: const StandardMethodCodec().messageCodec,
            onPlatformViewCreated: _onPlatformViewCreated,
          ),
          _ => const Center(
            child: Text(
              'Klarna Payment is not supported on this platform',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
        },
        // Loading overlay with circular progress indicator
        ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: _isKlarnaStarted,
              builder: (context, isKlarnaStarted, child) {
                if (isLoading && !isKlarnaStarted) {
                  return Container(
                    color: Colors.white.withValues(alpha: 0.9),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Initializing Klarna Payment...',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),

        // Payment processing overlay
        ValueListenableBuilder<bool>(
          valueListenable: _isProcessingPayment,
          builder: (context, isProcessingPayment, child) {
            if (isProcessingPayment) {
              return Container(
                color: Colors.white.withValues(alpha: 0.9),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Payment is processing...',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Error overlay
        ValueListenableBuilder<String?>(
          valueListenable: _errorMessage,
          builder: (context, errorMessage, child) {
            if (errorMessage != null) {
              return Container(
                color: Colors.white.withValues(alpha: 0.9),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $errorMessage',
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Map<String, dynamic> _getCreationParams() {
    return {
      'tokenClient': widget.clientToken,
      'returnURL': widget.returnURL,
      'environment': widget.environment.name,
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
        _isLoading.value = false;
        break;

      case 'startedKlarna':
        _isKlarnaStarted.value = true;
        _isLoading.value = false;
        widget.onKlarnaStarted?.call();
        break;

      case 'errorKlarna':
        final errorData = call.arguments as Map<String, dynamic>;
        _errorMessage.value = errorData['message'] ?? 'Unknown error occurred';
        _isLoading.value = false;
        widget.onKlarnaError?.call(errorData);
        break;

      case 'finishKlarna':
        _isProcessingPayment.value = true;
        final finishData = Map<String, dynamic>.from(call.arguments);
        widget.onKlarnaFinished?.call(finishData['authToken'], finishData['approved']);
        break;
      case 'klarnaEvent':
        final eventData = call.arguments as Map<String, dynamic>?;
        if (eventData != null && eventData['params']['name'] == 'close') {
          widget.onKlarnaClosed?.call();
        }
        widget.onKlarnaEvent?.call(eventData?['params'] ?? {});
        break;
      case 'reauthorizedKlarna':
      case 'klarnaRedirect':
        final eventData = call.arguments as Map<String, dynamic>?;
        widget.onKlarnaEvent?.call(eventData ?? {});
        break;

      default:
        break;
    }
  }

  void _retry() {
    _errorMessage.value = null;
    _isLoading.value = true;
    _isKlarnaStarted.value = false;
    // The platform view will reinitialize automatically
  }

  Future<void> pay() async {
    if (_methodChannel != null) {
      try {
        await _methodChannel!.invokeMethod('pay');
      } catch (e) {
        _errorMessage.value = 'Failed to initiate payment: $e';
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
        _errorMessage.value = 'Failed to authorize: $e';
      }
    }
  }

  Future<void> finalize({String? sessionData}) async {
    if (_methodChannel != null) {
      try {
        await _methodChannel!.invokeMethod('finalize', {'sessionData': sessionData});
      } catch (e) {
        _errorMessage.value = 'Failed to finalize: $e';
      }
    }
  }
}
