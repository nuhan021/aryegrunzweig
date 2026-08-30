import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common/styles/global_text_style.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../auth/models/auth_models.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.address, this.onMenuPressed});

  final AddressResponse address;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE4E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              address.isPrimary ? Icons.home : Icons.location_on,
              color: AppColors.primary,
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.isPrimary ? 'Primary' : 'Saved address',
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.verticalSpace,
                Text(
                  [address.line1, address.apartment]
                      .where((value) => value != null && value.isNotEmpty)
                      .join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF495565),
                  ),
                ),
                4.verticalSpace,
                Text(
                  '${address.city}, ${address.state} ${address.zipCode}',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF697282),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onMenuPressed,
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
