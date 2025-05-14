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
  interop.onPayment = payment.toJS as JSPromise;
  interop.paymentDetail = paymentDetail.toJS as JSPromise<JSAny?>;
  interop.onListenHeightAdyenView = onListenHeightAdyenView.toJS;
}

void onStarted(JSNumber paymentId) {
  try {
    final plugin = MethodChannelAdyenWebFlutter();
    plugin.onStartedDone?.call();
  } catch (e, trace) {
    debugPrint(trace.toString());
    rethrow;
  }
}

void onListenHeightAdyenView(JSNumber paymentId, JSNumber height) {
  try {
    final plugin = MethodChannelAdyenWebFlutter();
    plugin.onListenHeightAdyen?.call(height.dartify() as double);
  } catch (e, trace) {
    debugPrint(trace.toString());
    rethrow;
  }
}

JSPromise payment(JSNumber paymentId, JSString data) {
  try {
    debugPrint('in dart payment ');
    debugPrint(data.toString());
    final plugin = MethodChannelAdyenWebFlutter();
    return JSPromise(
      (JSFunction resolve, JSFunction reject) {
        plugin.onPayment?.call(json.decode(data.toDart)).then((value) {
          resolve.callAsFunction(resolve, value.toJS);
        });
      }.toJS,
    );
  } catch (e, trace) {
    debugPrint("error : ${trace.toString()}");
    return JSPromise((() => '{result: "1"}').toJS);
  }
}

JSPromise paymentDetail(JSNumber paymentId, JSString data) {
  try {
    final plugin = MethodChannelAdyenWebFlutter();
    return JSPromise(
      (JSFunction resolve, JSFunction reject) {
        plugin.onPaymentDetail?.call(json.decode(data.toDart)).then((value) {
          resolve.callAsFunction(resolve, value.toJS);
        });
      }.toJS,
    );
  } catch (e, trace) {
    debugPrint(trace.toString());
    rethrow;
  }
}

void onPaymentDone(JSNumber paymentId, JSString data) {
  try {
    final plugin = MethodChannelAdyenWebFlutter();
    plugin.onPaymentDone?.call(json.decode(data.toDart));
  } catch (e, trace) {
    debugPrint(trace.toString());
    rethrow;
  }
}

void onPaymentError(JSNumber paymentId, JSString err) {
  try {
    final plugin = MethodChannelAdyenWebFlutter();
    plugin.onPaymentError?.call(err.toDart);
  } catch (e, trace) {
    debugPrint(trace.toString());
    rethrow;
  }
}
