import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/common/widgets/custom_text_field.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../controller/shop_controller.dart';
import 'order_success_screen.dart';

class OrderSummaryScreen extends StatelessWidget {
  OrderSummaryScreen({super.key});

  final ShopController controller = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Order Summary',
              subtitle:
                  'Review your items, delivery details, and total before placing your order.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...controller.cart.map(
                        (line) => Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 80.h,
                                width: 80.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image_outlined,
                                  color: Colors.grey.shade400,
                                  size: 28.sp,
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      line.product.name,
                                      style: getTextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    2.verticalSpace,
                                    Text(
                                      line.product.subtitle,
                                      style: getTextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade600,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    10.verticalSpace,
                                    _QuantityStepper(
                                      quantity: line.quantity.value,
                                      onDecrement: () => controller
                                          .decrementQuantity(line),
                                      onIncrement: () => controller
                                          .incrementQuantity(line),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        controller.removeFromCart(line),
                                    child: Container(
                                      height: 22.w,
                                      width: 22.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade100,
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.close,
                                        size: 13.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace,
                                  Text(
                                    '\$${line.product.price.toStringAsFixed(2)}',
                                    style: getTextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      _PriceRow(label: 'Subtotal', value: controller.subtotal),
                      _PriceRow(
                        label: 'Shipping',
                        valueText: 'FREE',
                        valueColor: const Color(0xFF2E7D32),
                      ),
                      _PriceRow(
                        label: 'Estimated Tax',
                        value: controller.estimatedTax,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Divider(color: Colors.grey.shade200, height: 1),
                      ),
                      _PriceRow(
                        label: 'Total',
                        value: controller.total,
                        isBold: true,
                      ),

                      24.verticalSpace,
                      _SectionTitle('Contact Information'),
                      12.verticalSpace,
                      _FieldLabel('Email'),
                      8.verticalSpace,
                      CustomTextField(
                        controller: controller.emailController,
                        hintText: 'info@gmail.com',
                        inputType: TextInputType.emailAddress,
                      ),

                      24.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SectionTitle('Shipping Address'),
                          Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                              4.horizontalSpace,
                              Text(
                                'Add New',
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      14.verticalSpace,

                      Row(
                        children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'Name',
                              hint: 'info@gmail.com',
                              controller: controller.nameController,
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: _LabeledField(
                              label: 'Phone',
                              hint: 'info@gmail.com',
                              controller: controller.phoneController,
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      _LabeledField(
                        label: 'Apartment/ suite',
                        hint: 'Apartment',
                        controller: controller.apartmentController,
                      ),
                      16.verticalSpace,
                      _LabeledField(
                        label: 'Country',
                        hint: 'Info',
                        controller: controller.countryController,
                      ),
                      16.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: _LabeledField(
                              label: 'State',
                              hint: 'Info',
                              controller: controller.stateController,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: _LabeledField(
                              label: 'City',
                              hint: 'Info',
                              controller: controller.cityController,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: _LabeledField(
                              label: 'Zip code',
                              hint: '1234',
                              controller: controller.zipController,
                              inputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      14.verticalSpace,

                      GestureDetector(
                        onTap: controller.toggleSaveAddress,
                        child: Row(
                          children: [
                            Icon(
                              controller.saveAddress.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 20.sp,
                              color: controller.saveAddress.value
                                  ? AppColors.primary
                                  : Colors.grey,
                            ),
                            8.horizontalSpace,
                            Expanded(
                              child: Text(
                                'Save this address for future purchases',
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      24.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SectionTitle('Payment Method'),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 14.sp,
                                  color: Colors.white,
                                ),
                                6.horizontalSpace,
                                Text(
                                  'SECURE PAYMENT',
                                  style: getTextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      24.verticalSpace,
                      SrPrimaryButton(
                        text: 'Place Order',
                        onPressed: () {
                          controller.placeOrder();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderSuccessScreen(),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                      ),
                      10.verticalSpace,
                      Text(
                        'By placing this order, you agree to our Terms of Service and Privacy Policy. Secure 256-bit SSL encrypted transaction.',
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500,
                        ),
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

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(Icons.remove, size: 14.sp, color: Colors.grey.shade600),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              '$quantity',
              style: getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(Icons.add, size: 14.sp, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    this.value,
    this.valueText,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final double? value;
  final String? valueText;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          Text(
            valueText ?? '\$${value!.toStringAsFixed(2)}',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getTextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getTextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.inputType = TextInputType.text,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        8.verticalSpace,
        CustomTextField(
          controller: controller,
          hintText: hint,
          inputType: inputType,
        ),
      ],
    );
  }
}
