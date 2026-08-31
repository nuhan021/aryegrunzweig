import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/common/widgets/hosted_checkout_webview.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../../orders/controller/orders_controller.dart';
import '../../controller/shop_controller.dart';
import 'order_success_screen.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  final ShopController controller = Get.find<ShopController>();
  bool checkingPayment = false;

  @override
  void initState() {
    super.initState();
    controller.loadPreview();
  }

  Future<void> _placeOrder() async {
    final session = await controller.placeOrder();
    if (session == null || !mounted) return;
    final checkoutResult = await Navigator.push<HostedCheckoutResult>(
      context,
      MaterialPageRoute(
        builder: (_) => HostedCheckoutWebView(
          checkoutUrl: session.checkoutUrl,
          title: 'Complete payment',
        ),
      ),
    );
    if (!mounted) return;
    if (checkoutResult == HostedCheckoutResult.cancelled) return;
    await _refreshPayment(
      attempts: checkoutResult == HostedCheckoutResult.completed ? 8 : 3,
    );
  }

  Future<void> _refreshPayment({int attempts = 4}) async {
    if (checkingPayment) return;
    setState(() => checkingPayment = true);
    final order = await controller.waitForCheckoutPayment(attempts: attempts);
    if (!mounted) return;
    setState(() => checkingPayment = false);
    if (order == null || !controller.isOrderPaid(order)) {
      AppHelperFunctions.showErrorSnackBar(
        'Payment is not confirmed yet. If Stripe charged you, wait a moment and refresh again.',
      );
      return;
    }
    await controller.finishPaidCheckout(order);
    if (Get.isRegistered<OrdersController>()) {
      await Get.find<OrdersController>().loadAll();
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrderSuccessScreen()),
    );
  }

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
                              _CartProductImage(
                                imageUrl: controller.cartProductImage(line),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      quantity: line.quantity,
                                      isSyncing: controller
                                          .isUpdatingCartProduct(
                                            line.api.productId,
                                          ),
                                      onDecrement: () =>
                                          controller.decrementQuantity(line),
                                      onIncrement: () =>
                                          controller.incrementQuantity(line),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap:
                                        controller.isRemovingCartProduct(
                                          line.api.productId,
                                        )
                                        ? null
                                        : () => controller.removeFromCart(line),
                                    child: Container(
                                      height: 22.w,
                                      width: 22.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade100,
                                      ),
                                      alignment: Alignment.center,
                                      child:
                                          controller.isRemovingCartProduct(
                                            line.api.productId,
                                          )
                                          ? SizedBox(
                                              height: 13.w,
                                              width: 13.w,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 1.8,
                                                  ),
                                            )
                                          : Icon(
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
                      _SectionTitle('Saved Shipping Address'),
                      14.verticalSpace,
                      if (controller.addresses.isEmpty)
                        Text(
                          'Add a saved address from Profile before checkout.',
                          style: getTextStyle(
                            fontSize: 12.sp,
                            color: Colors.orange.shade800,
                            textAlign: TextAlign.left,
                          ),
                        )
                      else
                        DropdownButtonFormField<String>(
                          initialValue:
                              controller.selectedShippingAddressId.value,
                          items: controller.addresses
                              .map(
                                (address) => DropdownMenuItem(
                                  value: address.id,
                                  child: Text(
                                    '${address.line1}, ${address.city}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: controller.isPreviewLoading.value
                              ? null
                              : (id) {
                                  if (id != null) {
                                    controller.selectShippingAddress(id);
                                  }
                                },
                        ),

                      if (controller.isPreviewLoading.value) ...[
                        8.verticalSpace,
                        const LinearProgressIndicator(minHeight: 2),
                      ],

                      10.verticalSpace,
                      Text(
                        'Tax, shipping, and total are calculated by the server for the selected address.',
                        style: getTextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                          lineHeight: 1.4,
                          textAlign: TextAlign.left,
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
                        text: controller.isCheckoutLoading.value
                            ? 'Opening Stripe...'
                            : 'Continue to secure payment',
                        isLoading: controller.isCheckoutLoading.value,
                        onPressed: controller.isCheckoutLoading.value
                            ? () {}
                            : _placeOrder,
                      ),
                      if (controller.checkoutSession.value != null)
                        TextButton(
                          onPressed: checkingPayment ? null : _refreshPayment,
                          child: checkingPayment
                              ? const SizedBox(
                                  height: 19,
                                  width: 19,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.1,
                                  ),
                                )
                              : const Text('Refresh payment status'),
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
    required this.isSyncing,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final bool isSyncing;
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
              child: Icon(
                Icons.remove,
                size: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$quantity',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                if (isSyncing) ...[
                  5.horizontalSpace,
                  SizedBox(
                    width: 10.w,
                    height: 10.w,
                    child: const CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                ],
              ],
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

class _CartProductImage extends StatelessWidget {
  const _CartProductImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.image_outlined,
      color: Colors.grey.shade400,
      size: 28.sp,
    );

    return Container(
      height: 80.h,
      width: 80.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: imageUrl == null || imageUrl!.trim().isEmpty
          ? placeholder
          : CachedNetworkImage(
              imageUrl: imageUrl!,
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.contain,
              placeholder: (_, __) => Center(
                child: SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => placeholder,
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
