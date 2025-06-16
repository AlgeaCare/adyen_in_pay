import 'package:adyen_in_pay/src/models/adyen_keys_configuration.dart' show AdyenKeysConfiguration;

typedef DopplerConfiguration = ({String dopplerKey, String dopplerEnvironment});

class AdyenConfiguration {
  final String? clientKey;
  final String env;
  final String redirectURL;
  final bool acceptOnlyCard;
  final AdyenKeysConfiguration adyenKeysConfiguration;
  AdyenConfiguration({
    this.clientKey,
    required this.env,
    required this.redirectURL,
    this.acceptOnlyCard = false,
    required this.adyenKeysConfiguration,
  });
}

class PayConfiguration {
  final String? clientKey;
  final String sessionId;
  final String sessionData;
  final String env;
  final String redirectURL;
  final bool acceptOnlyCard;
  PayConfiguration({
    required this.clientKey,
    required this.sessionId,
    required this.sessionData,
    required this.env,
    required this.redirectURL,
    this.acceptOnlyCard = false,
  });
}
