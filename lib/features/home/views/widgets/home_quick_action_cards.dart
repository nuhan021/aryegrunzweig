import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';

class HomeQuickActionCards extends StatelessWidget {
  const HomeQuickActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.headset_mic_outlined,
            iconColor: Colors.white,
            iconBackgroundColor: Colors.white.withOpacity(0.2),
            backgroundColor: AppColors.primary,
            title: 'Book a service?',
            titleColor: Colors.white,
            subtitle: 'Get a quote from our team',
            subtitleColor: Colors.white.withOpacity(0.8),
            onTap: () =>
                Get.find<AppBottomNavBarController>().jumpToScreen(1),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: _ActionCard(
            icon: Icons.shopping_bag_outlined,
            iconColor: Colors.grey.shade700,
            iconBackgroundColor: Colors.grey.shade300,
            backgroundColor: Colors.grey.shade100,
            title: 'Shop products',
            titleColor: Colors.black,
            subtitle: 'Hoses, tools & more',
            subtitleColor: Colors.grey.shade600,
            onTap: () =>
                Get.find<AppBottomNavBarController>().jumpToScreen(2),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.backgroundColor,
    required this.title,
    required this.titleColor,
    required this.subtitle,
    required this.subtitleColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color backgroundColor;
  final String title;
  final Color titleColor;
  final String subtitle;
  final Color subtitleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 36.w,
              width: 36.w,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            12.verticalSpace,
            Text(
              title,
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: titleColor,
                textAlign: TextAlign.left,
              ),
            ),
            4.verticalSpace,
            Text(
              subtitle,
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: subtitleColor,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
