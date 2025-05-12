import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:collection/collection.dart';

class DropInPlatform {
  static Future<void> dropInAdvanced({
    required AdyenClient client,
    required int amount,
    required String reference,
    required AdyenConfiguration configuration,
    required Function(PaymentResult payment) onPaymentResult,
    Function(Object error)? onErrorSessionPreparationWidget,
    bool acceptOnlyCard = false,
  }) async {
    final paymentMethods = await client.getPaymentMethods();

    final dropInConfig = DropInConfiguration(
      clientKey: configuration.clientKey,
      amount: Amount(value: amount, currency: 'EUR'),
      // paymentMethodNames: paymentMethods.toMap(),
      skipListWhenSinglePaymentMethod: true,
      shopperLocale: 'de_DE',
      cardConfiguration: CardConfiguration(
        showStorePaymentField: true,
        supportedCardTypes:
            acceptOnlyCard
                ? paymentMethods.onlyCardBrands()
                : paymentMethods.paymentMethods
                        .firstWhereOrNull((e) => e.type == 'scheme')
                        ?.brand ??
                    <String>[],
      ),
      cashAppPayConfiguration: CashAppPayConfiguration(
        cashAppPayEnvironment:
            configuration.env == 'test'
                ? CashAppPayEnvironment.sandbox
                : CashAppPayEnvironment.production,
        returnUrl: configuration.redirectURL,
      ),
      googlePayConfiguration: GooglePayConfiguration(
        googlePayEnvironment:
            configuration.env == 'test'
                ? GooglePayEnvironment.test
                : GooglePayEnvironment.production,
      ),
      storedPaymentMethodConfiguration: StoredPaymentMethodConfiguration(
        showPreselectedStoredPaymentMethod: true,
      ),
      environment:
          configuration.env == 'test' ? Environment.test : Environment.europe,
      countryCode: 'DE',
    );
    final paymentResult = await AdyenCheckout.advanced.startDropIn(
      dropInConfiguration: dropInConfig,
      paymentMethods: paymentMethods.onlyCards(),
      checkout: AdvancedCheckout(
        onSubmit: (data, [extra]) async {
          if (data.containsKey('paymentMethod')) {
            switch (data['paymentMethod']['type'].toLowerCase()) {
              case 'scheme':
                await Future.delayed(const Duration(seconds: 2));
                break;
              case 'klarna':
              case 'paybybank':
              case 'klarna_paynow':
                await Future.delayed(const Duration(seconds: 2));
                break;
              default:
                return Error(errorMessage: 'error');
            }

            return Finished(resultCode: '201');
          }
          return Error(errorMessage: 'error');
        },
        onAdditionalDetails: (paymentResult) async {
          return Finished(resultCode: '201');
        },
      ),
    );
    if (paymentResult is PaymentCancelledByUser) {
      await AdyenCheckout.advanced.stopDropIn();
    }
    onPaymentResult(paymentResult);

    return Future.delayed(const Duration(seconds: 2));
  }

  static Future<void> dropInSessionFlow({
    required AdyenClient client,
    required int amount,
    required String reference,
    required AdyenConfiguration configuration,
    required Function(PaymentResult payment) onPaymentResult,
    Function(Object error)? onErrorSessionPreparationWidget,
  }) async {
    final paymentMethods = await client.getPaymentMethods();

    final dropInConfig = DropInConfiguration(
      clientKey: configuration.clientKey,
      amount: Amount(value: amount, currency: 'EUR'),
      // paymentMethodNames: paymentMethods.toMap(),
      skipListWhenSinglePaymentMethod: true,
      shopperLocale: 'de_DE',
      cardConfiguration: CardConfiguration(
        showStorePaymentField: true,
        supportedCardTypes:
            paymentMethods.paymentMethods
                .firstWhereOrNull((e) => e.type == 'scheme')
                ?.brand ??
            <String>[],
      ),
      cashAppPayConfiguration: CashAppPayConfiguration(
        cashAppPayEnvironment:
            configuration.env == 'test'
                ? CashAppPayEnvironment.sandbox
                : CashAppPayEnvironment.production,
        returnUrl: configuration.redirectURL,
      ),
      googlePayConfiguration: GooglePayConfiguration(
        googlePayEnvironment:
            configuration.env == 'test'
                ? GooglePayEnvironment.test
                : GooglePayEnvironment.production,
      ),
      storedPaymentMethodConfiguration: StoredPaymentMethodConfiguration(
        showPreselectedStoredPaymentMethod: true,
      ),
      environment:
          configuration.env == 'test' ? Environment.test : Environment.europe,
      countryCode: 'DE',
    );
    final response = await client.startSession(
      amount: amount,
      reference: reference,
      redirectURL: configuration.redirectURL,
    );
    final SessionCheckout sessionCheckout = await AdyenCheckout.session.create(
      sessionId: response.id,
      sessionData: response.sessionData,
      configuration: dropInConfig,
    );

    final paymentResult = await AdyenCheckout.session.startDropIn(
      checkout: sessionCheckout,
      dropInConfiguration: dropInConfig,
    );
    if (paymentResult is PaymentCancelledByUser) {
      await AdyenCheckout.advanced.stopDropIn();
    }
    onPaymentResult(paymentResult);

    return Future.delayed(const Duration(seconds: 2));
  }
}
