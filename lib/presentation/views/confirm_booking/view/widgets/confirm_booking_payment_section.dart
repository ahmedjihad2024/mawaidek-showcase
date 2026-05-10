import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/assets_manager.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/confirm_booking/bloc/confirm_booking_bloc.dart';

class ConfirmBookingPaymentSection extends StatelessWidget {
  final ConfirmBookingState state;

  const ConfirmBookingPaymentSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Translation.payment_method.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeightM.semiBold,
            color: const Color(0xFF1C2A3A),
            height: 1.5,
          ),
        ),
        SizedBox(height: 14.h),
        // Card / online payment via Sadad Qatar — selected, the booking
        // creation kicks off a Sadad PaymentScreen with a server-issued
        // session token. Backend computes the amount; mobile never does.
        _PaymentOption(
          selected: state.paymentMethod.isOnline,
          title: Translation.credit_debit_card.tr,
          subtitle: Translation.pay_now_securely.tr,
          onTap: () {
            context.read<ConfirmBookingBloc>().add(
                UpdatePaymentMethodEvent(paymentMethod: PaymentMethod.online));
          },
          highlighted: state.paymentMethod.isOnline,
        ),
        SizedBox(height: 10.h),
        _PaymentOption(
          selected: state.paymentMethod.isCash,
          title: switch (state.confirmData!.provider.type) {
            ProviderType.Hospital => Translation.pay_at_hospital.tr,
            ProviderType.Clinic => Translation.pay_at_clinic.tr,
            ProviderType.Doctor => Translation.cash.tr,
          },
          subtitle: Translation.cash_or_card_at_reception.tr,
          onTap: () {
            context.read<ConfirmBookingBloc>().add(
                UpdatePaymentMethodEvent(paymentMethod: PaymentMethod.cash));
          },
          highlighted: state.paymentMethod.isCash,
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  const _PaymentOption({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInkButton(
      smoothness: 1,
      onTap: onTap,
      backgroundColor: highlighted
          ? const Color.fromRGBO(56, 121, 212, 0.04)
          : const Color(0xFFFAFAFA),
      borderRadius: 12.r,
      side: BorderSide(
        color: highlighted
            ? const Color.fromRGBO(56, 121, 212, 0.6)
            : Colors.black.withValues(alpha: 0.02),
        width: 1,
      ),
      boxShadow: highlighted
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? const Color(0xFF292230) : Colors.transparent,
              border: Border.all(
                color: selected
                    ? const Color(0xFF292230)
                    : const Color(0xFFD1D5DB),
                width: 1,
              ),
            ),
            child: selected
                ? Icon(
                    Icons.check,
                    size: 13.w,
                    color: Colors.white,
                  )
                : null,
          ),
          SizedBox(width: 14.w),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                SvgM.walletSolid,
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeightM.medium,
                    color: const Color(0xFF1F2A37),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeightM.regular,
                    color: const Color(0xFF637D92),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
