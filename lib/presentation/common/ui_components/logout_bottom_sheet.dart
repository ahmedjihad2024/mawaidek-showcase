import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mawadk/app/enums.dart';
import 'package:mawadk/presentation/common/ui_components/custom_form_field/custom_form_field.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/views/home/bloc/home_bloc.dart';

class LogoutBottomSheet extends StatefulWidget {
  final AccountActionType actionType;
  final VoidCallback? onCancel;
  final VoidCallback? onSuccess;
  final BuildContext context;

  const LogoutBottomSheet(
      {super.key,
      this.actionType = AccountActionType.logout,
      this.onCancel,
      this.onSuccess,
      required this.context});

  @override
  State<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
}

class _LogoutBottomSheetState extends State<LogoutBottomSheet> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final SecurityController _securityController = SecurityController();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    final isDeleteAccount = widget.actionType.isDeleteAccount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(34.r),
          topRight: Radius.circular(34.r),
        ),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title & Text Section
          Column(
            children: [
              // Title
              Text(
                isDeleteAccount
                    ? Translation.delete_account.tr
                    : Translation.logout.tr,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeightM.semiBold,
                  color: const Color(0xFF1C2A3A), // Dark Teal
                  height: 1.5,
                ),
              ),

              SizedBox(height: 16.h),

              // Separator
              Container(
                height: 1.h,
                color: const Color(0xFFE5E7EB), // gray-200
              ),

              SizedBox(height: 16.h),

              // Description Text
              Text(
                isDeleteAccount
                    ? Translation.delete_account_confirmation.tr
                    : Translation.logout_confirmation.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeightM.semiBold,
                  color: const Color(0xFF6B7280), // gray-500
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          // // Password Field (only for delete account)
          // if (isDeleteAccount) ...[
          //   SizedBox(height: 24.h),
          //   SimpleForm(
          //     controller: _passwordController,
          //     focusNode: _passwordFocus,
          //     hintText: Translation.enter_password_to_delete.tr,
          //     keyboardType: TextInputType.visiblePassword,
          //     securityController: _securityController,
          //     prefixWidget: SvgPicture.asset(
          //       SvgM.lock,
          //       width: 18.w,
          //       height: 18.w,
          //       fit: BoxFit.contain,
          //       colorFilter: const ColorFilter.mode(
          //         Color(0xFF9CA3AF), // gray-400
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //   ),
          // ],

          SizedBox(height: 24.h),

          // Buttons Section
          Row(
            children: [
              // Cancel Button
              Expanded(
                flex: 1,
                child: CustomInkButton(
                  onTap: widget.onCancel,
                  backgroundColor: const Color(0xFFE5E7EB), // gray-200
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  borderRadius: 50.r,
                  alignment: Alignment.center,
                  child: Text(
                    Translation.cancel.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeightM.bold,
                      color: const Color(0xFF1C2A3A), // Dark Teal
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Confirm Button (Logout or Delete)
              Expanded(
                flex: 2,
                child: CustomInkButton(
                  onTap: _handleConfirm,
                  backgroundColor: isDeleteAccount
                      ? const Color(0xFFF41731) // Red for delete
                      : const Color(0xFF1C2A3A), // Dark Teal for logout
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  borderRadius: 50.r,
                  alignment: Alignment.center,
                  child: Text(
                    isDeleteAccount
                        ? Translation.yes_delete_account.tr
                        : Translation.yes_logout.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeightM.bold,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleConfirm() {
    if (widget.actionType.isDeleteAccount) {
      // // Validate password
      // if (_passwordController.text.trim().isEmpty) {
      //   _passwordFocus.requestFocus();
      //   return;
      // }
      // Dispatch delete account event
      widget.context.read<HomeBloc>().add(
            DeleteAccountEvent(
              // password: _passwordController.text.trim(),
              onSuccess: widget.onSuccess,
            ),
          );
    } else {
      // Dispatch logout event
      widget.context.read<HomeBloc>().add(
            LogoutEvent(
              onSuccess: widget.onSuccess,
            ),
          );
    }
  }
}
