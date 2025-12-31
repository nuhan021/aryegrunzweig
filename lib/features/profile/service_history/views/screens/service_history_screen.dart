import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import '../../controllers/service_history_controller.dart';
import '../../widgets/service_card.dart';

class ServiceHistoryScreen extends StatelessWidget {
  const ServiceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServiceHistoryController());

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Service History',
      //         style: getTextStyle(
      //           color: Colors.white,
      //           fontSize: 16.sp,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //       Text(
      //         'Review all your past service bookings',
      //         style: getTextStyle(
      //           color: Colors.white,
      //           fontSize: 12.sp,
      //           fontWeight: FontWeight.w400,
      //         ),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: AppColors.primary,
      //   elevation: 0,
      //   automaticallyImplyLeading: true,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Service History',
              subtitle: 'Review all your past service bookings',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Obx(
                    () => controller.services.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.h),
                              child: Text(
                                'No service history available',
                                style: getTextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF697282),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: List.generate(
                              controller.services.length,
                              (index) {
                                final service = controller.services[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: ServiceCard(service: service),
                                );
                              },
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
}
