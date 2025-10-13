# PlanRadarWeather
📱 PlanRadar iOS Assessment – Weather Tracker  A small, cleanly architected SwiftUI + Core Data app that fetches live weather data from the OpenWeather API using an Objective-C network layer (as required by the task specification).

Dependency Rule: Views → ViewModels → UseCases → Repository → (Remote | Local).
Presentation never touches Core Data or Obj-C directly.

PlanRadar Weather — iOS Assessment

A tiny, production-style weather app built with SwiftUI + MVVM (Clean-inspired).
It fetches current weather from OpenWeather, persists history with Core Data, and (optionally) demonstrates a minimal Objective-C networking client bridged into Swift.

⸻

Highlights
    •    Architecture: MVVM + Use-Cases + Repository (domain/data split), Obj-C network client wrapped by a Swift façade.
    •    UI/UX: Spec-driven layout (city list, details card, history modal), light/dark assets, custom pill buttons, accessibility identifiers for UI tests.
    •    Persistence: Core Data (Cities, WeatherInfo), mapping to pure domain models.
    •    Error Handling: Precise, user-presentable AppError (transport, HTTP semantics, content-type, rate-limits).
    •    Testing: Pure Swift unit tests (no Core Data or Obj-C needed) + UI tests with stable accessibility IDs.

⸻

Table of Contents
    •    Architecture
    •    Project Structure
    •    Setup
    •    Running
    •    Testing
    •    Design & Accessibility
    •    Error Handling
    •    Troubleshooting
    •    Tradeoffs & Future Work
    •    Grading Rubric Map

⸻

Architecture

Presentation (SwiftUI)
  ├─ ViewModels (MVVM, @MainActor)
  │    ├─ CitiesViewModel
  │    └─ CityDetailViewModel
  ├─ Views (Cities, Details, History)
  └─ A11yID.swift (stable IDs for UI tests)

Domain (Pure Swift, no frameworks)
  ├─ Entities (CityEntity, WeatherSnapshot)
  ├─ UseCases (AddOrGetCity, ListCities, DeleteCities, FetchLatestWeather, GetCityHistory)
  └─ Repository Protocol (WeatherRepository)

Data
  ├─ Repository Impl (WeatherRepositoryImpl)  ← bridges Remote + Local
  ├─ Remote
  │    ├─ (Option A) Objective-C WeatherAPIClient + Swift façade (WeatherNetworking)
  │    └─ (Option B) Pure-Swift URLSession client (drop-in)
  └─ Local
       ├─ Core Data Stack (PersistenceController)
       └─ Mappings (CoreData <-> Domain, API <-> Domain)
       
⸻

Project Structure

PlanRadarWeather/
├─ App/
│  ├─ PlanRadarWeatherApp.swift
│  └─ AppDI.swift (lazy DI providers)
├─ Presentation/
│  ├─ Views/ (CitiesView, CityDetailView, HistoryView, components)
│  ├─ ViewModels/ (CitiesViewModel, CityDetailViewModel)
│  └─ Support/ (A11yID.swift, Spec colors, modifiers)
├─ Domain/
│  ├─ Entities/ (CityEntity.swift, WeatherSnapshot.swift)
│  └─ UseCases/ (AddOrGetCity.swift, etc.)
├─ Data/
│  ├─ Remote/
│  │  ├─ WeatherAPIClient.h/.m (Obj-C)  ← optional
│  │  └─ WeatherNetworking.swift (Swift façade or pure URLSession)
│  ├─ Local/
│  │  ├─ PersistenceController.swift
│  │  └─ Mappings/ (CoreDataToDomain.swift, APIToDomain.swift)
│  └─ Repository/ (WeatherRepository.swift, WeatherRepositoryImpl.swift)
├─ Resources/
│  └─ Assets.xcassets (colors, symbols, app icon)
└─ PlanRadarWeatherTests/ & PlanRadarWeatherUITests/
   ├─ ViewModel tests with in-memory mocks (no Core Data)
   └─ UI tests (XCUITest) using A11yID
   
   
Setup

1) API Key

Register at https://openweathermap.org and create an API key.
Add it to Info.plist as:


<key>OPENWEATHER_API_KEY</key>
<string>YOUR_API_KEY_HERE</string>

2) Objective-C Networking (optional but included)

If you want to demonstrate Obj-C:
    •    Ensure the bridging header path is configured (or remove Obj-C from Compile Sources if testing Swift-only).
    •    WeatherAPIClient builds the URL and calls NSURLSession.
    •    WeatherNetworking (Swift) wraps that and normalizes HTTP/errors.

Prefer Swift-only? Switch WeatherNetworking.fetchRaw to the URLSession implementation (drop-in). No other code changes needed.

3) Core Data
    •    Model name: PlanRadarWeather (entities: City, WeatherInfo).
    •    Important: Use either Core Data codegen or manual class files—not both.
If you keep the generated classes: set entities to Class Definition and remove manual files.

⸻

Running
    •    Open the workspace in Xcode.
    •    Select PlanRadarWeather scheme.
    •    Run on Simulator or device.

Note on configuration: AppDI is lazy, so nothing heavy spins up until the UI needs it.

⸻

Testing

Unit Tests (fast, no Core Data/Obj-C)
    •    Tests isolate ViewModels with closure-based mocks:
    •    No persistence or networking required.
    •    Deterministic and crash-free.
    •    Run: Product → Test (⌘U), or via scheme.

UI Tests (XCUITest)
    •    Views expose stable IDs via A11yID.
    •    Helper launchArguments += ["-uiTesting", "1"] instructs the app to render full UI for UI tests (but a tiny stub for unit tests, to avoid heavy bootstraps).
    •    Run the PlanRadarWeatherUITests bundle in the Test action.

⸻

Design & Accessibility
    •    Spec-driven city list, details card, history modal.
    •    Colors: BrandAccent, PrimaryText, SecondaryText with light/dark defined in asset catalog.
    •    Symbols: SFSymbols (chevrons, plus, xmark), rendered with brand colors.
    •    Accessibility:
    •    Dynamic type-friendly fonts and contrast-aware colors.
    •    Explicit accessibilityIdentifier for UI test stability.

⸻

Error Handling

AppError: LocalizedError collapses network and HTTP semantics into user-friendly messages:
    •    network(URLError), cancelled
    •    invalidResponse, emptyBody, invalidContentType
    •    unauthorized (401), notFound (404), rateLimited(429, Retry-After)
    •    httpStatus(code:reason:preview:)

HTTP helper extracts Retry-After and a safe body preview to aid diagnostics.

⸻

Troubleshooting

“Multiple NSEntityDescriptions claim …” / malloc crash
    •    You have both generated AND manual Core Data classes.
Fix: choose one codegen path:
    •    Keep generated classes: set entities to Class Definition; delete manual files.
    •    Keep manual files: set entities to Manual/None.
    •    Ensure tests do not copy a .momd into their bundle.
    •    Keep Obj-C/bridging out of the Unit Tests target.

Bridging header errors
    •    Clear or correct the Objective-C Bridging Header path in Build Settings, or remove the Obj-C file from Compile Sources when doing Swift-only networking.

No background image / asset tinting
    •    Ensure the asset’s Appearances include light/dark variants if needed.
    •    For images with color, use .renderingMode(.original).

⸻

Tradeoffs & Future Work
    •    Networking: kept minimal (no Alamofire) to match assessment scope. Could add caching, request retry/backoff.
    •    DI: simple “service locator” enum for brevity; could move to protocols + constructors for finer testability.
    •    Persistence: Core Data is sufficient here; for larger domains consider background contexts, batch updates, and lightweight migrations.
    •    UI: Only the core screens from the spec; could add pull-to-refresh, empty states, and richer metrics (pressure, visibility).
    •    Observability: Add OSLog categories and signposts around networking/persistence.

⸻

Grading Rubric Map
    •    [2] Architecture & Code Quality & Docs
MVVM + Use-Cases + Repository, domain isolation, error taxonomy, README + in-code docs.
    •    [2] UI
Spec-faithful screens, dark/light assets, custom pill controls, semantic colors.
    •    [2] Error Handling
Transport vs HTTP vs content-type, Retry-After parsing, user-friendly messages.
    •    [2] Interpretation of Spec
City selector, details card, history modal, accessibility IDs for testing.
    •    [2] Tests
Deterministic ViewModel unit tests (pure Swift), stable XCUITests via A11y IDs.

⸻

Security & Secrets
    •    Keep the API key in Info.plist (or use build settings with a user-configurable xcconfig).
    •    Never hardcode keys in source files or commit real keys.
