import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/home_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTopSection extends StatelessWidget {
  const HomeTopSection({
    super.key,
    required this.state,
    required this.context,
  });

  final HomeState state;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Banner
        SizedBox(height: 14.h),
        SizedBox(
          height: 163.h,
          child: CarouselSlider(
            items: [
              for (int i = 0; i < state.homeData!.sliders.length; i++)
                HomeBanner(
                  pagesCount: state.homeData!.sliders.length,
                  selectedPage: i,
                  type: state.homeData!.sliders[i].type,
                  title: state.homeData!.sliders[i].title,
                  description: state.homeData!.sliders[i].description,
                  url: state.homeData!.sliders[i].url,
                  image: state.homeData!.sliders[i].image,
                  onTap: () async {
                    if (state.homeData!.sliders[i].type == "ULR") {
                      if (await canLaunchUrl(
                          Uri.parse(state.homeData!.sliders[i].url!))) {
                        await launchUrl(
                            Uri.parse(state.homeData!.sliders[i].url!),
                            mode: LaunchMode.externalApplication);
                      }
                    } else if (ProviderType.fromString(
                            state.homeData!.sliders[i].type) !=
                        null) {
                      Navigator.of(context).pushNamed(
                        RoutesManager.services.route,
                        arguments: {
                          'exploreType': ProviderType.fromString(
                              state.homeData!.sliders[i].type)!,
                          "provider-id":
                              int.parse(state.homeData!.sliders[i].url!)
                        },
                      );
                    }
                  },
                ),
            ],
            options: CarouselOptions(
              initialPage: 0, // Start with Home
              viewportFraction: 1,
              height: double.infinity,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
              autoPlayInterval: const Duration(seconds: 6),
            ),
          ),
        ),
      ],
    );
  }
}
