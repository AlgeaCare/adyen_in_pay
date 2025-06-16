typedef DopplerConfiguration = ({String dopplerKey, String dopplerEnvironment});

class AdyenConfiguration {
  final String? clientKey;
  final String env;
  final String redirectURL;
  final bool acceptOnlyCard;
  final DopplerConfiguration dopplerConfiguration;
  AdyenConfiguration({
    this.clientKey,
    required this.env,
    required this.redirectURL,
    this.acceptOnlyCard = false,
    required this.dopplerConfiguration,
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
