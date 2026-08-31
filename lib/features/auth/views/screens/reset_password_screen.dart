import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/auth_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

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
            28.verticalSpace,
            Text(
              'Reset password',
              style: getTextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            8.verticalSpace,
            Text(
              'Enter the 5-digit code sent to ${controller.pendingResetEmail}.',
              style: getTextStyle(
                fontSize: 13.sp,
                color: Colors.black54,
                textAlign: TextAlign.left,
              ),
            ),
            30.verticalSpace,
            OtpTextField(
              numberOfFields: 5,
              fieldHeight: 46.w,
              fieldWidth: 46.w,
              borderRadius: BorderRadius.circular(10.r),
              borderColor: AppColors.primary,
              focusedBorderColor: AppColors.primary,
              showFieldAsBox: true,
              onCodeChanged: (value) => controller.otp = value,
              onSubmit: (value) => controller.otp = value,
            ),
            28.verticalSpace,
            Text('New password', style: getTextStyle(fontSize: 13.sp)),
            9.verticalSpace,
            Obx(
              () => CustomTextField(
                controller: controller.resetPasswordController,
                hintText: 'Minimum 8 characters',
                obscureText: controller.isResetPasswordHidden.value,
                suffixIcon: Icon(
                  controller.isResetPasswordHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onSuffixPressed: controller.isResetPasswordHidden.toggle,
              ),
            ),
            18.verticalSpace,
            Text('Confirm password', style: getTextStyle(fontSize: 13.sp)),
            9.verticalSpace,
            Obx(
              () => CustomTextField(
                controller: controller.resetPasswordConfirmController,
                hintText: 'Enter password again',
                obscureText: controller.isResetPasswordHidden.value,
              ),
            ),
            32.verticalSpace,
            Obx(
              () => CustomButton(
                text: controller.isSubmitting.value
                    ? 'Resetting...'
                    : 'Reset Password',
                isLoading: controller.isSubmitting.value,
                onPressed: () => _reset(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reset(BuildContext context) async {
    final success = await controller.resetPassword();
    if (!context.mounted) return;
    if (success) {
      AppHelperFunctions.showSuccessSnackBar(controller.infoMessage.value);
    } else {
      AppHelperFunctions.showErrorSnackBar(controller.errorMessage.value);
    }
    if (success) Get.offAllNamed(AppRoute.loginScreen);
  }
}
