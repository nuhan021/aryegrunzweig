import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/hosted_checkout_webview.dart';
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
  final ServicesController controller = Get.find<ServicesController>();
  String? paymentId;
  String status = 'Not started';
  bool checking = false;

  Future<void> _openStripeCheckout() async {
    final authorization = await controller.authorizePayment(widget.request);
    if (authorization == null || !mounted) return;
    paymentId = authorization.paymentId;
    final checkoutUrl = authorization.checkoutUrl;
    if (checkoutUrl == null || checkoutUrl.isEmpty) {
      await _refreshStatus();
      return;
    }
    setState(() => status = 'Waiting for Stripe confirmation');
    final checkoutResult = await Navigator.push<HostedCheckoutResult>(
      context,
      MaterialPageRoute(
        builder: (_) => HostedCheckoutWebView(
          checkoutUrl: checkoutUrl,
          title: 'Authorize payment',
        ),
      ),
    );
    if (!mounted) return;
    if (checkoutResult == HostedCheckoutResult.cancelled) {
      setState(() => status = 'Checkout cancelled');
    }
    await _refreshStatus();
  }

  Future<void> _refreshStatus() async {
    final id = paymentId;
    if (id == null || checking) return;
    setState(() => checking = true);
    final payment = await controller.paymentStatus(id);
    if (!mounted) return;
    setState(() {
      checking = false;
      if (payment != null) status = payment.status;
    });
    if (payment != null &&
        const {
          'AUTHORIZED',
          'CAPTURED',
          'SUCCEEDED',
        }.contains(payment.status)) {
      final refreshed = await controller.refreshOne(widget.request);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PaymentConfirmedScreen(request: refreshed ?? widget.request),
        ),
      );
    }
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
              title: 'Authorize service payment',
              subtitle:
                  'Payment is completed securely on Stripe. This app never collects your card number or CVV.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Amount to authorize',
                            style: getTextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF667C9B),
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            '\$${request.quotedAmount.toStringAsFixed(2)} CAD',
                            style: getTextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.verticalSpace,
                    Icon(
                      Icons.lock_outline,
                      size: 54.sp,
                      color: AppColors.primary,
                    ),
                    14.verticalSpace,
                    Text(
                      'Secure hosted checkout',
                      style: getTextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      'Stripe Checkout opens securely inside the app. Close it after completing or cancelling payment.',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF667C9B),
                        lineHeight: 1.5,
                      ),
                    ),
                    20.verticalSpace,
                    Text(
                      'Status: $status',
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Obx(
                    () => SrPrimaryButton(
                      text: controller.isActionLoading.value
                          ? 'Opening Stripe...'
                          : 'Continue to Stripe Checkout',
                      onPressed: controller.isActionLoading.value
                          ? () {}
                          : _openStripeCheckout,
                    ),
                  ),
                  if (paymentId != null) 10.verticalSpace,
                  if (paymentId != null)
                    SrOutlineButton(
                      text: checking ? 'Checking...' : 'Refresh payment status',
                      onPressed: checking ? () {} : _refreshStatus,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
