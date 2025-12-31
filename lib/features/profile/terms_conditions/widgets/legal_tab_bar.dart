import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';

class LegalTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const LegalTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Terms of Service Tab
            GestureDetector(
              onTap: () => onTabChanged(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.description,
                        size: 16.w,
                        color: selectedIndex == 0
                            ? const Color(0xFF101727)
                            : const Color(0xFF495565),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Terms of Service',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: selectedIndex == 0
                              ? const Color(0xFF101727)
                              : const Color(0xFF495565),
                        ),
                      ),
                    ],
                  ),
                  if (selectedIndex == 0) ...[
                    SizedBox(height: 8.h),
                    Container(
                      width: 160.w,
                      height: 2,
                      color: const Color(0xFF1C4F50),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 32.w),

            // Privacy Policy Tab
            GestureDetector(
              onTap: () => onTabChanged(1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shield,
                        size: 16.w,
                        color: selectedIndex == 1
                            ? const Color(0xFF101727)
                            : const Color(0xFF495565),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Privacy Policy',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: selectedIndex == 1
                              ? const Color(0xFF101727)
                              : const Color(0xFF495565),
                        ),
                      ),
                    ],
                  ),
                  if (selectedIndex == 1) ...[
                    SizedBox(height: 8.h),
                    Container(
                      width: 140.w,
                      height: 2,
                      color: const Color(0xFF1C4F50),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
