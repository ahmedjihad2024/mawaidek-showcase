import 'package:flutter/material.dart';

import 'app.dart';

extension NonNullString on String? {
  String get orEmpty => this ?? "";
}

extension NonNullInt on int? {
  int get orEmpty => this ?? 0;
}

extension ThemeSettings on BuildContext {
  set setTheme(ThemeMode theme) =>
      findAncestorStateOfType<MyAppState>()?.setTheme = theme;

  ThemeData get theme => Theme.of(this);

  /// 10.sp
  TextStyle get labelSmall => theme.textTheme.labelSmall!;

  /// 12.sp
  TextStyle get labelMedium => theme.textTheme.labelMedium!;

  /// 14.sp
  TextStyle get labelLarge => theme.textTheme.labelLarge!;

  /// 12.sp
  TextStyle get bodySmall => theme.textTheme.bodySmall!;

  /// 14.sp
  TextStyle get bodyMedium => theme.textTheme.bodyMedium!;

  /// 16.sp
  TextStyle get bodyLarge => theme.textTheme.bodyLarge!;

  /// 14.sp
  TextStyle get titleSmall => theme.textTheme.titleSmall!;

  /// 16.sp
  TextStyle get titleMedium => theme.textTheme.titleMedium!;

  /// 20.sp
  TextStyle get titleLarge => theme.textTheme.titleLarge!;

  /// 18.sp
  TextStyle get headlineSmall => theme.textTheme.headlineSmall!;

  /// 22.sp
  TextStyle get headlineMedium => theme.textTheme.headlineMedium!;

  /// 26.sp
  TextStyle get headlineLarge => theme.textTheme.headlineLarge!;

  /// 30.sp
  TextStyle get displaySmall => theme.textTheme.displaySmall!;

  /// 36.sp
  TextStyle get displayMedium => theme.textTheme.displayMedium!;

  /// 42.sp
  TextStyle get displayLarge => theme.textTheme.displayLarge!;

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;
}

extension OnlyNumber on String {
  String get onlyDoubles => replaceAll(RegExp(r'[^0-9.]'), '');
  String get onlyNumbers => replaceAll(RegExp(r'[^0-9]'), '');
}

extension ListReplaceExtension<T> on List<T> {
  void replaceWhere(bool Function(T) test, T replacement) {
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        this[i] = replacement;
      }
    }
  }

  void replaceFirstWhere(bool Function(T) test, T replacement) {
    for (int i = 0; i < length; i++) {
      if (test(this[i])) {
        this[i] = replacement;
        break;
      }
    }
  }
}
