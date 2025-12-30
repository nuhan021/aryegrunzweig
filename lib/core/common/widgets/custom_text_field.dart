import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final bool obscureText; // This will now be controlled by Obx
  final int maxLine;
  final TextInputType? inputType;
  final VoidCallback? onSuffixPressed; // Add this callback

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.maxLine = 1,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.onSuffixPressed, // Pass the toggle function here
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLine,
      keyboardType: inputType,
      style: getTextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),

        // Wrap the suffix icon in an IconButton to make it clickable
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: suffixIcon!,
          onPressed: onSuffixPressed,
        )
            : null,

        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        // ... (Keep your border styles as they are)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:  BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
