# 📱 Hello, World — Native iPad App with Xcode & GitHub Actions

[![iOS CI — Build & Test](https://github.com/luke-b/xcode-hello-world/actions/workflows/ios.yml/badge.svg)](https://github.com/luke-b/xcode-hello-world/actions/workflows/ios.yml)

A **Hello, World** native iPad app built with **SwiftUI** and **Xcode**, with a fully automated **GitHub Actions** CI pipeline that builds the app and runs both unit tests and UI tests on an iPad simulator on every push and pull request.

---

## 📋 Table of Contents

- [Overview](#overview)
- [App Preview](#app-preview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Building Locally](#building-locally)
- [Running Tests Locally](#running-tests-locally)
- [GitHub Actions CI Pipeline](#github-actions-ci-pipeline)
- [Architecture & Design Decisions](#architecture--design-decisions)
- [Test Coverage](#test-coverage)

---

## Overview

| Property | Value |
|---|---|
| Platform | iPad + iPhone (Universal) |
| Minimum iOS | 16.0 |
| Language | Swift 5 |
| UI Framework | SwiftUI |
| Xcode compatibility | Xcode 15+ / Xcode 16+ |
| CI Runner | `macos-latest` (GitHub-hosted) |

---

## App Preview

The app displays a simple, native SwiftUI screen:

```
        🖥  (iPad icon)

    Hello, World!

  A native iPad app built
       with SwiftUI
```

The main view (`ContentView`) uses a `VStack` with an SF Symbol, a large-title label, and a subtitle. The label carries an `accessibilityIdentifier` so that UI tests can assert its presence.

---

## Project Structure

```
xcode-hello-world/
├── .github/
│   └── workflows/
│       └── ios.yml                  # GitHub Actions CI workflow
├── HelloWorld/
│   ├── HelloWorld.xcodeproj/
│   │   ├── project.pbxproj          # Xcode project (3 targets)
│   │   └── project.xcworkspace/
│   │       └── contents.xcworkspacedata
│   ├── HelloWorld/                  # App source
│   │   ├── HelloWorldApp.swift      # @main entry point
│   │   ├── ContentView.swift        # Hello World SwiftUI view
│   │   └── Assets.xcassets/
│   │       ├── AccentColor.colorset/
│   │       ├── AppIcon.appiconset/
│   │       └── Contents.json
│   ├── HelloWorldTests/
│   │   └── HelloWorldTests.swift    # XCTest unit tests
│   └── HelloWorldUITests/
│       └── HelloWorldUITests.swift  # XCUITest UI tests
└── README.md
```

### Targets

| Target | Type | Description |
|---|---|---|
| `HelloWorld` | Application | Main iPad/iPhone SwiftUI app |
| `HelloWorldTests` | Unit Test Bundle | Logic & model tests |
| `HelloWorldUITests` | UI Test Bundle | End-to-end UI tests via `XCUIApplication` |

---

## Prerequisites

| Tool | Version |
|---|---|
| macOS | Ventura 13+ (Sonoma 14+ recommended) |
| Xcode | 15.0 or later |
| iOS Simulator | iOS 16.0+ iPad simulator |

---

## Building Locally

1. **Clone the repo**

   ```bash
   git clone https://github.com/luke-b/xcode-hello-world.git
   cd xcode-hello-world
   ```

2. **Open in Xcode**

   ```bash
   open HelloWorld/HelloWorld.xcodeproj
   ```

3. **Select an iPad simulator** from the scheme bar (e.g. *iPad Air (5th generation)*) and press **⌘R** to build and run.

4. **Build from the command line** (no code signing required for simulators):

   ```bash
   xcodebuild build \
     -project HelloWorld/HelloWorld.xcodeproj \
     -scheme HelloWorld \
     -destination 'generic/platform=iOS Simulator' \
     CODE_SIGN_IDENTITY="" \
     CODE_SIGNING_REQUIRED=NO \
     CODE_SIGNING_ALLOWED=NO
   ```

---

## Running Tests Locally

### Unit tests

```bash
xcodebuild test \
  -project HelloWorld/HelloWorld.xcodeproj \
  -scheme HelloWorld \
  -destination 'platform=iOS Simulator,name=iPad Air (5th generation)' \
  -only-testing HelloWorldTests \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO
```

### UI tests

```bash
xcodebuild test \
  -project HelloWorld/HelloWorld.xcodeproj \
  -scheme HelloWorld \
  -destination 'platform=iOS Simulator,name=iPad Air (5th generation)' \
  -only-testing HelloWorldUITests \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO
```

> **Tip:** Substitute the simulator name with whatever device is available on your machine (`xcrun simctl list devices available | grep iPad`).

---

## GitHub Actions CI Pipeline

The workflow file is located at [`.github/workflows/ios.yml`](.github/workflows/ios.yml).

### Trigger events

| Event | Branches |
|---|---|
| `push` | `main` |
| `pull_request` | `main` |

### Pipeline steps

```
1. Checkout repository          (actions/checkout@v4)
2. Show Xcode version           (xcodebuild -version)
3. List available iPad sims     (xcrun simctl list)
4. Select iPad simulator        (Python snippet – picks newest iOS iPad)
5. Build app                    (xcodebuild build, generic/platform=iOS Simulator)
6. Run unit tests               (xcodebuild test -only-testing HelloWorldTests)
7. Run UI tests                 (xcodebuild test -only-testing HelloWorldUITests)
```

### Simulator selection

The workflow automatically selects the first available iPad simulator for the newest installed iOS runtime, making it forward-compatible across different `macos-latest` images (macOS 14 + Xcode 15, macOS 15 + Xcode 16, etc.).

### Code signing

All `xcodebuild` invocations pass `CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO`, which disables code signing for simulator builds — no developer certificates or provisioning profiles are needed in CI.

---

## Architecture & Design Decisions

| Decision | Rationale |
|---|---|
| **SwiftUI** | Apple's modern declarative UI framework; minimal boilerplate for a Hello World app |
| **`@main` / `WindowGroup`** | Standard SwiftUI app lifecycle; no `AppDelegate` boilerplate needed |
| **`GENERATE_INFOPLIST_FILE = YES`** | Removes the need for a separate `Info.plist` file; Info.plist is generated from Xcode build settings |
| **`TARGETED_DEVICE_FAMILY = "1,2"`** | Supports both iPhone (1) and iPad (2) from a single binary |
| **iOS 16.0 deployment target** | Broad device coverage while enabling modern SwiftUI features (`foregroundStyle`, multi-platform layouts) |
| **accessibilityIdentifier on label** | Allows `XCUITest` to locate UI elements by stable identifier rather than fragile display text |

---

## Test Coverage

| Test | Type | What it verifies |
|---|---|---|
| `testExample` | Unit | Baseline: test runner works |
| `testArithmetic` | Unit | Test environment executes Swift correctly |
| `testStringContents` | Unit | Greeting string has correct content |
| `testAppLaunchesSuccessfully` | UI | App reaches `.runningForeground` state |
| `testHelloWorldTextIsVisible` | UI | `Hello, World!` label is visible on screen |
| `testAppLaunchPerformance` | UI | Launch time measured via `XCTApplicationLaunchMetric` |

---

*Built with ❤️ using Swift, SwiftUI, Xcode, and GitHub Actions.*
