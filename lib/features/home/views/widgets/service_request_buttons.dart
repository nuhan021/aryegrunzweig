import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';

class SrPrimaryButton extends StatelessWidget {
  const SrPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading;
    return GestureDetector(
      onTap: canPress ? onPressed : null,
      child: Container(
        height: 50.h,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: canPress
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: isLoading
            ? SizedBox(
                height: 21.w,
                width: 21.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class SrOutlineButton extends StatelessWidget {
  const SrOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading;
    return GestureDetector(
      onTap: canPress ? onPressed : null,
      child: Container(
        height: 50.h,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: isLoading
            ? SizedBox(
                height: 21.w,
                width: 21.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: AppColors.primary,
                ),
              )
            : Text(
                text,
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
      ),
    );
  }
}
