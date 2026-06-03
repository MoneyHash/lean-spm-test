# MoneyHashLeanSDK

A unified Swift Package that provides comprehensive wrappers for both MoneyHash and Lean SDKs, enabling seamless payment processing and bank connectivity in iOS applications.

## Features

### MoneyHash SDK Wrapper
- 💳 **Card Payments**: Complete card payment processing with validation
- 🍎 **Apple Pay**: Native Apple Pay integration with full support
- 📱 **Form Rendering**: Pre-built payment forms and UI components
- 🔄 **Subscriptions**: Subscription plan management and processing
- 📊 **Installments**: Flexible installment plan options
- 💰 **Fees & Discounts**: Dynamic fee and discount management
- 🔍 **BIN Lookup**: Card validation and information retrieval

### Lean SDK Wrapper
- 🏦 **Bank Linking**: Secure bank account connection
- 🌍 **Multi-Country**: Support for UAE, Saudi Arabia, Egypt, and more
- 💸 **Bank Transfers**: Direct bank-to-bank payment processing
- 👤 **Customer Management**: Customer account and data management
- 🎨 **UI Customization**: Flexible theming and branding options
- 🔐 **Permission Control**: Granular access control for bank data

### Unified Payment SDK
- 🚀 **Single Integration**: One interface for both payment providers
- ⚖️ **Smart Routing**: Intelligent payment method selection
- 📊 **Unified Analytics**: Combined reporting and insights
- 🔄 **Fallback Support**: Automatic failover between payment methods

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/moeyhashleantest-spm", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version and add to your target

### Manual Installation

1. Download the latest `moeyhashleantest.xcframework` from releases
2. Drag and drop into your Xcode project
3. Add to "Frameworks, Libraries, and Embedded Content"

## Quick Start

### Import the SDK

```swift
import moeyhashleantest  // Main unified wrapper
import MoneyHash         // Direct MoneyHash access
import LeanSDK          // Direct Lean access
```

### Initialize Individual SDKs

```swift
// MoneyHash SDK
let moneyHash = MoneyHashWrapper.createDefault(publicKey: "your_moneyhash_public_key")
    .configure(locale: .en, logLevel: .debug)

// Lean SDK  
let lean = LeanSDKWrapper.createForCountry(
    appToken: "your_lean_app_token",
    country: .saudiArabia,
    sandbox: true
)
```

### Unified SDK (Recommended)

```swift
// Initialize unified SDK
let unifiedSDK = UnifiedPaymentSDK(
    moneyHashPublicKey: "your_moneyhash_key",
    leanAppToken: "your_lean_token",
    sandbox: true
)

// Get available payment methods
let methods = try await unifiedSDK.getAvailablePaymentMethods(
    currency: "USD",
    amount: 100.0,
    customer: "customer_123"
)

// Setup bank connection
let bankStatus = try await unifiedSDK.setupBankConnection(
    customerId: "customer_123"
)
```

## Examples

### MoneyHash Payment Processing

```swift
// Apple Pay payment
let receipt = try await moneyHash.generateApplePayReceipt(
    amount: 50.0,
    merchantIdentifier: "merchant.com.yourapp",
    currencyCode: "USD",
    countryCode: "US"
)

let result = try await moneyHash.submitPaymentReceipt(
    intentId: "intent_123",
    nativePayReceipt: receipt
)

// Card payment with validation
let cardData = try await moneyHash.collectCardData()
let payment = try await moneyHash.payWithCard(
    intentId: "intent_123",
    cardData: cardData!,
    saveCard: true
)
```

### Lean Bank Operations

```swift
// Link bank account
let linkResult = try await lean.linkBankAccount(
    customerId: "customer_123",
    permissions: [.identity, .accounts, .payments]
)

// Make bank transfer
let transfer = try await lean.makePayment(
    customerId: "customer_123",
    amount: 100.0,
    currency: "AED",
    beneficiaryId: "beneficiary_456"
)

// Customize UI
let customization = LeanSDKWrapper.LeanCustomization(
    buttonTextColor: "#FFFFFF",
    themeColor: "#007AFF"
)
lean.configure(customization: customization)
```

### Unified Payment Processing

```swift
// Process payments across both platforms
enum PaymentMethod {
    case moneyHashCard
    case moneyHashApplePay  
    case leanBankTransfer
    case leanWallet
}

let paymentId = try await unifiedSDK.processUnifiedPayment(
    method: .moneyHashApplePay,
    amount: 75.0,
    currency: "USD",
    customerId: "customer_123",
    intentId: "intent_456"
)
```

## Configuration

### MoneyHash Configuration

```swift
// Basic setup
let wrapper = MoneyHashWrapper(publicKey: "pk_live_...")

// With Apple Pay
let wrapper = MoneyHashWrapper.createWithApplePay(
    publicKey: "pk_live_...",
    merchantIdentifier: "merchant.com.yourapp"
)

// Configure settings
wrapper.setLocale(.arabic)
wrapper.setLogLevel(.verbose)
wrapper.setCrossplatformVersion("1.0.0")
```

### Lean Configuration

```swift
// Country-specific setup
let lean = LeanSDKWrapper.createForCountry(
    appToken: "lean_app_token",
    country: .uae,
    sandbox: false
)

// Custom configuration
let config = LeanSDKWrapper.LeanConfiguration(
    appToken: "lean_app_token",
    sandbox: true,
    version: "latest",
    language: "ar"
)
```

## Supported Countries

### MoneyHash
- 🌍 **Global**: Supports international payments
- 💳 **Cards**: Visa, Mastercard, American Express
- 🍎 **Apple Pay**: Available in supported regions

### Lean
- 🇸🇦 **Saudi Arabia**
- 🇦🇪 **UAE** 
- 🇪🇬 **Egypt**
- 🇧🇭 **Bahrain**
- 🇰🇼 **Kuwait**
- 🇶🇦 **Qatar**
- 🇴🇲 **Oman**

## Error Handling

```swift
do {
    let result = try await unifiedSDK.processUnifiedPayment(
        method: .moneyHashCard,
        amount: 100.0,
        currency: "USD",
        customerId: "customer_123",
        intentId: "intent_456"
    )
    print("Payment successful: \(result)")
} catch UnifiedPaymentSDK.UnifiedError.moneyHashError(let error) {
    print("MoneyHash error: \(error.localizedDescription)")
} catch UnifiedPaymentSDK.UnifiedError.leanError(let error) {
    print("Lean error: \(error.localizedDescription)")
} catch {
    print("General error: \(error.localizedDescription)")
}
```

## Requirements

- **iOS 11.0+**
- **Xcode 12.5+**
- **Swift 5.5+**

## Dependencies

This package automatically includes all required dependencies via Swift Package Manager:
- **MoneyHashLeanSDK**: Main wrapper framework with unified APIs
- **MoneyHash SDK**: MoneyHash payment processing framework (via SPM)
- **LeanSDK**: Lean banking and payment framework (via SPM)

All dependencies are resolved automatically - no manual framework management required.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 **Documentation**: [API Documentation](https://your-docs-site.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/your-org/moeyhashleantest-spm/issues)
- 💬 **Support**: [Contact Support](mailto:support@yourcompany.com)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Changelog

### Version 1.0.0
- ✅ Initial release
- ✅ MoneyHash SDK wrapper
- ✅ Lean SDK wrapper
- ✅ Unified payment interface
- ✅ Complete API coverage
- ✅ Example implementations