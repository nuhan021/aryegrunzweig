import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../controller/technician_equipment_controller.dart';

class TechnicianEditEquipmentScreen extends StatefulWidget {
  const TechnicianEditEquipmentScreen({super.key, required this.controller});

  final TechnicianEquipmentController controller;

  @override
  State<TechnicianEditEquipmentScreen> createState() =>
      _TechnicianEditEquipmentScreenState();
}

class _TechnicianEditEquipmentScreenState
    extends State<TechnicianEditEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [
      TextEditingController(text: widget.controller.unitNumber.value),
      TextEditingController(text: widget.controller.manufacturer.value),
      TextEditingController(text: widget.controller.model.value),
      TextEditingController(text: widget.controller.serialNumber.value),
      TextEditingController(text: widget.controller.location.value),
      TextEditingController(text: widget.controller.previousCondition.value),
    ];
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final saved = await widget.controller.updateEquipment(
      unit: _controllers[0].text,
      brand: _controllers[1].text,
      modelName: _controllers[2].text,
      serial: _controllers[3].text,
      unitLocation: _controllers[4].text,
      condition: _controllers[5].text,
    );
    if (!saved || !mounted) return;
    AppHelperFunctions.showSuccessSnackBar('Equipment details saved.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Unit number',
      'Manufacturer',
      'Model',
      'Serial number',
      'Location',
      'Previous condition',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _EditHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 28.h, 16.w, 30.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Main Vacuum Unit',
                        style: getTextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF172231),
                        ),
                      ),
                      26.verticalSpace,
                      ...List.generate(
                        labels.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: _EquipmentField(
                            label: labels[index],
                            controller: _controllers[index],
                          ),
                        ),
                      ),
                      22.verticalSpace,
                      Obx(
                        () => _ActionButton(
                          label: 'Save changes',
                          primary: true,
                          isLoading: widget.controller.isSaving.value,
                          onTap: _save,
                        ),
                      ),
                      12.verticalSpace,
                      _ActionButton(
                        label: 'Cancel',
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
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

class _EditHeader extends StatelessWidget {
  const _EditHeader();

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
            'Edit Equipment Details',
            style: getTextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          7.verticalSpace,
          Text(
            'Update the equipment information and save your changes.',
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

class _EquipmentField extends StatelessWidget {
  const _EquipmentField({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        8.verticalSpace,
        TextFormField(
          controller: controller,
          validator: (value) => value == null || value.trim().isEmpty
              ? 'This field is required'
              : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.r),
              borderSide: const BorderSide(color: Color(0xFFDCE1E7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.r),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onTap,
    this.primary = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 54.h,
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: isLoading
            ? SizedBox(
                height: 22.w,
                width: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: primary ? Colors.white : AppColors.primary,
                ),
              )
            : Text(
                label,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: primary ? Colors.white : Colors.black,
                ),
              ),
      ),
    );
  }
}
