import 'package:flutter/material.dart';

/// Extension methods for BuildContext to provide convenient access to common properties
extension ContextExtensions on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);
  
  /// Get the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Get the current text theme
  TextTheme get textTheme => theme.textTheme;
  
  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Get screen size
  Size get screenSize => mediaQuery.size;
  
  /// Get screen width
  double get screenWidth => screenSize.width;
  
  /// Get screen height
  double get screenHeight => screenSize.height;
  
  /// Get safe area padding
  EdgeInsets get padding => mediaQuery.padding;
  
  /// Get view insets (keyboard height, etc.)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  
  /// Check if device is in dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  /// Check if device is in portrait mode
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;
  
  /// Check if device is in landscape mode
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;
  
  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;
  
  /// Get status bar height
  double get statusBarHeight => padding.top;
  
  /// Get bottom safe area height
  double get bottomSafeAreaHeight => padding.bottom;
  
  /// Check if device is a tablet (width > 600)
  bool get isTablet => screenWidth > 600;
  
  /// Check if device is a phone
  bool get isPhone => !isTablet;
  
  /// Get responsive width based on screen size
  double responsiveWidth(double phoneWidth, {double? tabletWidth}) {
    return isTablet ? (tabletWidth ?? phoneWidth * 1.5) : phoneWidth;
  }
  
  /// Get responsive height based on screen size
  double responsiveHeight(double phoneHeight, {double? tabletHeight}) {
    return isTablet ? (tabletHeight ?? phoneHeight * 1.2) : phoneHeight;
  }
  
  /// Get responsive font size
  double responsiveFontSize(double phoneSize, {double? tabletSize}) {
    return isTablet ? (tabletSize ?? phoneSize * 1.2) : phoneSize;
  }
  
  /// Show a snackbar with message
  void showSnackBar(String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
  
  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
  
  /// Show warning snackbar
  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }
  
  /// Show info snackbar
  void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }
  
  /// Hide current snackbar
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
  
  /// Show a bottom sheet
  Future<T?> showBottomSheet<T>(Widget child, {
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: (context) => child,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
  
  /// Navigate to a new screen
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }
  
  /// Navigate and replace current screen
  Future<T?> pushReplacement<T extends Object?>(Widget page) {
    return Navigator.of(this).pushReplacement<T, T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }
  
  /// Navigate and clear all previous screens
  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }
  
  /// Pop current screen
  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
  
  /// Pop until a specific condition
  void popUntil(bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).popUntil(predicate);
  }
  
  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();
}