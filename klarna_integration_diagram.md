# Klarna Integration Architecture

## Overview
This diagram shows the complete Klarna payment integration flow within the Adyen In-Pay Flutter application.

## Architecture Diagram

```mermaid
graph TB
    %% Main Application Layer
    subgraph "Flutter App Layer"
        App[Main Flutter App]
        DropIn[Drop-in Component]
        Config[Configuration Input]
    end

    %% Klarna Integration Layer
    subgraph "Klarna Integration Layer"
        KlarnaBS[Klarna Native Bottom Sheet]
        KlarnaWidget[Klarna Payment Widget]
        KlarnaConfig[Klarna Native Configuration]
    end

    %% Klarna Flutter Pay Package
    subgraph "Klarna Flutter Pay Package"
        KlarnaFlutterPay[KlarnaFlutterPay Class]
        KlarnaPaymentWidget[KlarnaPaymentWidget]
        KlarnaCommons[Klarna Commons]
        PlatformInterface[Platform Interface]
    end

    %% Platform Specific Implementation
    subgraph "Platform Layer"
        AndroidView[Android Native View]
        iOSView[iOS Native View]
        MethodChannel[Method Channel]
    end

    %% External Services
    subgraph "External Services"
        KlarnaSDK[Klarna Native SDK]
        AdyenAPI[Adyen Payment API]
        PaymentBackend[Payment Backend]
    end

    %% Flow connections
    App --> DropIn
    DropIn --> KlarnaBS
    Config --> KlarnaConfig
    KlarnaBS --> KlarnaWidget
    KlarnaConfig --> KlarnaWidget
    
    KlarnaWidget --> KlarnaPaymentWidget
    KlarnaPaymentWidget --> KlarnaFlutterPay
    KlarnaFlutterPay --> PlatformInterface
    
    PlatformInterface --> AndroidView
    PlatformInterface --> iOSView
    AndroidView --> MethodChannel
    iOSView --> MethodChannel
    
    MethodChannel --> KlarnaSDK
    KlarnaSDK --> AdyenAPI
    AdyenAPI --> PaymentBackend

    %% Styling
    classDef appLayer fill:#e1f5fe
    classDef integrationLayer fill:#f3e5f5
    classDef packageLayer fill:#e8f5e8
    classDef platformLayer fill:#fff3e0
    classDef externalLayer fill:#ffebee

    class App,DropIn,Config appLayer
    class KlarnaBS,KlarnaWidget,KlarnaConfig integrationLayer
    class KlarnaFlutterPay,KlarnaPaymentWidget,KlarnaCommons,PlatformInterface packageLayer
    class AndroidView,iOSView,MethodChannel platformLayer
    class KlarnaSDK,AdyenAPI,PaymentBackend externalLayer
```

## Payment Flow Sequence

```mermaid
sequenceDiagram
    participant User
    participant App as Flutter App
    participant DropIn as Drop-in Component
    participant KlarnaBS as Klarna Bottom Sheet
    participant KlarnaWidget as Klarna Payment Widget
    participant Platform as Platform Channel
    participant KlarnaSDK as Klarna Native SDK
    participant Backend as Payment Backend

    User->>App: Initiate Payment
    App->>DropIn: Show Payment Options
    User->>DropIn: Select Klarna Payment
    
    DropIn->>KlarnaBS: showKlarnaBottomSheet()
    KlarnaBS->>KlarnaWidget: Create KlarnaWidgetBottomSheet
    
    KlarnaWidget->>Platform: Initialize Platform View
    Platform->>KlarnaSDK: Initialize Klarna SDK
    KlarnaSDK-->>Platform: SDK Ready
    Platform-->>KlarnaWidget: initKlarna callback
    
    KlarnaWidget->>User: Show Klarna Payment UI
    User->>KlarnaWidget: Complete Payment Details
    
    KlarnaWidget->>Platform: Authorize Payment
    Platform->>KlarnaSDK: authorize()
    KlarnaSDK->>Backend: Process Authorization
    Backend-->>KlarnaSDK: Authorization Token
    KlarnaSDK-->>Platform: finishKlarna callback
    Platform-->>KlarnaWidget: onKlarnaFinished()
    
    KlarnaWidget->>KlarnaBS: onPaymentEvent(authToken)
    KlarnaBS->>Backend: Submit Payment Details
    Backend-->>KlarnaBS: Payment Result
    
    alt Payment Successful
        KlarnaBS-->>DropIn: Finished(resultCode)
        DropIn-->>App: Payment Success
        App-->>User: Show Success Message
    else Payment Failed
        KlarnaBS-->>DropIn: Error(errorMessage)
        DropIn-->>App: Payment Error
        App-->>User: Show Error Message
    end
```

## Component Details

### Key Components

1. **KlarnaNativeConfiguration**
   - Stores client token, payment data, redirect URL
   - Configuration object for Klarna payments

2. **KlarnaWidgetBottomSheet**
   - Modal bottom sheet container
   - Handles payment events and callbacks
   - Manages navigation and result handling

3. **KlarnaPaymentWidget**
   - Core payment widget with platform views
   - Handles Android/iOS native implementations
   - Manages loading states and error handling

4. **Platform Integration**
   - Uses AndroidView/UiKitView for native rendering
   - Method channels for Flutter-Native communication
   - Supports both staging and production environments

### Payment States

- **Loading**: Initializing Klarna SDK
- **Ready**: Payment UI displayed to user
- **Processing**: Payment authorization in progress
- **Success**: Payment completed successfully
- **Error**: Payment failed or cancelled

### Environment Support

- **Staging**: Development and testing
- **Production**: Live payments
- **Regions**: EU and US support
