import 'package:adyen_web_flutter/src/channel/adyen_web_flutter_method_channel.dart';
import 'package:adyen_web_flutter/src/common/web_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web; // Add
import 'dart:ui_web' as ui;

int _viewId = 0;

class AdyenWebView extends StatefulWidget {
  final String clientKey;
  final String sessionId;
  final String sessionData;
  final String redirectURL;
  final String env;
  final String currency;
  final int amount;
  final VoidCallback onStarted;
  final Function(Map<String, dynamic>) onPaymentDone;
  final VoidCallback onPaymentFailed;
  final Future<String> Function(Map<String, dynamic>) onPayment;
  final Future<String> Function(Map<String, dynamic>) onPaymentDetail;
  final Future<String> Function() onPaymentMethod;
  final Future<List<String>> Function() cardBrands;

  final bool _isAdvancedFlow;
  const AdyenWebView({
    super.key,
    required this.clientKey,
    required this.sessionId,
    required this.sessionData,
    required this.env,
    required this.redirectURL,
    required this.currency,
    required this.amount,
    required this.onStarted,
    required this.onPaymentDone,
    required this.onPaymentFailed,
    required this.onPayment,
    required this.onPaymentDetail,
    required this.onPaymentMethod,
    required this.cardBrands,
  }) : _isAdvancedFlow = false;
  const AdyenWebView.advancedFlow({
    super.key,
    required this.clientKey,
    required this.env,
    required this.redirectURL,
    required this.currency,
    required this.amount,
    required this.onStarted,
    required this.onPaymentDone,
    required this.onPaymentFailed,
    required this.onPayment,
    required this.onPaymentDetail,
    required this.onPaymentMethod,
    required this.cardBrands,
  }) : sessionId = '',
       sessionData = '',
       _isAdvancedFlow = true;

  static WebMixin? of(BuildContext context) {
    return context.findAncestorStateOfType<_AdyenWebViewState>();
  }

  @override
  State<AdyenWebView> createState() => _AdyenWebViewState();
}

class _AdyenWebViewState extends State<AdyenWebView> with WebMixin {
  late final MethodChannelAdyenWebFlutter channelWeb =
      MethodChannelAdyenWebFlutter();
  double _height = 400;
  web.HTMLIFrameElement? _frame;
  late web.HTMLDivElement _div;
  web.HTMLScriptElement? mapScript;
  void createHtml() {
    final body = web.window.document.querySelector('body')!;

    debugPrint("div added iframe");
    if (web.window.document.getElementById("adyen_interop") == null) {
      body.appendChild(
        web.document.createElement('script') as web.HTMLScriptElement
          ..id = "adyen_interop"
          ..src =
              '${kReleaseMode ? "assets/" : ''}packages/adyen_web_flutter/src/assets/adyen_interop.js'
          ..type = 'text/javascript',
      );
    }
    if (web.window.document.getElementById("jsScript") == null) {
      mapScript =
          web.document.createElement('script') as web.HTMLScriptElement
            ..id = "jsScript"
            ..src =
                '${kReleaseMode ? "assets/" : ''}packages/adyen_web_flutter/src/assets/adyen_web.js'
            ..type = 'text/javascript';
      body.appendChild(mapScript!);
    }
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _viewId++;
      // Register the view
      _div =
          web.document.createElement('div')
              as web.HTMLDivElement; //web.HTMLDivElement(); //html.DivElement()
      _div.style.width = '100%';
      _div.style.height = '100%';
      //'${400 * MediaQuery.devicePixelRatioOf(context)}';
      ui.platformViewRegistry.registerViewFactory(
        MethodChannelAdyenWebFlutter.getViewType(_viewId),
        (int viewId) {
          debugPrint("viewId : $viewId");
          _div.id = 'adyen_bloomweel_$_viewId';
          final idFrame = "frame_verify_$_viewId";
          debugPrint(idFrame);
          _frame =
              web.document.createElement("iframe") as web.HTMLIFrameElement
                ..id = idFrame
                ..src =
                    "${kReleaseMode ? "assets/" : ''}/packages/adyen_web_flutter/src/assets/adyen.html"
                ..allowFullscreen = true
                ..style.border = 'none'
                ..style.width = '100%'
                ..style.height = '100%';
          //'${400 * MediaQuery.devicePixelRatioOf(context)}';
          _div.appendChild(_frame!);
          return _div;
        },
      );
      createHtml();
      channelWeb.handleMethodChannel(
        onStarted: () {
          widget.onStarted();
        },
        onPayment: (data) async {
          return await widget.onPayment(data);
        },
        onPaymentDetail: (data) async {
          return await widget.onPaymentDetail(data);
        },
        onPaymentDone: (result) {
          widget.onPaymentDone(result);
        },
        onPaymentError: (err) {
          debugPrint(err);
          widget.onPaymentFailed();
        },
        onListenHeightAdyen: (height) {
          setState(() {
            _height = height + 15;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || kIsWasm) {
      return SizedBox(
        height: _height,
        child: HtmlElementView(
          viewType: MethodChannelAdyenWebFlutter.getViewType(_viewId),
          onPlatformViewCreated: (int id) {
            Future.delayed(const Duration(milliseconds: 1000), () async {
              await channelWeb.setup(_viewId);
              final paymentMethods = await widget.onPaymentMethod();
              final cardBrands = await widget.cardBrands();
              if (widget._isAdvancedFlow) {
                await channelWeb.initAdvanced(
                  _viewId,
                  widget.clientKey,
                  widget.env,
                  widget.redirectURL,
                  widget.currency,
                  widget.amount,
                  paymentMethods,
                  cardBrands,
                );
              } else {
                await channelWeb.init(
                  _viewId,
                  widget.clientKey,
                  widget.sessionId,
                  widget.sessionData,
                  widget.env,
                  widget.redirectURL,
                  widget.currency,
                  widget.amount,
                  paymentMethods,
                  cardBrands,
                );
              }
            });
          },
        ),
      );
    }
    return const SizedBox.shrink(); // Fallback for non-web platforms
  }

  @override
  void refresh() {
    channelWeb.refresh(_viewId);
  }

  @override
  void unmount() {
    channelWeb.unmount(_viewId);
  }
}
