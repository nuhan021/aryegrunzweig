import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../controller/auth_controller.dart';

class AccountCreateSuccessScreen extends StatelessWidget {
  AccountCreateSuccessScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: Center(child: Image.asset(IconPath.logo, width: 158.w)),
          ),
          Container(
            height: 433.h,
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
                    color: Colors.white,
                  ),
                ),
                25.verticalSpace,
                Text(
                  controller.isTechnician
                      ? 'Your technician account will be available after verification.'
                      : 'Your account is ready to use.',
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: .8),
                  ),
                ),
                65.verticalSpace,
                SizedBox(
                  width: 190.w,
                  child: Obx(
                    () => CustomButton(
                      text: controller.isSubmitting.value
                          ? 'Please wait...'
                          : 'Let\'s Explore',
                      onPressed: () => _continue(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _continue(BuildContext context) async {
    final success = await controller.completeOnboarding();
    if (!context.mounted) return;
    if (!success) {
      AppHelperFunctions.showErrorSnackBar(controller.errorMessage.value);
      return;
    }
    Get.find<AppBottomNavBarController>().resetToFirstTab();
    Get.offAllNamed(controller.authenticatedDestination);
  }
}
