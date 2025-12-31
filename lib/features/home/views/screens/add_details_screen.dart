import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_app_bar.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_text_field.dart';
import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/home/controller/home_controller.dart';
import 'package:aryegrunzweig/features/home/views/screens/service_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/media_upload_section.dart';

class AddDetailsScreen extends StatelessWidget {
  AddDetailsScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // app bar
            CustomAppBar(
              title: 'Add Details',
              subtitle: 'Help us understand your issue better',
            ),
        
            22.verticalSpace,
        
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF364153),
                      ),
                    ),
        
                    10.verticalSpace,
        
                    CustomTextField(
                      controller: controller.descriptionController,
                      hintText: "Describe your issue in detail...",
                      maxLine: 7,
                    ),

                    28.verticalSpace,

                    Text(
                      'Add Photos or Videos (Optional)',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF364153),
                      ),
                    ),

                    18.verticalSpace,

                    MediaUploadSection(),
                    
                    30.verticalSpace,
                    
                    CustomButton(text: 'Next', onPressed: () => AppHelperFunctions.navigateToScreen(context, ServiceAddressScreen()))
                  ],
                ).paddingSymmetric(horizontal: 16.w),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
