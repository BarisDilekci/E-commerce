## E‑Commerce (iOS)

A modern iOS e‑commerce sample app. It showcases MVVM with use‑case driven layered architecture, a URLSession‑based networking client, JWT authentication, dependency injection, and a lightweight design system. Built with UIKit and no external packages.

### Highlights
- **Products**: Listing, search, and category‑based filtering
- **Detail**: Product detail screen with image display
- **Favorites**: Add/remove products to favorites
- **Authentication**: Login, register, logout; JWT storage (Keychain) and token refresh
- **Profile**: Basic user information and settings menu
- **Network Monitoring**: Online/offline detection and graceful error handling
- **UI/UX**: Theme, typography, reusable components, and empty states

### Architecture
- **Layers**
  - `Application`: App lifecycle (AppDelegate, SceneDelegate)
  - `Core`: Cross‑cutting infrastructure
    - `Config` (`AppConfig.swift`): Environment and `apiBaseURLString` (DEBUG/RELEASE)
    - `Service`:
      - `NetworkService` (+ `APIEndpoint`): Type‑safe endpoints and request execution
      - `Network` (`RequestAdapter`, `RefreshTokenInterceptor`, `TokenRefreshing`): Authorization headers and 401‑based token refresh
      - `Auth` (`AuthService`, `TokenService`, `UserStorage`, `KeychainHelper`): JWT parsing, expiry tracking, secure storage
      - `Reachability` (`NetworkMonitor`): Network status via NWPathMonitor
    - `Formatter`, `ImageLoader` (simple in‑memory cache)
  - `Domain`: Business rules
    - `Repository` protocols
    - `UseCase` (e.g., `FetchProductsUseCase`)
  - `Data`: External data access
    - Repository implementations (e.g., `ProductRepositoryImpl` → `NetworkService`)
  - `Screens`: UIKit + MVVM feature modules (Home, Category, Detail, Favorites, Login, Register, Profile, Tabbar)
  - `UIComponents`, `DesignSystem`: Visual components, theme, and typography
- **Dependency Injection**: `DIContainer` wires services, repositories, and use‑cases and provides them to screens.

### Networking and Authentication
- `APIEndpoint`: Endpoints (e.g., `/products`, `/categories/{id}/products`, `/auth/login`, `/auth/register`, `/auth/refresh`)
- `NetworkService`: Executes requests with URLSession and applies a list of `RequestAdapter`s.
- `AuthRequestAdapter`: Adds `Authorization: Bearer <token>` if a valid token exists.
- `RefreshTokenInterceptor`: On HTTP 401, calls `AuthService.refreshToken` and retries the request once.
- `AuthService`: Login/register/logout, token and user storage (`Keychain` + `UserDefaults`), JWT expiry checks (`TokenService`).

### Requirements
- Xcode 15+ (Swift 5.9+ recommended)
- iOS 15.0+ deployment target
- No external dependencies (no SwiftPM/CocoaPods)

### Setup and Run
1. Clone the repository.
2. Open `E-Commerce.xcodeproj` in Xcode.
3. Update API base URL if needed:
   - `Core/Config/AppConfig.swift` → `apiBaseURLString` (DEBUG defaults to `http://localhost:8080/api/v1`).
4. Select the target scheme and run (Cmd+R).

### Backend Expectations
- Default base URL: `http://localhost:8080/api/v1`
- Example endpoints:
  - GET `/products`
  - GET `/categories`
  - GET `/categories/{id}/products`
  - POST `/auth/login` (body: `{ "username_or_email": string, "password": string }`)
  - POST `/auth/register`
  - POST `/auth/refresh`

### Screens and Flow
- **Login/Register**: After authentication, navigates to `MainTabbar`. Optional “continue as guest” flow.
- **Home**: Product list, search with debounce, pull‑to‑refresh, promo banner component.
- **Category**: List categories and filter products by selection.
- **Detail**: Product images and meta information.
- **Favorites**: Manage favorite products.
- **Profile**: User info and menu actions (including logout).

### Technical Notes
- **MVVM**: ViewModels are decoupled from data sources and talk to the domain via use‑cases.
- **Error Handling**: `NetworkError` maps to user‑friendly messages; offline handling with meaningful alerts.
- **Images**: `ImageLoader` provides simple in‑memory caching.
- **Theme/Design**: Centralized colors and typography in `DesignSystem/Theme.swift`.

### Tests
- Run tests with Xcode (Cmd+U). Unit tests live under `E-CommerceTests/`.

### Roadmap (Suggestions)
- Offline cache with CoreData (directory skeleton present)
- Related products on product detail
- Persistent favorites and server sync
- Localization (multi‑language)

### Folder Structure (Overview)
- `Core/` infrastructure and services
- `Domain/` repository protocols and use‑cases
- `Data/` repository implementations
- `Screens/` UIKit + MVVM screens
- `DesignSystem/`, `UIComponents/` visual system and components

### Configuration Tips
- Environment selection: `AppConfig.current` switches via DEBUG/RELEASE.
- Authorization header: `AuthRequestAdapter` injects it automatically.
- 401 handling: `RefreshTokenInterceptor` refreshes and retries once.

Contributions and feedback are welcome. Happy coding!
