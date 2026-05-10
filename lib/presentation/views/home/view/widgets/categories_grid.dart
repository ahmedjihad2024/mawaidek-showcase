import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/presentation/res/routes_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';
import 'package:mawadk/presentation/views/home/view/widgets/category_item.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFDC9497),
      const Color(0xFF93C19E),
      const Color(0xFFF5AD7E),
      const Color(0xFFACA1CD),
      const Color(0xFF4D9B91),
      const Color.fromARGB(255, 112, 78, 191),
      const Color.fromARGB(255, 171, 198, 237),
      const Color(0xFF89CCDB),
    ];
    var state = context.read<HomeBloc>().state;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.w,
        childAspectRatio: .70,
      ),
      itemCount: state.homeData!.categories.length,
      itemBuilder: (context, index) {
        final category = state.homeData!.categories[index];
        return CategoryItem(
          imageUrl: category.image,
          title: category.name,
          color: colors[index % 8],
          onTap: () {
            Navigator.of(context).pushNamed(
              RoutesManager.categoryProviders.route,
              arguments: {
                'category': category,
              },
            );
          },
        );
      },
    );
  }
}
