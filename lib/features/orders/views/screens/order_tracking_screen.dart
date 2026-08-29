import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/orders_controller.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.order});

  final ShopOrder order;

  int get _reachedStepIndex {
    switch (order.status) {
      case OrderStatus.processing:
        return 2;
      case OrderStatus.shipped:
        return 3;
      case OrderStatus.delivered:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    final placedDate = DateFormat('MMMM d').format(order.orderDate);
    final steps = [
      ('Order placed', placedDate),
      ('Paid', placedDate),
      ('Processing', null),
      ('Shipped', null),
      ('Delivered', null),
    ];

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
                            final isReached = index <= _reachedStepIndex;
                            final isLast = index == steps.length - 1;
                            return _TimelineStep(
                              title: steps[index].$1,
                              date: steps[index].$2,
                              isReached: isReached,
                              isLast: isLast,
                            );
                          }),
                        ],
                      ),
                    ),
                    16.verticalSpace,

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
