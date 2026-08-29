import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common/styles/global_text_style.dart';
import '../../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../../core/utils/constants/colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password changed successfully.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Change password',
              subtitle: 'Create a strong password to secure your account.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 28.h, 16.w, 28.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 72.w,
                        width: 72.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 34.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      28.verticalSpace,
                      _PasswordField(
                        label: 'Current password',
                        controller: _currentPasswordController,
                        obscureText: _hideCurrentPassword,
                        onToggleVisibility: () => setState(
                          () => _hideCurrentPassword = !_hideCurrentPassword,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter your current password'
                            : null,
                      ),
                      18.verticalSpace,
                      _PasswordField(
                        label: 'New password',
                        controller: _newPasswordController,
                        obscureText: _hideNewPassword,
                        onToggleVisibility: () => setState(
                          () => _hideNewPassword = !_hideNewPassword,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a new password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      18.verticalSpace,
                      _PasswordField(
                        label: 'Confirm new password',
                        controller: _confirmPasswordController,
                        obscureText: _hideConfirmPassword,
                        onToggleVisibility: () => setState(
                          () => _hideConfirmPassword = !_hideConfirmPassword,
                        ),
                        validator: (value) =>
                            value != _newPasswordController.text
                            ? 'Passwords do not match'
                            : null,
                      ),
                      16.verticalSpace,
                      Text(
                        'Use at least 8 characters. Avoid passwords you use for other accounts.',
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF667C9B),
                          lineHeight: 1.5,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      32.verticalSpace,
                      GestureDetector(
                        onTap: _changePassword,
                        child: Container(
                          height: 52.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Update password',
                            style: getTextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.validator,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF172231),
          ),
        ),
        8.verticalSpace,
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF172231),
          ),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            filled: true,
            fillColor: const Color(0xFFF8FAFD),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 15.h,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF99A7B9),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Color(0xFFDCE5EF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
