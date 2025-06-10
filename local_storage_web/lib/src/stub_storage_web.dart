import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:web/web.dart';

typedef InputCallback = void Function(Map input);
InputCallback? callback;
Set<String> _keys = {};
void call(Event event) {
  for (final key in _keys) {
    final value = web.window.localStorage.getItem(key);
    if (value != null && event.isA<StorageEvent>() && (event as StorageEvent).key == key) {
      callback?.call(json.decode(value /*event.newValue!*/) as Map);
    }
  }
}

void listenToState(String key, InputCallback callbackInput) {
  callback = callbackInput;
  _keys.add(key);
  // Listen for storage events
  web.window.addEventListener('storage', call.toJS);
}

void clearListener() {
  web.window.removeEventListener('storage', call.toJS);
  _keys.clear();
  callback = null;
}

void saveState(Map input, String key) {
  web.window.localStorage.setItem(key, json.encode(input));
}

void clearState(String key) {
  web.window.localStorage.delete(key.toJS);
}

void closeWindow() {
  web.window.close();
}
