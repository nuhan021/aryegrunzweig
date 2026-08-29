import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../controller/services_controller.dart';

class PriceNegotiationScreen extends StatefulWidget {
  const PriceNegotiationScreen({super.key, required this.request});

  final ServiceRequest request;

  @override
  State<PriceNegotiationScreen> createState() => _PriceNegotiationScreenState();
}

class _PriceNegotiationScreenState extends State<PriceNegotiationScreen> {
  late double parts = widget.request.partsAndMaterials;
  late double tax = widget.request.tax;
  late double discount = widget.request.discount;
  final noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void _sendRequest() {
    if (noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a negotiation note.')),
      );
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Negotiation request sent.')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Price Negotiation',
              subtitle: 'Manage and track price negotiations',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StepperField(
                      label: 'Parts and materials',
                      value: parts,
                      onIncrement: () => setState(() => parts += 5),
                      onDecrement: () =>
                          setState(() => parts = (parts - 5).clamp(0, 999999)),
                    ),
                    18.verticalSpace,
                    _StepperField(
                      label: 'Tax',
                      value: tax,
                      onIncrement: () => setState(() => tax += 1),
                      onDecrement: () =>
                          setState(() => tax = (tax - 1).clamp(0, 999999)),
                    ),
                    18.verticalSpace,
                    _StepperField(
                      label: 'Discount',
                      value: -discount,
                      onIncrement: () => setState(() => discount += 5),
                      onDecrement: () => setState(
                        () => discount = (discount - 5).clamp(0, 999999),
                      ),
                    ),
                    18.verticalSpace,

                    Text(
                      'Quote Breakdown Note',
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    8.verticalSpace,
                    CustomTextField(
                      controller: noteController,
                      hintText:
                          'Please describe the problem. For example: suction is weak in the basement, the unit makes unusual noise, or an inlet valve is broken.',
                      maxLine: 5,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SrPrimaryButton(
                text: 'Send Request',
                onPressed: _sendRequest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperField extends StatelessWidget {
  const _StepperField({
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final double value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            textAlign: TextAlign.left,
          ),
        ),
        8.verticalSpace,
        Container(
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
                  '${value < 0 ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onIncrement,
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size: 18.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  GestureDetector(
                    onTap: onDecrement,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
