import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../../notifications/views/screens/notifications_screen.dart';

class TechnicianNotificationsScreen extends StatelessWidget {
  const TechnicianNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => NotificationsScreen(
    onBackPressed: () {
      if (Get.isRegistered<AppBottomNavBarController>()) {
        Get.find<AppBottomNavBarController>().jumpToScreen(0);
      }
    },
  );
}
