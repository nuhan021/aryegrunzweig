import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:aryegrunzweig/core/utils/constants/image_path.dart';
import 'package:aryegrunzweig/features/onboarding/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController onboardingController =
      Get.find<OnboardingController>();

  List<OnboardingContent> contents = [
    OnboardingContent(
      title: 'Book Services Instantly',
      image: ImagePath.onboarding1,
      description:
          "Find and book trusted home service professionals with just a few taps",
    ),
    OnboardingContent(
      title: 'Track in Real-Time',
      image: ImagePath.onboarding2,
      description:
          "Know exactly when your technician will arrive with live tracking",
    ),
    OnboardingContent(
      title: 'Quality Guaranteed',
      image: ImagePath.onboarding3,
      description:
          "All our professionals are verified and rated by real customers",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: onboardingController.controller,
            itemCount: contents.length,
            onPageChanged: (index) {
              onboardingController.currentPage.value = index;
            },
            itemBuilder: (context, index) {
              final item = contents[index];
              return Stack(
                children: [
                  SizedBox(
                    height: 400.h,
                    width: double.maxFinite,
                    child: Image.asset(item.image, fit: BoxFit.cover),
                  ),

                  Align(
                    alignment: AlignmentGeometry.bottomCenter,
                    child: Container(
                      height: 433.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          Obx(() {
                            if (onboardingController.isLastPage) {
                              return 55.verticalSpace;
                            }

                            return 10.verticalSpace;
                          }),
                          // skip button
                          Obx(() {
                            if (onboardingController.isLastPage) {
                              return SizedBox();
                            }
                            return Align(
                              alignment: AlignmentGeometry.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  onboardingController.skipPage();
                                },
                                child: Text(
                                  'Skip',
                                  style: getTextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ).paddingOnly(right: 26.w),
                            );
                          }),

                          40.verticalSpace,

                          Text(
                            item.title,
                            style: getTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

                          20.verticalSpace,

                          Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8B8B8B),
                            ),
                          ).paddingSymmetric(horizontal: 20.w),

                          100.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmoothPageIndicator(
                  controller: onboardingController.controller, // PageController
                  count: 3,
                  effect: CustomizableEffect(
                    activeDotDecoration: DotDecoration(
                      width: 45.w,
                      height: 2.h,
                      color: AppColors.primary,
                      rotationAngle: 180,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    dotDecoration: DotDecoration(
                      width: 45.w,
                      height: 2.h,
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onDotClicked: (index) {},
                ),
                37.verticalSpace,

                SizedBox(
                  width: 180.w,
                  child: Obx(() {
                    return CustomButton(
                      text: onboardingController.isLastPage
                          ? 'Get Started'
                          : 'Next',
                      onPressed: () {
                        onboardingController.nextPage();
                      },
                    );
                  }),
                ),
                50.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingContent {
  String image;
  String title;
  String description;

  OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}
