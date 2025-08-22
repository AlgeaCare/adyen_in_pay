import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_in_pay/adyen_in_pay.dart';
import 'package:adyen_in_pay/src/models/klarna_native_configuration.dart';
import 'package:adyen_in_pay/src/platform/drop_in.dart' show paymentData, setPaymentData;
import 'package:adyen_in_pay/src/utils/commons.dart' show resultCodeFromString;
import 'package:adyen_in_pay/src/utils/klarna_native_bottom_sheet.dart' show showKlarnaBottomSheet;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show BuildContext, Widget, TargetPlatform;
import 'package:klarna_flutter_pay/klarna_flutter_pay.dart' show KlarnaEnvironment;
import 'package:ua_client_hints/ua_client_hints.dart';
import 'package:url_launcher/url_launcher.dart';

void dropIn({
  required BuildContext context,
  required AdyenClient client,
  required String reference,
  required AdyenConfiguration configuration,
  required Function(PaymentResult payment) onPaymentResult,
  required ShopperPaymentInformation shopperPaymentInformation,
  required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,
  PaymentMethodResponse Function(PaymentMethodResponse paymentMethods)? skipPaymentMethodCallback,
  PaymentInformation? paymentInformation,
  Widget? widgetChildCloseForWeb,
  bool ignoreGooglePay = false,
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
  skipPaymentMethodCallback: skipPaymentMethodCallback,
  onConfigurationStatus: onConfigurationStatus,
  acceptOnlyCard: acceptOnlyCard,
  ignoreGooglePay: ignoreGooglePay,
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
  PaymentMethodResponse Function(PaymentMethodResponse paymentMethods)? skipPaymentMethodCallback,
  bool acceptOnlyCard = false,
  bool ignoreGooglePay = false,
  required Function(ConfigurationStatus configurationStatus) onConfigurationStatus,
  PaymentInformation? paymentInformation,
  Widget Function(String url, Function()? onRetry)? topTitleBottomSheetWidget,
}) async {
  onConfigurationStatus(ConfigurationStatus.started);
  final ValueNotifier<bool> isKlarnaNotifier = ValueNotifier(false);
  final channel = defaultTargetPlatform == TargetPlatform.android ? 'android' : 'ios';
  var paymentInfo = paymentInformation;
  PaymentMethodResponse? paymentMethods;
  String userAgentStr = 'Bloomwell/7.4.1 (Android 15; SM-A546B; a54x; arm64-v8a)';
  try {
    // userAgentStr = await userAgent();

    paymentInfo ??= await client.paymentInformation(invoiceId: reference);
    paymentMethods = await client.getPaymentMethods(
      data: {
        'invoiceId': reference,
        'browserInfo': {
          'acceptHeader':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
          'userAgentHeader': userAgentStr,
        },
        'channel': channel,
        'shopperLocale': shopperPaymentInformation.locale,
      },
    );
    paymentMethods = skipPaymentMethodCallback?.call(paymentMethods) ?? paymentMethods;
    onConfigurationStatus(ConfigurationStatus.done);
  } catch (e, trace) {
    debugPrint(e.toString());
    debugPrint(trace.toString());
    onConfigurationStatus(ConfigurationStatus.error);
    return;
  }

  final dropInConfig = DropInConfiguration(
    clientKey: configuration.adyenKeysConfiguration.clientKey,
    amount: Amount(value: configuration.amount ?? paymentInfo.amountDue, currency: 'EUR'),
    skipListWhenSinglePaymentMethod: true,
    shopperLocale: shopperPaymentInformation.locale,
    cardConfiguration: CardConfiguration(
      holderNameRequired: true,
      showStorePaymentField: true,
      supportedCardTypes: acceptOnlyCard ? paymentMethods.onlyCardBrands() : [],
    ),
    applePayConfiguration: ApplePayConfiguration(
      merchantId:
          configuration
              .adyenKeysConfiguration
              .appleMerchantId, //'merchant.com.algeacare.${configuration.env == 'test' ? 'staging.' : ''}app',
      merchantName:
          paymentMethods.applePayConfiguration?["merchantName"] ??
          configuration.adyenKeysConfiguration.merchantName,
      allowShippingContactEditing: true,
      billingContact: ApplePayContact(
        emailAddress: configuration.userEmail,
        phoneNumber: shopperPaymentInformation.telephoneNumber,
        city: shopperPaymentInformation.billingAddress.city,
        country: shopperPaymentInformation.billingAddress.country,
        postalCode: shopperPaymentInformation.billingAddress.postalCode,
        addressLines: [
          shopperPaymentInformation.billingAddress.street,
          shopperPaymentInformation.billingAddress.houseNumberOrName,
        ],
      ),
      allowOnboarding: true,
    ),
    googlePayConfiguration: GooglePayConfiguration(
      merchantAccount:
          paymentMethods.googlePayConfiguration?["merchantId"] ??
          configuration.adyenKeysConfiguration.googleMerchantId,
      googlePayEnvironment:
          configuration.env == 'test' ? GooglePayEnvironment.test : GooglePayEnvironment.production,

      merchantInfo: MerchantInfo(
        merchantName:
            paymentMethods.googlePayConfiguration?["merchantId"] ??
            configuration.adyenKeysConfiguration.merchantName,
        merchantId: configuration.adyenKeysConfiguration.googleMerchantId,
      ),
    ),
    storedPaymentMethodConfiguration: StoredPaymentMethodConfiguration(
      showPreselectedStoredPaymentMethod: true,
    ),
    environment: configuration.env == 'test' ? Environment.test : Environment.europe,
    countryCode: shopperPaymentInformation.countryCode,
  );
  final paymentResult = await AdyenCheckout.advanced.startDropIn(
    dropInConfiguration: dropInConfig,
    paymentMethods:
        acceptOnlyCard
            ? paymentMethods.onlyCards()
            : paymentMethods.toJson(ignoreGooglePay: ignoreGooglePay),
    checkout: AdvancedCheckout(
      onSubmit: (data, [extra]) async {
        final selectedPaymentMethod = data['paymentMethod']['type'];
        final paymentMethodType = data['paymentMethod']['type'];
        if (paymentMethodType.contains('klarna')) {
          data['paymentMethod'] = {'type': paymentMethodType, 'subtype': 'sdk'};
        }
        final modifiedData =
            data
              ..putIfAbsent('channel', () => channel)
              ..putIfAbsent('reference', () => reference)
              ..putIfAbsent('returnUrl', () => configuration.redirectURL);

        final onlyCardsTypes =
            ((paymentMethods?.onlyCards()['paymentMethods'] as List?) ?? [])
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
          userAgent: defaultTargetPlatform == TargetPlatform.android ? userAgentStr : null,
        );
        if (result.action?['paymentMethodType']?.contains('klarna') == true) {
          debugPrint("result: ${result.action?.toString()}");
          // setPaymentData(result.action?['paymentData']);

          isKlarnaNotifier.value = true;
          await AdyenCheckout.advanced.stopDropIn();
          if (!context.mounted) {
            return Error(errorMessage: "context is not mounted");
          }
          final resultKlarna = await showKlarnaBottomSheet(
            context: context,
            environment:
                configuration.env == 'test'
                    ? KlarnaEnvironment.staging
                    : KlarnaEnvironment.production,
            klarnaNativeConfiguration: KlarnaNativeConfiguration(
              redirectUrl: configuration.redirectURL,
              clientToken: result.action!['sdkData']['client_token'],
              paymentData: result.action!['paymentData'],
              category: result.action!['sdkData']['payment_method_category'],
            ),
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
            onPaymentDetail: (Map<String, dynamic> paymentDetailbody) async {
              final data = <String, dynamic>{};
              // data.putIfAbsent('paymentData', () => paymentData);
              data["provider"] = paymentDetailbody;
              data["payment"] = {'invoiceId': reference};
              return await client.makeDetailPayment(data);
            },
          );
          switch (resultKlarna) {
            case Finished():
              if (resultKlarna.resultCode == "cancelled") {
                onPaymentResult(PaymentCancelledByUser());
                break;
              }

              onPaymentResult(
                PaymentAdvancedFinished(resultCode: resultCodeFromString(resultKlarna.resultCode)),
              );
              break;
            case Action():
            case Update():
              onPaymentResult(PaymentError(reason: 'Action should not happen'));
            case Error():
              onPaymentResult(PaymentError(reason: resultKlarna.errorMessage));
          }
        } else if (result.action?['paymentMethodType']?.contains('paybybank') == true &&
            result.actionType == 'redirect') {
          isKlarnaNotifier.value = true;
          await AdyenCheckout.advanced.stopDropIn();
          if (!context.mounted) {
            return Error(errorMessage: "");
          }
          await launchUrl(
            Uri.parse(result.action!['url']),
            mode: LaunchMode.externalApplication,
            browserConfiguration: const BrowserConfiguration(showTitle: true),
          );
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
          return Finished(resultCode: result.resultCode.toString());
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
