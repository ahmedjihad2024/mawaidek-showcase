import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mawadk/presentation/common/ui_components/circular_progress_indicator.dart';
import 'package:mawadk/presentation/common/ui_components/error_widget.dart';
import 'package:mawadk/presentation/common/utils/after_layout.dart';
import 'package:mawadk/presentation/common/utils/fast_function.dart';
import 'package:mawadk/presentation/common/utils/state_render.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/booking_details/bloc/booking_details_bloc.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_action_buttons.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_auto_action_banner.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_details_app_bar.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_doctor_card.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_fees_summary.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_location_section.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_payment_info_section.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_section_header.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_status_explanation_card.dart';
import 'package:mawadk/presentation/views/booking_details/view/widgets/booking_status_timeline_section.dart';

class BookingDetailsView extends StatefulWidget {
  final int bookingId;
  final VoidCallback? onReviewSubmitted;
  final VoidCallback? onBookingCancelled;

  const BookingDetailsView({
    super.key,
    required this.bookingId,
    this.onReviewSubmitted,
    this.onBookingCancelled,
  });

  @override
  State<BookingDetailsView> createState() => _BookingDetailsViewState();
}

class _BookingDetailsViewState extends State<BookingDetailsView>
    with AfterLayout {
  BookingDetailsState get _state => context.read<BookingDetailsBloc>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                // App Bar
                BookingDetailsAppBar(
                  onBack: () => Navigator.of(context).pop(),
                ),

                ScreenState.setState(
                  reqState: state.reqState,
                  loading: () => const Expanded(
                    child: Center(child: MyCircularProgressIndicator()),
                  ),
                  error: () => Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeM.pagePadding.dg),
                        child: MyErrorWidget(
                          onRetry: () {
                            context.read<BookingDetailsBloc>().add(
                                GetBookingDetailsEvent(
                                    bookingId: widget.bookingId));
                          },
                          errorMessage: state.errorMessage,
                        ),
                      ),
                    ),
                  ),
                  online: () {
                    final booking = state.booking!;
                    return Expanded(
                      child: Column(
                        children: [
                          26.verticalSpace,

                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeM.pagePadding.dg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section header (title + status tag)
                                  BookingSectionHeader(booking: booking),

                                  SizedBox(height: 16.h),

                                  // Date row
                                  _DateAndEditRow(
                                    date: parseDateAndTime(
                                      date: booking.date,
                                      time: booking.time,
                                    ),
                                    locale: Localizations.localeOf(context)
                                        .languageCode,
                                  ),

                                  SizedBox(height: 16.h),

                                  // Divider
                                  Container(
                                      height: 1.h,
                                      color: const Color(0xFFE5E7EB)),

                                  SizedBox(height: 16.h),

                                  // Doctor / provider card
                                  BookingDoctorCard(booking: booking),

                                  SizedBox(height: 16.h),

                                  // Fees summary
                                  BookingFeesSummary(booking: booking),

                                  // Payment info (only when available)

                                  SizedBox(height: 12.h),
                                  BookingPaymentInfoSection(booking: booking),

                                  // Auto-action banner
                                  if (_autoActionMessage(state) != null) ...[
                                    SizedBox(height: 12.h),
                                    BookingAutoActionBanner(
                                        message: _autoActionMessage(state)!),
                                  ],

                                  // Status explanation card
                                  BookingStatusExplanationCard(
                                      booking: booking),

                                  // Status timeline
                                  if (booking.statusTimeline.isNotEmpty) ...[
                                    SizedBox(height: 24.h),
                                    BookingStatusTimelineSection(
                                        entries: booking.statusTimeline),
                                  ],

                                  SizedBox(height: 24.h),

                                  // Location
                                  if (booking.provider != null)
                                    BookingLocationSection(booking: booking),

                                  SizedBox(height: 24.h),
                                ],
                              ),
                            ),
                          ),

                          // Bottom action buttons
                          if (!booking.status.isCancelled)
                            BookingActionButtons(
                              booking: booking,
                              onReviewSubmitted: widget.onReviewSubmitted,
                              onBookingCancelled: widget.onBookingCancelled,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String? _autoActionMessage(BookingDetailsState state) {
    final reason = state.booking?.autoActionReason;
    if (reason == null || reason.isEmpty) return null;
    switch (reason) {
      case 'provider_no_response':
        return Translation.auto_cancelled_provider_no_response.tr;
      case 'payment_expired':
        return Translation.auto_cancelled_payment_expired.tr;
      case 'auto_complete_after_grace':
        return Translation.auto_completed_after_grace.tr;
      case 'no_show':
        return Translation.auto_no_show.tr;
      default:
        return null;
    }
  }

  @override
  Future<void> afterLayout(BuildContext context) async {
    context
        .read<BookingDetailsBloc>()
        .add(GetBookingDetailsEvent(bookingId: widget.bookingId));
  }
}

// ─────────────────────────────────────────────
// Date Row (kept here — simple, screen-specific)
// ─────────────────────────────────────────────

class _DateAndEditRow extends StatelessWidget {
  final DateTime date;
  final String locale;

  const _DateAndEditRow({required this.date, required this.locale});

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('MMMM d, y - h:mm a', locale).format(date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatted,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeightM.bold,
            color: const Color(0xFF1F2A37),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
