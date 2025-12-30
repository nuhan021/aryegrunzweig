import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/home/views/screens/add_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../controller/home_controller.dart';

class SelectIssueScreen extends StatelessWidget {
  SelectIssueScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  final List<String> problems = [
    "Low suction",
    "No Suction",
    "Clogged pipes or hoses",
    "Hose not pulling in or out",
    "Accessory not working",
    "Filter & Bag Replacement",
    "parts & cleaning Accessories",
    "General inspection needed",
    "Machine doesn't turn on or doesn't shut off",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Top Bar
            CustomAppBar(
              title: 'Select Issue',
              subtitle: 'What issue are you experiencing?',
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),

                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: problems.length,
                      separatorBuilder: (context, index) => 12.verticalSpace,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          bool isSelected =
                              controller.selectedProblem.value ==
                              problems[index];

                          return GestureDetector(
                            onTap: () =>
                                controller.updateProblem(problems[index]),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1C4F50)
                                    : const Color(0xFFF9F9F9),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : Colors.black.withOpacity(0.05),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.withOpacity(0.5),
                                    size: 20.sp,
                                  ),
                                  12.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      problems[index],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),

            // Bottom Fixed Button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: CustomButton(
                text: "Continue",
                onPressed: () => AppHelperFunctions.navigateToScreen(
                  context,
                  AddDetailsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
