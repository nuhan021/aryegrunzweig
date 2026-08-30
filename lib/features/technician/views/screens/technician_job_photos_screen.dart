import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/technician_jobs_controller.dart';

class TechnicianJobPhotosScreen extends StatefulWidget {
  const TechnicianJobPhotosScreen({super.key});

  @override
  State<TechnicianJobPhotosScreen> createState() =>
      _TechnicianJobPhotosScreenState();
}

class _TechnicianJobPhotosScreenState extends State<TechnicianJobPhotosScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _beforePhotos = List<XFile?>.filled(3, null);
  final List<XFile?> _afterPhotos = List<XFile?>.filled(3, null);
  final TechnicianJobsController _jobs = Get.find<TechnicianJobsController>();
  bool _uploading = false;

  Future<void> _pickPhoto(List<XFile?> target, int index) async {
    final photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (photo == null || !mounted) return;
    setState(() => target[index] = photo);
  }

  Future<void> _upload() async {
    final hasBeforePhoto = _beforePhotos.any((photo) => photo != null);
    final hasAfterPhoto = _afterPhotos.any((photo) => photo != null);
    if (!hasBeforePhoto || !hasAfterPhoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add at least one before and one after photo.'),
        ),
      );
      return;
    }
    setState(() => _uploading = true);
    var successful = true;
    for (final photo in _beforePhotos.whereType<XFile>()) {
      successful = await _jobs.uploadMedia('BEFORE', photo.path) && successful;
    }
    for (final photo in _afterPhotos.whereType<XFile>()) {
      successful = await _jobs.uploadMedia('AFTER', photo.path) && successful;
    }
    if (!mounted) return;
    setState(() => _uploading = false);
    if (!successful) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job photos uploaded successfully.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _PhotosHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 20.h),
                child: Column(
                  children: [
                    _PhotoGroup(
                      title: 'Before Photos',
                      photos: _beforePhotos,
                      onTap: (index) => _pickPhoto(_beforePhotos, index),
                      onRemove: (index) =>
                          setState(() => _beforePhotos[index] = null),
                    ),
                    22.verticalSpace,
                    _PhotoGroup(
                      title: 'After Photos',
                      photos: _afterPhotos,
                      onTap: (index) => _pickPhoto(_afterPhotos, index),
                      onRemove: (index) =>
                          setState(() => _afterPhotos[index] = null),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 22.h),
              child: GestureDetector(
                onTap: _uploading ? null : _upload,
                child: Container(
                  height: 54.h,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Text(
                    _uploading ? 'Uploading...' : 'Upload Photos',
                    style: getTextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotosHeader extends StatelessWidget {
  const _PhotosHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 22.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, size: 22.sp, color: Colors.white),
                Text(
                  'Back',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,
          Text(
            'Upload Before / After Photos',
            style: getTextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          8.verticalSpace,
          Text(
            'Add photos showing the condition before and after the service.',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              lineHeight: 1.4,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoGroup extends StatelessWidget {
  const _PhotoGroup({
    required this.title,
    required this.photos,
    required this.onTap,
    required this.onRemove,
  });

  final String title;
  final List<XFile?> photos;
  final ValueChanged<int> onTap;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getTextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF172231),
            ),
          ),
          16.verticalSpace,
          Row(
            children: List.generate(
              photos.length,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 2 ? 0 : 8.w),
                  child: _PhotoSlot(
                    label: 'Image ${index + 1}',
                    photo: photos[index],
                    onTap: () => onTap(index),
                    onRemove: () => onRemove(index),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.label,
    required this.photo,
    required this.onTap,
    required this.onRemove,
  });

  final String label;
  final XFile? photo;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 92.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFBFCFE),
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: const Color(0xFFDCE5EF), width: 1.5),
        ),
        child: photo == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 30.sp,
                    color: const Color(0xFF92A7C5),
                  ),
                  8.verticalSpace,
                  Text(
                    label,
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF667C9B),
                    ),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(File(photo!.path), fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: Colors.black54,
                        child: Icon(
                          Icons.close,
                          size: 13.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
