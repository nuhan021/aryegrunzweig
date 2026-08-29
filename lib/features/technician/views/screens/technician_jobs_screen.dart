import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../controller/technician_jobs_controller.dart';
import 'technician_job_details_screen.dart';
import 'technician_service_report_screen.dart';

class TechnicianJobsScreen extends StatefulWidget {
  const TechnicianJobsScreen({super.key});

  @override
  State<TechnicianJobsScreen> createState() => _TechnicianJobsScreenState();
}

class _TechnicianJobsScreenState extends State<TechnicianJobsScreen> {
  int _selectedTab = 0;

  late final TechnicianJobsController _jobsController =
      Get.isRegistered<TechnicianJobsController>()
      ? Get.find<TechnicianJobsController>()
      : Get.put(TechnicianJobsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _JobsHeader(onBack: _goHome),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 30.h, 16.w, 30.h),
                child: Column(
                  children: [
                    _JobTabs(
                      selectedIndex: _selectedTab,
                      onSelected: (index) =>
                          setState(() => _selectedTab = index),
                    ),
                    28.verticalSpace,
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: KeyedSubtree(
                        key: ValueKey(_selectedTab),
                        child: switch (_selectedTab) {
                          0 => _buildTodayJobs(),
                          1 => _buildUpcomingJobs(),
                          _ => _buildCompletedJobs(),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayJobs() {
    return Column(
      children: [
        Obx(() {
          final status = _jobsController.status.value;
          return _JobCard(
            status: status == TechnicianJobStatus.completed
                ? 'COMPLETED'
                : 'In Progress',
            statusKind: status == TechnicianJobStatus.completed
                ? _StatusKind.completed
                : _StatusKind.inProgress,
            time: '9:00 AM',
            customer: _jobsController.job.customerName,
            service: _jobsController.job.serviceName,
            address: _jobsController.job.address,
            issue:
                'Unit turns on but there is very low suction throughout the home.',
            primaryLabel: 'Open Job',
            secondaryLabel: 'Update Report',
            onPrimary: _openSarahJob,
            onSecondary: _openSarahReport,
          );
        }),
        14.verticalSpace,
        _JobCard(
          status: 'SCHEDULED',
          statusKind: _StatusKind.scheduled,
          time: '12:30 PM',
          customer: 'David Chen',
          service: 'Low Suction',
          address: '55 Park Avenue, Montréal',
          issue:
              'Customer reports low suction on the first floor and basement.',
          primaryLabel: 'View details',
          onPrimary: () => _showUnavailable('David Chen'),
        ),
        14.verticalSpace,
        _JobCard(
          status: 'SCHEDULED',
          statusKind: _StatusKind.scheduled,
          time: '03:30 PM',
          customer: 'Amelia Roberts',
          service: 'Broken Inlet Valve',
          address: '909 Rue Sherbrooke O., Montréal',
          issue:
              'Inlet valve in the living room is cracked and no longer seals properly.',
          primaryLabel: 'View details',
          onPrimary: () => _showUnavailable('Amelia Roberts'),
        ),
      ],
    );
  }

  Widget _buildUpcomingJobs() {
    return _JobCard(
      status: 'SCHEDULED',
      statusKind: _StatusKind.scheduled,
      time: '12:30 PM',
      customer: 'David Chen',
      service: 'Low Suction',
      address: '55 Park Avenue, Montréal',
      issue: 'Customer reports low suction on the first floor and basement.',
      primaryLabel: 'View details',
      onPrimary: () => _showUnavailable('David Chen'),
    );
  }

  Widget _buildCompletedJobs() {
    return _JobCard(
      status: 'COMPLETED',
      statusKind: _StatusKind.completed,
      jobId: 'SR-1047',
      customer: 'John Miller',
      service: 'Retractable Hose Repair',
      dateAndTime: 'Wednesday, July 30 · 2:00 PM',
      address: '77 Lakeshore Dr., Pointe-Claire',
      issue: 'Repaired hose retraction mechanism.',
      primaryLabel: 'View details',
      secondaryLabel: 'View Report',
      subduedActions: true,
      onPrimary: () => _showUnavailable('John Miller'),
      onSecondary: () => _showMessage(
        'The completed report for SR-1047 is not available yet.',
      ),
    );
  }

  void _goHome() {
    if (Get.isRegistered<AppBottomNavBarController>()) {
      Get.find<AppBottomNavBarController>().jumpToScreen(0);
    }
  }

  void _openSarahJob() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TechnicianJobDetailsScreen(controller: _jobsController),
      ),
    );
  }

  void _openSarahReport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            TechnicianServiceReportScreen(controller: _jobsController),
      ),
    );
  }

  void _showUnavailable(String customer) {
    _showMessage('$customer job details are not available yet.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _JobsHeader extends StatelessWidget {
  const _JobsHeader({required this.onBack});

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
            'My Jobs',
            style: getTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              textAlign: TextAlign.left,
            ),
          ),
          9.verticalSpace,
          Text(
            'View and manage all your scheduled and\ncompleted jobs.',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
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

class _JobTabs extends StatelessWidget {
  const _JobTabs({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const labels = ['Today', 'Upcoming', 'Completed'];
    return Container(
      height: 46.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.white,
                  border: index == 1 && !selected
                      ? const Border.symmetric(
                          vertical: BorderSide(color: Color(0xFFE4E4E4)),
                        )
                      : null,
                ),
                child: Text(
                  labels[index],
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: selected ? Colors.white : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

enum _StatusKind { inProgress, scheduled, completed }

class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.status,
    required this.statusKind,
    required this.customer,
    required this.service,
    required this.address,
    required this.issue,
    required this.primaryLabel,
    required this.onPrimary,
    this.time,
    this.jobId,
    this.dateAndTime,
    this.secondaryLabel,
    this.onSecondary,
    this.subduedActions = false,
  });

  final String status;
  final _StatusKind statusKind;
  final String customer;
  final String service;
  final String address;
  final String issue;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? time;
  final String? jobId;
  final String? dateAndTime;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool subduedActions;

  @override
  Widget build(BuildContext context) {
    final badgeColors = switch (statusKind) {
      _StatusKind.inProgress => (
        const Color(0xFFFFF6D8),
        const Color(0xFFD97900),
        const Color(0xFFFFD262),
      ),
      _StatusKind.scheduled => (
        const Color(0xFFF1F7FF),
        AppColors.primary,
        AppColors.primary,
      ),
      _StatusKind.completed => (
        const Color(0xFFEAFBF4),
        const Color(0xFF15B879),
        const Color(0xFFEAFBF4),
      ),
    };

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE6E6E6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: badgeColors.$1,
                  borderRadius: BorderRadius.circular(7.r),
                  border: Border.all(color: badgeColors.$3),
                ),
                child: Text(
                  status,
                  style: getTextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: badgeColors.$2,
                  ),
                ),
              ),
              const Spacer(),
              if (time != null)
                Text(
                  time!,
                  style: getTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                )
              else if (jobId != null)
                Text(
                  jobId!,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFA4AEC0),
                  ),
                ),
            ],
          ),
          10.verticalSpace,
          Text(
            customer,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF172231),
              textAlign: TextAlign.left,
            ),
          ),
          7.verticalSpace,
          Text(
            service,
            style: getTextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF9AACC8),
              textAlign: TextAlign.left,
            ),
          ),
          if (dateAndTime != null) ...[
            5.verticalSpace,
            Text(
              dateAndTime!,
              style: getTextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF7489A9),
                textAlign: TextAlign.left,
              ),
            ),
          ],
          5.verticalSpace,
          Text(
            address,
            style: getTextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF7489A9),
              textAlign: TextAlign.left,
            ),
          ),
          12.verticalSpace,
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F6FD),
              borderRadius: BorderRadius.circular(7.r),
            ),
            child: Text(
              issue,
              style: getTextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF7186A6),
                lineHeight: 1.45,
                textAlign: TextAlign.left,
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          12.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _CardAction(
                  label: primaryLabel,
                  onTap: onPrimary,
                  primary: !subduedActions,
                  subdued: subduedActions,
                ),
              ),
              if (secondaryLabel != null) ...[
                14.horizontalSpace,
                Expanded(
                  child: _CardAction(
                    label: secondaryLabel!,
                    onTap: onSecondary!,
                    subdued: subduedActions,
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

class _CardAction extends StatelessWidget {
  const _CardAction({
    required this.label,
    required this.onTap,
    this.primary = false,
    this.subdued = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;
  final bool subdued;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary ? AppColors.primary : Colors.white,
          foregroundColor: primary
              ? Colors.white
              : subdued
              ? const Color(0xFFA4AEC0)
              : AppColors.primary,
          side: BorderSide(
            color: primary
                ? AppColors.primary
                : subdued
                ? const Color(0xFFDDE5EF)
                : const Color(0xFFD8E2F0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getTextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: primary
                ? Colors.white
                : subdued
                ? const Color(0xFFA4AEC0)
                : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
