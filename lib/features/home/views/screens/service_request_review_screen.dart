import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/home/views/screens/service_request_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../controller/home_controller.dart';
import '../widgets/service_request_buttons.dart';

class ServiceRequestReviewScreen extends StatelessWidget {
  ServiceRequestReviewScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  String _attachmentsSummary() {
    final photos = controller.srImages.length;
    final videos = controller.srVideos.length;
    if (photos == 0 && videos == 0) return 'None';
    final parts = <String>[];
    if (photos > 0) parts.add('$photos photo${photos > 1 ? 's' : ''}');
    if (videos > 0) parts.add('$videos video${videos > 1 ? 's' : ''}');
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Review your request',
              subtitle: 'Please check the details below before submitting.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Obx(() {
                  final date = controller.srPreferredDate.value;
                  return Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request Summary',
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        14.verticalSpace,
                        Divider(color: Colors.grey.shade200, height: 1),
                        14.verticalSpace,
                        _SummaryRow(
                          label: 'Service type',
                          value: controller.srSelectedIssue.value,
                        ),
                        _SummaryRow(
                          label: 'Address',
                          value: controller.srAddressController.text,
                        ),
                        _SummaryRow(
                          label: 'Preferred date',
                          value: date == null
                              ? 'Not specified'
                              : DateFormat('EEEE, MMMM d').format(date),
                        ),
                        _SummaryRow(
                          label: 'Preferred time',
                          value: controller.srPreferredTime.value.isEmpty
                              ? 'Not specified'
                              : controller.srPreferredTime.value,
                        ),
                        _SummaryRow(
                          label: 'Issue summary',
                          value: controller.srDescriptionController.text.isEmpty
                              ? 'Not provided'
                              : controller.srDescriptionController.text,
                        ),
                        _SummaryRow(
                          label: 'Attachments',
                          value: _attachmentsSummary(),
                          isLast: true,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SrPrimaryButton(
                text: 'Submit service request',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ServiceRequestSuccessScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
