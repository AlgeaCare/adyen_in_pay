enum KlarnaEnvironment { production, staging }

enum KlarnaRegion {
  eu('EU'),
  us('US');

  const KlarnaRegion(this.value);
  final String value;
}
