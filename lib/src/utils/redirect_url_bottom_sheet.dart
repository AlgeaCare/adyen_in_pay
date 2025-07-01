import 'dart:async';

import 'package:adyen_checkout/adyen_checkout.dart' as adyen show PaymentEvent, Finished, Error;
import 'package:adyen_in_pay/adyen_in_pay.dart' show DetailPaymentResponse, PaymentResultCode;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<adyen.PaymentEvent> showRedirectUrlBottomSheet({
  required BuildContext context,
  required String redirectUrl,
  required Future<DetailPaymentResponse> Function(String resultCode) onPaymentDetail,
}) async {
  final Completer<adyen.PaymentEvent> completer = Completer();
  final controller = Scaffold.of(context).showBottomSheet((context) {
    return RedirectUrlBottomSheet(
      redirectUrl: redirectUrl,
      url: redirectUrl,
      onRedirect: (controller, url) {
        if (url != null) {}
      },
      onCloseWindow: (controller) {
        completer.complete(adyen.Error(errorMessage: ""));
        Navigator.of(context).pop();
      },
      onPaymentEvent: (String event) async {
        final result = await onPaymentDetail(event);
        if (result.resultCode.toLowerCase() == PaymentResultCode.authorised.name.toLowerCase() ||
            result.resultCode.toLowerCase() == PaymentResultCode.pending.name.toLowerCase() ||
            result.resultCode.toLowerCase() == PaymentResultCode.received.name.toLowerCase() ||
            result.resultCode.toLowerCase() == PaymentResultCode.paid.name.toLowerCase()) {
          completer.complete(adyen.Finished(resultCode: event));
        } else {
          completer.complete(adyen.Error(errorMessage: result.resultCode.toString()));
        }
        if (!context.mounted) {
          return;
        }
        Navigator.of(context).pop();
      },
    );
  });
  controller.closed.then((value) {
    if(!completer.isCompleted){
      completer.completeError(Exception('Complete without Any information'));
    }
  });
  return completer.future;
}

class RedirectUrlBottomSheet extends StatelessWidget {
  const RedirectUrlBottomSheet({
    super.key,
    required this.redirectUrl,
    required this.url,
    required this.onPaymentEvent,
    this.onCloseWindow,
    required this.onRedirect,
  });
  final String redirectUrl;
  final String url;
  final Function(String) onPaymentEvent;
  final Function(InAppWebViewController)? onCloseWindow;
  final Function(InAppWebViewController, WebUri?) onRedirect;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: InAppWebView(
        initialSettings: InAppWebViewSettings(
          isInspectable: kReleaseMode,
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          iframeAllow: "camera",
          iframeAllowFullscreen: true,
        ),
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))),
        onCloseWindow: (controller) {
          onCloseWindow?.call(controller);
        },
        // onUpdateVisitedHistory: (controller, url, isReload) {
        //   onRedirect(controller, url);
        // },
        onLoadStart: (controller, webURI) {
          if (webURI != null && webURI.queryParameters.containsKey('resultCode')) {
            controller.stopLoading();
            onPaymentEvent(webURI.queryParameters['resultCode']!);
          }
        },
      ),
    );
  }
}
