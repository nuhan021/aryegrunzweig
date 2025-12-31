import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';

class SystemTypeDropdown extends StatelessWidget {
  final Rx<String> selectedType;
  final List<String> options;
  final Function(String)? onChanged;

  const SystemTypeDropdown({
    super.key,
    required this.selectedType,
    required this.options,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Type',
          style: getTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF495565),
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD0D5DB), width: 0.67),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedType.value,
                isExpanded: true,
                hint: Text('Select System Type'),
                icon: const Icon(Icons.expand_more),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedType.value = newValue;
                    onChanged?.call(newValue);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
