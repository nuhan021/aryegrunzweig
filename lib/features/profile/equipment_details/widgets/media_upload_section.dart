import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';

class MediaUploadSection extends StatelessWidget {
  final RxList<File> photos;
  final RxList<File> videos;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;
  final Function(int)? onRemovePhoto;
  final Function(int)? onRemoveVideo;

  const MediaUploadSection({
    super.key,
    required this.photos,
    required this.videos,
    required this.onAddPhoto,
    required this.onAddVideo,
    this.onRemovePhoto,
    this.onRemoveVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Photos or Videos (Optional)',
          style: getTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF354152),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onAddPhoto,
                child: Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFD0D5DB),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 20.w,
                        color: const Color(0xFF495565),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Add Photo',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF495565),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: onAddVideo,
                child: Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFD0D5DB),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam,
                        size: 20.w,
                        color: const Color(0xFF495565),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Add Video',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF495565),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildMediaPreview(),
      ],
    );
  }

  Widget _buildMediaPreview() {
    return Obx(() {
      final allMedia = <Widget>[];

      // Add photos
      for (int i = 0; i < photos.length; i++) {
        allMedia.add(
          Stack(
            children: [
              Container(
                width: 108.w,
                height: 108.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Image.file(
                    photos[i],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF3F4F6),
                        child: Icon(Icons.broken_image, size: 32.w),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 4.w,
                right: 4.w,
                child: GestureDetector(
                  onTap: () => onRemovePhoto?.call(i),
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFB2C36),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 12.w),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Add videos
      for (int i = 0; i < videos.length; i++) {
        allMedia.add(
          Stack(
            children: [
              Container(
                width: 108.w,
                height: 108.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: const Color(0xFFF3F4F6),
                ),
                child: Center(
                  child: Icon(
                    Icons.videocam,
                    size: 32.w,
                    color: const Color(0xFF697282),
                  ),
                ),
              ),
              Positioned(
                top: 4.w,
                right: 4.w,
                child: GestureDetector(
                  onTap: () => onRemoveVideo?.call(i),
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFB2C36),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 12.w),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      if (allMedia.isEmpty) {
        return SizedBox(
          height: 108.w,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: const Color(0xFFF3F4F6),
            ),
            child: Center(
              child: Text(
                'No media added yet',
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF697282),
                ),
              ),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            allMedia.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                right: index < allMedia.length - 1 ? 12.w : 0,
              ),
              child: allMedia[index],
            ),
          ),
        ),
      );
    });
  }
}
