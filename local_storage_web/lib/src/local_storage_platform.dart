import 'package:local_storage_web/src/stub_storage_web.dart'
    if (dart.library.io) 'package:local_storage_web/src/stub_storage_mobile.dart'
    if (dart.library.js_interop) 'package:local_storage_web/src/stub_storage_web.dart';

void platformListenToState(String key, Function(Map input) callback) => listenToState(key, callback);
void platformSaveState(Map input, String key) => saveState(input, key);
void platformClearState(String key) => clearState(key);
void platformClose() => closeWindow();
void clearListener() => clearListener();