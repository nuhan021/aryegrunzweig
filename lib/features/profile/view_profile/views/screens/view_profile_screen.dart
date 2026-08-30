import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/common/styles/global_text_style.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../../../auth/models/auth_models.dart';
import '../../../change_password/views/screens/change_password_screen.dart';
import '../../../edit_profile/views/screens/edit_profile_screen.dart';
import '../../../help_support/views/screens/help_support_screen.dart';
import '../../../notification_preferences/views/screens/notification_preferences_screen.dart';
import '../../../payment_history/views/screens/payment_history_screen.dart';
import '../../../saved_addresses/views/screens/saved_addresses_screen.dart';
import '../../controllers/view_profile_controller.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ViewProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => Skeletonizer(
            enabled: controller.isLoading.value,
            effect: ShimmerEffect(
              baseColor: AppColors.primary.withValues(alpha: 0.10),
              highlightColor: AppColors.primary.withValues(alpha: 0.22),
            ),
            child: RefreshIndicator(
              onRefresh: controller.loadProfile,
              color: AppColors.primary,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => _ProfileHeader(
                        name: controller.displayedUserName,
                        email: controller.displayedUserEmail,
                        imageUrl: controller.profileImageUrl,
                        onBack: () => _goBack(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 28.h, 16.w, 36.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionTitle(title: 'Personal Information'),
                          12.verticalSpace,
                          Obx(
                            () => _PersonalInformationCard(
                              details: [
                                ('Full name', controller.displayedUserName),
                                (
                                  'Email address',
                                  controller.displayedUserEmail,
                                ),
                                (
                                  'Phone number',
                                  controller.profile.value?.phone ?? '—',
                                ),
                                (
                                  'Company',
                                  controller.profile.value?.company ?? '—',
                                ),
                              ],
                            ),
                          ),
                          28.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const _SectionTitle(title: 'My Addresses'),
                              _TextAction(
                                label: 'Add New',
                                onTap: () => _push(
                                  context,
                                  const SavedAddressesScreen(),
                                ),
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          Obx(
                            () => _PrimaryAddressCard(
                              address: controller.primaryAddress,
                              onEdit: () =>
                                  _push(context, const SavedAddressesScreen()),
                            ),
                          ),
                          28.verticalSpace,
                          _ProfileActionTile(
                            icon: Icons.person_outline,
                            label: 'Edit profile',
                            accentColor: AppColors.primary,
                            onTap: () =>
                                _push(context, const EditProfileScreen()),
                          ),
                          12.verticalSpace,
                          _ProfileActionTile(
                            icon: Icons.credit_card_outlined,
                            label: 'Change password',
                            accentColor: const Color(0xFF22C97A),
                            onTap: () =>
                                _push(context, const ChangePasswordScreen()),
                          ),
                          12.verticalSpace,
                          _ProfileActionTile(
                            icon: Icons.credit_card_outlined,
                            label: 'Payment history',
                            accentColor: const Color(0xFF22C97A),
                            onTap: () =>
                                _push(context, const PaymentHistoryScreen()),
                          ),
                          12.verticalSpace,
                          _ProfileActionTile(
                            icon: Icons.notifications_none_rounded,
                            label: 'Notification preferences',
                            accentColor: Colors.grey.shade400,
                            onTap: () => _push(
                              context,
                              const NotificationPreferencesScreen(),
                            ),
                          ),
                          12.verticalSpace,
                          _ProfileActionTile(
                            icon: Icons.support_agent,
                            label: 'Help & support',
                            accentColor: AppColors.primary,
                            onTap: () =>
                                _push(context, const HelpSupportScreen()),
                          ),
                          40.verticalSpace,
                          GestureDetector(
                            onTap: controller.handleLogout,
                            child: Container(
                              height: 54.h,
                              width: double.maxFinite,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF2F3B),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 20.sp,
                                    color: Colors.white,
                                  ),
                                  8.horizontalSpace,
                                  Text(
                                    'Logout',
                                    style: getTextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Get.find<AppBottomNavBarController>().jumpToScreen(0);
  }

  Future<void> _push(BuildContext context, Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.onBack,
  });

  final String name;
  final String email;
  final String? imageUrl;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 30.h),
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
                child: GestureDetector(
                  onTap: onBack,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_left,
                          size: 22.sp,
                          color: Colors.white,
                        ),
                        2.horizontalSpace,
                        Text(
                          'Back',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
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
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          22.verticalSpace,
          Container(
            height: 100.w,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.w),
              image: imageUrl != null && imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: imageUrl == null || imageUrl!.isEmpty
                ? Icon(Icons.person, size: 54.sp, color: AppColors.primary)
                : null,
          ),
          18.verticalSpace,
          Text(
            name,
            style: getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          8.verticalSpace,
          Text(
            email,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getTextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF172231),
      ),
    );
  }
}

class _PersonalInformationCard extends StatelessWidget {
  const _PersonalInformationCard({required this.details});

  final List<(String, String)> details;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: List.generate(details.length, (index) {
          final detail = details[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              border: index == details.length - 1
                  ? null
                  : Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    detail.$1,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF667C9B),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    detail.$2,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF202020),
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

class _TextAction extends StatelessWidget {
  const _TextAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.primary,
        ).copyWith(decoration: TextDecoration.underline),
      ),
    );
  }
}

class _PrimaryAddressCard extends StatelessWidget {
  const _PrimaryAddressCard({required this.address, required this.onEdit});

  final AddressResponse? address;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address?.line1 ?? 'No saved address',
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF172231),
                    textAlign: TextAlign.left,
                  ),
                ),
                6.verticalSpace,
                Text(
                  address == null
                      ? 'Add an address for service and checkout.'
                      : '${address!.city}, ${address!.state} · ${address!.zipCode}',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF667C9B),
                    textAlign: TextAlign.left,
                  ),
                ),
                if (address?.isPrimary == true) 9.verticalSpace,
                if (address?.isPrimary == true)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3FD),
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      'Primary',
                      style: getTextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _TextAction(label: 'Edit', onTap: onEdit),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 72.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              height: 42.w,
              width: 42.w,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20.sp, color: accentColor),
            ),
            16.horizontalSpace,
            Expanded(
              child: Text(
                label,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF172231),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: const Color(0xFF99A7B9),
            ),
          ],
        ),
      ),
    );
  }
}
