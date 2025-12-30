import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isShadow = false,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: isShadow
              ? [
            BoxShadow(
              color: const Color(0x1A000000),
              offset: Offset(0, 10.h),
              blurRadius: 15,
              spreadRadius: -3,
            ),
            BoxShadow(
              color: const Color(0x1A000000),
              offset: Offset(0, 4.h),
              blurRadius: 6,
              spreadRadius: -4,
            ),
          ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}