import 'package:aryegrunzweig/features/app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import 'package:aryegrunzweig/features/home/views/screens/home_screen.dart';
import 'package:aryegrunzweig/features/orders/views/screens/my_orders_screen.dart';
import 'package:aryegrunzweig/features/profile/view_profile/views/screens/view_profile_screen.dart';
import 'package:aryegrunzweig/features/services/views/screens/services_screen.dart';
import 'package:aryegrunzweig/features/shop/views/screens/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../../core/common/styles/global_text_style.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/icon_path.dart';

class AppBottomNavBar extends StatelessWidget {
  AppBottomNavBar({super.key});

  final AppBottomNavBarController controller =
      Get.find<AppBottomNavBarController>();

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      const ServicesScreen(),
      ShopScreen(),
      MyOrdersScreen(),
      ViewProfileScreen(),
    ];
  }

  List<PersistentTabConfig> _tabs() => [
    _buildTab(index: 0, iconPath: IconPath.home, title: "Home"),
    _buildTab(index: 1, iconPath: IconPath.headset, title: "Services"),
    _buildTab(
      index: 2,
      iconData: Icons.shopping_cart_outlined,
      title: "Shop",
      isEmphasized: true,
    ),
    _buildTab(index: 3, iconPath: IconPath.order, title: "Orders"),
    _buildTab(index: 4, iconPath: IconPath.person, title: "Profile"),
  ];

  PersistentTabConfig _buildTab({
    required int index,
    String? iconPath,
    IconData? iconData,
    required String title,
    bool isEmphasized = false,
  }) {
    assert(
      (iconPath == null) != (iconData == null),
      'Provide exactly one of iconPath or iconData',
    );
    return PersistentTabConfig(
      screen: _buildScreens()[index],
      item: ItemConfig(
        icon: Obx(() {
          bool isActive = controller.currentIndex.value == index;
          final color = isActive ? AppColors.primary : Colors.grey;

          final iconWidget = iconData != null
              ? Icon(iconData, size: isEmphasized ? 24.w : 20.w, color: color)
              : Image.asset(
                  iconPath!,
                  width: isEmphasized ? 24.w : 20.w,
                  color: color,
                );

          if (!isEmphasized) return iconWidget;

          return Container(
            height: 38.w,
            width: 38.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: color, width: 1.8),
            ),
            child: iconWidget,
          );
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
      navBarBuilder: (navBarConfig) =>
          Style1BottomNavBar(navBarConfig: navBarConfig, height: 68.h),
      onTabChanged: (index) {
        controller.changeCurrentIndex(index);
      },
    );
  }
}
