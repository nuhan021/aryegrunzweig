import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../controller/home_controller.dart';

class ServiceRequestMediaUpload extends StatelessWidget {
  ServiceRequestMediaUpload({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          // Read observables directly in Obx. LayoutBuilder executes its
          // callback later, outside GetX's dependency-tracking scope.
          final images = List<File>.of(controller.srImages);
          final mediaCount = images.length + controller.srVideos.length;
          return LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 12.w) / 2;
              final canAddMore = mediaCount < 10;
              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  ...images.asMap().entries.map(
                    (entry) => SizedBox(
                      width: tileWidth,
                      child: _MediaPreviewTile(
                        file: entry.value,
                        isVideo: false,
                        onRemove: () => controller.srRemoveImage(entry.key),
                      ),
                    ),
                  ),
                  if (canAddMore)
                    SizedBox(
                      width: tileWidth,
                      child: _UploadBox(
                        icon: Icons.collections_outlined,
                        label: images.isEmpty
                            ? 'Add photos'
                            : 'Add more photos',
                        onTap: () => controller.srPickImage(),
                      ),
                    ),
                ],
              );
            },
          );
        }),
        12.verticalSpace,
        Obx(
          () => controller.srVideos.isNotEmpty
              ? _MediaPreviewTile(
                  file: controller.srVideos.first,
                  isVideo: true,
                  onRemove: () => controller.srRemoveVideo(0),
                  height: 130.h,
                )
              : _UploadBox(
                  icon: Icons.videocam_outlined,
                  label: 'Add videos',
                  height: 130.h,
                  onTap: () => controller.srPickVideo(),
                ),
        ),
      ],
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.icon,
    required this.label,
    required this.onTap,
    this.height = 100,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorderBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey.shade500, size: 24.sp),
            8.verticalSpace,
            Text(
              label,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.child, this.height = 100});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(radius: 12.r),
      child: Container(
        height: height,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.radius});

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      const dashWidth = 5.0;
      const dashGap = 4.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MediaPreviewTile extends StatelessWidget {
  const _MediaPreviewTile({
    required this.file,
    required this.isVideo,
    required this.onRemove,
    this.height = 100,
  });

  final File file;
  final bool isVideo;
  final VoidCallback onRemove;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: height,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.grey.shade100,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: isVideo
                ? Icon(Icons.videocam, size: 32.sp, color: Colors.grey.shade500)
                : Image.file(file, fit: BoxFit.cover, width: double.maxFinite),
          ),
        ),
        Positioned(
          top: -6.h,
          right: -6.w,
          child: GestureDetector(
            onTap: onRemove,
            child: CircleAvatar(
              radius: 11.r,
              backgroundColor: Colors.red,
              child: Icon(Icons.close, size: 14.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
