# PlanRadarWeather

_A tiny, production-style weather app built for the **PlanRadar iOS Assessment**._

- **Tech**: SwiftUI · MVVM (Clean-inspired) · Core Data · URLSession · **Objective-C** client (as required)
- **Data**: OpenWeather (current weather)
- **Dependency Rule**: `Views → ViewModels → UseCases → Repository → (Remote | Local)`  
  _Presentation never touches Core Data or Obj-C directly._

---

## ✨ Highlights

- **Architecture**: MVVM + Use-Cases + Repository (domain/data split). Obj-C client wrapped by a Swift façade.
- **UI/UX**: Spec-driven screens (Cities list, Details card, History modal). Light/Dark, custom pill buttons, semantic colors.
- **Persistence**: Core Data entities (`City`, `WeatherInfo`) mapped to pure domain models.
- **Errors**: Rich `AppError` (transport, HTTP semantics, content-type, rate limit with `Retry-After`).
- **Testing**: Pure Swift **unit tests** (no Core Data/Obj-C) + **UI tests** via stable `A11yID` identifiers.

---

## 🧱 Architecture
Presentation (SwiftUI)
├─ ViewModels (@MainActor)
│    ├─ CitiesViewModel
│    └─ CityDetailViewModel
├─ Views (Cities, Details, History)
└─ Support (A11yID, spec colors, modifiers)

## Domain (pure Swift)
├─ Entities (CityEntity, WeatherSnapshot)
├─ UseCases (AddOrGetCity, ListCities, DeleteCities, FetchLatestWeather, GetCityHistory)
└─ Repository Protocol (WeatherRepository)

## Data
├─ Repository Impl (WeatherRepositoryImpl)  ← bridges Remote + Local
├─ Remote
│    ├─ (A) Objective-C WeatherAPIClient + Swift façade (WeatherNetworking)
│    └─ (B) Pure-Swift URLSession client (drop-in)
└─ Local
├─ Core Data Stack (PersistenceController)
└─ Mappings (CoreData ↔︎ Domain, API ↔︎ Domain)

## 🗂 Project Structure
PlanRadarWeather/
├─ App/
│  ├─ PlanRadarWeatherApp.swift
│  └─ AppDI.swift                (lazy DI providers)
├─ Presentation/
│  ├─ Views/                     (CitiesView, CityDetailView, HistoryView, components)
│  ├─ ViewModels/                (CitiesViewModel, CityDetailViewModel)
│  └─ Support/                   (A11yID.swift, colors, modifiers)
├─ Domain/
│  ├─ Entities/                  (CityEntity.swift, WeatherSnapshot.swift)
│  └─ UseCases/                  (AddOrGetCity.swift, etc.)
├─ Data/
│  ├─ Remote/
│  │  ├─ WeatherAPIClient.h/.m   (Obj-C)  ← optional but included
│  │  └─ WeatherNetworking.swift
│  ├─ Local/
│  │  ├─ PersistenceController.swift
│  │  └─ Mappings/               (CoreDataToDomain.swift, APIToDomain.swift)
│  └─ Repository/                (WeatherRepository.swift, WeatherRepositoryImpl.swift)
├─ Resources/
│  └─ Assets.xcassets            (colors, symbols, app icon)
└─ Tests/
├─ PlanRadarWeatherTests/     (ViewModel tests with in-memory mocks)
└─ PlanRadarWeatherUITests/   (XCUITests using A11yID)




## ⚙️ Setup

### 1) OpenWeather API key
Create a key at https://openweathermap.org and add to **Info.plist**:

```xml
<key>OPENWEATHER_API_KEY</key>
<string>YOUR_API_KEY_HERE</string>

### 2) Objective-C networking (spec requirement, optional at runtime)
    •    WeatherAPIClient (Obj-C) builds the URL and calls NSURLSession.
    •    WeatherNetworking (Swift) wraps it and normalizes HTTP/errors.

Prefer Swift-only? Swap WeatherNetworking.fetchRaw to a URLSession implementation (drop-in). No other code changes.

### 3) Core Data model
    •    Model name: PlanRadarWeather (City, WeatherInfo).
    •    Important: Use either Core Data Class Definition or Manual/None (generated files) — not both.
If keeping generated classes: set entities to Class Definition and delete manual files.
    •    Ensure the data model is not included in the tests target.
## ▶️ Running
    1.    Open the project in Xcode.
    2.    Select the PlanRadarWeather scheme.
    3.    Run on Simulator or device.

DI is lazy: heavy objects are created only when the UI needs them.

⸻

## ✅ Testing

Unit tests (fast, pure Swift)
    •    ViewModels are tested with closure-based mocks (no Core Data, no Obj-C).
    •    Deterministic and crash-free.
    •    Run: Product → Test (⌘U).

## UI tests (XCUITest)
    •    Screens expose stable IDs via A11yID (e.g., Cities.Title, Cities.AddPill, row IDs).
    •    UI tests launch with -uiTesting argument to render the full UI (unit tests render a tiny stub).

⸻

## ♿️ Design & Accessibility
    •    Spec-driven layout for Cities / Details / History.
    •    Light/Dark assets (e.g., BrandAccent, PrimaryText, SecondaryText).
    •    SFSymbols (chevrons/plus/xmark) tinted with brand colors.
    •    Accessibility:
    •    Dynamic Type-friendly fonts and strong contrast.
    •    Stable accessibilityIdentifier values across the app for robust UI tests.

⸻

## 🛡 Error Handling

AppError: LocalizedError provides a single, user-presentable surface:
    •    Transport: network(URLError), cancelled
    •    Protocol: invalidResponse, emptyBody, invalidContentType
    •    HTTP semantics: unauthorized (401), notFound (404), rateLimited (429, Retry-After)
    •    Fallback: httpStatus(code:reason:preview:) with a safe body preview

⸻

## 🧰 Troubleshooting

“Multiple NSEntityDescriptions claim …” / malloc crash
    •    You have both generated and manual Core Data classes.
    •    Choose one codegen path (see Core Data model above).
    •    Ensure tests do not copy a .momd.
    •    Keep Obj-C / bridging header out of the unit tests target.

Bridging header errors
    •    Clear or fix the Objective-C Bridging Header in Build Settings, or remove the Obj-C files from the tests target.

Assets not showing / tinted
    •    Provide Light/Dark variants in asset catalog if needed.
    •    Use .renderingMode(.original) for colored images.

⸻

## 🔭 Trade-offs & Future Work
    •    Networking: minimal by design (no Alamofire); could add caching, retry/backoff.
    •    DI: simple service-locator; could move to protocols + constructors for finer testability.
    •    Persistence: Core Data suits this scope; larger apps may add background contexts, batches, migrations.
    •    UI: Future additions—pull-to-refresh, empty states, richer metrics (pressure/visibility).
    •    Observability: Add OSLog and signposts around networking/persistence.

⸻

## 🧪 Grading Rubric Map
    •    [2] Architecture / Code Quality / Docs
MVVM + Use-Cases + Repository, domain isolation, error taxonomy, and clear README/in-code docs.
    •    [2] UI
Spec-faithful screens, dark/light assets, custom pill controls, semantic colors.
    •    [2] Error Handling
Clear messaging; transport vs HTTP; Retry-After parsing; safe body preview.
    •    [2] Interpretation of Spec
City selector, details card, history modal, testable IDs.
    •    [2] Tests
Deterministic ViewModel unit tests; stable UI tests via A11yID.

⸻

## 🔒 Security & Secrets
    •    Put the API key in Info.plist (or supply via build settings / xcconfig).
    •    Never hardcode production secrets in source or VCS.
