import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/styles/global_text_style.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;
  final bool showShadow;

  const LogoutButton({
    super.key,
    required this.onPressed,
    this.text = 'Logout',
    this.backgroundColor = const Color(0xFFFB2C36),
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.icon = Icons.logout,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.maxFinite,
        height: 48.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: const Color(0x1A000000),
                    offset: Offset(0, 4.h),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.w, color: iconColor),
            SizedBox(width: 8.w),
            Text(
              text,
              style: getTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
