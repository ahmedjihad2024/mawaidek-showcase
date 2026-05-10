import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/custom_cached_image.dart';
import 'package:mawadk/presentation/common/ui_components/custom_form_field/simple_form.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/common/ui_components/default_app_bar.dart';
import 'package:mawadk/presentation/common/ui_components/rate_widget.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/review/bloc/review_bloc.dart';

class ReviewView extends StatefulWidget {
  final int bookingId;
  final ProviderType providerType;
  final String doctorImage;
  final String doctorName;

  const ReviewView({
    super.key,
    required this.bookingId,
    required this.providerType,
    required this.doctorImage,
    required this.doctorName,
  });

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  double selectedRating = 1.0;
  double? selectedRatingDoctor;

  @override
  Widget build(BuildContext context) {
    final isDoctor = widget.providerType.isDoctor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh,
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              child: Column(
                children: [
                  // App Bar
                  DefaultAppBar(
                    title: Translation.review.tr,
                    backFunction: () => Navigator.of(context).pop(),
                  ),
        
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Doctor Image and Name
                                Column(
                                  children: [
                                    CustomCachedImage(
                                      imageUrl: widget.doctorImage,
                                      width: 96.w,
                                      height: 96.w,
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      widget.doctorName,
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeightM.semiBold,
                                        color: const Color(0xFF111A2C),
                                        height: 1.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
        
                                SizedBox(height: 50.h),
        
                                // Rating Section
                                Column(
                                  children: [
                                    Text(
                                      Translation.please_rate_the_service.tr,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeightM.medium,
                                        color: const Color(0xFF111A2C),
                                        height: 1.44,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 11.h),
                                    RateWidget(
                                      initialRate: selectedRating,
                                      size: 47.w,
                                      spacing: 10.44.w,
                                      allowHalfRating: false,
                                      onRateChange: (val) {
                                        setState(() {
                                          selectedRating = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
        
                                SizedBox(height: 50.h),
        
                                // Comment field
                                SimpleForm(
                                  controller: _commentController,
                                  focusNode: _commentFocusNode,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  alignment: AlignmentDirectional.topStart,
                                  hintText: Translation.add_a_comment.tr,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  height: 144.h,
                                  backgroundColor: const Color(0xFFF7FCFF),
                                  borderRadius: 14.r,
                                  outlineBorder: false,
                                ),
                              ],
                            ),
                          ),
        
                          SizedBox(height: 24.h),
        
                          // Submit button
                          CustomInkButton(
                            onTap: () {
                              if (_commentController.text.trim().isNotEmpty) {
                                context.read<ReviewBloc>().add(
                                      SubmitReviewEvent(
                                        bookingId: widget.bookingId,
                                        providerType: widget.providerType,
                                        rating: selectedRating,
                                        comment: _commentController.text.trim(),
                                        ratingDoctor: isDoctor
                                            ? null
                                            : selectedRatingDoctor ??
                                                selectedRating,
                                        commentDoctor: isDoctor
                                            ? null
                                            : _commentController.text.trim(),
                                        onSuccess: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    );
                              } else {
                                _commentFocusNode.requestFocus();
                              }
                            },
                            backgroundColor: const Color(0xFF1C2A3A),
                            borderRadius: 50.r,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            alignment: Alignment.center,
                            child: Text(
                              Translation.submit_review.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeightM.medium,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ),
        
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
