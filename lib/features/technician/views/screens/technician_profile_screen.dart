import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../profile/edit_profile/views/screens/edit_profile_screen.dart';
import '../../controller/technician_profile_controller.dart';

class TechnicianProfileScreen extends StatelessWidget {
  const TechnicianProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TechnicianProfileController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => _ProfileHeader(
                onBack: _goHome,
                name: controller.fullName,
                imageUrl: controller.profile.value?.avatarUrl,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 26.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height * .55,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Info',
                        style: getTextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF172231),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      14.verticalSpace,
                      Obx(
                        () => _AccountInfoCard(
                          rows: [
                            ('Full name', controller.fullName),
                            (
                              'Email address',
                              controller.profile.value?.email ?? '',
                            ),
                            (
                              'Phone number',
                              controller.profile.value?.phone ?? '—',
                            ),
                            (
                              'Service area',
                              controller
                                      .profile
                                      .value
                                      ?.technician
                                      ?.serviceArea ??
                                  '—',
                            ),
                          ],
                        ),
                      ),
                      14.verticalSpace,
                      Obx(
                        () => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Available for jobs'),
                          value:
                              controller
                                  .profile
                                  .value
                                  ?.technician
                                  ?.isAvailable ??
                              false,
                          onChanged: controller.isUpdatingAvailability.value
                              ? null
                              : controller.setAvailability,
                        ),
                      ),
                      46.verticalSpace,
                      _EditProfileButton(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        ),
                      ),
                      190.verticalSpace,
                      _LogoutButton(onTap: () => _logout()),
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

  void _goHome() {
    if (Get.isRegistered<AppBottomNavBarController>()) {
      Get.find<AppBottomNavBarController>().jumpToScreen(0);
    }
  }

  Future<void> _logout() async {
    await Get.find<AuthController>().logout();
    Get.offAllNamed(AppRoute.loginScreen);
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.onBack,
    required this.name,
    required this.imageUrl,
  });

  final VoidCallback onBack;
  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 26.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                        4.horizontalSpace,
                        Text(
                          'Back',
                          style: getTextStyle(
                            fontSize: 11.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'Profile',
                style: getTextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          18.verticalSpace,
          Container(
            width: 92.w,
            height: 92.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: imageUrl == null
                ? Icon(
                    Icons.engineering_rounded,
                    size: 54.sp,
                    color: const Color(0xFF174EA6),
                  )
                : ClipOval(child: Image.network(imageUrl!, fit: BoxFit.cover)),
          ),
          16.verticalSpace,
          Text(
            name,
            style: getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          9.verticalSpace,
          Text(
            'Field Technician',
            style: getTextStyle(
              fontSize: 14.sp,
              color: Colors.white.withValues(alpha: .82),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountInfoCard extends StatelessWidget {
  const _AccountInfoCard({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE6E6E6)),
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
            decoration: BoxDecoration(
              border: index == rows.length - 1
                  ? null
                  : const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              children: [
                Text(
                  row.$1,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF7186A6),
                    textAlign: TextAlign.left,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    row.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF191919),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          height: 68.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 23.sp,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Text(
                  'Edit Profile',
                  style: getTextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 56.h,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFF303B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        icon: Icon(Icons.logout, color: Colors.white, size: 22.sp),
        label: Text(
          'Logout',
          style: getTextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
