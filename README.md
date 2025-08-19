# groshly_customer_app

# Groshly Customer App

A B2C grocery aggregator app built with Flutter following clean architecture principles.

## Features Implemented (Phase 1)

### ✅ Core Architecture
- **Clean Architecture**: Organized into data, domain, and presentation layers
- **SOLID Principles**: Well-structured, maintainable, and testable code
- **Dependency Injection**: Using GetIt and Injectable for DI
- **State Management**: Riverpod for reactive state management
- **Navigation**: GoRouter for declarative routing
- **Error Handling**: Comprehensive error handling with custom failures and exceptions

### ✅ Authentication
- Google Sign-In integration (with mock support)
- Email/Password authentication (mock implementation)
- User profile management
- Secure token handling and local storage
- Authentication state management with auto-redirect

### ✅ UI/UX
- **Material 3 Design**: Modern, consistent UI components
- **Dark Mode Support**: Automatic theme switching
- **Responsive Design**: Works on both phones and tablets
- **Custom Components**: Reusable widgets (buttons, text fields, etc.)
- **Loading States**: Proper loading indicators and error states

### ✅ Screens Implemented
1. **Splash Screen**: Animated logo with app initialization
2. **Login/SignUp**: Email/Google authentication with form validation
3. **Home Screen**: Categories, nearby stores, featured products
4. **Navigation**: Bottom navigation with placeholder screens

### ✅ Data Layer
- **Mock Data**: JSON files for stores, products, and categories
- **Local Storage**: SharedPreferences and Hive integration
- **Network Layer**: Dio client with interceptors
- **Repository Pattern**: Clean separation of data sources
- **Offline Support**: Local caching with network-first strategy

## Tech Stack

- **Framework**: Flutter 3.8+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Dependency Injection**: GetIt + Injectable
- **HTTP Client**: Dio + Retrofit
- **Local Storage**: SharedPreferences + Hive
- **Authentication**: Firebase Auth (with mock support)
- **Code Generation**: build_runner, json_serializable
- **Architecture**: Clean Architecture + SOLID principles

## Getting Started

### Prerequisites
- Flutter SDK 3.8.0 or higher
- Dart 3.0.0 or higher
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd groshly_customer_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/                     # Core utilities and configurations
│   ├── constants/           # App constants and routes
│   ├── di/                  # Dependency injection setup
│   ├── errors/              # Custom exceptions and failures
│   ├── extensions/          # Dart extensions
│   ├── navigation/          # App routing configuration
│   ├── network/             # Network client and utilities
│   ├── theme/               # App theme and styling
│   └── utils/               # Utility functions and validators
├── features/                # Feature modules
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data sources and repositories
│   │   ├── domain/         # Entities, repositories, use cases
│   │   └── presentation/   # Pages, widgets, and providers
│   ├── home/               # Home screen feature
│   └── splash/             # Splash screen feature
├── shared/                  # Shared widgets and services
│   ├── services/           # Shared services
│   └── widgets/            # Reusable UI components
└── main.dart               # App entry point
```

## Features Coming Soon

- 🔄 Location services and GPS integration
- 🔄 Product listing and search
- 🔄 Shopping cart management
- 🔄 Checkout flow with payment integration
- 🔄 Order tracking and history
- 🔄 User reviews and ratings
- 🔄 Push notifications
- 🔄 Multi-language support

## Architecture Highlights

### Clean Architecture Layers
1. **Presentation Layer**: UI components, state management
2. **Domain Layer**: Business logic, entities, use cases
3. **Data Layer**: API calls, local storage, repositories

### Key Patterns Used
- Repository Pattern for data abstraction
- Provider Pattern for state management
- Factory Pattern for dependency creation
- Observer Pattern for reactive updates

### Code Quality
- Comprehensive error handling
- Type safety with null safety
- Extensive documentation
- Unit test ready structure
- Lint rules enforcement

## Mock Data

The app currently uses mock data located in `assets/mock_data/`:
- `stores.json`: Sample grocery stores
- `products.json`: Sample products with pricing
- `categories.json`: Product categories

Set `AppConstants.useMockData = false` when backend is ready.

## Contributing

1. Follow the existing code structure and naming conventions
2. Add unit tests for new business logic
3. Update documentation for new features
4. Use conventional commit messages
5. Ensure all lint checks pass

## License

This project is private and proprietary to Groshly.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
