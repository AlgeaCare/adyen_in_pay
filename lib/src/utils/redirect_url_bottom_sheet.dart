import 'dart:async';
import 'package:adyen_checkout/adyen_checkout.dart' as adyen show PaymentEvent, Finished, Error;
import 'package:adyen_in_pay/adyen_in_pay.dart' show DetailPaymentResponse, PaymentResultCode;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<adyen.PaymentEvent> showRedirectUrlBottomSheet({
  required BuildContext context,
  required String redirectUrl,
  required String url,
  required Future<DetailPaymentResponse> Function(String resultCode) onPaymentDetail,
  required Function() onRetry,
  Widget Function(String url, Function()? onRetry)? topTitleWidget,
}) async {
  // final Completer<adyen.PaymentEvent> completer = Completer();
  // final controller
  final result = await showModalBottomSheet<adyen.PaymentEvent>(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    scrollControlDisabledMaxHeightRatio: 0.9,
    builder: (context) {
      return RedirectUrlBottomSheet(
        redirectUrl: redirectUrl,
        url: url,
        onRetry: onRetry,
        topTitleWidget: topTitleWidget,
        onRedirect: (controller, url) {
          if (url?.path.contains(redirectUrl) ?? false) {
            controller.stopLoading();
            if (!context.mounted) {
              return;
            }
            // completer.complete(adyen.Error(errorMessage: ""));
            Navigator.of(context).pop(adyen.Error(errorMessage: ""));
          }
        },
        onCloseWindow: (controller) async {
          final url = await controller.getUrl();
          if (url?.path.contains(redirectUrl) ?? false) {
            controller.stopLoading();
          }
          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop(adyen.Finished(resultCode: "cancelled"));
          onRetry();
        },
        onPaymentEvent: (String event) async {
          final result = await onPaymentDetail(event);
          if (!context.mounted) {
            return;
          }
          if (result.resultCode.toLowerCase() == PaymentResultCode.authorised.name.toLowerCase() ||
              result.resultCode.toLowerCase() == PaymentResultCode.pending.name.toLowerCase() ||
              result.resultCode.toLowerCase() == PaymentResultCode.received.name.toLowerCase() ||
              result.resultCode.toLowerCase() == PaymentResultCode.paid.name.toLowerCase()) {
            // completer.complete(adyen.Finished(resultCode: event));
            Navigator.of(context).pop(adyen.Finished(resultCode: result.resultCode.toString()));
          } else {
            Navigator.of(context).pop(adyen.Error(errorMessage: result.resultCode.toString()));
            // completer.complete(adyen.Error(errorMessage: result.resultCode.toString()));
          }
        },
      );
    },
    constraints: BoxConstraints(
      maxWidth: MediaQuery.sizeOf(context).width,
      maxHeight: MediaQuery.sizeOf(context).height * 0.9,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    elevation: 10,
  );

  return result ?? adyen.Finished(resultCode: "cancelled");
  // controller.closed.then((value) {
  //   if (!completer.isCompleted) {
  //     completer.completeError(Exception('Complete without Any information'));
  //   }
  // });
  // return completer.future;
}

class RedirectUrlBottomSheet extends StatelessWidget {
  const RedirectUrlBottomSheet({
    super.key,
    required this.redirectUrl,
    required this.url,
    required this.onPaymentEvent,
    this.onCloseWindow,
    required this.onRedirect,
    required this.onRetry,
    this.topTitleWidget,
  });
  final String redirectUrl;
  final String url;
  final Function() onRetry;
  final Function(String) onPaymentEvent;
  final Function(InAppWebViewController)? onCloseWindow;
  final Function(InAppWebViewController, WebUri?) onRedirect;
  final Widget Function(String url, Function()? onRetry)? topTitleWidget;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: Column(
        children: [
          topTitleWidget?.call(url, onRetry) ??
              SizedBox(
                height: 56,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(
                      child: const Text('cancel', style: TextStyle(fontFamily: 'Inter')),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Text(
                        url,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: SizedBox(
                    child: SingleChildScrollView(
                      controller: ScrollController(initialScrollOffset: 12, keepScrollOffset: true),
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.85,
                        child: InAppWebView(
                          initialSettings: InAppWebViewSettings(
                            isInspectable: kReleaseMode,
                            mediaPlaybackRequiresUserGesture: false,
                            allowsInlineMediaPlayback: true,
                            iframeAllow: "camera",
                            iframeAllowFullscreen: true,
                            useOnRenderProcessGone: true,
                            disableVerticalScroll: false,
                            verticalScrollBarEnabled: true,
                            isFindInteractionEnabled: true,
                            supportZoom: true,
                            preferredContentMode: UserPreferredContentMode.RECOMMENDED,
                            allowsLinkPreview: true,
                            disallowOverScroll: false,
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
                          onNavigationResponse: (controller, request) async {
                            // onRedirect(controller, request.response?.url);
                            final uri = request.response?.url;
                            if (uri != null &&
                                (uri.path.contains(redirectUrl) ||
                                    uri.path.contains('redirectResult'))) {
                              controller.stopLoading();
                              return NavigationResponseAction.CANCEL;
                            }
                            return NavigationResponseAction.ALLOW;
                          },
                          onUpdateVisitedHistory: (controller, url, isReload) {
                            if (url != null && url.queryParameters.containsKey('redirectResult')) {
                              controller.stopLoading();
                              onPaymentEvent(url.queryParameters['redirectResult']!);
                            }
                          },
                          onLoadStart: (controller, webURI) {
                            if (webURI != null &&
                                webURI.queryParameters.containsKey('redirectResult')) {
                              controller.stopLoading();
                              onPaymentEvent(webURI.queryParameters['redirectResult']!);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 56,
                  child: DecoratedBox(decoration: BoxDecoration(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
