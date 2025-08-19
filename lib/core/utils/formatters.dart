import 'package:intl/intl.dart';

/// Utility class for formatting various data types
class Formatters {
  /// Currency formatter for Indian Rupees
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
  
  /// Decimal currency formatter for precise values
  static final NumberFormat _decimalCurrencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );
  
  /// Number formatter with commas
  static final NumberFormat _numberFormatter = NumberFormat('#,##,###');
  
  /// Date formatters
  static final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');
  static final DateFormat _timeFormatter = DateFormat('hh:mm a');
  static final DateFormat _dateTimeFormatter = DateFormat('dd MMM yyyy, hh:mm a');
  static final DateFormat _shortDateFormatter = DateFormat('dd/MM/yyyy');
  
  /// Format currency as Indian Rupees
  static String formatCurrency(double amount) {
    return _currencyFormatter.format(amount);
  }
  
  /// Format currency with decimal places
  static String formatCurrencyWithDecimals(double amount) {
    return _decimalCurrencyFormatter.format(amount);
  }
  
  /// Format number with commas (Indian style)
  static String formatNumber(int number) {
    return _numberFormatter.format(number);
  }
  
  /// Format phone number in Indian format
  static String formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length == 10) {
      return '+91 ${digitsOnly.substring(0, 5)} ${digitsOnly.substring(5)}';
    }
    
    return phoneNumber; // Return original if not valid
  }
  
  /// Format date to readable format
  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }
  
  /// Format time to readable format
  static String formatTime(DateTime dateTime) {
    return _timeFormatter.format(dateTime);
  }
  
  /// Format date and time together
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }
  
  /// Format date in short format
  static String formatShortDate(DateTime date) {
    return _shortDateFormatter.format(date);
  }
  
  /// Format delivery time estimate
  static String formatDeliveryTime(int minutes) {
    if (minutes < 60) {
      return '$minutes mins';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hr${hours > 1 ? 's' : ''}';
      } else {
        return '$hours hr${hours > 1 ? 's' : ''} $remainingMinutes mins';
      }
    }
  }
  
  /// Format distance
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1.0) {
      final meters = (distanceInKm * 1000).round();
      return '${meters}m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }
  
  /// Format weight
  static String formatWeight(double weightInGrams) {
    if (weightInGrams < 1000) {
      return '${weightInGrams.toInt()}g';
    } else {
      final kg = weightInGrams / 1000;
      if (kg % 1 == 0) {
        return '${kg.toInt()}kg';
      } else {
        return '${kg.toStringAsFixed(1)}kg';
      }
    }
  }
  
  /// Format file size
  static String formatFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '${sizeInBytes}B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)}KB';
    } else if (sizeInBytes < 1024 * 1024 * 1024) {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }
  
  /// Format order status
  static String formatOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Order Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'preparing':
        return 'Being Prepared';
      case 'ready':
        return 'Ready for Pickup';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }
  
  /// Format rating with star symbol
  static String formatRating(double rating) {
    return '${rating.toStringAsFixed(1)} ⭐';
  }
  
  /// Format percentage
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}%';
  }
  
  /// Capitalize first letter of each word
  static String capitalizeWords(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  /// Format relative time (e.g., "2 hours ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 7) {
      return formatDate(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}