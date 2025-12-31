import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import '../models/address_model.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback? onMenuPressed;

  const AddressCard({super.key, required this.address, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE4E7EB), width: 1),
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
              color: address.iconBackgroundColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Icon(
                address.type.icon,
                size: 24.w,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 16.w),

          // Address details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Label
                Text(
                  address.label,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF101727),
                  ),
                ),
                SizedBox(height: 4.h),

                // Street
                Text(
                  address.street,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF495565),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),

                // City, State, Zip
                Text(
                  address.fullAddress,
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF697282),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Menu button
          GestureDetector(
            onTap: onMenuPressed,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.more_vert,
                  size: 20.w,
                  color: const Color(0xFF697282),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
