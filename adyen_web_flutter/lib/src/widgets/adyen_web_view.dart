import 'package:adyen_web_flutter/src/channel/adyen_web_flutter_method_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web; // Add
import 'dart:ui_web' as ui;

class AdyenWebView extends StatefulWidget {
  final String clientKey;
  final String sessionId;
  final String sessionData;
  final String redirectURL;
  final String env;
  final VoidCallback onStarted;
  final Function(Map<String, dynamic>) onPaymentSession;
  final VoidCallback onPaymentFailed;
  const AdyenWebView({
    super.key,
    required this.clientKey,
    required this.sessionId,
    required this.sessionData,
    required this.env,
    required this.redirectURL,
    required this.onStarted,
    required this.onPaymentSession,
    required this.onPaymentFailed,
  });

  @override
  State<AdyenWebView> createState() => _AdyenWebViewState();
}

class _AdyenWebViewState extends State<AdyenWebView> {
  late final MethodChannelAdyenWebFlutter channelWeb =
      MethodChannelAdyenWebFlutter();
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
            ..type = 'text/javascript');
    }
    if (web.window.document.getElementById("jsScript") == null) {
      mapScript = web.document.createElement('script') as web.HTMLScriptElement
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
      // Register the view
      _div = web.document.createElement('div')
          as web.HTMLDivElement; //web.HTMLDivElement(); //html.DivElement()
      _div.style.width = '100%';
      _div.style.height = '100%';
      ui.platformViewRegistry.registerViewFactory(
          MethodChannelAdyenWebFlutter.getViewType(0), (int viewId) {
        debugPrint("viewId : $viewId");
        _div.id = 'adyen_bloomweel_0';
        const idFrame = "frame_verify_0";
        debugPrint(idFrame);
        _frame = web.document.createElement("iframe") as web.HTMLIFrameElement
          ..id = idFrame
          ..src =
              "${kReleaseMode ? "assets/" : ''}/packages/adyen_web_flutter/src/assets/adyen.html"
          ..allowFullscreen = true
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        _div.appendChild(_frame!);
        return _div;
      });
      createHtml();
      channelWeb.handleMethodChannel(
        onStarted: () {
          widget.onStarted();
        },
        onPaymentSessionDone: (result) {
          widget.onPaymentSession(result);
        },
        onPaymentAdvancedDone: (result) {
          widget.onPaymentSession(result);
        },
        onPaymentError: (err) {
          widget.onPaymentFailed();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HtmlElementView(
        viewType: MethodChannelAdyenWebFlutter.getViewType(0),
        onPlatformViewCreated: (int id) {
          Future.delayed(const Duration(milliseconds: 1000), () async {
            await channelWeb.setup(0);
            await channelWeb.init(
              0,
              widget.clientKey,
              widget.sessionId,
              widget.sessionData,
              widget.env,
              widget.redirectURL,
            );
          });
        },
      );
    }
    return const SizedBox.shrink(); // Fallback for non-web platforms
  }
}
