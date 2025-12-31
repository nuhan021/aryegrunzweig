import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import '../models/help_support_models.dart';

class FAQCard extends StatefulWidget {
  final FAQ faq;

  const FAQCard({super.key, required this.faq});

  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question with icon and chevron
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question icon
                Icon(
                  Icons.help_outline,
                  size: 20.w,
                  color: const Color(0xFF1A73E8),
                ),
                SizedBox(width: 12.w),

                // Question text
                Expanded(
                  child: Text(
                    widget.faq.question,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF101727),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Chevron icon
                Icon(
                  isExpanded ? Icons.expand_less : Icons.chevron_right,
                  size: 20.w,
                  color: const Color(0xFF697282),
                ),
              ],
            ),

            // Answer (shown only when expanded)
            if (isExpanded) ...[
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.only(left: 32.w),
                child: Text(
                  widget.faq.answer,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF495565),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
