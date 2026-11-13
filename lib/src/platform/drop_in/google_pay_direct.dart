// Starts Google Pay without Adyen's button widget. Uses adyen_checkout's
// internal component API the same way its GooglePayAdvancedComponent does, so
// re-check this file whenever adyen_checkout is upgraded.
// ignore_for_file: implementation_imports
import 'dart:async';
import 'dart:convert';

import 'package:adyen_checkout/adyen_checkout.dart';
import 'package:adyen_checkout/src/components/component_flutter_api.dart';
import 'package:adyen_checkout/src/components/component_platform_api.dart';
import 'package:adyen_checkout/src/generated/platform_api.g.dart'
    show
        ComponentCommunicationModel,
        ComponentCommunicationType,
        ErrorDTO,
        InstantPaymentSetupResultDTO,
        InstantPaymentType,
        PaymentEventDTO,
        PaymentEventType;
import 'package:adyen_checkout/src/util/constants.dart';
import 'package:adyen_checkout/src/util/dto_mapper.dart';
import 'package:adyen_checkout/src/util/payment_event_handler.dart';
import 'package:adyen_checkout/src/util/sdk_version_number_provider.dart';

/// The Android plugin only accepts its own Google Pay component ids.
const _componentId = 'GOOGLE_PAY_ADVANCED_COMPONENT';

/// Opens Google's payment sheet right away for [paymentMethod].
///
/// Adyen's Android Drop-in never skips its list for Google Pay, so picking it
/// in the app's own list and then opening Drop-in costs the shopper a second
/// tap. This skips Drop-in.
///
/// Returns null when Google Pay is not available on this device, so the
/// caller can fall back to Drop-in.
Future<PaymentResult?> startGooglePayDirectly({
  required GooglePayComponentConfiguration configuration,
  required Map<String, dynamic> paymentMethod,
  required AdvancedCheckout checkout,
}) async {
  final platformApi = ComponentPlatformApi.instance;
  final flutterApi = ComponentFlutterApi.instance;
  final paymentEventHandler = PaymentEventHandler();
  final availability = Completer<InstantPaymentSetupResultDTO>();
  final result = Completer<PaymentResult>();

  Future<void> onSubmit(ComponentCommunicationModel event) async {
    try {
      final decoded = jsonDecode(event.data as String) as Map<String, dynamic>;
      final paymentEvent = await checkout.onSubmit(
        decoded[Constants.submitDataKey],
        decoded[Constants.submitExtraKey],
      );
      await platformApi.onPaymentsResult(
        _componentId,
        paymentEventHandler.mapToPaymentEventDTO(paymentEvent),
      );
    } catch (exception) {
      await platformApi.onPaymentsResult(
        _componentId,
        PaymentEventDTO(
          paymentEventType: PaymentEventType.error,
          error: ErrorDTO(errorMessage: exception.toString()),
        ),
      );
    }
  }

  Future<void> onAdditionalDetails(ComponentCommunicationModel event) async {
    try {
      final decoded = jsonDecode(event.data as String) as Map<String, dynamic>;
      final paymentEvent = await checkout.onAdditionalDetails(decoded);
      await platformApi.onPaymentsDetailsResult(
        _componentId,
        paymentEventHandler.mapToPaymentEventDTO(paymentEvent),
      );
    } catch (exception) {
      await platformApi.onPaymentsDetailsResult(
        _componentId,
        PaymentEventDTO(
          paymentEventType: PaymentEventType.error,
          error: ErrorDTO(errorMessage: exception.toString()),
        ),
      );
    }
  }

  void onResult(ComponentCommunicationModel event) {
    if (result.isCompleted) {
      return;
    }
    final paymentResult = event.paymentResult;
    result.complete(switch (paymentResult?.type) {
      PaymentResultEnum.finished => PaymentAdvancedFinished(
        resultCode: paymentResult?.result?.toResultCode() ?? ResultCode.unknown,
      ),
      PaymentResultEnum.cancelledByUser => PaymentCancelledByUser(),
      _ => PaymentError(reason: paymentResult?.reason),
    });
  }

  final subscription = flutterApi.componentCommunicationStream.stream
      .where((event) => event.componentId == _componentId)
      .listen((event) {
        switch (event.type) {
          case ComponentCommunicationType.availability:
            if (!availability.isCompleted) {
              availability.complete(event.data as InstantPaymentSetupResultDTO);
            }
          case ComponentCommunicationType.onSubmit:
            onSubmit(event);
          case ComponentCommunicationType.additionalDetails:
            onAdditionalDetails(event);
          case ComponentCommunicationType.result:
            onResult(event);
          default:
            break;
        }
      });

  try {
    final configurationDTO = configuration.toDTO(
      await SdkVersionNumberProvider.instance.getSdkVersionNumber(),
      InstantPaymentType.googlePay,
    );
    final encodedPaymentMethod = jsonEncode(paymentMethod);
    platformApi.isInstantPaymentSupportedByPlatform(
      configurationDTO,
      encodedPaymentMethod,
      _componentId,
    );
    final setup = await availability.future.timeout(
      const Duration(seconds: 10),
    );
    if (setup.instantPaymentType != InstantPaymentType.googlePay ||
        !setup.isSupported) {
      return null;
    }
    platformApi.onInstantPaymentPressed(
      configurationDTO,
      encodedPaymentMethod,
      _componentId,
    );
    return await result.future;
  } on TimeoutException {
    return null;
  } finally {
    await subscription.cancel();
    await platformApi.onDispose(_componentId);
    flutterApi.dispose();
  }
}
