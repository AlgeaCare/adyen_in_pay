enum VoucherBasketItemType {
  voucher('voucher'),
  goa('goa'),
  aux('aux');

  const VoucherBasketItemType(this.label);

  final String label;

  @override
  String toString() => label;
}
