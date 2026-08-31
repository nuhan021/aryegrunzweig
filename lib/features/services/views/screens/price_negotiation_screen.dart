import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
  late double requestedTotal = widget.request.quotedAmount;
  final noteController = TextEditingController();
  final ServicesController controller = Get.find<ServicesController>();

  @override
  void initState() {
    super.initState();
    controller.loadCounteroffers(widget.request);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  Future<void> _sendRequest() async {
    final success = await controller.submitCounteroffer(
      widget.request,
      requestedTotal: requestedTotal,
      note: noteController.text.trim(),
    );
    if (success && mounted) Navigator.pop(context);
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
                      label: 'Your proposed total',
                      value: requestedTotal,
                      onIncrement: () => setState(() => requestedTotal += 5),
                      onDecrement: () => setState(
                        () => requestedTotal = (requestedTotal - 5).clamp(
                          0.01,
                          999999,
                        ),
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
                    20.verticalSpace,
                    Obx(
                      () => controller.counterofferHistory.isEmpty
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Negotiation history',
                                  style: getTextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                8.verticalSpace,
                                ...controller.counterofferHistory.map(
                                  (offer) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      '\$${offer.requestedTotal.toStringAsFixed(2)} · ${offer.status}',
                                    ),
                                    subtitle: offer.note == null
                                        ? null
                                        : Text(offer.note!),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Obx(
                () => SrPrimaryButton(
                  text: 'Send Request',
                  isLoading: controller.isActionLoading.value,
                  onPressed: _sendRequest,
                ),
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
