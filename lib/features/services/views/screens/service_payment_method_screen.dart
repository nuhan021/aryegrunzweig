import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../controller/services_controller.dart';
import 'payment_confirmed_screen.dart';

class ServicePaymentMethodScreen extends StatefulWidget {
  const ServicePaymentMethodScreen({super.key, required this.request});

  final ServiceRequest request;

  @override
  State<ServicePaymentMethodScreen> createState() =>
      _ServicePaymentMethodScreenState();
}

class _ServicePaymentMethodScreenState
    extends State<ServicePaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController cardholderController;
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cardholderController = TextEditingController(
      text: widget.request.requestedByName,
    );
  }

  @override
  void dispose() {
    cardholderController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  void _authorize() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (Get.isRegistered<ServicesController>()) {
      Get.find<ServicesController>().authorizeAndSchedule(widget.request);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentConfirmedScreen(request: widget.request),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Confirm your payment method',
              subtitle:
                  'Your card will be authorized for the quoted amount. You will not be charged until service is completed.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6EDF3),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount to authorize',
                              style: getTextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              '\$${request.quotedAmount.toStringAsFixed(2)}',
                              style: getTextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      const _Label('Cardholder name'),
                      8.verticalSpace,
                      _PaymentField(
                        controller: cardholderController,
                        hintText: request.requestedByName,
                        validator: _requiredValidator,
                        textCapitalization: TextCapitalization.words,
                      ),
                      16.verticalSpace,
                      const _Label('Card number'),
                      8.verticalSpace,
                      _PaymentField(
                        controller: cardNumberController,
                        hintText: '1234 1234 1234 1234',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        validator: (value) {
                          final digits = (value ?? '').replaceAll(' ', '');
                          return digits.length == 16
                              ? null
                              : 'Enter a valid 16-digit card number';
                        },
                      ),
                      16.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _Label('Expiry date'),
                                8.verticalSpace,
                                _PaymentField(
                                  controller: expiryController,
                                  hintText: 'mm/yy',
                                  keyboardType: TextInputType.datetime,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(5),
                                  ],
                                  validator: (value) {
                                    final valid = RegExp(
                                      r'^(0[1-9]|1[0-2])/\d{2}$',
                                    ).hasMatch(value ?? '');
                                    return valid ? null : 'Use mm/yy';
                                  },
                                ),
                              ],
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _Label('CVV'),
                                8.verticalSpace,
                                _PaymentField(
                                  controller: cvvController,
                                  hintText: '•••',
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  validator: (value) {
                                    final length = value?.length ?? 0;
                                    return length == 3 || length == 4
                                        ? null
                                        : 'Enter 3–4 digits';
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      const _Label('Billing postal code'),
                      8.verticalSpace,
                      _PaymentField(
                        controller: postalCodeController,
                        hintText: 'H3Z 2B2',
                        validator: _requiredValidator,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                children: [
                  SrPrimaryButton(
                    text:
                        'Authorize \$${request.quotedAmount.toStringAsFixed(2)}',
                    onPressed: _authorize,
                  ),
                  10.verticalSpace,
                  Text(
                    'Secured with 256-bit SSL encryption',
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required'
        : null;
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

class _PaymentField extends StatelessWidget {
  const _PaymentField({
    required this.controller,
    required this.hintText,
    required this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: getTextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
