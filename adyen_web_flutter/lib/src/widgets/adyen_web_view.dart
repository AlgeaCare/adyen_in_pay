import 'package:adyen_web_flutter/src/channel/adyen_web_flutter_method_channel.dart';
import 'package:adyen_web_flutter/src/common/configuration.dart';
import 'package:adyen_web_flutter/src/common/web_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web; // Add
import 'dart:ui_web' as ui;

int _viewId = 0;

class AdyenWebView extends StatefulWidget {
  final WebConfiguration configuration;
  const AdyenWebView({super.key, required this.configuration});

  static WebMixin? of(BuildContext context) {
    return context.findAncestorStateOfType<_AdyenWebViewState>();
  }

  @override
  State<AdyenWebView> createState() => _AdyenWebViewState();
}

class _AdyenWebViewState extends State<AdyenWebView> with WebMixin {
  late final MethodChannelAdyenWebFlutter channelWeb =
      MethodChannelAdyenWebFlutter();
  late double _height = widget.configuration.sizeWeb?.height ?? 400;
  web.HTMLIFrameElement? _frame;
  late web.HTMLDivElement _div;
  web.HTMLScriptElement? mapScript;
  ValueNotifier<bool> isReadyNotifier = ValueNotifier(false);
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
          isReadyNotifier.value = true;
          widget.configuration.callbacks.onStarted();
        },
        onPayment: (data) async {
          return await widget.configuration.callbacks.onPayment(data);
        },
        onPaymentDetail: (data) async {
          return await widget.configuration.callbacks.onPaymentDetail(data);
        },
        onPaymentDone: (result) {
          widget.configuration.callbacks.onPaymentDone(result);
        },
        onPaymentError: (err) {
          debugPrint(err);
          widget.configuration.callbacks.onPaymentFailed();
        },
        onListenHeightAdyen: (height) {
          debugPrint('height adyen component: $height');
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
        height:
            _height > MediaQuery.sizeOf(context).height
                ? MediaQuery.sizeOf(context).height - 150
                : _height,
        width: widget.configuration.sizeWeb?.width ?? 400,
        child: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: isReadyNotifier,
              builder:
                  (context, isReady, child) =>
                      isReady
                          ? const SizedBox.shrink()
                          : const Center(child: CircularProgressIndicator()),
            ),
            Positioned.fill(
              child: SizedBox(
                height:
                    _height > MediaQuery.sizeOf(context).height
                        ? MediaQuery.sizeOf(context).height - 150
                        : _height,
                width: widget.configuration.sizeWeb?.width ?? 400,
                child: HtmlElementView(
                  viewType: MethodChannelAdyenWebFlutter.getViewType(_viewId),
                  onPlatformViewCreated: (int id) {
                    Future.delayed(
                      const Duration(milliseconds: 1000),
                      () async {
                        await channelWeb.setup(_viewId);
                        final paymentMethods =
                            await widget.configuration.callbacks
                                .onPaymentMethod();
                        final cardBrands =
                            await widget.configuration.callbacks.cardBrands();
                        if (widget.configuration.configurationType
                            is WebConfigurationTypeAdvanced) {
                          await channelWeb.initAdvanced(
                            _viewId,
                            widget.configuration.configurationType.clientKey,
                            widget.configuration.configurationType.env,
                            widget.configuration.configurationType.redirectURL,
                            widget.configuration.configurationType.currency,
                            widget.configuration.configurationType.amount,
                            paymentMethods,
                            cardBrands,
                          );
                        } else if (widget.configuration.configurationType
                            is WebConfigurationTypeSession) {
                          await channelWeb.init(
                            _viewId,
                            widget.configuration.configurationType.clientKey,
                            (widget.configuration.configurationType
                                    as WebConfigurationTypeSession)
                                .sessionId,
                            (widget.configuration.configurationType
                                    as WebConfigurationTypeSession)
                                .sessionData,
                            widget.configuration.configurationType.env,
                            widget.configuration.configurationType.redirectURL,
                            widget.configuration.configurationType.currency,
                            widget.configuration.configurationType.amount,
                            paymentMethods,
                            cardBrands,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
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
