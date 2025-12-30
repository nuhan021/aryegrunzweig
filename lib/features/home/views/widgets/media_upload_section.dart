import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/home_controller.dart';

class MediaUploadSection extends StatelessWidget {
  MediaUploadSection({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // টপ বাটন দুটি (Add Photo & Add Video)
        Row(
          children: [
            Expanded(
              child: _buildUploadButton(
                icon: Icons.image_outlined,
                label: "Add Photo",
                onTap: () => controller.pickImage(),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _buildUploadButton(
                icon: Icons.videocam_outlined,
                label: "Add Video",
                onTap: () => controller.pickVideo(),
              ),
            ),
          ],
        ),
        20.verticalSpace,

        // প্রিভিউ সেকশন
        Obx(() => Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [

            ...controller.selectedImages.asMap().entries.map((entry) {
              return _buildPreviewCard(
                file: entry.value,
                isVideo: false,
                onRemove: () => controller.removeImage(entry.key),
              );
            }),

            ...controller.selectedVideos.asMap().entries.map((entry) {
              return _buildPreviewCard(
                file: entry.value,
                isVideo: true,
                onRemove: () => controller.removeVideo(entry.key),
              );
            }),
          ],
        )),
      ],
    );
  }

  Widget _buildUploadButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blueGrey),
            8.horizontalSpace,
            Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }


  Widget _buildPreviewCard({required File file, required bool isVideo, required VoidCallback onRemove}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: Colors.grey[100],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: isVideo
                ? Icon(Icons.videocam, size: 40.sp, color: Colors.grey)
                : Image.file(file, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: -5.h,
          right: -5.w,
          child: GestureDetector(
            onTap: onRemove,
            child: CircleAvatar(
              radius: 12.r,
              backgroundColor: Colors.red,
              child: Icon(Icons.close, size: 16.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
