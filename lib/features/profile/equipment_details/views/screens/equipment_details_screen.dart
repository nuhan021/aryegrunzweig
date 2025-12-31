import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import '../../controllers/equipment_details_controller.dart';
import '../../widgets/equipment_form_field.dart';
import '../../widgets/system_type_dropdown.dart';
import '../../widgets/media_upload_section.dart';

class EquipmentDetailsScreen extends StatelessWidget {
  const EquipmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EquipmentDetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Equipment Details',
      //         style: getTextStyle(
      //           color: Colors.white,
      //           fontSize: 16.sp,
      //           fontWeight: FontWeight.w600,
      //         ),
      //       ),
      //       Text(
      //         'Enter your Equipment Details',
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
              title: 'Enter Customer Equipment Details',
              subtitle: 'Enter your payment details to proceed',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Manufacturer Name
                      EquipmentFormField(
                        label: 'Manufacturer Name',
                        hint: 'Enter manufacturer name',
                        controller: controller.manufacturerController,
                        onChanged: controller.updateManufacturer,
                      ),
                      SizedBox(height: 16.h),

                      // Model Number
                      EquipmentFormField(
                        label: 'Model Number',
                        hint: 'Enter model number',
                        controller: controller.modelController,
                        onChanged: controller.updateModel,
                      ),
                      SizedBox(height: 16.h),

                      // Serial Number
                      EquipmentFormField(
                        label: 'Serial Number',
                        hint: 'Enter serial number',
                        controller: controller.serialController,
                        onChanged: controller.updateSerial,
                      ),
                      SizedBox(height: 16.h),

                      // System Type
                      SystemTypeDropdown(
                        selectedType: controller.systemType,
                        options: controller.systemTypes,
                        onChanged: controller.updateSystemType,
                      ),
                      SizedBox(height: 20.h),

                      // Inlets Per Floor Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Inlets Per Floor',
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF495565),
                            ),
                          ),
                          Text(
                            '(for Regular System Only)',
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF697282),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Basement Inlets
                      EquipmentFormField(
                        label: 'Basement Inlets',
                        hint: 'Number of inlets in basement',
                        controller: controller.basementController,
                        onChanged: controller.updateBasementInlets,
                        keyboardType: TextInputType.number,
                        isNumeric: true,
                      ),
                      SizedBox(height: 12.h),

                      // First Floor Inlets
                      EquipmentFormField(
                        label: 'First Floor Inlets',
                        hint: 'Number of inlets in first floor',
                        controller: controller.firstFloorController,
                        onChanged: controller.updateFirstFloorInlets,
                        keyboardType: TextInputType.number,
                        isNumeric: true,
                      ),
                      SizedBox(height: 12.h),

                      // Second Floor Inlets
                      EquipmentFormField(
                        label: 'Second Floor Inlets',
                        hint: 'Number of inlets in second floor',
                        controller: controller.secondFloorController,
                        onChanged: controller.updateSecondFloorInlets,
                        keyboardType: TextInputType.number,
                        isNumeric: true,
                      ),
                      SizedBox(height: 12.h),

                      // Third Floor Inlets
                      EquipmentFormField(
                        label: 'Third Floor Inlets',
                        hint: 'Number of inlets in third floor',
                        controller: controller.thirdFloorController,
                        onChanged: controller.updateThirdFloorInlets,
                        keyboardType: TextInputType.number,
                        isNumeric: true,
                      ),
                      SizedBox(height: 12.h),

                      // Additional Floors
                      Obx(
                        () => Column(
                          children: List.generate(
                            controller.additionalFloorInlets.length,
                            (index) => Column(
                              children: [
                                EquipmentFormField(
                                  label: 'Floor ${4 + index} Inlets',
                                  hint:
                                      'Number of inlets in floor ${4 + index}',
                                  controller: TextEditingController(
                                    text: controller
                                        .additionalFloorInlets[index]
                                        .toString(),
                                  ),
                                  onChanged: (value) {
                                    controller.updateAdditionalFloorInlets(
                                      index,
                                      value,
                                    );
                                  },
                                  keyboardType: TextInputType.number,
                                  isNumeric: true,
                                ),
                                SizedBox(height: 12.h),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Add More Floors Button
                      GestureDetector(
                        onTap: controller.addMoreFloor,
                        child: Container(
                          width: double.infinity,
                          height: 52.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFD0D5DB),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 20.w,
                                color: const Color(0xFF495565),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Add more floors',
                                style: getTextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF495565),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Media Upload Section
                      MediaUploadSection(
                        photos: controller.photos,
                        videos: controller.videos,
                        onAddPhoto: controller.addPhoto,
                        onAddVideo: controller.addVideo,
                        onRemovePhoto: controller.removePhoto,
                        onRemoveVideo: controller.removeVideo,
                      ),
                      SizedBox(height: 24.h),

                      // Additional Notes
                      EquipmentFormField(
                        label: 'Additional Notes',
                        hint: 'Add any equipment notes or comments here...',
                        controller: controller.notesController,
                        onChanged: controller.updateNotes,
                        maxLines: 5,
                      ),
                      SizedBox(height: 32.h),

                      // Save Button
                      Obx(
                        () => CustomButton(
                          text: controller.isLoading.value
                              ? 'Saving...'
                              : 'Save Equipment Details',
                          onPressed: controller.isLoading.value
                              ? () {}
                              : controller.saveEquipmentDetails,
                          isShadow: true,
                        ),
                      ),
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
