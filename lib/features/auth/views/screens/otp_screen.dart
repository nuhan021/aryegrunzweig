import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,

            // logo
            Align(alignment: AlignmentGeometry.center, child: Image.asset(IconPath.logo, width: 158.w,)),

            55.verticalSpace,

            // title,
            Text(
              'verification Code',
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),

            10.verticalSpace,

            // subtitle
            Text(
              'A verification code has been sent to your mail.',
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.6),
              ),
            ),

            35.verticalSpace,
            OtpTextField(
              contentPadding: EdgeInsets.zero,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              numberOfFields: 6,
              borderRadius: BorderRadius.circular(10.0.r),
              fieldHeight: 42.0.w,
              fieldWidth: 42.0.w,
              borderColor: AppColors.primary,
              showFieldAsBox: true,
              onCodeChanged: (code) {
                /* when value changes */
              },
              onSubmit: (verificationCode) {
                // signUpScreenController.otp = verificationCode;
              },
            ),
          ],
        ).paddingSymmetric(horizontal: 26.w),
      ),
    );
  }
}
