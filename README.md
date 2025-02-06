# Adyen In Pay Flutter Plugin

A comprehensive Flutter plugin for integrating Adyen payment solutions into your Flutter applications. This project consists of three main packages that work together to provide a complete Adyen payment integration solution.

## Packages Overview

### 1. Adyen In Pay (Main Package)

The main package that provides a unified interface for implementing Adyen payments in your Flutter applications.

**Features:**
- Cross-platform support (Web, iOS, Android)
- Unified payment widget
- Easy configuration
- Payment status handling

**Installation:**
```yaml
dependencies:
  adyen_in_pay: ^latest_version
```

**Basic Usage:**
```dart
AdyenPayWidget(
  amount: 1000, // Amount in cents
  reference: "order_reference",
  configuration: AdyenConfiguration(
    clientKey: "your_client_key",
    adyenAPI: "your_api_endpoint",
    env: 'test', // or 'live'
    redirectURL: 'your_redirect_url',
  ),
  onPaymentResult: (PaymentResult payment) {
    // Handle payment result
  },
)
```

### 2. Adyen Client API Package

A dedicated package for handling API communications with Adyen's payment services.

**Features:**
- Session management
- Payment method handling
- Secure API communication

**Installation:**
```yaml
dependencies:
  adyen_client_api: ^latest_version
```

### 3. Adyen Web Flutter Package

Specialized package for web-specific implementations of Adyen payment solutions.

**Features:**
- Web-specific payment components
- Iframe integration
- Web payment session handling

**Installation:**
```yaml
dependencies:
  adyen_web_flutter: ^latest_version
```

## Getting Started

1. Add the required dependencies to your `pubspec.yaml`
2. Configure your Adyen API credentials
3. Implement the payment widget in your application
4. Handle payment results

## Example

Check the `example` directory for a complete implementation example.

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web

## Additional Resources

- [Adyen Documentation](https://docs.adyen.com)
- [Flutter Documentation](https://flutter.dev/docs)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
