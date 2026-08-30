import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/home/views/screens/service_request_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../widgets/service_request_buttons.dart';
import '../widgets/service_request_media_upload.dart';

class ServiceRequestMediaScreen extends StatelessWidget {
  const ServiceRequestMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Help us understand the issue',
              subtitle:
                  'Add photos or videos of the vacuum unit, inlet, hose, or affected area.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceRequestMediaUpload(),
                    14.verticalSpace,
                    Text(
                      'Clear photos can help our team prepare an accurate quotation.',
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  SrPrimaryButton(
                    text: 'Continue',
                    onPressed: () => AppHelperFunctions.navigateToScreen(
                      context,
                      ServiceRequestReviewScreen(),
                    ),
                  ),
                  10.verticalSpace,
                  SrOutlineButton(
                    text: 'Skip for Now',
                    onPressed: () => AppHelperFunctions.navigateToScreen(
                      context,
                      ServiceRequestReviewScreen(),
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
