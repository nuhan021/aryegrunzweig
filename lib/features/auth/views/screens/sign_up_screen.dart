import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/auth_controller.dart';
import '../../models/auth_models.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(26.w, 0, 26.w, 40.h),
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
            8.verticalSpace,
            Text(
              'Choose your role and enter the required account details.',
              style: getTextStyle(
                fontSize: 12.sp,
                color: Colors.black.withValues(alpha: .55),
                textAlign: TextAlign.left,
              ),
            ),
            22.verticalSpace,
            Obx(
              () => _RoleSelector(
                selectedRole: controller.selectedSignupRole.value,
                onSelected: controller.selectSignupRole,
              ),
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: SignUpTextField(
                    textController: controller.firstNameController,
                    hintText: 'Alex',
                    title: 'First name *',
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: SignUpTextField(
                    textController: controller.lastNameController,
                    hintText: 'Morgan',
                    title: 'Last name *',
                  ),
                ),
              ],
            ),
            Text(
              'Phone number *',
              style: getTextStyle(fontSize: 13.sp, textAlign: TextAlign.left),
            ),
            9.verticalSpace,
            Row(
              children: [
                Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: CountryCodePicker(
                    initialSelection: controller.countryCode,
                    favorite: const ['CA', 'US'],
                    onChanged: (value) {
                      controller.countryCode = value.code ?? 'CA';
                      controller.dialCode = value.dialCode ?? '+1';
                    },
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: CustomTextField(
                    controller: controller.phoneNumberController,
                    hintText: '416 555 0100',
                    inputType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            SignUpTextField(
              textController: controller.addressController,
              hintText: '123 Main Street',
              title: 'Address *',
            ),
            SignUpTextField(
              textController: controller.aptController,
              hintText: 'Unit 4B',
              title: 'Apartment (optional)',
            ),
            Row(
              children: [
                Expanded(
                  child: SignUpTextField(
                    textController: controller.cityController,
                    hintText: 'Toronto',
                    title: 'City *',
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: SignUpTextField(
                    textController: controller.stateController,
                    hintText: 'ON',
                    title: 'State *',
                  ),
                ),
              ],
            ),
            SignUpTextField(
              textController: controller.zipController,
              hintText: 'M5V 2T6',
              title: 'Zip code *',
            ),
            SignUpTextField(
              textController: controller.emailController,
              hintText: 'alex@example.com',
              title: 'Email *',
              type: TextInputType.emailAddress,
            ),
            Obx(
              () => SignUpTextField(
                textController: controller.passwordController,
                hintText: 'Minimum 8 characters',
                title: 'Password *',
                isObscure: controller.isPasswordHidden.value,
                suffixIcon: Icon(
                  controller.isPasswordHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onSuffixTap: controller.isPasswordHidden.toggle,
              ),
            ),
            Obx(
              () => SignUpTextField(
                textController: controller.retypePasswordController,
                hintText: 'Enter password again',
                title: 'Confirm password *',
                isObscure: controller.isRetypePasswordHidden.value,
                suffixIcon: Icon(
                  controller.isRetypePasswordHidden.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onSuffixTap: controller.isRetypePasswordHidden.toggle,
              ),
            ),
            Obx(
              () => controller.isTechnicianSignup
                  ? _TechnicianFields(controller: controller)
                  : const SizedBox.shrink(),
            ),
            GestureDetector(
              onTap: controller.termAndCondition.toggle,
              child: Row(
                children: [
                  Obx(
                    () => Icon(
                      controller.termAndCondition.value
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank,
                      color: AppColors.primary,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      'I accept the terms and conditions *',
                      style: getTextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        textAlign: TextAlign.left,
                      ).copyWith(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            28.verticalSpace,
            Obx(
              () => CustomButton(
                text: controller.isSubmitting.value
                    ? 'Creating account...'
                    : 'Create Account',
                onPressed: () => _submit(context),
              ),
            ),
            20.verticalSpace,
            Center(
              child: TextButton(
                onPressed: () => Get.offAllNamed(AppRoute.loginScreen),
                child: const Text('Already have an account? Log in'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final success = await controller.signup();
    if (!context.mounted) return;
    if (success) {
      Get.toNamed(AppRoute.otpScreen);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.errorMessage.value)));
    }
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.selectedRole, required this.onSelected});

  final UserRole selectedRole;
  final ValueChanged<UserRole> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _roleButton('Customer', UserRole.customer),
          _roleButton('Technician', UserRole.technician),
        ],
      ),
    );
  }

  Widget _roleButton(String label, UserRole role) {
    final selected = selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => onSelected(role),
        borderRadius: BorderRadius.circular(9.r),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

class _TechnicianFields extends StatelessWidget {
  const _TechnicianFields({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Text(
            'Technician information',
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        SignUpTextField(
          textController: controller.serviceAreaController,
          hintText: 'Greater Toronto Area',
          title: 'Service area *',
        ),
        SignUpTextField(
          textController: controller.skillsController,
          hintText: 'Repair, Installation',
          title: 'Skills, comma separated *',
        ),
        SignUpTextField(
          textController: controller.employeeIdController,
          hintText: 'TECH-1001',
          title: 'Employee ID (optional)',
        ),
        SignUpTextField(
          textController: controller.licenseNumberController,
          hintText: 'LIC-123456',
          title: 'License number (optional)',
        ),
        SignUpTextField(
          textController: controller.yearsExperienceController,
          hintText: '6',
          title: 'Years of experience (optional)',
          type: TextInputType.number,
        ),
        SignUpTextField(
          textController: controller.bioController,
          hintText: 'Certified central vacuum technician.',
          title: 'Bio (optional)',
          maxLines: 3,
        ),
      ],
    );
  }
}

class SignUpTextField extends StatelessWidget {
  const SignUpTextField({
    super.key,
    required this.textController,
    required this.hintText,
    required this.title,
    this.type = TextInputType.text,
    this.isObscure = false,
    this.onSuffixTap,
    this.suffixIcon,
    this.maxLines = 1,
  });

  final String title;
  final TextEditingController textController;
  final String hintText;
  final TextInputType type;
  final bool isObscure;
  final VoidCallback? onSuffixTap;
  final Widget? suffixIcon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle(fontSize: 13.sp, textAlign: TextAlign.left),
          ),
          9.verticalSpace,
          CustomTextField(
            controller: textController,
            hintText: hintText,
            inputType: type,
            obscureText: isObscure,
            suffixIcon: suffixIcon,
            onSuffixPressed: onSuffixTap,
            maxLine: isObscure ? 1 : maxLines,
          ),
        ],
      ),
    );
  }
}
