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

@JS('initAdvanced')
external JSPromise initAdvanced(
  JSNumber viewID,
  JSString clientKey,
  JSString env,
  JSString redirectURL,
);

@JS('setUpJS')
external JSPromise<JSNumber> setUpJS(JSNumber viewID);

@JS('heightAdyenView')
external set onListenHeightAdyenView(JSFunction f);

@JS('onPaymentDone')
external set onPaymentDone(JSFunction f);

@JS('onPayment')
external set onPayment(JSPromise f);

@JS('paymentDetail')
external set paymentDetail(JSPromise f);

@JS('onStarted')
external set onStarted(JSFunction f);

@JS('onPaymentError')
external set onPaymentError(JSFunction f);
