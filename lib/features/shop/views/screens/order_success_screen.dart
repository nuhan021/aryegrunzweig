import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../controller/shop_controller.dart';
import '../../../orders/controller/orders_controller.dart';
import '../../../orders/views/screens/order_delivered_screen.dart';
import '../../../orders/views/screens/order_tracking_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  OrderSuccessScreen({super.key});

  final ShopController controller = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    final deliveryDate = controller.lastOrderDeliveryDate;
    final apiOrder = controller.completedOrder.value;
    final placedOrder = apiOrder == null ? null : ShopOrder(api: apiOrder);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              20.verticalSpace,
              Container(
                height: 72.w,
                width: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.check, color: AppColors.primary, size: 36.sp),
              ),
              20.verticalSpace,
              Text(
                'Order Placed Successfully',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              10.verticalSpace,
              Text(
                'Thank you for your purchase. Your order has been confirmed and is being processed for professional delivery.',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
              24.verticalSpace,

              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ORDER ID',
                              style: getTextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              '#${controller.lastOrderId ?? ''}',
                              style: getTextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified,
                                size: 14.sp,
                                color: AppColors.primary,
                              ),
                              4.horizontalSpace,
                              Text(
                                'PAID',
                                style: getTextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,

                    ...controller.lastOrderLines.map(
                      (line) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 70.h,
                              width: 70.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.grey.shade400,
                                size: 26.sp,
                              ),
                            ),
                            10.horizontalSpace,
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
                                  8.verticalSpace,
                                  Text(
                                    'Qty: ${line.quantity}',
                                    style: getTextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    _SummaryLine(
                      label: 'Subtotal',
                      value: controller.lastOrderSubtotal,
                    ),
                    _SummaryLine(
                      label: 'Estimated Tax',
                      value: controller.lastOrderTax,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Divider(color: Colors.grey.shade200, height: 1),
                    ),
                    _SummaryLine(
                      label: 'Total Amount',
                      value: controller.lastOrderTotal,
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              16.verticalSpace,

              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DELIVERY ADDRESS',
                            style: getTextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          8.verticalSpace,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                              6.horizontalSpace,
                              Expanded(
                                child: Text(
                                  controller.shippingAddressSummary,
                                  style: getTextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ESTIMATED DELIVERY',
                            style: getTextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          8.verticalSpace,
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                              6.horizontalSpace,
                              Expanded(
                                child: Text(
                                  deliveryDate == null
                                      ? '-'
                                      : DateFormat(
                                          'MMMM d, yyyy',
                                        ).format(deliveryDate),
                                  style: getTextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              24.verticalSpace,

              SrPrimaryButton(
                text: 'View Order Details',
                onPressed: placedOrder == null
                    ? () {}
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              placedOrder.status == OrderStatus.delivered
                              ? OrderDeliveredScreen(order: placedOrder)
                              : OrderTrackingScreen(order: placedOrder),
                        ),
                      ),
              ),
              10.verticalSpace,
              GestureDetector(
                onTap: placedOrder == null
                    ? null
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              OrderTrackingScreen(order: placedOrder),
                        ),
                      ),
                child: Container(
                  height: 50.h,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 18.sp,
                        color: Colors.black87,
                      ),
                      8.horizontalSpace,
                      Text(
                        'Track Order',
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              SrOutlineButton(
                text: 'Continue Shopping',
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final double value;
  final bool isTotal;

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
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              color: isTotal ? AppColors.primary : Colors.grey.shade600,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: getTextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: isTotal ? AppColors.primary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
