import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';

class LegalSection extends StatelessWidget {
  final int number;
  final String title;
  final String content;
  final List<String>? bulletPoints;

  const LegalSection({
    super.key,
    required this.number,
    required this.title,
    required this.content,
    this.bulletPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with number
        Text(
          '$number. $title',
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF101727),
          ),
        ),
        SizedBox(height: 8.h),

        // Content text
        Text(
          content,
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF495565),
          ),
        ),

        // Bullet points if available
        if (bulletPoints != null && bulletPoints!.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              bulletPoints!.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  bulletPoints![index],
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF495565),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
