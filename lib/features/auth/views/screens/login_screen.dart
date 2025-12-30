import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_outline_button.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_text_field.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:aryegrunzweig/core/utils/constants/icon_path.dart';
import 'package:aryegrunzweig/features/auth/controller/auth_controller.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              50.verticalSpace,

              Image.asset(IconPath.logo, width: 160.w),

              38.verticalSpace,

              Text(
                'Welcome',
                style: getTextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),

              7.verticalSpace,

              Text(
                'Please choose your login option below',
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              75.verticalSpace,

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
                    controller: controller.loginEmailController,
                    hintText: 'Enter your  email address',
                    inputType: TextInputType.emailAddress,
                  ),
                ],
              ),

              16.verticalSpace,

              // password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  10.verticalSpace,
                  Obx(
                    () => CustomTextField(
                      controller: controller.loginPasswordController,
                      hintText: 'Enter your password',
                      inputType: TextInputType.visiblePassword,
                      // Toggle obscureText based on controller state
                      obscureText: !controller.isLoginPasswordVisible.value,
                      onSuffixPressed: () =>
                          controller.togglePasswordVisibility(),
                      suffixIcon: Icon(
                        controller.isLoginPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),


              // forgot password
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoute.getForgotPasswordScreen()),
                  child: Text(
                    'Forgot password?',
                    style:
                        getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                        ).copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                          decorationThickness: 1.5,
                        ),
                  ),
                ),
              ),

              7.verticalSpace,

              // login button
              CustomButton(text: 'Login', onPressed: () {}),

              25.verticalSpace,

              CustomOutLineButton(text: 'Create Account', onPressed: () {}),
            ],
          ).paddingSymmetric(horizontal: 26.w),
        ),
      ),
    );
  }
}
