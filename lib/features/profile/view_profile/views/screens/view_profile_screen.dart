import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/view_profile_controller.dart';
import '../../models/profile_menu_item.dart';
import '../../widgets/profile_header_card.dart';
import '../../widgets/profile_menu_section.dart';
import '../../widgets/logout_button.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header Card
              Obx(
                () => ProfileHeaderCard(
                  userName: controller.userName.value,
                  userEmail: controller.userEmail.value,
                  profileImageUrl: controller.profileImageUrl.value,
                  onBackPressed: () => Get.back(),
                ),
              ),
              SizedBox(height: 20.h),

              // Menu Items Section
              ProfileMenuSection(menuItems: _buildMenuItems(controller)),
              SizedBox(height: 24.h),

              // Logout Button
              LogoutButton(onPressed: () => controller.handleLogout()),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  List<ProfileMenuItem> _buildMenuItems(ViewProfileController controller) {
    return [
      ProfileMenuItem(
        label: 'Edit Profile',
        icon: Icons.person,
        iconBackgroundColor: const Color(0xFF1A5758),
        textColor: const Color(0xFF101727),
        onTap: controller.handleEditProfile,
      ),
      ProfileMenuItem(
        label: 'Payment Methods',
        icon: Icons.credit_card,
        iconBackgroundColor: const Color(0x1F28C76F),
        textColor: const Color(0xFF101727),
        onTap: controller.handlePaymentMethods,
      ),
      ProfileMenuItem(
        label: 'Equipment Details',
        icon: Icons.build,
        iconBackgroundColor: const Color(0xFFFAEFE4),
        textColor: const Color(0xFF101727),
        onTap: controller.handleEquipmentDetails,
      ),
      ProfileMenuItem(
        label: 'Saved Addresses',
        icon: Icons.location_on,
        iconBackgroundColor: const Color(0x1F00CFE8),
        textColor: const Color(0xFF101727),
        onTap: controller.handleSavedAddresses,
      ),
      ProfileMenuItem(
        label: 'Service History',
        icon: Icons.history,
        iconBackgroundColor: const Color(0x1FFF9F43),
        textColor: const Color(0xFF101727),
        onTap: controller.handleServiceHistory,
      ),
      // ProfileMenuItem(
      //   label: 'Notifications',
      //   icon: Icons.notifications,
      //   iconBackgroundColor: const Color(0x1FB6B6B6),
      //   textColor: const Color(0xFF101727),
      //   onTap: controller.handleNotifications,
      // ),
      ProfileMenuItem(
        label: 'Help & Support',
        icon: Icons.help,
        iconBackgroundColor: const Color(0x1F7367F0),
        textColor: const Color(0xFF101727),
        onTap: controller.handleHelpSupport,
      ),
      ProfileMenuItem(
        label: 'Terms & Privacy',
        icon: Icons.description,
        iconBackgroundColor: const Color(0x1FEA5455),
        textColor: const Color(0xFF101727),
        onTap: controller.handleTermsPrivacy,
      ),
    ];
  }
}
