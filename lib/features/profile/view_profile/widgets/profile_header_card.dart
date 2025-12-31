import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? profileImageUrl;
  final VoidCallback? onBackPressed;

  const ProfileHeaderCard({
    super.key,
    required this.userName,
    required this.userEmail,
    this.profileImageUrl,
    this.onBackPressed,
  });

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
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1A73E8), width: 1),
              image: profileImageUrl != null && profileImageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(profileImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profileImageUrl == null || profileImageUrl!.isEmpty
                ? Center(
                    child: Icon(Icons.person, size: 50.w, color: Colors.white),
                  )
                : null,
          ),
          SizedBox(height: 20.h),

          // User Name
          Text(
            userName,
            style: getTextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),

          // User Email
          Text(
            userEmail,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFBBBBBB),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
