import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/technician_jobs_controller.dart';
import '../../controller/technician_equipment_controller.dart';
import 'technician_equipment_screen.dart';
import 'technician_job_photos_screen.dart';
import 'technician_service_report_screen.dart';

class TechnicianJobDetailsScreen extends StatelessWidget {
  const TechnicianJobDetailsScreen({super.key, required this.controller});

  final TechnicianJobsController controller;

  @override
  Widget build(BuildContext context) {
    final job = controller.job;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              _JobHeader(controller: controller),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 28.h),
                  child: Column(
                    children: [
                      _SectionCard(
                        title: 'Customer Details',
                        children: [
                          _DataRow('Customer', job.customerName),
                          _DataRow('Phone', job.phone),
                          _DataRow('Email', job.email),
                          _DataRow('Address', job.address, isLast: true),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 12.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _SmallAction(
                                    text: 'Call customer',
                                    isPrimary: true,
                                    onTap: () => _showMessage(
                                      context,
                                      'Calling ${job.phone}',
                                    ),
                                  ),
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: _SmallAction(
                                    text: 'Get directions',
                                    onTap: () => _showMessage(
                                      context,
                                      'Opening directions to ${job.address}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      _SectionCard(
                        title: 'Service Details',
                        children: [
                          _DataRow('Service type', job.serviceName),
                          _DataRow('Requested date', job.requestedDate),
                          _DataRow('Appointment time', job.appointmentTime),
                          _DataRow('Est. duration', job.estimatedDuration),
                          _DataRow(
                            'Previous visit',
                            job.previousVisit,
                            isLast: true,
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer-Reported Issue',
                              style: getTextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              job.issueTitle,
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF172231),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              '"${job.issueDescription}"',
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary,
                                lineHeight: 1.5,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            12.verticalSpace,
                            Row(
                              children: List.generate(
                                3,
                                (index) => Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: index == 2 ? 0 : 8.w,
                                    ),
                                    child: const _PhotoPlaceholder(
                                      label: 'Issue photo',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Technician Actions',
                              style: getTextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF172231),
                              ),
                            ),
                            if (controller.status.value ==
                                TechnicianJobStatus.inProgress) ...[
                              12.verticalSpace,
                              Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 11.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAFBF4),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: const Color(0xFF32D296),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16.sp,
                                      color: const Color(0xFF1DAA75),
                                    ),
                                    8.horizontalSpace,
                                    Text(
                                      'Status updated to In Progress',
                                      style: getTextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF147A59),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            12.verticalSpace,
                            _LargeAction(
                              text:
                                  controller.status.value ==
                                      TechnicianJobStatus.inProgress
                                  ? 'Job is in progress'
                                  : controller.status.value ==
                                        TechnicianJobStatus.reportSubmitted
                                  ? 'Report submitted'
                                  : 'Mark as in progress',
                              isPrimary: true,
                              onTap: controller.markInProgress,
                            ),
                            10.verticalSpace,
                            _LargeAction(
                              text: 'Upload before / After photos',
                              onTap: () => _push(
                                context,
                                const TechnicianJobPhotosScreen(),
                              ),
                            ),
                            10.verticalSpace,
                            _LargeAction(
                              text: 'Add technician notes',
                              onTap: () => _addNotes(context),
                            ),
                            10.verticalSpace,
                            _LargeAction(
                              text: 'Open equipment & inlet details',
                              onTap: () {
                                Get.find<TechnicianEquipmentController>()
                                    .loadEquipment();
                                _push(
                                  context,
                                  const TechnicianEquipmentScreen(),
                                );
                              },
                            ),
                            10.verticalSpace,
                            _LargeAction(
                              text: 'Complete service report',
                              onTap: () => _push(
                                context,
                                TechnicianServiceReportScreen(
                                  controller: controller,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _addNotes(BuildContext context) async {
    final notesController = TextEditingController(
      text: controller.technicianNotes.value,
    );
    final notes = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Technician notes'),
        content: TextField(
          controller: notesController,
          minLines: 4,
          maxLines: 7,
          decoration: const InputDecoration(
            hintText: 'Add diagnosis, observations, or follow-up notes.',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, notesController.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    notesController.dispose();
    if (notes == null) return;
    final saved = await controller.updateNotes(notes);
    if (saved && context.mounted) {
      _showMessage(context, 'Technician notes saved.');
    }
  }
}

class _JobHeader extends StatelessWidget {
  const _JobHeader({required this.controller});

  final TechnicianJobsController controller;

  @override
  Widget build(BuildContext context) {
    final status = controller.status.value;
    final statusText = switch (status) {
      TechnicianJobStatus.assigned => 'ASSIGNED',
      TechnicianJobStatus.inProgress => 'IN PROGRESS',
      TechnicianJobStatus.reportSubmitted => 'REPORT SUBMITTED',
      TechnicianJobStatus.completed => 'COMPLETED',
    };

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 22.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, color: Colors.white, size: 22.sp),
                Text(
                  'Back',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          18.verticalSpace,
          Text(
            'Job #${controller.job.id}',
            style: getTextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          8.verticalSpace,
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: status == TechnicianJobStatus.completed
                      ? const Color(0xFFE8F8F0)
                      : const Color(0xFFFFF3C4),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  statusText,
                  style: getTextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: status == TechnicianJobStatus.completed
                        ? const Color(0xFF22A866)
                        : const Color(0xFFD58A00),
                  ),
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  controller.job.serviceName,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    textAlign: TextAlign.left,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Text(
              title,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF172231),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow(this.label, this.value, {this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF667C9B),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF172231),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFDCE5EF), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 24.sp,
            color: const Color(0xFF92A7C5),
          ),
          5.verticalSpace,
          Text(
            label,
            style: getTextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF667C9B),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.text,
    required this.onTap,
    this.isPrimary = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _LargeAction extends StatelessWidget {
  const _LargeAction({
    required this.text,
    required this.onTap,
    this.isPrimary = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
