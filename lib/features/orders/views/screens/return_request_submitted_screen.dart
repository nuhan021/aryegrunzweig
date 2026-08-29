import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';

class ReturnRequestSubmittedScreen extends StatelessWidget {
  const ReturnRequestSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 28.h),
          child: Column(
            children: [
              const Spacer(flex: 4),
              Container(
                height: 82.w,
                width: 82.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3FD),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.check, color: AppColors.primary, size: 42.sp),
              ),
              26.verticalSpace,
              Text(
                'Return request submitted',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              22.verticalSpace,
              Text(
                'Our team will review your request and contact\nyou within 1–2 business days.',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF667C9B),
                  lineHeight: 1.6,
                ),
              ),
              14.verticalSpace,
              Text(
                'Do not ship the item until you receive approval\nfrom Central Care.',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF667C9B),
                  lineHeight: 1.6,
                ),
              ),
              const Spacer(flex: 5),
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: Container(
                  height: 56.h,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Back to orders',
                    style: getTextStyle(
                      fontSize: 16.sp,
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
    );
  }
}
