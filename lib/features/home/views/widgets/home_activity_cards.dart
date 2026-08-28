import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    this.filled = false,
  });

  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: filled ? color.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: filled ? null : Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: getTextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class QuoteReadyCard extends StatelessWidget {
  const QuoteReadyCard({
    super.key,
    required this.price,
    required this.expiresAt,
    required this.title,
    required this.requestId,
    required this.description,
  });

  final String price;
  final String expiresAt;
  final String title;
  final String requestId;
  final String description;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(label: 'QUOTE READY', color: AppColors.primary),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: getTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    expiresAt,
                    style: getTextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            title,
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              textAlign: TextAlign.left,
            ),
          ),
          4.verticalSpace,
          Text(
            requestId,
            style: getTextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              textAlign: TextAlign.left,
            ),
          ),
          8.verticalSpace,
          Text(
            description,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
              textAlign: TextAlign.left,
            ),
          ),
          14.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _SolidButton(
                  text: 'Review quote',
                  onPressed: () =>
                      Get.find<AppBottomNavBarController>().jumpToScreen(3),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: _OutlineButton(
                  text: 'View request',
                  onPressed: () =>
                      Get.find<AppBottomNavBarController>().jumpToScreen(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScheduledCard extends StatelessWidget {
  const ScheduledCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.technicianName,
  });

  final String title;
  final String dateTime;
  final String technicianName;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
                size: 16.sp,
              ),
              8.horizontalSpace,
              _StatusBadge(label: 'SCHEDULED', color: AppColors.primary),
            ],
          ),
          10.verticalSpace,
          Text(
            title,
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              textAlign: TextAlign.left,
            ),
          ),
          4.verticalSpace,
          Text(
            dateTime,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              textAlign: TextAlign.left,
            ),
          ),
          2.verticalSpace,
          Text(
            technicianName,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
              textAlign: TextAlign.left,
            ),
          ),
          14.verticalSpace,
          _SoftButton(
            text: 'View appointment',
            onPressed: () =>
                Get.find<AppBottomNavBarController>().jumpToScreen(3),
          ),
        ],
      ),
    );
  }
}

class ShippedCard extends StatelessWidget {
  const ShippedCard({
    super.key,
    required this.orderId,
    required this.title,
    required this.trackingNumber,
  });

  final String orderId;
  final String title;
  final String trackingNumber;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: green, size: 16.sp),
              8.horizontalSpace,
              _StatusBadge(label: 'SHIPPED', color: green, filled: true),
              8.horizontalSpace,
              Text(
                orderId,
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            title,
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              textAlign: TextAlign.left,
            ),
          ),
          4.verticalSpace,
          Text(
            trackingNumber,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              textAlign: TextAlign.left,
            ),
          ),
          14.verticalSpace,
          _SoftButton(
            text: 'Track package',
            onPressed: () =>
                Get.find<AppBottomNavBarController>().jumpToScreen(3),
          ),
        ],
      ),
    );
  }
}

class _SolidButton extends StatelessWidget {
  const _SolidButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _SoftButton extends StatelessWidget {
  const _SoftButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44.h,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
