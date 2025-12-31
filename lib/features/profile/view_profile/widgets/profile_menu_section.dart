import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/profile_menu_item.dart';
import 'profile_menu_item_widget.dart';

class ProfileMenuSection extends StatelessWidget {
  final List<ProfileMenuItem> menuItems;

  const ProfileMenuSection({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        spacing: 8.h,
        children: List.generate(
          menuItems.length,
          (index) => ProfileMenuItemWidget(
            menuItem: menuItems[index],
            isHighlighted: index == 0, // Highlight first item (Edit Profile)
          ),
        ),
      ),
    );
  }
}
