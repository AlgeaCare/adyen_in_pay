import 'dart:js_interop';

@JS('init')
external JSPromise init(
  JSNumber viewID,
  JSString clientKey,
  JSString sessionId,
  JSString sessionData,
  JSString env,
  JSString redirectURL,
);

@JS('setUpJS')
external JSPromise<JSNumber> setUpJS(JSNumber viewID);

@JS('onPaymentDone')
external set onPaymentDone(JSFunction f);

@JS('onStarted')
external set onStarted(JSFunction f);

@JS('onPaymentError')
external set onPaymentError(JSFunction f);
