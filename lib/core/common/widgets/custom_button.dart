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
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isShadow;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading;
    return GestureDetector(
      onTap: canPress ? onPressed : null,
      child: Container(
        height: 48.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: canPress
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.7),
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
        child: isLoading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
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
