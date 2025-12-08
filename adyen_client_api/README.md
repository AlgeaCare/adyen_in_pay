# Payment Client API

A Dart package for communicating with the Adyen payment backend API. This package provides a clean, type-safe interface for handling payment operations.

## Features

- **Payment Methods** - Retrieve available payment methods
- **Payment Processing** - Make payments and handle payment details
- **Payment Information** - Fetch payment/invoice details
- **Voucher Support** - Apply voucher codes to payments
- **Cost Coverage** - Apply cost coverage codes (e.g., insurance)
- **Preferred Method** - Update user's preferred payment method
- **Pagination** - Fetch paginated payment history

## Installation

```yaml
dependencies:
  payment_client_api:
    git:
      url: https://github.com/AlgeaCare/adyen_in_pay.git
      path: adyen_client_api
```

## Usage

### Initialize the Client

```dart
import 'package:payment_client_api/payment_client_api.dart';

final client = AdyenClient(
  baseUrl: 'https://your-api-endpoint.com',
  interceptors: [/* optional Dio interceptors */],
);
```

### Get Payment Methods

```dart
final methods = await client.getPaymentMethods(data: {
  'merchantAccount': 'YourMerchantAccount',
  'countryCode': 'DE',
  'amount': {'value': 1000, 'currency': 'EUR'},
});
```

### Get Payment Information

```dart
final paymentInfo = await client.paymentInformation(
  invoiceId: 'INV-12345',
);
```

### Make a Payment

```dart
final response = await client.makePayment(
  paymentInformation,
  paymentData,
  countryCode: 'DE',
  shopperLocale: 'de-DE',
  billingAddress: ShopperBillingAddress(...),
);

if (response.resultCode == PaymentResultCode.authorised) {
  // Payment successful
}
```

### Apply Voucher

```dart
final result = await client.applyVoucher(
  invoiceId: 'INV-12345',
  voucherCode: 'DISCOUNT20',
);

print('Discount: ${result.discount}');
print('Amount Due: ${result.amountDue}');
```

### Apply Cost Coverage

```dart
final response = await client.applyCostCoverage(
  invoiceId: 'INV-12345',
  costCoverageCode: 'INS-67890',
);

if (response.applied) {
  print('Coverage applied: ${response.amount}');
  print('Transaction ID: ${response.transaction.id}');
}
```

### Get Payment History

```dart
final payments = await client.getPayments(1, service: 'pharmacy');
```

### Update Preferred Payment Method

```dart
await client.updatePreferredMethod('payment-id', 'scheme');
```

## API Reference

### AdyenClient Methods

| Method | Description |
|--------|-------------|
| `getPaymentMethods()` | Fetch available payment methods |
| `paymentInformation()` | Get payment/invoice details |
| `makePayment()` | Process a payment |
| `makeDetailPayment()` | Handle additional payment details (3DS, etc.) |
| `applyVoucher()` | Apply a voucher code |
| `applyCostCoverage()` | Apply cost coverage (insurance) |
| `getPayments()` | Get paginated payment history |
| `updatePreferredMethod()` | Update preferred payment method |

## Models

- `PaymentMethodResponse` - Available payment methods
- `PaymentInformation` - Invoice/payment details
- `PaymentResponse` - Payment result
- `CostCoverageResponse` - Cost coverage application result
- `PaymentsPageResponse` - Paginated payments list
- `ShopperBillingAddress` - Billing address data

## Testing

```bash
flutter test
```

## License

MIT License
