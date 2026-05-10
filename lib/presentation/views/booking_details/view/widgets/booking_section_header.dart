import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/data/responses/responses.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';

class BookingSectionHeader extends StatelessWidget {
  final Booking booking;

  const BookingSectionHeader({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Translation.booking_info.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeightM.semiBold,
            color: const Color(0xFF1C2A3A),
            height: 1.5,
          ),
        ),
        BookingStatusTag(booking: booking),
      ],
    );
  }
}

class BookingStatusTag extends StatelessWidget {
  final Booking booking;

  const BookingStatusTag({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(booking.status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        _getStatusText(booking.status),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeightM.semiBold,
          color: color,
        ),
      ),
    );
  }

  static Color getStatusColor(BookingStatusApp status) =>
      _getStatusColor(status);

  static Color _getStatusColor(BookingStatusApp status) {
    return switch (status) {
      BookingStatusApp.pending ||
      BookingStatusApp.confirmed =>
        const Color(0xFF009FF5),
      BookingStatusApp.completed => const Color(0xFFB8C311),
      BookingStatusApp.cancelled => const Color(0xFFF41731),
      BookingStatusApp.expired => const Color(0xFF6B7280),
      BookingStatusApp.noShow => const Color(0xFFEA580C),
      BookingStatusApp.providerNoShow => const Color(0xFF9F1239),
    };
  }

  static String _getStatusText(BookingStatusApp status) {
    return switch (status) {
      BookingStatusApp.pending ||
      BookingStatusApp.confirmed =>
        Translation.upcoming.tr,
      BookingStatusApp.completed => Translation.completed.tr,
      BookingStatusApp.cancelled => Translation.cancelled.tr,
      BookingStatusApp.expired => Translation.expired.tr,
      BookingStatusApp.noShow => Translation.no_show.tr,
      BookingStatusApp.providerNoShow => Translation.provider_no_show.tr,
    };
  }
}
