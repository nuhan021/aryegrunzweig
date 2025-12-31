import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';

class EditProfileHeaderCard extends StatelessWidget {
  final String? profileImageUrl;
  final VoidCallback onCameraPressed;
  final VoidCallback? onBackPressed;

  const EditProfileHeaderCard({
    super.key,
    this.profileImageUrl,
    required this.onCameraPressed,
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
          // // Back button
          // Row(
          //   children: [
          //     GestureDetector(
          //       onTap: onBackPressed,
          //       child: Row(
          //         children: [
          //           Icon(Icons.arrow_back_ios, size: 18.w, color: Colors.white),
          //           SizedBox(width: 8.w),
          //           Text(
          //             'Back',
          //             style: getTextStyle(
          //               fontSize: 10.sp,
          //               fontWeight: FontWeight.w400,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 12.h),

          // Title
          // Text(
          //   'Edit Profile',
          //   style: getTextStyle(
          //     fontSize: 16.sp,
          //     fontWeight: FontWeight.w600,
          //     color: Colors.white,
          //   ),
          // ),
          // SizedBox(height: 20.h),

          // Avatar with camera button
          GestureDetector(
            onTap: onCameraPressed,
            child: Stack(
              children: [
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1A73E8),
                      width: 1,
                    ),
                  ),
                  child: _buildAvatarImage(),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 16.w,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // "Tap to change photo" text
          Text(
            'Tap to change photo',
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (profileImageUrl == null || profileImageUrl!.isEmpty) {
      return Center(
        child: Icon(Icons.person, size: 50.w, color: Colors.white),
      );
    }

    // Check if it's a file path (local) or URL (network)
    if (profileImageUrl!.startsWith('http')) {
      // Network image
      return ClipOval(
        child: Image.network(
          profileImageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(Icons.person, size: 50.w, color: Colors.white),
            );
          },
        ),
      );
    } else {
      // Local file
      return ClipOval(
        child: Image.file(
          File(profileImageUrl!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(Icons.person, size: 50.w, color: Colors.white),
            );
          },
        ),
      );
    }
  }
}
