import 'package:flutter/material.dart';
import 'package:mawadk/presentation/common/ui_components/default_app_bar.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class AppointmentAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const AppointmentAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return DefaultAppBar(
      title: Translation.book_appointment.tr,
      backFunction: onBack,
    );
  }
}
