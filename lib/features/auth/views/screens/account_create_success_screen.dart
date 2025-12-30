import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/common/widgets/custom_button.dart';
import 'package:aryegrunzweig/core/utils/constants/icon_path.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountCreateSuccessScreen extends StatelessWidget {
  const AccountCreateSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              alignment: AlignmentGeometry.center,
              child: Image.asset(IconPath.logo, width: 158.w,),
            ),
          ),

          Container(
            height: 433.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Successfully created an account',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),
                ),

                25.verticalSpace,

                Text(
                  'you can now enjoy the ELITE service for your central vacuum system',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8)
                  ),
                ),

                65.verticalSpace,

                SizedBox(
                  width: 180.w,
                  child: CustomButton(text: 'Let\'s Explore', onPressed: () => Get.offAllNamed(AppRoute.getLoginScreen())),
                )
              ],
            ).paddingSymmetric(horizontal: 25.w),
          )
        ],
      ),
    );
  }
}
