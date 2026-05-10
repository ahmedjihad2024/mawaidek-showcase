import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/screens/taps/sub_explore_taps/sub_explore_tap_view.dart';

class ExploreViewContent extends StatelessWidget {
  final CarouselSliderController carouselSliderController;

  const ExploreViewContent({
    super.key,
    required this.carouselSliderController,
  });

  @override
  Widget build(BuildContext context) {
    var state = context.read<HomeBloc>().state;
    return Expanded(
      child: CarouselSlider(
        items: [
          // Home (Figma Home)
          SubExploreTapView(
            exploreType: ProviderType.Doctor,
            state: state,
          ),
          // Explore (Figma Explore)
          SubExploreTapView(
            exploreType: ProviderType.Clinic,
            state: state,
          ),
          // Explore (Figma Explore)
          SubExploreTapView(
            exploreType: ProviderType.Hospital,
            state: state,
          ),
        ],
        options: CarouselOptions(
          initialPage: 0, // Start with Home
          viewportFraction: 1,
          aspectRatio: 1,
          height: double.infinity,
          enableInfiniteScroll: false,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          padEnds: false,
          animateToClosest: false,
        ),
        carouselController: carouselSliderController,
      ),
    );
  }
}
