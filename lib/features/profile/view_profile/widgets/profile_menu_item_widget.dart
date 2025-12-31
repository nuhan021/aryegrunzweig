import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../models/profile_menu_item.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final ProfileMenuItem menuItem;
  final bool isHighlighted;

  const ProfileMenuItemWidget({
    super.key,
    required this.menuItem,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: menuItem.onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFF1C4F50)
              : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: menuItem.iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  menuItem.icon,
                  size: 20.w,
                  color: isHighlighted ? Colors.white : AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // Menu Label
            Expanded(
              child: Text(
                menuItem.label,
                style: getTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: isHighlighted ? Colors.white : menuItem.textColor,
                ),
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: isHighlighted ? Colors.white : const Color(0xFF99A1AF),
            ),
          ],
        ),
      ),
    );
  }
}
