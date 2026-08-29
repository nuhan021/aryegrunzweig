import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../controller/orders_controller.dart';

class OrderDeliveredScreen extends StatelessWidget {
  const OrderDeliveredScreen({super.key, required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.check, color: AppColors.primary, size: 36.sp),
              ),
              20.verticalSpace,
              Text(
                'Order Delivered Successfully',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              10.verticalSpace,
              Text(
                'Your order has been delivered. Enjoy!',
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
              28.verticalSpace,

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 18.sp,
                    color: Colors.black87,
                  ),
                  8.horizontalSpace,
                  Text(
                    'Shipping Info',
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              14.verticalSpace,

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
                              Text(
                                order.deliveryAddress,
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  lineHeight: 1.4,
                                  textAlign: TextAlign.left,
                                ),
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
                                'TRACKING NUMBER',
                                style: getTextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              8.verticalSpace,
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
                      ],
                    ),
                    18.verticalSpace,

                    Text(
                      'ESTIMATED DELIVERY',
                      style: getTextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      DateFormat('MMMM d, yyyy').format(order.estimatedDelivery),
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    18.verticalSpace,

                    Row(
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 16.sp,
                          color: AppColors.primary,
                        ),
                        8.horizontalSpace,
                        Text(
                          'Payment Details',
                          style: getTextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ).copyWith(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    if (order.isPaid)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified,
                              size: 14.sp,
                              color: AppColors.primary,
                            ),
                            6.horizontalSpace,
                            Text(
                              'PAID',
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              24.verticalSpace,

              GestureDetector(
                onTap: () =>
                    Get.find<AppBottomNavBarController>().jumpToScreen(2),
                child: Container(
                  height: 50.h,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: getTextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
