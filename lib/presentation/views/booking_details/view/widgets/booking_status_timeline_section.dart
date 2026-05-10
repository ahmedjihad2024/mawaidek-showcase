import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/data/responses/responses.dart';

class BookingStatusTimelineSection extends StatelessWidget {
  final List<BookingStatusTimelineEntry> entries;

  const BookingStatusTimelineSection({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == ui.TextDirection.rtl;
    const labelColor = Color(0xFF1F2937);
    const subtleColor = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded,
                  size: 20, color: Color(0xFF1C2A3A)),
              SizedBox(width: 8.w),
              Text(
                isRTL ? 'سجل الحالة' : 'Status history',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...List.generate(entries.length, (i) {
            return _TimelineRow(
              entry: entries[i],
              isLast: i == entries.length - 1,
              labelColor: labelColor,
              subtleColor: subtleColor,
              borderColor: borderColor,
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final BookingStatusTimelineEntry entry;
  final bool isLast;
  final Color labelColor;
  final Color subtleColor;
  final Color borderColor;

  const _TimelineRow({
    required this.entry,
    required this.isLast,
    required this.labelColor,
    required this.subtleColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == ui.TextDirection.rtl;
    final color = _statusDotColor(entry.status);
    final label = _statusLabel(entry.status, isRTL);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + vertical connector line
          Column(
            children: [
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: borderColor),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12, color: subtleColor),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          entry.changedAtHuman ?? entry.changedAtIso ?? '',
                          style:
                              TextStyle(fontSize: 12.sp, color: subtleColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (entry.actorType != null) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: borderColor.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            _actorLabel(entry.actorType!, isRTL),
                            style: TextStyle(
                                fontSize: 10.sp, color: subtleColor),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusDotColor(BookingStatusApp status) {
    switch (status) {
      case BookingStatusApp.pending:
        return Colors.orange;
      case BookingStatusApp.confirmed:
        return Colors.blue;
      case BookingStatusApp.completed:
        return Colors.green;
      case BookingStatusApp.cancelled:
      case BookingStatusApp.expired:
      case BookingStatusApp.noShow:
      case BookingStatusApp.providerNoShow:
        return Colors.red;
    }
  }

  String _statusLabel(BookingStatusApp status, bool isRTL) {
    switch (status) {
      case BookingStatusApp.pending:
        return isRTL ? 'تم الحجز' : 'Booked';
      case BookingStatusApp.confirmed:
        return isRTL ? 'تم التأكيد' : 'Confirmed';
      case BookingStatusApp.completed:
        return isRTL ? 'مكتمل' : 'Completed';
      case BookingStatusApp.cancelled:
        return isRTL ? 'تم الإلغاء' : 'Cancelled';
      case BookingStatusApp.expired:
        return isRTL ? 'منتهي الصلاحية' : 'Expired';
      case BookingStatusApp.noShow:
        return isRTL ? 'لم يحضر المريض' : 'Patient no-show';
      case BookingStatusApp.providerNoShow:
        return isRTL ? 'لم يحضر مقدّم الخدمة' : 'Provider no-show';
    }
  }

  String _actorLabel(String actorType, bool isRTL) {
    switch (actorType) {
      case 'User':
        return isRTL ? 'بواسطتك' : 'By you';
      case 'Admin':
        return isRTL ? 'بواسطة الإدارة' : 'By admin';
      case 'Provider':
        return isRTL ? 'بواسطة مقدم الخدمة' : 'By provider';
      default:
        return isRTL ? 'تلقائي' : 'Automatic';
    }
  }
}
