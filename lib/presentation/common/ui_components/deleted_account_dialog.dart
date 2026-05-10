import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/translations_manager.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';

class DeletedAccountDialog extends StatelessWidget {
  /// WhatsApp support number (Qatar test number)
  static const String _supportPhone = '97433001122';

  const DeletedAccountDialog({super.key});

  Future<void> _openWhatsApp(BuildContext context) async {
    final locale = context.locale.languageCode;
    final message = locale == 'ar'
        ? 'السلام عليكم، أرغب في إعادة تفعيل حسابي في تطبيق موعدك.'
        : 'Hello, I would like to reactivate my account on Mawadk app.';

    final uri = Uri.parse(
      'https://wa.me/$_supportPhone?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 341.w,
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(48.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 100.w,
              height: 100.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3E0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 52.w,
                  color: const Color(0xFFFF9800),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Title
            Text(
              Translation.deleted_account_title.tr,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeightM.semiBold,
                color: const Color(0xFF1C2A3A),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),

            // Message
            Text(
              Translation.deleted_account_message.tr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeightM.regular,
                color: const Color(0xFF6B7280),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 28.h),

            // WhatsApp button
            SizedBox(
              width: double.infinity,
              child: CustomInkButton(
                onTap: () => _openWhatsApp(context),
                backgroundColor: const Color(0xFF25D366),
                borderRadius: 50.r,
                height: 48.h,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_rounded,
                      color: Colors.white,
                      size: 20.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      Translation.contact_support_whatsapp.tr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeightM.medium,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Close button
            SizedBox(
              width: double.infinity,
              child: CustomInkButton(
                onTap: () => Navigator.of(context).pop(),
                backgroundColor: Colors.transparent,
                borderRadius: 50.r,
                height: 48.h,
                alignment: Alignment.center,
                side: const BorderSide(
                  color: Color(0xFFE5E7EB),
                  width: 1,
                ),
                child: Text(
                  Translation.cancel.tr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeightM.medium,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to show the dialog easily
extension DeletedAccountDialogExtension on BuildContext {
  void showDeletedAccountDialog() {
    showDialog(
      context: this,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const DeletedAccountDialog();
      },
    );
  }
}
