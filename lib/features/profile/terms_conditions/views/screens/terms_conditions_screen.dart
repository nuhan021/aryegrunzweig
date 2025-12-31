import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/terms_privacy_controller.dart';
import '../../widgets/legal_tab_bar.dart';
import '../../widgets/legal_section.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TermsPrivacyController());

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Legal',
      //         style: getTextStyle(
      //           color: Colors.white,
      //           fontSize: 16.sp,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //       Text(
      //         'Review our terms, policies, and legal information',
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
              title: 'Legal',
              subtitle: 'Review our terms, policies, and legal information',
            ),
            Expanded(
              child: Column(
                children: [
                  // Tab Bar
                  Obx(
                    () => LegalTabBar(
                      selectedIndex: controller.selectedTab.value,
                      onTabChanged: controller.selectTab,
                    ),
                  ),

                  // Content Area
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.selectedTab.value == 0)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    controller.termsContent.length,
                                    (index) {
                                      final section =
                                          controller.termsContent[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 24.h),
                                        child: LegalSection(
                                          number: section.number,
                                          title: section.title,
                                          content: section.content,
                                          bulletPoints: section.bulletPoints,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    controller.privacyContent.length,
                                    (index) {
                                      final section =
                                          controller.privacyContent[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 24.h),
                                        child: LegalSection(
                                          number: section.number,
                                          title: section.title,
                                          content: section.content,
                                          bulletPoints: section.bulletPoints,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
