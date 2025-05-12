class AdyenConfiguration {
  final String clientKey;
  final String env;
  final String adyenAPI;
  final String redirectURL;

  AdyenConfiguration({
    required this.clientKey,
    required this.env,
    required this.adyenAPI,
    required this.redirectURL,
  });
}


class PayConfiguration {
  final String clientKey;
  final String sessionId;
  final String sessionData;
  final String env;
  final String redirectURL;

  PayConfiguration({
    required this.clientKey,
    required this.sessionId,
    required this.sessionData,
    required this.env,
    required this.redirectURL,
  });
}
