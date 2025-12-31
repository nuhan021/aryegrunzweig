import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../widgets/edit_profile_header_card.dart';
import '../../widgets/edit_profile_form.dart';
import '../../../../../core/common/widgets/custom_button.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: getTextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with avatar
            Obx(
              () => EditProfileHeaderCard(
                profileImageUrl: controller.profileImageUrl.value,
                onCameraPressed: controller.changeProfilePhoto,
                onBackPressed: () => Get.back(),
              ),
            ),
            SizedBox(height: 20.h),

            // Form fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: EditProfileForm(
                fullNameController: controller.fullNameController,
                emailController: controller.emailController,
                phoneController: controller.phoneController,
                addressController: controller.addressController,
                apartmentController: controller.apartmentController,
                cityController: controller.cityController,
                stateController: controller.stateController,
                zipController: controller.zipController,
                onFullNameChanged: controller.updateFullName,
                onEmailChanged: controller.updateEmail,
                onPhoneChanged: controller.updatePhoneNumber,
                onAddressChanged: controller.updateAddress,
                onApartmentChanged: controller.updateApartment,
                onCityChanged: controller.updateCity,
                onStateChanged: controller.updateState,
                onZipChanged: controller.updateZipCode,
              ),
            ),
            SizedBox(height: 32.h),

            // Save Changes button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(
                () => CustomButton(
                  text: controller.isLoading.value
                      ? 'Saving...'
                      : 'Save Changes',
                  onPressed: controller.isLoading.value
                      ? () {}
                      : controller.saveChanges,
                  isShadow: true,
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
