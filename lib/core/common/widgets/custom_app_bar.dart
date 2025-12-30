import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/colors.dart';
import '../styles/global_text_style.dart';


class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, this.isBack = true, required this.title, required this.subtitle});

  final bool isBack;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios, size: 20.w, color: Colors.white,),
              Text(
                'Back',
                style: getTextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          20.verticalSpace,

          // title
          Text(
            title,
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          10.verticalSpace,

          Text(
            subtitle,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),

        ],
      ),
    );
  }
}