import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/orders_controller.dart';
import 'order_tracking_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Order details',
              subtitle: 'Order Code: #${order.orderCode}',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OrderHeader(order: order),
                    16.verticalSpace,
                    Text(
                      'Items',
                      style: getTextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    10.verticalSpace,
                    ...order.api.items.map(
                      (item) => _OrderItemRow(
                        name: item.product.name,
                        imageUrl: item.product.imageUrls.isEmpty
                            ? null
                            : item.product.imageUrls.first,
                        quantity: item.quantity,
                        unitPrice: item.unitPrice.toDouble(),
                      ),
                    ),
                    6.verticalSpace,
                    _DetailsCard(
                      child: Column(
                        children: [
                          _ValueRow(
                            label: 'Subtotal',
                            value: '\$${order.api.subtotal.toStringAsFixed(2)}',
                          ),
                          _ValueRow(
                            label: 'Shipping',
                            value: order.api.shippingFee == 0
                                ? 'FREE'
                                : '\$${order.api.shippingFee.toStringAsFixed(2)}',
                          ),
                          _ValueRow(
                            label: 'Tax',
                            value: '\$${order.api.tax.toStringAsFixed(2)}',
                          ),
                          Divider(color: Colors.grey.shade200),
                          _ValueRow(
                            label: 'Total',
                            value: '\$${order.api.total.toStringAsFixed(2)}',
                            bold: true,
                          ),
                        ],
                      ),
                    ),
                    16.verticalSpace,
                    _DetailsCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipping address',
                            style: getTextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            order.deliveryAddress,
                            style: getTextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade600,
                              lineHeight: 1.4,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(order: order),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'Track order',
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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

class _OrderHeader extends StatelessWidget {
  const _OrderHeader({required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) => _DetailsCard(
    child: Column(
      children: [
        _ValueRow(
          label: 'Status',
          value: order.api.status.wireValue.replaceAll('_', ' '),
          valueColor: AppColors.primary,
        ),
        _ValueRow(
          label: 'Payment',
          value: order.isPaid
              ? 'PAID'
              : (order.api.paymentStatus ?? 'PENDING').replaceAll('_', ' '),
          valueColor: order.isPaid ? const Color(0xFF15805D) : Colors.orange,
        ),
        _ValueRow(
          label: 'Ordered',
          value: DateFormat('MMMM d, yyyy').format(order.orderDate),
        ),
        if (order.api.carrier?.isNotEmpty ?? false)
          _ValueRow(label: 'Carrier', value: order.api.carrier!),
        if (order.api.trackingNumber?.isNotEmpty ?? false)
          _ValueRow(label: 'Tracking', value: order.api.trackingNumber!),
      ],
    ),
  );
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
  });

  final String name;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.image_outlined,
      color: Colors.grey.shade400,
      size: 26.sp,
    );
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: imageUrl == null || imageUrl!.trim().isEmpty
                ? placeholder
                : CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (_, _) => placeholder,
                    errorWidget: (_, _, _) => placeholder,
                  ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    textAlign: TextAlign.left,
                  ),
                ),
                6.verticalSpace,
                Text(
                  'Qty: $quantity  ·  \$${unitPrice.toStringAsFixed(2)} each',
                  style: getTextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${(unitPrice * quantity).toStringAsFixed(2)}',
            style: getTextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: child,
  );
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 5.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              color: Colors.grey.shade600,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        12.horizontalSpace,
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}
