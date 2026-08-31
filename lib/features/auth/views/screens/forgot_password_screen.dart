import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:aryegrunzweig/core/utils/constants/icon_path.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../controller/auth_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,

            // logo
            Align(
              alignment: AlignmentGeometry.center,
              child: Image.asset(IconPath.logo, width: 158.w),
            ),

            55.verticalSpace,

            // title,
            Text(
              'Forget password',
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),

            10.verticalSpace,

            // subtitle
            Text(
              'Enter your email or phone we will send the verification code to reset your password',
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black.withValues(alpha: .6),
              ),
            ),

            35.verticalSpace,

            // email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email',
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                10.verticalSpace,
                CustomTextField(
                  controller: controller.forgotPasswordEmailController,
                  hintText: 'Enter your  email address',
                  inputType: TextInputType.emailAddress,
                ),
              ],
            ),

            25.verticalSpace,

            Obx(
              () => CustomButton(
                text: controller.isSubmitting.value
                    ? 'Requesting...'
                    : 'Request Code',
                onPressed: () => _requestCode(context),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 26.w),
      ),
    );
  }

  Future<void> _requestCode(BuildContext context) async {
    final success = await controller.requestPasswordReset();
    if (!context.mounted) return;
    if (success) {
      controller.otp = '';
      Get.toNamed(AppRoute.resetPasswordScreen);
    } else {
      AppHelperFunctions.showErrorSnackBar(controller.errorMessage.value);
    }
  }
}
