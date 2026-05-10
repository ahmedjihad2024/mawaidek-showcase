import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

/// Visual + textual recipe for a status explanation card.
class ExplanationTheme {
  final IconData icon;
  final Color fg;
  final Color bg;
  final Color iconBg;
  final Color border;
  final String title;
  final String description;

  ExplanationTheme({
    required this.icon,
    required this.fg,
    required this.bg,
    required this.iconBg,
    required this.border,
    required this.title,
    required this.description,
  });
}

ExplanationTheme getExplanationTheme(BookingStatusApp status) {
  switch (status) {
    case BookingStatusApp.cancelled:
      return ExplanationTheme(
        icon: Icons.cancel_outlined,
        fg: const Color(0xFFB91C1C),
        bg: const Color(0xFFFEF2F2),
        iconBg: const Color(0xFFFEE2E2),
        border: const Color(0xFFFCA5A5),
        title: Translation.status_cancelled_title.tr,
        description: Translation.status_cancelled_desc.tr,
      );
    case BookingStatusApp.expired:
      return ExplanationTheme(
        icon: Icons.access_time_filled,
        fg: const Color(0xFF374151),
        bg: const Color(0xFFF3F4F6),
        iconBg: const Color(0xFFE5E7EB),
        border: const Color(0xFFD1D5DB),
        title: Translation.status_expired_title.tr,
        description: Translation.status_expired_desc.tr,
      );
    case BookingStatusApp.noShow:
      return ExplanationTheme(
        icon: Icons.person_off_outlined,
        fg: const Color(0xFFC2410C),
        bg: const Color(0xFFFFF7ED),
        iconBg: const Color(0xFFFFEDD5),
        border: const Color(0xFFFDBA74),
        title: Translation.status_no_show_title.tr,
        description: Translation.status_no_show_desc.tr,
      );
    case BookingStatusApp.providerNoShow:
      return ExplanationTheme(
        icon: Icons.warning_amber_rounded,
        fg: const Color(0xFF9F1239),
        bg: const Color(0xFFFFF1F2),
        iconBg: const Color(0xFFFFE4E6),
        border: const Color(0xFFFDA4AF),
        title: Translation.status_provider_no_show_title.tr,
        description: Translation.status_provider_no_show_desc.tr,
      );
    default:
      return ExplanationTheme(
        icon: Icons.info_outline,
        fg: Colors.grey,
        bg: Colors.transparent,
        iconBg: Colors.transparent,
        border: Colors.transparent,
        title: '',
        description: '',
      );
  }
}

class BookingStatusExplanationCard extends StatelessWidget {
  final Booking booking;

  const BookingStatusExplanationCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = booking.status;

    // Skip for active statuses
    if (status == BookingStatusApp.pending ||
        status == BookingStatusApp.confirmed ||
        status == BookingStatusApp.completed) {
      return const SizedBox.shrink();
    }

    final theme = getExplanationTheme(status);

    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.bg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.border, width: 1),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: theme.iconBg,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(theme.icon, color: theme.fg, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        theme.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeightM.bold,
                          color: theme.fg,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        theme.description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF374151),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
