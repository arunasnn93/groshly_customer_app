/// App-wide constants for Groshly Customer App
class AppConstants {
  // App Info
  static const String appName = 'Groshly';
  static const String appTagline = 'Your Local Grocery Aggregator';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.groshly.com/v1';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_data';
  static const String addressKey = 'saved_addresses';
  static const String onboardingKey = 'onboarding_completed';
  
  // Default Values
  static const double defaultLatitude = 12.9716; // Bangalore
  static const double defaultLongitude = 77.5946;
  static const int maxCartItems = 50;
  static const double deliveryFee = 49.0;
  static const double freeDeliveryThreshold = 299.0;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache Duration
  static const Duration cacheExpiry = Duration(hours: 1);
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 1000);
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxAddressLength = 200;
  
  // Mock Data
  static const bool useMockData = true; // Set to false when backend is ready
}

/// Route constants for navigation
class RouteConstants {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String stores = '/stores';
  static const String storeDetail = '/store/:storeId';
  static const String product = '/product/:productId';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String orders = '/orders';
  static const String orderDetail = '/order/:orderId';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String search = '/search';
}

/// Asset path constants
class AssetConstants {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String logoWhite = 'assets/images/logo_white.png';
  static const String placeholderProduct = 'assets/images/placeholder_product.png';
  static const String placeholderStore = 'assets/images/placeholder_store.png';
  static const String emptyCart = 'assets/images/empty_cart.png';
  static const String orderSuccess = 'assets/images/order_success.png';
  
  // Icons
  static const String groceryIcon = 'assets/icons/grocery.svg';
  static const String locationIcon = 'assets/icons/location.svg';
  static const String cartIcon = 'assets/icons/cart.svg';
  
  // Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  
  // Mock Data
  static const String mockStores = 'assets/mock_data/stores.json';
  static const String mockProducts = 'assets/mock_data/products.json';
  static const String mockCategories = 'assets/mock_data/categories.json';
}