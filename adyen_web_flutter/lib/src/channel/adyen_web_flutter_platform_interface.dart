import 'dart:convert';
import 'package:adyen_web_flutter/src/channel/adyen_web_flutter_method_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dart:js_interop';
import 'package:adyen_web_flutter/src/platform/interop.dart' as interop;

abstract class AdyenWebFlutterPlatform extends PlatformInterface {
  /// Constructs a AdyenWebFlutterPlatform.
  AdyenWebFlutterPlatform() : super(token: _token);

  static final Object _token = Object();
}

void bindingWebAdyen() {
  interop.onStarted = onStarted.toJS;
  interop.onPaymentError = onPaymentError.toJS;
  interop.onPaymentDone = onPaymentDone.toJS;
}

void onStarted(JSNumber mapId) {
  try {
    final plugin = MethodChannelAdyenWebFlutter();
    plugin.onStartedDone?.call();
  } catch (e, trace) {
    debugPrint(trace.toString());
    rethrow;
  }
}

void onPaymentDone(JSNumber mapId, JSString data) {
  try {
    final plugin = MethodChannelAdyenWebFlutter();
    plugin.onPaymentSessionDone?.call(json.decode(data.toDart));
  } catch (e, trace) {
    debugPrint(trace.toString());
    rethrow;
  }
}

void onPaymentError(JSNumber mapId, JSString err) {
  try {
    final plugin = MethodChannelAdyenWebFlutter();
    plugin.onPaymentError?.call(err.toDart);
  } catch (e, trace) {
    debugPrint(trace.toString());
    rethrow;
  }
}
