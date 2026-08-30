import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../home/views/screens/select_issue_screen.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../controller/services_controller.dart';

class ServiceCompleteScreen extends StatelessWidget {
  const ServiceCompleteScreen({super.key, required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServicesController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20.w,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Back',
                        style: getTextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Your service is complete',
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'COMPLETED',
                          style: getTextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Text(
                    'Your request has been completed successfully.',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoCard(
                      rows: [
                        ('Service', request.title),
                        (
                          'Completed',
                          request.completedDate == null
                              ? '-'
                              : DateFormat(
                                  'MMMM d, yyyy',
                                ).format(request.completedDate!),
                        ),
                        (
                          'Final amount',
                          '\$${request.finalAmount.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                    16.verticalSpace,

                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '"${request.completionNote}"',
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          lineHeight: 1.5,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    16.verticalSpace,

                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(14.r),
                                topRight: Radius.circular(14.r),
                              ),
                            ),
                            child: Text(
                              'Service Record',
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          _InfoRow('Technician', request.technicianName),
                          _InfoRow('Parts used', request.partsUsed),
                          _InfoRow(
                            'Before/after photos',
                            '${request.photosCount} photos',
                          ),
                          _InfoRow(
                            'Payment',
                            request.paymentMethodText,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    24.verticalSpace,

                    if (request.api.report?.customerConfirmedAt == null)
                      SrPrimaryButton(
                        text: 'Confirm completed service report',
                        onPressed: () async {
                          await controller.confirmReport(request);
                        },
                      ),
                    if (request.api.report?.customerConfirmedAt == null)
                      10.verticalSpace,

                    SrOutlineButton(
                      text: 'View service report',
                      onPressed: () => _showServiceReport(context),
                    ),
                    10.verticalSpace,
                    SrOutlineButton(
                      text: 'Download receipt',
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Receipt download has started.'),
                            ),
                          ),
                    ),
                    16.verticalSpace,
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SelectIssueScreen(),
                          ),
                        ),
                        child: Text(
                          'Request another service',
                          style: getTextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ).copyWith(decoration: TextDecoration.underline),
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

  void _showServiceReport(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service report',
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              16.verticalSpace,
              Text(
                request.completionNote,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade700,
                  lineHeight: 1.5,
                  textAlign: TextAlign.left,
                ),
              ),
              16.verticalSpace,
              _InfoRow('Technician', request.technicianName),
              _InfoRow('Parts used', request.partsUsed),
              _InfoRow(
                'Before/after photos',
                '${request.photosCount} photos',
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          return _InfoRow(
            entry.value.$1,
            entry.value.$2,
            isLast: entry.key == rows.length - 1,
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.isLast = false});

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
