import 'dart:js_interop';

import 'package:adyen_web_flutter/src/channel/adyen_web_flutter_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:adyen_web_flutter/src/platform/interop.dart' as interop;

/// An implementation of [AdyenWebFlutterPlatform] that uses method channels.
class MethodChannelAdyenWebFlutter extends AdyenWebFlutterPlatform {
  /// The method channel used to interact with the native platform.

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final MethodChannel methodChannel;
  late BinaryMessenger? messenger;

  static const String viewType = "adyen_plugin_web";
  static MethodChannelAdyenWebFlutter? _instance;

  VoidCallback? onStartedDone;
  Function(Map<String, dynamic>)? onPaymentSessionDone;
  Function(Map<String, dynamic>)? onPaymentAdvancedDone;
  Function(String)? onPaymentError;

  MethodChannelAdyenWebFlutter._({
    required this.messenger,
  }) : methodChannel = MethodChannel(
          viewType,
          const StandardMethodCodec(),
          messenger,
        );
  factory MethodChannelAdyenWebFlutter() {
    _instance ??=
        MethodChannelAdyenWebFlutter._instance as MethodChannelAdyenWebFlutter;
    return _instance!;
  }
  static void registerWith(Registrar registrar) {
    final messenger = registrar;
    MethodChannelAdyenWebFlutter._instance =
        MethodChannelAdyenWebFlutter._(messenger: messenger);
    bindingWebAdyen();
  }

  static String getViewType(int viewId) => "${viewType}_$viewId";
  Future<void> init(
    int id,
    String clientKey,
    String sessionId,
    String sessionData,
    String env,
    String redirectURL,
  ) async {
    await interop
        .init(
          id.toJS,
          clientKey.toJS,
          sessionId.toJS,
          sessionData.toJS,
          env.toJS,
          redirectURL.toJS,
        )
        .toDart;
  }

  Future<void> setup(int id) async {
    await interop.setUpJS(id.toJS).toDart;
  }

  void handleMethodChannel({
    required VoidCallback onStarted,
    required Function(Map<String, dynamic>) onPaymentSessionDone,
    required Function(Map<String, dynamic>) onPaymentAdvancedDone,
    required Function(String) onPaymentError,
  }) {
    onStartedDone = onStarted;
    this.onPaymentSessionDone = onPaymentSessionDone;
    this.onPaymentAdvancedDone = onPaymentAdvancedDone;
    this.onPaymentError = onPaymentError;
  }
}
