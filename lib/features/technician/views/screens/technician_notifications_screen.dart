import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../controller/technician_jobs_controller.dart';
import 'technician_job_details_screen.dart';

class TechnicianNotificationsScreen extends StatelessWidget {
  const TechnicianNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobsController = Get.isRegistered<TechnicianJobsController>()
        ? Get.find<TechnicianJobsController>()
        : Get.put(TechnicianJobsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _NotificationsHeader(onBack: _goHome),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 30.h),
                itemCount: 4,
                separatorBuilder: (_, _) => 12.verticalSpace,
                itemBuilder: (context, index) => _NotificationCard(
                  onViewJob: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TechnicianJobDetailsScreen(
                        controller: jobsController,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goHome() {
    if (Get.isRegistered<AppBottomNavBarController>()) {
      Get.find<AppBottomNavBarController>().jumpToScreen(0);
    }
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, color: Colors.white, size: 22.sp),
                  4.horizontalSpace,
                  Text(
                    'Back',
                    style: getTextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          16.verticalSpace,
          Text(
            'Notifications',
            style: getTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              textAlign: TextAlign.left,
            ),
          ),
          9.verticalSpace,
          Text(
            'Stay informed about updates to your jobs,\nrequests, and account.',
            style: getTextStyle(
              fontSize: 13.sp,
              color: Colors.white.withValues(alpha: .82),
              lineHeight: 1.35,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.onViewJob});

  final VoidCallback onViewJob;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE6E6E6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            margin: EdgeInsets.only(top: 5.h),
            decoration: const BoxDecoration(
              color: Color(0xFF1457AF),
              shape: BoxShape.circle,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Amelia Roberts',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF172231),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      '2m ago',
                      style: getTextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF7186A6),
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Text(
                  'Sarah Thompson - August 1 at 9:00 AM',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF7186A6),
                    textAlign: TextAlign.left,
                  ),
                ),
                14.verticalSpace,
                Material(
                  color: const Color(0xFFF0F6FD),
                  borderRadius: BorderRadius.circular(8.r),
                  child: InkWell(
                    onTap: onViewJob,
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 9.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View job',
                            style: getTextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1457AF),
                            ),
                          ),
                          7.horizontalSpace,
                          Icon(
                            Icons.chevron_right,
                            size: 18.sp,
                            color: const Color(0xFF1457AF),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
