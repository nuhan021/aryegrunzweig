import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/services_controller.dart';
import '../../data/service_request_models.dart';

class ServiceRequestOverviewScreen extends StatelessWidget {
  const ServiceRequestOverviewScreen({super.key, required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Service request',
              subtitle: 'Review the details submitted to Central Care.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatusBadge(label: request.statusLabel),
                        Text(
                          request.id,
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    _DetailsCard(
                      rows: [
                        ('Service', request.title),
                        ('Requested by', request.requestedByName),
                        (
                          'Submitted',
                          DateFormat(
                            'MMMM d, yyyy',
                          ).format(request.submittedDate),
                        ),
                        ('Address', request.address),
                      ],
                    ),
                    20.verticalSpace,
                    Text(
                      'Issue details',
                      style: getTextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF172231),
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFD),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFDCE5EF)),
                      ),
                      child: Text(
                        request.issueDescription,
                        style: getTextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF667C9B),
                          lineHeight: 1.5,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    if (request.api.status !=
                            CustomerRequestStatus.inProgress &&
                        request.api.status !=
                            CustomerRequestStatus.reportSubmitted &&
                        request.api.status != CustomerRequestStatus.completed &&
                        request.api.status != CustomerRequestStatus.cancelled)
                      20.verticalSpace,
                    if (request.api.status !=
                            CustomerRequestStatus.inProgress &&
                        request.api.status !=
                            CustomerRequestStatus.reportSubmitted &&
                        request.api.status != CustomerRequestStatus.completed &&
                        request.api.status != CustomerRequestStatus.cancelled)
                      OutlinedButton(
                        onPressed: () => _cancel(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48.h),
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Cancel service request'),
                      ),
                    20.verticalSpace,
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        request.status == ServiceRequestStatus.underReview
                            ? 'Our team is reviewing your request. You will receive a notification when your quotation is ready.'
                            : 'Your appointment details are shown in the Scheduled tab.',
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          lineHeight: 1.5,
                          textAlign: TextAlign.left,
                        ),
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

  Future<void> _cancel(BuildContext context) async {
    final reasonController = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel service request'),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Why are you cancelling?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep request'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, reasonController.text.trim()),
            child: const Text('Cancel request'),
          ),
        ],
      ),
    );
    reasonController.dispose();
    if (reason == null || reason.isEmpty || !context.mounted) return;
    final success = await Get.find<ServicesController>().cancel(
      request,
      reason,
    );
    if (success && context.mounted) Navigator.pop(context);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: Text(
        label,
        style: getTextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.rows});

  final List<(String, String)> rows;

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
        children: rows.asMap().entries.map((entry) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            decoration: BoxDecoration(
              border: entry.key == rows.length - 1
                  ? null
                  : Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    entry.value.$1,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF667C9B),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.value.$2,
                    textAlign: TextAlign.right,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF172231),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
