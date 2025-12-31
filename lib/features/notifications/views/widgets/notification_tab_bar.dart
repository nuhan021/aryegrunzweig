import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationTabBar extends StatelessWidget {
  final int selectedIndex;
  final int allCount;
  final int unreadCount;
  final Function(int) onTabChanged;

  const NotificationTabBar({
    super.key,
    required this.selectedIndex,
    required this.allCount,
    required this.unreadCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onTabChanged(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All ($allCount)',
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: selectedIndex == 0
                        ? const Color(0xFF101727)
                        : const Color(0xFF495565),
                  ),
                ),
                if (selectedIndex == 0)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    height: 2.h,
                    width: 20.w,
                    color: const Color(0xFF1C4F50),
                  ),
              ],
            ),
          ),
          SizedBox(width: 32.w),
          GestureDetector(
            onTap: () => onTabChanged(1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unread ($unreadCount)',
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: selectedIndex == 1
                        ? const Color(0xFF101727)
                        : const Color(0xFF495565),
                  ),
                ),
                if (selectedIndex == 1)
                  Container(
                    margin: EdgeInsets.only(top: 4.h),
                    height: 2.h,
                    width: 30.w,
                    color: const Color(0xFF1C4F50),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
