import Foundation
import MoneyHashLeanSDK

// MARK: - Basic Usage Examples

/// Example demonstrating basic SDK initialization and usage
class BasicUsageExample {
    
    // MARK: - SDK Initialization
    
    /// Initialize the unified SDK (recommended approach)
    private let unifiedSDK = UnifiedPaymentSDK(
        moneyHashPublicKey: "pk_test_example_key",
        leanAppToken: "lean_test_token",
        sandbox: true
    )
    
    /// Initialize individual SDKs if needed
    private let moneyHashWrapper = MoneyHashWrapper.createDefault(publicKey: "pk_test_example_key")
        .configure(locale: .en, logLevel: .debug)
    
    private let leanWrapper = LeanSDKWrapper.createForCountry(
        appToken: "lean_test_token",
        country: .saudiArabia,
        sandbox: true
    )
    
    // MARK: - Basic Payment Flow
    
    /// Complete payment flow using unified SDK
    func processPayment(amount: Double, currency: String, customerId: String) async throws {
        
        // 1. Setup bank connection (if using Lean)
        print("Setting up bank connection...")
        let bankConnection = try await unifiedSDK.setupBankConnection(customerId: customerId)
        print("Bank connection status: \(bankConnection.status)")
        
        // 2. Get available payment methods
        print("Getting available payment methods...")
        let methods = try await unifiedSDK.getAvailablePaymentMethods(
            currency: currency,
            amount: amount,
            customer: customerId
        )
        
        print("MoneyHash methods available: \(methods.moneyHashMethods?.paymentMethods?.count ?? 0)")
        print("Lean available: \(methods.leanAvailable)")
        
        // 3. Process payment based on available methods
        // This is a simplified example - in practice, you'd present options to the user
        print("Payment flow completed successfully")
    }
    
    // MARK: - MoneyHash Specific Examples
    
    /// Example of MoneyHash-only operations
    func moneyHashExample() async throws {
        
        // Get MoneyHash payment methods
        let methods = try await moneyHashWrapper.getAvailableMethods(
            currency: "USD",
            amount: 100.0,
            customer: "customer_123"
        )
        
        print("Available MoneyHash methods:")
        methods.paymentMethods?.forEach { method in
            print("- \(method.title): \(method.id)")
        }
        
        // Check Apple Pay compatibility
        if moneyHashWrapper.isApplePayCompatible() {
            print("✅ Apple Pay is available on this device")
            
            // Example Apple Pay flow (requires real merchant ID in production)
            let receipt = try await moneyHashWrapper.generateApplePayReceipt(
                amount: 50.0,
                merchantIdentifier: "merchant.com.example.app",
                currencyCode: "USD",
                countryCode: "US"
            )
            
            // In a real app, you would submit this to your payment intent
            print("Apple Pay receipt generated: \(receipt.receipt.prefix(50))...")
        }
        
        // BIN lookup example
        // Note: This requires actual card data in practice
        // let lookupData = try await moneyHashWrapper.performBinLookup()
        // print("Card lookup: \(lookupData.type ?? "Unknown")")
    }
    
    // MARK: - Lean Specific Examples
    
    /// Example of Lean-only operations
    func leanExample() async throws {
        
        // Customize Lean UI
        let customization = LeanSDKWrapper.LeanCustomization(
            buttonTextColor: "#FFFFFF",
            themeColor: "#007AFF",
            dialogMode: "overlay"
        )
        leanWrapper.configure(customization: customization)
        
        // Link bank account
        let linkResult = try await leanWrapper.linkBankAccount(
            customerId: "customer_123",
            permissions: [.identity, .accounts, .transactions, .payments]
        )
        
        print("Bank link result:")
        print("- Status: \(linkResult.status)")
        print("- Message: \(linkResult.message ?? "N/A")")
        print("- Bank: \(linkResult.bank?.bankIdentifier ?? "N/A")")
        
        if linkResult.status == "SUCCESS" {
            // Create payment source
            let paymentSource = try await leanWrapper.createPaymentSource(
                customerId: "customer_123"
            )
            print("Payment source created: \(paymentSource.status)")
            
            // Make a payment
            let payment = try await leanWrapper.makePayment(
                customerId: "customer_123",
                amount: 100.0,
                currency: "AED"
            )
            print("Payment result: \(payment.status)")
        }
    }
    
    // MARK: - Error Handling Examples
    
    /// Comprehensive error handling example
    func errorHandlingExample() async {
        
        do {
            let methods = try await unifiedSDK.getAvailablePaymentMethods(
                currency: "USD",
                amount: 100.0,
                customer: "customer_123"
            )
            print("Success: Got \(methods.moneyHashMethods?.paymentMethods?.count ?? 0) methods")
            
        } catch UnifiedPaymentSDK.UnifiedError.moneyHashError(let error) {
            print("MoneyHash specific error: \(error.localizedDescription)")
            
        } catch UnifiedPaymentSDK.UnifiedError.leanError(let error) {
            print("Lean specific error: \(error.localizedDescription)")
            
        } catch UnifiedPaymentSDK.UnifiedError.integrationError(let message) {
            print("Integration error: \(message)")
            
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Advanced Configuration
    
    /// Example of advanced SDK configuration
    func advancedConfiguration() {
        
        // Advanced MoneyHash configuration
        let advancedMoneyHash = MoneyHashWrapper.createWithApplePay(
            publicKey: "pk_live_production_key",
            merchantIdentifier: "merchant.com.yourapp.payments",
            countryCode: "US"
        )
        
        // Configure additional settings
        advancedMoneyHash.setLocale(.arabic)
        advancedMoneyHash.setLogLevel(.verbose)
        advancedMoneyHash.setCrossplatformVersion("1.0.0")
        
        // Advanced Lean configuration for specific country
        let advancedLean = LeanSDKWrapper.createForCountry(
            appToken: "lean_production_token",
            country: .uae,
            sandbox: false
        )
        
        let customization = LeanSDKWrapper.LeanCustomization(
            buttonTextColor: "#FFFFFF",
            themeColor: "#1E88E5",
            dialogMode: "fullscreen"
        )
        advancedLean.configure(customization: customization)
        
        // Create unified SDK with advanced configuration
        let advancedUnified = UnifiedPaymentSDK(
            moneyHashWrapper: advancedMoneyHash,
            leanWrapper: advancedLean
        )
        
        print("Advanced SDK configuration completed")
    }
}

// MARK: - Usage in SwiftUI

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
struct PaymentView: View {
    @State private var isProcessing = false
    @State private var result = ""
    
    private let sdk = UnifiedPaymentSDK(
        moneyHashPublicKey: "pk_test_key",
        leanAppToken: "lean_test_token",
        sandbox: true
    )
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Payment SDK Example")
                .font(.title)
            
            Button("Process Payment") {
                processPayment()
            }
            .disabled(isProcessing)
            
            if isProcessing {
                ProgressView("Processing...")
            }
            
            if !result.isEmpty {
                Text(result)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private func processPayment() {
        isProcessing = true
        result = ""
        
        Task {
            do {
                let methods = try await sdk.getAvailablePaymentMethods(
                    currency: "USD",
                    amount: 100.0,
                    customer: "customer_123"
                )
                
                await MainActor.run {
                    result = "✅ Success! Found \(methods.moneyHashMethods?.paymentMethods?.count ?? 0) MoneyHash methods"
                    isProcessing = false
                }
                
            } catch {
                await MainActor.run {
                    result = "❌ Error: \(error.localizedDescription)"
                    isProcessing = false
                }
            }
        }
    }
}
#endif