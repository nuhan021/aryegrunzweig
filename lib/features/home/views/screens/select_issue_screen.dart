import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/home/views/screens/service_request_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/home_controller.dart';
import '../widgets/service_request_buttons.dart';

class SelectIssueScreen extends StatelessWidget {
  SelectIssueScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'What can we help with?',
              subtitle:
                  'Select the issue that best describes your central vacuum system.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  children: [
                    Obx(() {
                      if (controller.srIsLoadingCatalog.value) {
                        return const _IssueCatalogSkeleton();
                      }
                      if (controller.srErrorMessage.value.isNotEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Text(controller.srErrorMessage.value),
                              TextButton(
                                onPressed: controller.srLoadPrerequisites,
                                child: const Text('Try again'),
                              ),
                            ],
                          ),
                        );
                      }
                      final category = controller.srCategories.firstWhereOrNull(
                        (item) =>
                            item.id == controller.srSelectedCategoryId.value,
                      );
                      return Column(
                        children: [
                          _CategoryTabs(controller: controller),
                          18.verticalSpace,
                          ...?category?.issues.map(
                            (issue) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _IssueOptionTile(
                                label: issue.name,
                                isSelected:
                                    controller.srSelectedIssueId.value ==
                                    issue.id,
                                onTap: () =>
                                    controller.srSelectIssueModel(issue),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SrPrimaryButton(
                text: 'Continue',
                onPressed: () {
                  if (controller.srIsLoadingCatalog.value) return;
                  if (controller.srSelectedCategoryId.value.isEmpty ||
                      controller.srSelectedIssueId.value == null) {
                    AppHelperFunctions.showErrorSnackBar(
                      'Please wait for the service issues to load and select one.',
                    );
                    return;
                  }
                  AppHelperFunctions.navigateToScreen(
                    context,
                    ServiceRequestDetailsScreen(),
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

class _IssueCatalogSkeleton extends StatelessWidget {
  const _IssueCatalogSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Container(
            height: 48.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          18.verticalSpace,
          ...List.generate(
            5,
            (_) => Container(
              height: 52.h,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  16.horizontalSpace,
                  const Icon(Icons.radio_button_off),
                  12.horizontalSpace,
                  const Text('Loading service issue option'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: controller.srCategories.map((category) {
            final bool isSelected =
                controller.srSelectedCategoryId.value == category.id;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.srSelectCategoryModel(category),
                child: Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    category.name,
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _IssueOptionTile extends StatelessWidget {
  const _IssueOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20.sp,
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : Colors.black87,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
