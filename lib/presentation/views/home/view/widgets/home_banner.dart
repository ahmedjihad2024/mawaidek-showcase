import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';

class HomeBanner extends StatelessWidget {
  final int pagesCount;
  final int selectedPage;
  final String type;
  final String title;
  final String description;
  final String? url;
  final String image;
  final VoidCallback? onTap;
  const HomeBanner(
      {super.key,
      required this.pagesCount,
      required this.selectedPage,
      required this.type,
      required this.title,
      required this.description,
      this.url,
      required this.image,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 163.h,
      margin: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cached background image
            CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.fill,
              memCacheWidth: 800,
              placeholder: (context, url) => Container(
                color: Colors.grey.withValues(alpha: 0.2),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.withValues(alpha: 0.3),
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
            // Content overlay
            InkWell(
              onTap: onTap,
              child: Padding(
              padding: EdgeInsets.all(11.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeightM.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 210.w,
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeightM.regular,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const Spacer(),
      
                  // Carousel indicators
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < pagesCount; i++) ...[
                          Container(
                            width: selectedPage == i ? 25.w : 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: selectedPage == i
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                          ),
                          if (i != pagesCount - 1) SizedBox(width: 4.w),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
