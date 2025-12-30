import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:aryegrunzweig/features/auth/controller/auth_controller.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create account',
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),

            10.verticalSpace,

            Text(
              'Get the best out of derleng by creating an account',
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.5),
              ),
            ),

            20.verticalSpace,

            // first name
            SignUpTextField(
              textController: controller.firstNameController,
              hintText: 'John',
              title: 'First Name',
            ),

            // last name
            SignUpTextField(
              textController: controller.lastNameController,
              hintText: 'John',
              title: 'First Name',
            ),

            // phone number
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.black.withOpacity(0.1)),
                  ),
                  child: CountryCodePicker(
                    initialSelection: controller.countryCode,
                    onChanged: (value) {
                      controller.countryCode = value.code!;
                      controller.dialCode = value.dialCode!.toString();
                    },
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  child: CustomTextField(
                    controller: controller.phoneNumberController,
                    hintText: '123 456 789',
                    inputType: TextInputType.phone,
                  ),
                ),
              ],
            ),

            20.verticalSpace,

            // address
            SignUpTextField(
              textController: controller.addressController,
              hintText: 'Address',
              title: 'Address',
            ),

            // address
            SignUpTextField(
              textController: controller.addressController,
              hintText: 'Address',
              title: 'Address',
            ),

            // apt
            SignUpTextField(
              textController: controller.aptController,
              hintText: 'Apartment Number',
              title: 'APT',
            ),

            // city
            SignUpTextField(
              textController: controller.cityController,
              hintText: 'City Name',
              title: 'City',
            ),

            // state
            SignUpTextField(
              textController: controller.stateController,
              hintText: 'State',
              title: 'State',
            ),

            // zip
            SignUpTextField(
              textController: controller.zipController,
              hintText: 'Zip code',
              title: 'Zip',
            ),

            // email
            SignUpTextField(
              textController: controller.emailController,
              hintText: 'info@gmail.com',
              title: 'Email',
              type: TextInputType.emailAddress,
            ),

            // password
            Obx(() {
              return SignUpTextField(
                textController: controller.passwordController,
                hintText: 'Enter your Strong Password',
                title: 'Password',
                isObsecure: controller.isPasswordHidden.value,
                suffixIcon: Icon(
                  controller.isPasswordHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                // This matches the renamed parameter
                onSuffixTap: () => controller.isPasswordHidden.toggle(),
              );
            }),

            // password
            Obx(() {
              return SignUpTextField(
                textController: controller.retypePasswordController,
                hintText: 'Enter your Strong Password Again',
                title: 'Re-type Password',
                isObsecure: controller.isRetypePasswordHidden.value,
                suffixIcon: Icon(
                  controller.isRetypePasswordHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                // This matches the renamed parameter
                onSuffixTap: () => controller.isRetypePasswordHidden.toggle(),
              );
            }),

            // terms and condition
            GestureDetector(
              onTap: () => controller.termAndCondition.value = !controller.termAndCondition.value,
              child: Row(
                children: [
                  Obx(() {
                    return Icon(
                      controller.termAndCondition.value
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank,
                      color: AppColors.primary,
                    );
                  }),

                  10.horizontalSpace,

                  Text(
                    'I accept term and condition',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                      decorationThickness: 1.5,
                    ),
                  )
                ],
              ),
            ),

            30.verticalSpace,

            Align(
              alignment: Alignment.center, // Changed to Alignment.center for simplicity
              child: GestureDetector(
                onTap: () => Get.offAllNamed(AppRoute.getLoginScreen()),
                child: Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Go back',
                        style: getTextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold, // Making this part bold
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            20.verticalSpace,

            CustomButton(text: 'Create Account', onPressed: () => Get.toNamed(AppRoute.getOtpScreen())),

            40.verticalSpace,
          ],
        ).paddingSymmetric(horizontal: 26.w),
      ),
    );
  }
}

class SignUpTextField extends StatelessWidget {
  const SignUpTextField({
    super.key,
    required this.textController,
    required this.hintText,
    this.type = TextInputType.text,
    required this.title,
    this.isObsecure = false,
    this.onSuffixTap, // Renamed for clarity
    this.suffixIcon,
  });

  final String title;
  final TextEditingController textController;
  final String hintText;
  final TextInputType type;
  final bool isObsecure;
  final VoidCallback? onSuffixTap; // Logic for the eye icon
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        10.verticalSpace,
        CustomTextField(
          controller: textController,
          hintText: hintText,
          inputType: type,
          obscureText: isObsecure,
          suffixIcon: suffixIcon,
          // Use the callback here
          onSuffixPressed: onSuffixTap,
        ),
      ],
    ).paddingOnly(bottom: 20.h);
  }
}
