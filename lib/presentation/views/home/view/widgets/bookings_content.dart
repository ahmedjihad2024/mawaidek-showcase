import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/views/home/view/screens/taps/sub_bookings_taps/sub_bookings_tap_view.dart';
import 'package:mawadk/presentation/views/home/view/screens/taps/tap_bookings_view.dart';

class BookingsContent extends StatelessWidget {
  const BookingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CarouselSlider(
        items: [
          // Upcoming Bookings
          SubBookingsTapView(bookingType: BookingType.upcoming),
          // Completed Bookings
          SubBookingsTapView(bookingType: BookingType.completed),
          // Cancelled Bookings
          SubBookingsTapView(bookingType: BookingType.cancelled),
        ],
        options: CarouselOptions(
          initialPage: 0, // Start with Upcoming
          viewportFraction: 1,
          aspectRatio: 1,
          height: double.infinity,
          enableInfiniteScroll: false,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          padEnds: false,
          animateToClosest: false,
        ),
        carouselController: CAROUSE_SLIDER_CONTROLLER_BOOKINGS,
      ),
    );
  }
}
