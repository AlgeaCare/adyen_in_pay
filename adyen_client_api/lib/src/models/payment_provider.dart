enum PaymentProvider {
  adyen('adyen'),
  unzer('unzer');

  const PaymentProvider(this.label);

  final String label;

  @override
  String toString() => label;
}
