import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/orders_controller.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    final steps = order.api.timeline;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: order.itemName,
              subtitle: 'Order Code: #${order.orderCode}',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          Text(
                            'Delivery Timeline',
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          14.verticalSpace,
                          ...List.generate(steps.length, (index) {
                            final isLast = index == steps.length - 1;
                            return _TimelineStep(
                              title: steps[index].label,
                              date: steps[index].at == null
                                  ? null
                                  : DateFormat(
                                      'MMMM d',
                                    ).format(steps[index].at!.toLocal()),
                              isReached:
                                  steps[index].completed ||
                                  steps[index].current,
                              isLast: isLast,
                            );
                          }),
                        ],
                      ),
                    ),
                    16.verticalSpace,

                    if (order.api.canCancel)
                      GestureDetector(
                        onTap: () async {
                          final cancelled = await controller.cancelOrder(order);
                          if (cancelled && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: 50.h,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Text(
                            'Cancel order',
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade500,
                            ),
                          ),
                        ),
                      ),
                    if (order.api.canCancel) 16.verticalSpace,

                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tracking number',
                            style: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            order.trackingNumber,
                            style: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50.h,
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'Track Order',
                          style: getTextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    16.verticalSpace,

                    Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        'Returns require approval by Central Care before the item is sent back.',
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade600,
                          lineHeight: 1.4,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.title,
    required this.date,
    required this.isReached,
    required this.isLast,
  });

  final String title;
  final String? date;
  final bool isReached;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = isReached ? AppColors.primary : Colors.grey.shade300;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 12.w,
                width: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isReached ? AppColors.primary : Colors.white,
                  border: Border.all(color: color, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2.w, color: color),
                ),
            ],
          ),
          10.horizontalSpace,
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isReached ? Colors.black : Colors.grey.shade400,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  if (date != null) ...[
                    2.verticalSpace,
                    Text(
                      date!,
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
