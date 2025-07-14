import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/platform/drop_in.dart' show paymentData, setPaymentData;
import 'package:adyen_in_pay/src/utils/commons.dart' show resultCodeFromString;
import 'package:adyen_in_pay/src/utils/redirect_url_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show BuildContext, Widget, TargetPlatform;
import 'package:ua_client_hints/ua_client_hints.dart' as user_agent show userAgent;

void dropIn({
  required BuildContext context,
  required AdyenClient client,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  required ShopperPaymentInformation shopperPaymentInformation,
  required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,
  PaymentInformation? paymentInformation,
  Widget? widgetChildCloseForWeb,
  bool acceptOnlyCard = false,
  String? webURL,
   Widget Function(String url, Function()? onRetry)? topTitleBottomSheetWidget,
}) => dropInAdvancedMobile(
  context: context,
  client: client,
  reference: reference,
  configuration: configuration,
  onPaymentResult: onPaymentResult,
  shopperPaymentInformation: shopperPaymentInformation,
  onConfigurationStatus: onConfigurationStatus,
  acceptOnlyCard: acceptOnlyCard,
  paymentInformation: paymentInformation,
  topTitleBottomSheetWidget: topTitleBottomSheetWidget,
);

Future<void> dropInAdvancedMobile({
  required BuildContext context,
  required AdyenClient client,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  required ShopperPaymentInformation shopperPaymentInformation,
  bool acceptOnlyCard = false,
  required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,
  PaymentInformation? paymentInformation,
  Widget Function(String url, Function()? onRetry)? topTitleBottomSheetWidget,
}) async {
  onConfigurationStatus(ConfigurationStatus.started);
  final ValueNotifier<bool> isKlarnaNotifier = ValueNotifier(false);
  final channel = defaultTargetPlatform == TargetPlatform.android ? 'android' : 'ios';
  var paymentInfo = paymentInformation;
  PaymentMethodResponse? paymentMethods;
  try {
    final String userAgent = await user_agent.userAgent();

    paymentInfo ??= await client.paymentInformation(invoiceId: reference);
    paymentMethods = await client.getPaymentMethods(
      data: {
        'invoiceId': reference,
        'browserInfo': {
          'acceptHeader':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
          'userAgentHeader': userAgent,
        },
        'channel': channel,
        'shopperLocale': shopperPaymentInformation.locale,
      },
    );

    await Future.delayed(const Duration(seconds: 2));
    onConfigurationStatus(ConfigurationStatus.done);
  } catch (e) {
    onConfigurationStatus(ConfigurationStatus.error);
    return;
  }

  final dropInConfig = DropInConfiguration(
    clientKey: configuration.adyenKeysConfiguration.clientKey,
    amount: Amount(value: configuration.amount ?? paymentInfo.amountDue, currency: 'EUR'),
    // paymentMethodNames: paymentMethods.toMap(),
    skipListWhenSinglePaymentMethod: true,
    shopperLocale: shopperPaymentInformation.locale,
    cardConfiguration: CardConfiguration(
      holderNameRequired: true,
      showStorePaymentField: true,
      supportedCardTypes: acceptOnlyCard ? paymentMethods.onlyCardBrands() : [],
    ),
    applePayConfiguration: ApplePayConfiguration(
      merchantId: configuration.adyenKeysConfiguration
          .appleMerchantId, //'merchant.com.algeacare.${configuration.env == 'test' ? 'staging.' : ''}app',
      merchantName: configuration.adyenKeysConfiguration.merchantName,
      merchantCapability: ApplePayMerchantCapability.credit,
      allowOnboarding: true,
    ),
    googlePayConfiguration: GooglePayConfiguration(
      merchantInfo: MerchantInfo(
        merchantId: shopperPaymentInformation
            .appleMerchantId, //'merchant.com.algeacare.${configuration.env == 'test' ? 'staging.' : ''}app',
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
        final selectedPaymentMethod = data['paymentMethod']['type'];

        final modifiedData = data
          ..putIfAbsent('channel', () => channel)
          ..putIfAbsent('reference', () => reference)
          ..putIfAbsent('returnUrl', () => configuration.redirectURL);

        final onlyCardsTypes = ((paymentMethods?.onlyCards()['paymentMethods'] as List?) ?? [])
            .map((method) => method['type'])
            .cast<String>()
            .toList();

        if (onlyCardsTypes.contains(selectedPaymentMethod)) {
          modifiedData.putIfAbsent(
            'authenticationData',
            () => {
              'threeDSRequestData': {'nativeThreeDS': 'preferred'},
            },
          );
        }

        final result = await client.makePayment(
          paymentInfo!,
          modifiedData,
          billingAddress: shopperPaymentInformation.billingAddress,
          countryCode: shopperPaymentInformation.countryCode,
          shopperLocale: shopperPaymentInformation.locale,
          telephoneNumber: shopperPaymentInformation.telephoneNumber,
        );
        if (result.action?['paymentMethodType']?.contains('klarna') == true &&
            result.actionType == 'redirect') {
          // setPaymentData(result.action?['paymentData']);
          isKlarnaNotifier.value = true;
          await AdyenCheckout.advanced.stopDropIn();
          if (!context.mounted) {
            return Error(errorMessage: "");
          }
          final resultRedirectURL = await showRedirectUrlBottomSheet(
            context: context,
            redirectUrl: configuration.redirectURL,
            url: result.action!['url'],
            topTitleWidget: topTitleBottomSheetWidget,
            onRetry: () {
              debugPrint("onRetry called");
              dropInAdvancedMobile(
                context: context,
                client: client,
                reference: reference,
                configuration: configuration,
                onPaymentResult: onPaymentResult,
                shopperPaymentInformation: shopperPaymentInformation,
                onConfigurationStatus: onConfigurationStatus,
                acceptOnlyCard: false,
                paymentInformation: paymentInfo,
              );
            },
            onPaymentDetail: (String resultCode) async {
              final data = <String, dynamic>{};
              // data.putIfAbsent('paymentData', () => paymentData);
              data["provider"] = {
                "details": {"redirectResult": resultCode},
              };
              data["payment"] = {'invoiceId': reference};
              return await client.makeDetailPayment(data);
            },
          );
          switch (resultRedirectURL) {
            case Finished():
              if (resultRedirectURL.resultCode == "cancelled") {
                onPaymentResult(PaymentCancelledByUser());
                break;
              }

              onPaymentResult(
                PaymentAdvancedFinished(
                  resultCode: resultCodeFromString(resultRedirectURL.resultCode),
                ),
              );
              break;
            case Action():
            case Update():
              onPaymentResult(PaymentError(reason: 'Action should not happen'));
            case Error():
              onPaymentResult(PaymentError(reason: resultRedirectURL.errorMessage));
          }
        }
        if (result.actionType == 'threeDS2' ||
            // result.actionType == 'redirect' ||
            result.actionType == 'qrCode' ||
            result.actionType == 'await' ||
            result.actionType == 'sdk') {
          setPaymentData(result.action?['paymentData']);
          return Action(actionResponse: result.action!);
        }
        if (result.resultCode == PaymentResultCode.authorised ||
            result.resultCode == PaymentResultCode.received ||
            result.resultCode == PaymentResultCode.paid) {
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
        if (result.resultCode.toLowerCase() == PaymentResultCode.authorised.name.toLowerCase() ||
            result.resultCode.toLowerCase() == PaymentResultCode.pending.name.toLowerCase() ||
            result.resultCode.toLowerCase() == PaymentResultCode.received.name.toLowerCase() ||
            result.resultCode.toLowerCase() == PaymentResultCode.paid.name.toLowerCase()) {
          return Finished(resultCode: '201');
        }
        return Error(errorMessage: result.resultCode.toString());
      },
    ),
  );
  if (paymentResult is PaymentCancelledByUser) {
    await AdyenCheckout.advanced.stopDropIn();
  }
  if (!isKlarnaNotifier.value) {
    onPaymentResult(paymentResult);
  }

  return Future.delayed(const Duration(seconds: 1));
}
