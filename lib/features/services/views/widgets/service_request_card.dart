import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/services_controller.dart';
import '../../data/service_request_models.dart';

class ServiceRequestCard extends StatelessWidget {
  const ServiceRequestCard({
    super.key,
    required this.request,
    required this.onAction,
    this.isLoading = false,
  });

  final ServiceRequest request;
  final VoidCallback onAction;
  final bool isLoading;

  String get _actionText => switch (request.api.status) {
    CustomerRequestStatus.newRequest => 'View request',
    CustomerRequestStatus.underReview => 'View review status',
    CustomerRequestStatus.quoteSent => 'Review quote',
    CustomerRequestStatus.accepted => 'Continue to payment',
    CustomerRequestStatus.scheduled => 'View appointment',
    CustomerRequestStatus.inProgress => 'View service progress',
    CustomerRequestStatus.reportSubmitted => 'View report status',
    CustomerRequestStatus.completed => 'View service report',
    CustomerRequestStatus.cancelled => 'View request',
  };

  bool get _isSolidAction =>
      request.api.status == CustomerRequestStatus.quoteSent ||
      request.api.status == CustomerRequestStatus.accepted;

  String get _metaLine {
    switch (request.status) {
      case ServiceRequestStatus.completed:
        return request.completedDate == null
            ? ''
            : 'Completed: ${DateFormat('MMMM d, yyyy').format(request.completedDate!)}';
      case ServiceRequestStatus.scheduled:
        return request.appointmentDate == null
            ? ''
            : '${DateFormat('EEEE, MMM d').format(request.appointmentDate!)} · ${request.appointmentTimeRange}';
      default:
        return 'Submitted: ${DateFormat('MMMM d, yyyy').format(request.submittedDate)}';
    }
  }

  String get _descriptionLine {
    switch (request.status) {
      case ServiceRequestStatus.completed:
        return '\$${request.finalAmount.toStringAsFixed(2)} charged';
      case ServiceRequestStatus.scheduled:
        return 'Technician: ${request.technicianName}';
      default:
        return request.issueDescription;
    }
  }

  @override
  Widget build(BuildContext context) {
    final badgeText = request.statusLabel;
    final isCompleted = request.status == ServiceRequestStatus.completed;

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 14.h),
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
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isCompleted ? Colors.green : AppColors.primary,
                  ),
                ),
                child: Text(
                  badgeText,
                  style: getTextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: isCompleted
                        ? Colors.green.shade700
                        : AppColors.primary,
                  ),
                ),
              ),
              Text(
                request.id,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            request.title,
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              textAlign: TextAlign.left,
            ),
          ),
          4.verticalSpace,
          Text(
            _metaLine,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              textAlign: TextAlign.left,
            ),
          ),
          2.verticalSpace,
          Text(
            _descriptionLine,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              textAlign: TextAlign.left,
            ),
          ),
          14.verticalSpace,
          GestureDetector(
            onTap: isLoading ? null : onAction,
            child: Container(
              height: 46.h,
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isSolidAction
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 20.w,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: _isSolidAction
                            ? Colors.white
                            : AppColors.primary,
                      ),
                    )
                  : Text(
                      _actionText,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: _isSolidAction
                            ? Colors.white
                            : AppColors.primary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
