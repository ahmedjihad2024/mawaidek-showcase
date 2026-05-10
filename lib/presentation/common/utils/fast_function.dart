import 'dart:ui';

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

// Extension on Duration to format as readable time
extension DurationFormat on Duration {
  /// Formats a duration into a human-readable string like "2 min" or "1:30 hours"
  ///
  /// Parameters:
  /// - [locale]: The locale to use for formatting (default: 'en')
  /// - [abbreviated]: Whether to use abbreviated units (min vs minutes) (default: true)
  /// - [decimalPlaces]: Number of decimal places to show for non-integer values (default: 1)
  String formatHumanReadable({
    Locale? locale,
    bool abbreviated = true,
    int decimalPlaces = 1,
  }) {
    if (inSeconds < 60) {
      final seconds = inSeconds;
      return locale?.languageCode == 'ar'
          ? '$seconds ${abbreviated ? 'ث' : 'ثانية'}'
          : '$seconds ${abbreviated ? 'sec' : 'seconds'}';
    } else if (inMinutes < 60) {
      final minutes = inMinutes;
      final seconds = inSeconds % 60;
      if (seconds == 0) {
        return locale?.languageCode == 'ar'
            ? '$minutes ${abbreviated ? 'د' : 'دقيقة'}'
            : '$minutes ${abbreviated ? 'min' : 'minutes'}';
      }
      return locale?.languageCode == 'ar'
          ? '$minutes:${seconds.toString().padLeft(2, '0')} ${abbreviated ? 'د' : 'دقيقة'}'
          : '$minutes:${seconds.toString().padLeft(2, '0')} ${abbreviated ? 'min' : 'minutes'}';
    } else if (inHours < 24) {
      final hours = inHours;
      final minutes = inMinutes % 60;

      // If it's a whole number of hours with no minutes
      if (minutes == 0) {
        return locale?.languageCode == 'ar'
            ? '$hours ${abbreviated ? 'س' : 'ساعة'}'
            : '$hours ${abbreviated ? 'hr' : hours == 1 ? 'hour' : 'hours'}';
      }

      // Format as HH:MM instead of decimal
      final formattedMinutes = minutes.toString().padLeft(2, '0');

      return locale?.languageCode == 'ar'
          ? '$hours:$formattedMinutes ${abbreviated ? 'س' : 'ساعة'}'
          : '$hours:$formattedMinutes ${abbreviated ? 'hr' : hours == 1 ? 'hour' : 'hours'}';
    } else if (inDays < 7) {
      final days = inDays;
      return locale?.languageCode == 'ar'
          ? '$days ${abbreviated ? 'ي' : 'يوم'}'
          : '$days ${abbreviated ? 'd' : days == 1 ? 'day' : 'days'}';
    } else if (inDays < 30) {
      final weeks = (inDays / 7).floor();
      return locale?.languageCode == 'ar'
          ? '$weeks ${abbreviated ? 'أ' : 'أسبوع'}'
          : '$weeks ${abbreviated ? 'wk' : weeks == 1 ? 'week' : 'weeks'}';
    } else if (inDays < 365) {
      final months = (inDays / 30).floor();
      return locale?.languageCode == 'ar'
          ? '$months ${abbreviated ? 'ش' : 'شهر'}'
          : '$months ${abbreviated ? 'mo' : months == 1 ? 'month' : 'months'}';
    } else {
      final years = (inDays / 365).floor();
      return locale?.languageCode == 'ar'
          ? '$years ${abbreviated ? 'سنة' : 'سنة'}'
          : '$years ${abbreviated ? 'yr' : years == 1 ? 'year' : 'years'}';
    }
  }

  String toHoursMinutes() {
    int hours = inHours;
    int minutes = inMinutes % 60;

    return "$hours:${minutes.toString().padLeft(2, '0')}";
  }
}

// Extension on num to format numbers with K, M, B suffixes
extension NumberFormat on num {
  /// Formats a number with K (thousand), M (million), B (billion), T (trillion) suffixes.
  ///
  /// Examples:
  /// - 1000 becomes "1K" (with default threshold)
  /// - 12000 becomes "12K"
  /// - 1200000 becomes "1.2M"
  /// - 1500000000 becomes "1.5B"
  ///
  /// Parameters:
  /// - [decimalPlaces]: Number of decimal places to show (default: 0)
  /// - [showDecimalIfWhole]: Whether to show decimal places if the number is a whole number (default: false)
  /// - [startThreshold]: The number at which to start using suffixes (default: 1000)
  /// - [customThresholds]: Custom thresholds for different suffixes (e.g., [100, 1000, 1000000])
  /// - [customSuffixes]: Custom suffixes for custom thresholds (e.g., ['H', 'K', 'M'])
  String formatCompact({
    int decimalPlaces = 0,
    bool showDecimalIfWhole = false,
    int startThreshold = 1000,
    List<int>? customThresholds,
    List<String>? customSuffixes,
  }) {
    // If number is below the start threshold, return as is
    if (this < startThreshold) {
      return toString();
    }

    // Use custom thresholds if provided, otherwise use default
    List<int> thresholds;
    List<String> suffixes;

    if (customThresholds != null && customSuffixes != null) {
      // Use custom thresholds and suffixes
      thresholds = customThresholds;
      suffixes = customSuffixes;
    } else {
      // Always use standard K, M, B, T thresholds regardless of startThreshold
      thresholds = [1000, 1000000, 1000000000, 1000000000000];
      suffixes = ['K', 'M', 'B', 'T'];
    }

    // Find the appropriate tier for the current number
    int tier = 0;
    for (int i = 0; i < thresholds.length; i++) {
      if (this >= thresholds[i]) {
        tier = i;
      } else {
        break;
      }
    }

    // Ensure we don't exceed available suffixes
    tier = tier < suffixes.length ? tier : suffixes.length - 1;

    // Calculate the scaled value
    double scaled = this / thresholds[tier];

    // Check if the scaled value is a whole number
    bool isWhole = scaled == scaled.truncateToDouble();

    if (isWhole && !showDecimalIfWhole) {
      return '${scaled.toInt()}${suffixes[tier]}';
    } else {
      // Don't round up, just truncate to avoid "100K" for 99988
      return '${scaled.truncate()}${suffixes[tier]}';
    }
  }

  /// Formats a number with custom starting threshold for suffixes.
  ///
  /// Examples:
  /// - formatFromThreshold(100, startThreshold: 100) -> "1K"
  /// - formatFromThreshold(500, startThreshold: 2000) -> "500" (below threshold)
  /// - formatFromThreshold(2001, startThreshold: 2000) -> "2K"
  /// - formatFromThreshold(2420, startThreshold: 2000) -> "2.4K"
  String formatFromThreshold({
    int startThreshold = 1000,
    int decimalPlaces = 0,
    bool showDecimalIfWhole = false,
  }) {
    return formatCompact(
      decimalPlaces: decimalPlaces,
      showDecimalIfWhole: showDecimalIfWhole,
      startThreshold: startThreshold,
    );
  }

  /// Formats a number with custom thresholds and suffixes.
  ///
  /// Examples:
  /// - formatCustom(150, thresholds: [100, 1000], suffixes: ['H', 'K']) -> "1.5H"
  /// - formatCustom(1500, thresholds: [100, 1000], suffixes: ['H', 'K']) -> "1.5K"
  /// - formatCustom(500, thresholds: [50, 500, 5000], suffixes: ['F', 'H', 'K']) -> "1H"
  String formatCustom({
    required List<int> thresholds,
    required List<String> suffixes,
    int decimalPlaces = 0,
    bool showDecimalIfWhole = false,
  }) {
    return formatCompact(
      decimalPlaces: decimalPlaces,
      showDecimalIfWhole: showDecimalIfWhole,
      customThresholds: thresholds,
      customSuffixes: suffixes,
    );
  }
}

Map<String, Map<String, String>> storageUnits = {
  "bytes": {
    "en": "Bytes",
    "ar": "بايت",
  },
  "kilobytes": {
    "en": "Kilobytes",
    "ar": "كيلوبايت",
  },
  "megabytes": {
    "en": "Megabytes",
    "ar": "ميغابايت",
  },
  "gigabytes": {
    "en": "Gigabytes",
    "ar": "غيغابايت",
  },
  "terabytes": {
    "en": "Terabytes",
    "ar": "تيرابايت",
  },
  "petabytes": {
    "en": "Petabytes",
    "ar": "بيتابايت",
  },
};

String formatBytes(int bytes, {String lang = 'en'}) {
  if (bytes == 0) return '0 ${storageUnits['bytes']![lang]}';

  List<String> sizes = [
    'bytes',
    'kilobytes',
    'megabytes',
    'gigabytes',
    'terabytes',
    'petabytes'
  ];

  int i = 0;
  Decimal value = Decimal.fromInt(bytes);

  while (value >= Decimal.fromInt(1024) && i < sizes.length - 1) {
    value = (value / Decimal.fromInt(1024)).toDecimal();
    i++;
  }

  return lang == "ar"
      ? '${storageUnits[sizes[i]]![lang]} ${value.toStringAsFixed(2)}'
      : '${value.toStringAsFixed(2)} ${storageUnits[sizes[i]]![lang]}';
}

bool isValidEmail(String email) {
  final RegExp emailRegex =
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  return emailRegex.hasMatch(email);
}

bool isBetweenInclusive(num value, num bound1, num bound2) {
  final lower = bound1 < bound2 ? bound1 : bound2;
  final upper = bound1 > bound2 ? bound1 : bound2;
  return value >= lower && value <= upper;
}

bool isBetweenHours(int target, int from, int to) {
  if (from <= to) {
    return target >= from && target <= to; // Normal case
  } else {
    return target >= from || target <= to; // Wrap-around case (spans midnight)
  }
}

bool isValidTimeRange(int from, int to) {
  return from <= to || to <= from; // Allows wrap-around correctly
}

List<int> getHourRange(int from, int to) {
  List<int> hours = [];

  int current = from;
  while (true) {
    hours.add(current);
    if (current == to) break; // Stop when reaching the 'to' hour
    current = (current + 1) % 24; // Increment and wrap around at 24
  }

  return hours;
}

/// Handles cases where night period crosses midnight
bool isInPeriod(int hour, int nightBegin, int nightEnd) {
  if (nightBegin <= nightEnd) {
    // Normal case (e.g., 18:00 to 23:00)
    return hour > nightBegin && hour < nightEnd;
  } else {
    // Crosses midnight (e.g., 18:00 to 01:00)
    return hour > nightBegin || hour < (nightEnd % 24);
  }
}

extension ListDifferentFrom on List<dynamic> {
  // check if this two list is different
  bool isDiffFrom(List<dynamic> list2) =>
      toSet().difference(list2.toSet()).isNotEmpty ||
      list2.toSet().difference(toSet()).isNotEmpty;
}

String timeAgo(DateTime dateTime, Locale locale) {
  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return locale.languageCode == 'ar'
        ? 'منذ ${difference.inSeconds} ثانية'
        : '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return locale.languageCode == 'ar'
        ? 'منذ ${difference.inMinutes} دقيقة'
        : '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return locale.languageCode == 'ar'
        ? 'منذ ${difference.inHours} ساعة'
        : '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return locale.languageCode == 'ar'
        ? 'منذ ${difference.inDays} يوم'
        : '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return locale.languageCode == 'ar'
        ? 'منذ $weeks أسبوع'
        : '$weeks weeks ago';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return locale.languageCode == 'ar'
        ? 'منذ $months شهر'
        : '$months months ago';
  } else {
    int years = (difference.inDays / 365).floor();
    return locale.languageCode == 'ar' ? 'منذ $years سنة' : '$years years ago';
  }
}

/// Formats a DateTime to a localized string with smart date handling using intl package
///
/// Examples:
/// - Today: "Today, 10:30 AM" / "اليوم، 10:30 صباحاً"
/// - Yesterday: "Yesterday, 10:30 AM" / "أمس، 10:30 صباحاً"
/// - Other dates: "Dec 15, 2023, 10:30 AM" / "15 ديسمبر 2023، 10:30 صباحاً"
String formatNotificationTime(DateTime dateTime, Locale locale) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

  // Format time using DateFormat for proper localization
  final timeFormat = DateFormat.jm(locale.languageCode);
  final timeString = timeFormat.format(dateTime);

  // Handle Today and Yesterday manually
  if (dateToCheck == today) {
    return locale.languageCode == 'ar'
        ? 'اليوم، $timeString'
        : 'Today, $timeString';
  } else if (dateToCheck == yesterday) {
    return locale.languageCode == 'ar'
        ? 'أمس، $timeString'
        : 'Yesterday, $timeString';
  } else {
    // Use DateFormat for other dates
    final dateFormat = DateFormat(
        'MMM d, y, ', locale.languageCode); // English: "Dec 15, 2023, "

    final dateString = dateFormat.format(dateTime);
    return '$dateString$timeString';
  }
}

/// Enhanced timeAgo function for reviews with better localization and formatting
///
/// Examples:
/// - English: "2 days ago", "1 week ago", "3 months ago"
/// - Arabic: "منذ يومين", "منذ أسبوع", "منذ 3 أشهر"
String timeAgoEnhanced(DateTime dateTime, Locale locale) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return locale.languageCode == 'ar'
        ? 'منذ ${difference.inSeconds} ثانية'
        : '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    if (minutes == 1) {
      return locale.languageCode == 'ar' ? 'منذ دقيقة' : '1 minute ago';
    }
    return locale.languageCode == 'ar'
        ? 'منذ $minutes دقيقة'
        : '$minutes minutes ago';
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    if (hours == 1) {
      return locale.languageCode == 'ar' ? 'منذ ساعة' : '1 hour ago';
    }
    return locale.languageCode == 'ar' ? 'منذ $hours ساعة' : '$hours hours ago';
  } else if (difference.inDays < 7) {
    final days = difference.inDays;
    if (days == 1) {
      return locale.languageCode == 'ar' ? 'منذ يوم' : '1 day ago';
    }
    return locale.languageCode == 'ar' ? 'منذ $days يوم' : '$days days ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    if (weeks == 1) {
      return locale.languageCode == 'ar' ? 'منذ أسبوع' : '1 week ago';
    }
    return locale.languageCode == 'ar'
        ? 'منذ $weeks أسبوع'
        : '$weeks weeks ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    if (months == 1) {
      return locale.languageCode == 'ar' ? 'منذ شهر' : '1 month ago';
    }
    return locale.languageCode == 'ar'
        ? 'منذ $months شهر'
        : '$months months ago';
  } else {
    final years = (difference.inDays / 365).floor();
    if (years == 1) {
      return locale.languageCode == 'ar' ? 'منذ سنة' : '1 year ago';
    }
    return locale.languageCode == 'ar' ? 'منذ $years سنة' : '$years years ago';
  }
}

String normalizeTimePeriod(String time) {
  return time
      .replaceAll('ص', 'AM')
      .replaceAll('م', 'PM')
      .replaceAll('am', 'AM')
      .replaceAll('pm', 'PM');
}

DateTime parseDateAndTime({
  required String date, // "2025-12-31"
  required String time, // "10:10 PM" | "10:10 م" | "09:00:00"
}) {
  final normalizedTime = normalizeTimePeriod(time.trim());
  final combined = '${date.trim()} $normalizedTime';

  // 12-hour with AM/PM
  if (RegExp(r'\b(AM|PM)\b').hasMatch(normalizedTime)) {
    return DateFormat('yyyy-MM-dd hh:mm a', 'en').parse(combined);
  }

  // 24-hour with seconds
  if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(normalizedTime)) {
    return DateFormat('yyyy-MM-dd HH:mm:ss', 'en').parse(combined);
  }

  // 24-hour without seconds (optional safety)
  if (RegExp(r'^\d{2}:\d{2}$').hasMatch(normalizedTime)) {
    return DateFormat('yyyy-MM-dd HH:mm', 'en').parse(combined);
  }

  throw FormatException('Unsupported time format: $time');
}