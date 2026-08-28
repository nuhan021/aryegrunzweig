import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../widgets/service_request_buttons.dart';

class ServiceRequestSuccessScreen extends StatelessWidget {
  const ServiceRequestSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Container(
                height: 64.w,
                width: 64.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 32.sp,
                ),
              ),
              20.verticalSpace,
              Text(
                'Your request has been sent',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              10.verticalSpace,
              Text(
                'Our team will review your request and send you a quotation. You will receive an email and app notification when it is ready.',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(flex: 4),
              SrPrimaryButton(
                text: 'Go to dashboard',
                onPressed: () =>
                    Get.find<AppBottomNavBarController>().jumpToScreen(0),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
