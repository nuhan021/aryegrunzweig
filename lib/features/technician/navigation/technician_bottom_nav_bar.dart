import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/icon_path.dart';
import '../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../views/screens/technician_jobs_screen.dart';
import '../views/screens/technician_home_screen.dart';
import '../views/screens/technician_notifications_screen.dart';
import '../views/screens/technician_profile_screen.dart';

class TechnicianBottomNavBar extends StatelessWidget {
  const TechnicianBottomNavBar({super.key, required this.controller});

  final AppBottomNavBarController controller;

  List<Widget> _screens() => const [
    TechnicianHomeScreen(),
    TechnicianJobsScreen(),
    TechnicianNotificationsScreen(),
    TechnicianProfileScreen(),
  ];

  List<PersistentTabConfig> _tabs() => [
    _tab(0, IconPath.home, 'Home'),
    _tab(1, IconPath.headset, 'My Jobs'),
    _tab(2, IconPath.order, 'Alerts'),
    _tab(3, IconPath.person, 'Profile'),
  ];

  PersistentTabConfig _tab(int index, String iconPath, String title) {
    return PersistentTabConfig(
      screen: _screens()[index],
      item: ItemConfig(
        icon: Obx(() {
          final color = controller.currentIndex.value == index
              ? AppColors.primary
              : Colors.grey;
          return Image.asset(iconPath, width: 21.w, color: color);
        }),
        title: title,
        textStyle: getTextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
        activeForegroundColor: AppColors.primary,
        inactiveForegroundColor: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: controller.controller,
      tabs: _tabs(),
      navBarBuilder: (config) =>
          Style1BottomNavBar(navBarConfig: config, height: 68.h),
      onTabChanged: controller.changeCurrentIndex,
    );
  }
}
