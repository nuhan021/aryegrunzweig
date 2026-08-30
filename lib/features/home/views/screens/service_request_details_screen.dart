import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/home/views/screens/service_request_media_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/home_controller.dart';
import '../widgets/service_request_buttons.dart';

class ServiceRequestDetailsScreen extends StatelessWidget {
  ServiceRequestDetailsScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  final List<String> _timeOptions = const [
    '09:00-12:00',
    '12:00-15:00',
    '15:00-18:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: "Tell us what's happening",
              subtitle:
                  'Share the details so we can better understand and help.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Service address'),
                    8.verticalSpace,
                    _AddressDropdown(controller: controller),
                    20.verticalSpace,

                    _Label('Preferred date'),
                    8.verticalSpace,
                    _DateField(controller: controller),
                    20.verticalSpace,

                    _Label('Preferred time'),
                    8.verticalSpace,
                    _TimeDropdown(
                      controller: controller,
                      options: _timeOptions,
                    ),
                    20.verticalSpace,

                    _Label('Describe the issue'),
                    8.verticalSpace,
                    CustomTextField(
                      controller: controller.srDescriptionController,
                      hintText:
                          'Please describe the problem. For example: suction is weak in the basement, the unit makes unusual noise, or an inlet valve is broken.',
                      maxLine: 5,
                    ),
                    10.verticalSpace,
                    Text(
                      'You may suggest a preferred day and time. The office will confirm the final appointment time.',
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SrPrimaryButton(
                text: 'Continue',
                onPressed: () => AppHelperFunctions.navigateToScreen(
                  context,
                  ServiceRequestMediaScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getTextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _AddressDropdown extends StatelessWidget {
  const _AddressDropdown({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.srAddresses.isEmpty) {
        return Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            'Add a saved address from Profile before requesting service.',
            style: getTextStyle(
              fontSize: 12.sp,
              color: Colors.orange.shade800,
              textAlign: TextAlign.left,
            ),
          ),
        );
      }
      return DropdownButtonFormField<String>(
        initialValue: controller.srSelectedAddressId.value.isEmpty
            ? null
            : controller.srSelectedAddressId.value,
        decoration: const InputDecoration(hintText: 'Select service address'),
        items: controller.srAddresses
            .map(
              (address) => DropdownMenuItem(
                value: address.id,
                child: Text('${address.line1}, ${address.city}'),
              ),
            )
            .toList(),
        onChanged: (id) {
          if (id == null) return;
          controller.srSelectAddress(
            controller.srAddresses.firstWhere((item) => item.id == id),
          );
        },
      );
    });
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final date = controller.srPreferredDate.value;
      return GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (picked != null) controller.srSetPreferredDate(picked);
        },
        child: Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  date == null
                      ? 'mm/dd/yyyy'
                      : DateFormat('MM/dd/yyyy').format(date),
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: date == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.calendar_today_outlined,
                size: 18.sp,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _TimeDropdown extends StatelessWidget {
  const _TimeDropdown({required this.controller, required this.options});

  final HomeController controller;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: controller.srPreferredTime.value.isEmpty
                ? null
                : controller.srPreferredTime.value,
            hint: Text(
              'Select Time',
              style: getTextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
              size: 20.sp,
            ),
            items: options
                .map(
                  (time) => DropdownMenuItem(
                    value: time,
                    child: Text(
                      time,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) controller.srSetPreferredTime(value);
            },
          ),
        ),
      ),
    );
  }
}
