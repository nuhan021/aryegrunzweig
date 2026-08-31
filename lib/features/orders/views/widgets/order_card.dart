import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/orders_controller.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTrackOrder,
    required this.onViewDetails,
    this.isTracking = false,
    this.isOpeningDetails = false,
    this.actionsEnabled = true,
  });

  final ShopOrder order;
  final VoidCallback onTrackOrder;
  final VoidCallback onViewDetails;
  final bool isTracking;
  final bool isOpeningDetails;
  final bool actionsEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.w),
      margin: EdgeInsets.only(bottom: 14.h),
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
              _OrderThumbnail(imageUrl: order.imageUrl),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: order.isPaid
                            ? const Color(0xFFE8F7F0)
                            : const Color(0xFFFFF4D6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        order.isPaid ? 'PAID' : 'PAYMENT PENDING',
                        style: getTextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: order.isPaid
                              ? const Color(0xFF15805D)
                              : const Color(0xFFB56A00),
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    Text(
                      order.itemName,
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'Order Code: #${order.orderCode}',
                      style: getTextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'Ordered: ${DateFormat('MMMM d, yyyy').format(order.orderDate)}',
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      '\$${order.price.toStringAsFixed(2)}',
                      style: getTextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          14.verticalSpace,
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: actionsEnabled ? onTrackOrder : null,
                  child: Container(
                    height: 44.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: isTracking
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Track Order',
                            style: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: GestureDetector(
                  onTap: actionsEnabled ? onViewDetails : null,
                  child: Container(
                    height: 44.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: isOpeningDetails
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          )
                        : Text(
                            'View details',
                            style: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderThumbnail extends StatelessWidget {
  const _OrderThumbnail({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.image_outlined,
      color: Colors.grey.shade400,
      size: 28.sp,
    );

    return Container(
      height: 84.h,
      width: 84.h,
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
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              placeholder: (_, _) => placeholder,
              errorWidget: (_, _, _) => placeholder,
            ),
    );
  }
}
