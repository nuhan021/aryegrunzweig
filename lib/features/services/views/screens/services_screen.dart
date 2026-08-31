import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/services_controller.dart';
import '../../data/service_request_models.dart';
import '../widgets/service_request_card.dart';
import 'quote_details_screen.dart';
import 'service_appointment_screen.dart';
import 'service_complete_screen.dart';
import 'service_request_overview_screen.dart';
import 'service_payment_method_screen.dart';

class ServicesScreen extends StatelessWidget {
  ServicesScreen({super.key});

  final ServicesController controller = Get.find<ServicesController>();

  static const _tabs = ['Active', 'Scheduled', 'Completed'];

  Future<void> _openRequest(
    BuildContext context,
    ServiceRequest request,
  ) async {
    if (request.status == ServiceRequestStatus.underReview) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServiceRequestOverviewScreen(request: request),
        ),
      );
      return;
    }
    if (request.status == ServiceRequestStatus.quoteReady) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QuoteDetailsScreen(request: request)),
      );
      return;
    }
    if (controller.openingRequestIds.contains(request.api.id)) return;
    controller.openingRequestIds.add(request.api.id);
    final refreshed = await controller.refreshOne(request) ?? request;
    controller.openingRequestIds.remove(request.api.id);
    if (!context.mounted) return;
    if (refreshed.api.status == CustomerRequestStatus.accepted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServicePaymentMethodScreen(request: refreshed),
        ),
      );
      return;
    }
    switch (refreshed.status) {
      case ServiceRequestStatus.quoteReady:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuoteDetailsScreen(request: refreshed),
          ),
        );
        break;
      case ServiceRequestStatus.underReview:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceRequestOverviewScreen(request: refreshed),
          ),
        );
        break;
      case ServiceRequestStatus.scheduled:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceAppointmentScreen(request: refreshed),
          ),
        );
        break;
      case ServiceRequestStatus.completed:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceCompleteScreen(request: refreshed),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              isBack: false,
              title: 'My service requests',
              subtitle: 'View and track all your submitted service requests.',
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.loadRequests,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: List.generate(_tabs.length, (index) {
                              final isSelected =
                                  controller.selectedTabIndex.value == index;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.selectTab(index),
                                  child: Container(
                                    height: 40.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      _tabs[index],
                                      style: getTextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      20.verticalSpace,

                      Obx(() {
                        if (controller.isLoading.value &&
                            controller.requests.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (controller.errorMessage.value.isNotEmpty &&
                            controller.requests.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                Text(controller.errorMessage.value),
                                TextButton(
                                  onPressed: controller.loadRequests,
                                  child: const Text('Try again'),
                                ),
                              ],
                            ),
                          );
                        }
                        final requests = controller.filteredRequests;
                        if (requests.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: Center(
                              child: Text(
                                'No service requests here yet.',
                                style: getTextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: requests
                              .map(
                                (request) => ServiceRequestCard(
                                  request: request,
                                  isLoading: controller.openingRequestIds
                                      .contains(request.api.id),
                                  onAction: () =>
                                      _openRequest(context, request),
                                ),
                              )
                              .toList(),
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
}
