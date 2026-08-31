import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            Center(child: Image.asset(IconPath.logo, width: 158.w)),
            55.verticalSpace,
            Text(
              'Verification code',
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            10.verticalSpace,
            Text(
              'Enter the 5-digit code sent to ${controller.pendingVerificationEmail}.',
              style: getTextStyle(
                fontSize: 13.sp,
                color: Colors.black.withValues(alpha: .6),
                textAlign: TextAlign.left,
              ),
            ),
            35.verticalSpace,
            OtpTextField(
              contentPadding: EdgeInsets.zero,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              numberOfFields: 5,
              borderRadius: BorderRadius.circular(10.r),
              fieldHeight: 46.w,
              fieldWidth: 46.w,
              borderColor: AppColors.primary,
              focusedBorderColor: AppColors.primary,
              showFieldAsBox: true,
              onCodeChanged: (code) => controller.otp = code,
              onSubmit: (code) => controller.otp = code,
            ),
            20.verticalSpace,
            TextButton(
              onPressed: () => _resend(context),
              child: const Text('Resend code'),
            ),
            20.verticalSpace,
            Obx(
              () => CustomButton(
                text: controller.isSubmitting.value ? 'Verifying...' : 'Verify',
                onPressed: () => _verify(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verify(BuildContext context) async {
    final success = await controller.verifyEmail();
    if (!context.mounted) return;
    if (success) {
      Get.offAllNamed(AppRoute.accountCreateSuccessScreen);
    } else {
      AppHelperFunctions.showErrorSnackBar(controller.errorMessage.value);
    }
  }

  Future<void> _resend(BuildContext context) async {
    final success = await controller.resendVerification();
    if (!context.mounted) return;
    if (success) {
      AppHelperFunctions.showSuccessSnackBar(controller.infoMessage.value);
    } else {
      AppHelperFunctions.showErrorSnackBar(controller.errorMessage.value);
    }
  }
}
