import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/platform/drop_in.dart' show paymentData, setPaymentData;
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart' show BuildContext, Widget, TargetPlatform;
import 'package:ua_client_hints/ua_client_hints.dart' as user_agent show userAgent;

void dropIn({
  required BuildContext context,
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  required ShopperPaymentInformation shopperPaymentInformation,
  required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,

  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  String? webURL,
}) => dropInAdvancedMobile(
  client: client,
  amount: amount,
  reference: reference,
  configuration: configuration,
  onPaymentResult: onPaymentResult,
  shopperPaymentInformation: shopperPaymentInformation,
  onConfigurationStatus: onConfigurationStatus,
  acceptOnlyCard: acceptOnlyCard,
);

Future<void> dropInAdvancedMobile({
  required AdyenClient client,
  required int amount,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  required ShopperPaymentInformation shopperPaymentInformation,
  bool acceptOnlyCard = false,
  required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,
}) async {
  onConfigurationStatus(ConfigurationStatus.started);
  final channel = defaultTargetPlatform == TargetPlatform.android ? 'android' : 'ios';
  final String userAgent = await user_agent.userAgent();
  final paymentInformation = await client.paymentInformation(invoiceId: reference);
  final paymentMethods = await client.getPaymentMethods(
    data: {
      'shopperEmail': paymentInformation.email,
      'browserInfo': {
        'acceptHeader':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
        'userAgentHeader': userAgent,
      },
      'channel': channel,
    },
  );
  final adyenConfiguration = await client.getClientKey(
    dopplerKey: configuration.dopplerConfiguration.dopplerKey,
    dopplerEnvironment: configuration.dopplerConfiguration.dopplerEnvironment,
  );
  await Future.delayed(const Duration(seconds: 2));
  onConfigurationStatus(ConfigurationStatus.done);
  final dropInConfig = DropInConfiguration(
    clientKey: adyenConfiguration.clientKey,
    amount: Amount(value: amount, currency: 'EUR'),
    // paymentMethodNames: paymentMethods.toMap(),
    skipListWhenSinglePaymentMethod: true,
    shopperLocale: shopperPaymentInformation.locale,
    cardConfiguration: CardConfiguration(
      holderNameRequired: true,
      showStorePaymentField: true,
      supportedCardTypes: acceptOnlyCard ? paymentMethods.onlyCardBrands() : [],
    ),
    applePayConfiguration: ApplePayConfiguration(
      merchantId:
          adyenConfiguration
              .appleMerchantId, //'merchant.com.algeacare.${configuration.env == 'test' ? 'staging.' : ''}app',
      merchantName: adyenConfiguration.merchantName,
      merchantCapability: ApplePayMerchantCapability.credit,
      allowOnboarding: true,
    ),
    googlePayConfiguration: GooglePayConfiguration(
      merchantInfo: MerchantInfo(
        merchantId:
            shopperPaymentInformation
                .merchantId, //'merchant.com.algeacare.${configuration.env == 'test' ? 'staging.' : ''}app',
        merchantName: shopperPaymentInformation.merchantName,
      ),
      googlePayEnvironment:
          configuration.env == 'test' ? GooglePayEnvironment.test : GooglePayEnvironment.production,
    ),
    storedPaymentMethodConfiguration: StoredPaymentMethodConfiguration(
      showPreselectedStoredPaymentMethod: true,
    ),
    environment: configuration.env == 'test' ? Environment.test : Environment.europe,
    countryCode: shopperPaymentInformation.countryCode,
  );
  final paymentResult = await AdyenCheckout.advanced.startDropIn(
    dropInConfiguration: dropInConfig,
    paymentMethods: acceptOnlyCard ? paymentMethods.onlyCards() : paymentMethods.toJson(),
    checkout: AdvancedCheckout(
      onSubmit: (data, [extra]) async {
        final result = await client.makePayment(
          paymentInformation,
          data
            ..putIfAbsent('channel', () => channel)
            ..putIfAbsent(
              'authenticationData',
              () => {
                'threeDSRequestData': {'nativeThreeDS': 'preferred'},
              },
            )
            ..putIfAbsent('reference', () => reference)
            ..putIfAbsent('returnUrl', () => configuration.redirectURL),
          billingAddress: shopperPaymentInformation.billingAddress,
          countryCode: shopperPaymentInformation.countryCode,
          shopperLocale: shopperPaymentInformation.locale,
          telephoneNumber: shopperPaymentInformation.telephoneNumber,
        );
        if (result.actionType == 'threeDS2' ||
            result.actionType == 'redirect' ||
            result.actionType == 'qrCode' ||
            result.actionType == 'await' ||
            result.actionType == 'sdk') {
          setPaymentData(result.action?['paymentData']);
          return Action(actionResponse: result.action!);
        }
        if (result.resultCode == PaymentResultCode.authorised ||
            result.resultCode == PaymentResultCode.received) {
          return Finished(resultCode: '201');
        }
        return Error(errorMessage: result.resultCode.toString());
      },
      onAdditionalDetails: (paymentResult) async {
        final data = <String, dynamic>{};
        paymentResult.putIfAbsent('paymentData', () => paymentData);
        data["provider"] = paymentResult;
        data["payment"] = {'invoiceId': reference};
        final result = await client.makeDetailPayment(data);
        if (result.resultCode.toLowerCase() == PaymentResultCode.authorised.name.toLowerCase()) {
          return Finished(resultCode: '201');
        }
        return Error(errorMessage: result.resultCode.toString());
      },
    ),
  );
  if (paymentResult is PaymentCancelledByUser) {
    await AdyenCheckout.advanced.stopDropIn();
  }
  onPaymentResult(paymentResult);

  return Future.delayed(const Duration(seconds: 1));
}
