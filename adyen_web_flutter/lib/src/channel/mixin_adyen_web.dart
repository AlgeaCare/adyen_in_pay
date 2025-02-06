import 'dart:async';

import 'package:adyen_web_flutter/src/channel/events.dart';
import 'package:stream_transform/stream_transform.dart';

mixin EventListenerMixin {
  static final streamController = StreamController<Event>.broadcast();
  Stream get _stream => streamController.stream;
  Stream<OnPaymentSessionDone> get onStart =>
      _stream.whereType<OnPaymentSessionDone>();
  Stream<OnPaymentAdvancedDone> get onInitialisationError =>
      _stream.whereType<OnPaymentAdvancedDone>();

  Stream<OnPaymentError> get onDone => _stream.whereType<OnPaymentError>();
  Stream<OnStart> get onErrorResult => _stream.whereType<OnStart>();
}
