# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**MoneyHashLeanSDK** is a Swift Package Manager library that wraps two payment SDKs — MoneyHash and Lean — into a unified interface for iOS applications. It re-exports both SDKs through a single import.

- **Platform:** iOS 12.0+
- **Swift:** 5.9+
- **Dependency:** `MoneyHashCore` lives in the sibling directory `../moneyhashCore-spm` (local path dependency)

## Common Commands

```bash
# Build for iOS device
xcodebuild -scheme MoneyHashLeanSDK -destination 'generic/platform=iOS' build

# Build for iOS Simulator
xcodebuild -scheme MoneyHashLeanSDK -destination 'generic/platform=iOS Simulator' build

# Resolve/update dependencies
swift package resolve
```

> **Note:** `swift build` will always fail — it targets macOS but all xcframeworks only contain iOS slices. Use `xcodebuild` with an explicit iOS destination.

## Architecture

### Package Structure

```
Sources/
├── MoneyHashLeanSDK/
│   └── MoneyHashLeanSDK.swift   # Single file: @_exported import of MoneyHashCore & LeanSDK
└── Frameworks/
    └── moeyhashleantest.xcframework  # Binary framework (declared as target in Package.swift)
```

### Dependency Graph

```
MoneyHashLeanSDK
├── MoneyHashCore  (local: ../moneyhashCore-spm)  — payments, Apple Pay, card validation, UI
└── LeanSDK        (github: leantechnologies, pinned to 3.0.19) — bank linking, transfers
```

### Three-Tier Integration Model

The SDK exposes three integration styles to consumers:

1. **Direct access** — import individual `MoneyHashCore` or `LeanSDK` modules
2. **Wrapper classes** — `MoneyHashWrapper` and `LeanSDKWrapper` (defined in the compiled xcframework)
3. **Unified interface** — `UnifiedPaymentSDK` for smart routing between providers

`Sources/MoneyHashLeanSDK/MoneyHashLeanSDK.swift` uses `@_exported import` so consumers only need `import MoneyHashLeanSDK` to access all types from both underlying SDKs.

### Key Patterns

- **Facade pattern** — `MoneyHashLeanSDK.swift` re-exports both SDKs
- **Builder pattern** — `DefaultMoneyHashLeanBuilder` (in xcframework) for SDK initialization
- **Async/await** — Modern Swift concurrency used throughout; closure-based callbacks also supported

### Binary Frameworks

- `Sources/Frameworks/moeyhashleantest.xcframework` — pre-compiled, supports arm64 device + simulator slices
- `MoneyHashCore.xcframework` — lives in the sibling `moneyhashCore-spm` package

When updating binary frameworks, replace the `.xcframework` bundle and update the checksum in `Package.swift` if it's a remote binary target. Currently `moeyhashleantest` is a local binary target (no checksum required).

## Examples

See `Examples/BasicUsage.swift` for comprehensive usage patterns including:
- SDK initialization (unified and individual)
- Apple Pay flow
- Card payment collection
- Bank account linking (Lean)
- Bank-to-bank transfers
- SwiftUI integration
- Error handling
