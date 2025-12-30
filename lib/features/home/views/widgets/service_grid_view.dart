import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';

class ServiceGridView extends StatelessWidget {
  ServiceGridView({super.key});

  final HomeController controller = Get.find<HomeController>();

  final List<Map<String, String>> serviceList = [
    {"title": "Central Vacuum Repair", "icon": IconPath.settings},
    {"title": "Parts", "icon": IconPath.settings},
    {"title": "Vacuum Bags/Filters", "icon": IconPath.settings},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 130.h,
      ),
      itemCount: serviceList.length,
      itemBuilder: (context, index) {
        return Obx(() {
          bool isSelected = controller.selectedServiceIndex.value == index;
          return GestureDetector(
            onTap: () => controller.selectService(index),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1C4F50) : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.blue.withOpacity(0.2),
                  width: 1,
                ),
                // boxShadow: [
                //   if (!isSelected)
                //     BoxShadow(
                //       color: Colors.black.withOpacity(0.05),
                //       blurRadius: 10,
                //       offset: const Offset(0, 5),
                //     ),
                // ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    serviceList[index]['icon']!,
                    width: 40.w,
                    height: 40.w,
                    color: isSelected ? Colors.white : const Color(0xFF1C4F50),
                  ),
                  12.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      serviceList[index]['title']!,
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}