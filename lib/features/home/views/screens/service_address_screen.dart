import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_text_field.dart';
import 'package:aryegrunzweig/core/utils/constants/icon_path.dart';
import 'package:aryegrunzweig/features/home/views/screens/schedule_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../controller/home_controller.dart';

class ServiceAddressScreen extends StatelessWidget {
  ServiceAddressScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  final List<Map<String, String>> addresses = [
    {
      "type": "Home",
      "address": "123 Main St, New York, NY 10001",
      "icon": "home_outlined",
    },
    {
      "type": "Work",
      "address": "456 Park Ave, New York, NY 10022",
      "icon": "work_outline",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Service Address',
              subtitle: "Enter the location where the service is needed",
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,
                    Text(
                      'Saved Addresses',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF364153),
                      ),
                    ),
                    15.verticalSpace,

                    // Saved Address List (Map logic remains same)
                    ...addresses
                        .map((data) => _buildAddressCard(data))
                        .toList(),

                    27.verticalSpace,

                    // Add New Address Button (Toggle Form)
                    GestureDetector(
                      onTap: () => controller.toggleAddressForm(),
                      child: Container(
                        height: 50.h,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFD1D5DC),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(IconPath.plus, width: 20.w),
                            5.horizontalSpace,
                            Text(
                              'Add New Address',
                              style: getTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5565),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Collapsable Form Section
                    Obx(
                      () => AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: controller.isAddressFormVisible.value
                            ? _buildAddressForm()
                            : const SizedBox.shrink(),
                      ),
                    ),

                    30.verticalSpace,
                    Text(
                      'Notes for Technician (Optional)',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF364153),
                      ),
                    ),
                    10.verticalSpace,
                    CustomTextField(
                      controller: controller.notesController,
                      hintText: 'e.g., Gate code, parking instructions...',
                      maxLine: 5,
                    ),
                    30.verticalSpace,
                    CustomButton(
                      text: 'Next',
                      onPressed: () => AppHelperFunctions.navigateToScreen(
                        context,
                        ScheduleServiceScreen(),
                      ),
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        _formField("Name", "Name", controller.nameController),
        _formField("Address", "Address", controller.addressController),
        _formField(
          "Apartment / Suite",
          "Apartment Suite",
          controller.apartmentController,
        ),
        Row(
          children: [
            Expanded(
              child: _formField("City", "City Name", controller.cityController),
            ),
            15.horizontalSpace,
            Expanded(
              child: _formField("State", "State", controller.stateController),
            ),
          ],
        ),
        _formField(
          "Zip",
          "Zip Code",
          controller.zipController,
          inputType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _formField(
    String label,
    String hint,
    TextEditingController textController, {
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF364153),
          ),
        ),
        8.verticalSpace,
        CustomTextField(
          controller: textController,
          hintText: hint,
          inputType: inputType,
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildAddressCard(Map<String, String> data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Obx(() {
        bool isSelected = controller.selectedAddress.value == data['type'];
        return GestureDetector(
          onTap: () => controller.updateAddress(data['type']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1C4F50) : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2),
              ),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  data['type'] == "Home"
                      ? Icons.home_outlined
                      : Icons.work_outline,
                  color: isSelected ? Colors.white : Colors.black54,
                  size: 24.sp,
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['type']!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        data['address']!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected
                      ? Colors.white
                      : Colors.grey.withOpacity(0.4),
                  size: 24.sp,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
