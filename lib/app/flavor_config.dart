import 'package:flutter/material.dart';

enum Flavor {
  dev,
  prod,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color color;
  final bool showBanner;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    Color color = Colors.blue,
    bool showBanner = true,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor: flavor,
      name: name,
      color: color,
      showBanner: showBanner,
    );
    return _instance!;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.color,
    required this.showBanner,
  });

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isDev() => _instance!.flavor == Flavor.dev;
  static bool isProd() => _instance!.flavor == Flavor.prod;
}
