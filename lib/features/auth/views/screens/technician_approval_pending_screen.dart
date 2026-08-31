import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../../../routes/app_routes.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../controller/auth_controller.dart';
import '../../models/auth_models.dart';

class TechnicianApprovalPendingScreen extends StatelessWidget {
  TechnicianApprovalPendingScreen({super.key});

  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final rejected =
        controller.currentProfile.value?.technician?.verificationStatus ==
        TechnicianVerificationStatus.rejected;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  rejected ? Icons.error_outline : Icons.schedule_outlined,
                  color: AppColors.primary,
                  size: 48.sp,
                ),
              ),
              28.verticalSpace,
              Text(
                rejected ? 'Verification rejected' : 'Approval pending',
                style: getTextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              12.verticalSpace,
              Text(
                rejected
                    ? 'Your technician profile could not be verified. Please contact support before trying again.'
                    : 'Your technician profile is being reviewed. Refresh after the administrator approves it.',
                textAlign: TextAlign.center,
                style: getTextStyle(fontSize: 13.sp, color: Colors.black54),
              ),
              38.verticalSpace,
              Obx(
                () => CustomButton(
                  text: controller.isSubmitting.value
                      ? 'Checking...'
                      : 'Check approval status',
                  isLoading: controller.isSubmitting.value,
                  onPressed: () => _refresh(context),
                ),
              ),
              12.verticalSpace,
              Obx(
                () => TextButton(
                  onPressed: controller.isSubmitting.value ? null : _logout,
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) async {
    final success = await controller.refreshCurrentProfile();
    if (!context.mounted) return;
    if (success && controller.technicianIsVerified) {
      Get.find<AppBottomNavBarController>().resetToFirstTab();
      Get.offAllNamed(AppRoute.appBottomNavBarScreen);
      return;
    }
    if (success) {
      AppHelperFunctions.showSnackBar(
        'Your technician account is still awaiting approval.',
      );
    } else {
      AppHelperFunctions.showErrorSnackBar(controller.errorMessage.value);
    }
  }

  Future<void> _logout() async {
    await controller.logout();
    Get.offAllNamed(AppRoute.loginScreen);
  }
}
