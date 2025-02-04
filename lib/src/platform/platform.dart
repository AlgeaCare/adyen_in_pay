import 'package:flutter/material.dart';

import 'package:adyen_in_pay/src/platform/stub.dart'
    if (dart.library.io) 'package:adyen_in_pay/src/platform/mobile.dart'
    if (dart.library.js_interop) 'package:adyen_in_pay/src/platform/web_ui.dart';

class AdyenPayWidget extends StatelessWidget {
  const AdyenPayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const PayWidget();
  }
}
