import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../notifications/controllers/notifications_controller.dart';
import '../../controller/technician_jobs_controller.dart';
import 'technician_job_details_screen.dart';
import 'technician_service_report_screen.dart';

class TechnicianHomeScreen extends StatelessWidget {
  const TechnicianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<TechnicianJobsController>()
        ? Get.find<TechnicianJobsController>()
        : Get.put(TechnicianJobsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _DashboardHeader(controller: controller),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.loadDashboard,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final stats = controller.homeStats.value;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    value: '${stats?.jobsToday ?? 0}',
                                    label: 'Jobs today',
                                    icon: Icons.work_outline_rounded,
                                    backgroundColor: Color(0xFFEDF5FF),
                                    accentColor: Color(0xFF174EA6),
                                  ),
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: _StatCard(
                                    value: '${stats?.inProgress ?? 0}',
                                    label: 'In progress',
                                    icon: Icons.query_stats_rounded,
                                    backgroundColor: const Color(0xFFFFFAE9),
                                    accentColor: const Color(0xFFE28700),
                                  ),
                                ),
                              ],
                            ),
                            12.verticalSpace,
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    value: '${stats?.completedThisMonth ?? 0}',
                                    label: 'Completed this month',
                                    icon: Icons.checklist_rounded,
                                    backgroundColor: const Color(0xFFECFBF5),
                                    accentColor: const Color(0xFF0B9E72),
                                  ),
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: _StatCard(
                                    value: '${stats?.averageRating ?? 0}',
                                    label: 'Avg. customer rating',
                                    icon: Icons.star_outline_rounded,
                                    backgroundColor: Color(0xFFEDF5FF),
                                    accentColor: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                      28.verticalSpace,
                      Text(
                        "Today's Jobs",
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF172231),
                        ),
                      ),
                      16.verticalSpace,
                      Obx(() {
                        final jobs = controller.todayJobs;
                        if (controller.isLoading.value && jobs.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (jobs.isEmpty) return const Text('No jobs today.');
                        return Column(
                          children: [
                            for (
                              var index = 0;
                              index < jobs.length;
                              index++
                            ) ...[
                              _dashboardJob(context, controller, jobs[index]),
                              if (index < jobs.length - 1) 14.verticalSpace,
                            ],
                          ],
                        );
                      }),
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

  Widget _dashboardJob(
    BuildContext context,
    TechnicianJobsController controller,
    TechnicianJob job,
  ) {
    final status = switch (job.uiStatus) {
      TechnicianJobStatus.assigned => 'SCHEDULED',
      TechnicianJobStatus.inProgress => 'IN PROGRESS',
      TechnicianJobStatus.reportSubmitted => 'REPORT SUBMITTED',
      TechnicianJobStatus.completed => 'COMPLETED',
    };
    return _TodayJobCard(
      status: status,
      time: job.appointmentTime,
      customer: job.customerName,
      service: job.serviceName,
      address: job.address,
      issue: job.issueDescription,
      primaryAction: 'Open Job',
      secondaryAction:
          job.uiStatus == TechnicianJobStatus.inProgress ||
              job.uiStatus == TechnicianJobStatus.reportSubmitted
          ? 'Update Report'
          : null,
      onPrimary: () {
        controller.selectJob(job);
        _openJob(context, controller);
      },
      onSecondary:
          job.uiStatus == TechnicianJobStatus.inProgress ||
              job.uiStatus == TechnicianJobStatus.reportSubmitted
          ? () {
              controller.selectJob(job);
              _openReport(context, controller);
            }
          : null,
    );
  }

  void _openJob(BuildContext context, TechnicianJobsController controller) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TechnicianJobDetailsScreen(controller: controller),
      ),
    );
  }

  void _openReport(BuildContext context, TechnicianJobsController controller) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TechnicianServiceReportScreen(controller: controller),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.controller});

  final TechnicianJobsController controller;

  @override
  Widget build(BuildContext context) {
    final notifications = Get.find<NotificationsController>();
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.homeStats.value?.date ?? '',
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                5.verticalSpace,
                Obx(
                  () => Text(
                    'Good Morning, ${controller.homeStats.value?.firstName ?? ''}',
                    style: getTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 28.sp,
              ),
              Positioned(
                top: -1.h,
                right: 0,
                child: Obx(
                  () => notifications.unreadCount == 0
                      ? const SizedBox.shrink()
                      : Container(
                          height: 8.w,
                          width: 8.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3B45),
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 34.w,
            width: 34.w,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 19.sp, color: Colors.white),
          ),
          9.horizontalSpace,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: getTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF667C9B),
                    textAlign: TextAlign.left,
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

class _TodayJobCard extends StatelessWidget {
  const _TodayJobCard({
    required this.status,
    required this.time,
    required this.customer,
    required this.service,
    required this.address,
    required this.issue,
    required this.primaryAction,
    required this.onPrimary,
    this.secondaryAction,
    this.onSecondary,
  });

  final String status;
  final String time;
  final String customer;
  final String service;
  final String address;
  final String issue;
  final String primaryAction;
  final VoidCallback onPrimary;
  final String? secondaryAction;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final inProgress = status.toLowerCase().contains('progress');
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: inProgress
                      ? const Color(0xFFFFF4CE)
                      : const Color(0xFFF2F7FD),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: inProgress
                        ? const Color(0xFFFFD65A)
                        : AppColors.primary,
                  ),
                ),
                child: Text(
                  status,
                  style: getTextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: inProgress
                        ? const Color(0xFFD48500)
                        : AppColors.primary,
                  ),
                ),
              ),
              Text(
                time,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            customer,
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF172231),
            ),
          ),
          4.verticalSpace,
          Text(
            service,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF92A7C5),
            ),
          ),
          4.verticalSpace,
          Text(
            address,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF667C9B),
              textAlign: TextAlign.left,
            ),
          ),
          12.verticalSpace,
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F6FD),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Text(
              issue,
              style: getTextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF667C9B),
                lineHeight: 1.4,
                textAlign: TextAlign.left,
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          12.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _DashboardAction(
                  label: primaryAction,
                  onTap: onPrimary,
                  isPrimary: true,
                ),
              ),
              if (secondaryAction != null && onSecondary != null) ...[
                12.horizontalSpace,
                Expanded(
                  child: _DashboardAction(
                    label: secondaryAction!,
                    onTap: onSecondary!,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardAction extends StatelessWidget {
  const _DashboardAction({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          label,
          style: getTextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: isPrimary ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
