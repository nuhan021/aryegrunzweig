import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import '../models/help_support_models.dart';

class ContactOptionCard extends StatelessWidget {
  final ContactOption contact;

  const ContactOptionCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: contact.onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: contact.iconBackgroundColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Icon(contact.icon, size: 24.w, color: Colors.white),
              ),
            ),
            SizedBox(width: 12.w),

            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    contact.title,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF101727),
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Description
                  Text(
                    contact.description,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF495565),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),

            // Arrow icon
            Icon(
              Icons.chevron_right,
              size: 20.w,
              color: const Color(0xFF697282),
            ),
          ],
        ),
      ),
    );
  }
}
