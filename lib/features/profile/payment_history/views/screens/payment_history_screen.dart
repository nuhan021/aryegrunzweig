import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/styles/global_text_style.dart';
import '../../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../../core/utils/constants/colors.dart';
import '../../../data/profile_models.dart';
import '../../controllers/payment_history_controller.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentHistoryController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Payment history',
              subtitle: 'Review your completed orders and service payments.',
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                }
                return RefreshIndicator(
                  onRefresh: controller.loadPayments,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 28.h),
                    children: [
                      _SummaryCard(
                        total: controller.totalPaid,
                        count: controller.payments.length,
                      ),
                      26.verticalSpace,
                      Text(
                        'Recent payments',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF172231),
                        ),
                      ),
                      14.verticalSpace,
                      if (controller.payments.isEmpty)
                        const Center(child: Text('No payments yet')),
                      ...controller.payments.map(
                        (payment) => _PaymentTile(
                          payment: payment,
                          onTap: () => controller.showInvoice(payment),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total, required this.count});

  final num total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total paid',
            style: getTextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: .8),
            ),
          ),
          8.verticalSpace,
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: getTextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          6.verticalSpace,
          Text(
            '$count payments',
            style: getTextStyle(
              fontSize: 11.sp,
              color: Colors.white.withValues(alpha: .8),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.payment, required this.onTap});

  final PaymentResponse payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              payment.purpose == PaymentPurpose.order
                  ? Icons.shopping_bag_outlined
                  : Icons.home_repair_service_outlined,
              size: 28.sp,
              color: AppColors.primary,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.purpose == PaymentPurpose.order
                        ? 'Order payment'
                        : 'Service payment',
                    style: getTextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    payment.reference,
                    style: getTextStyle(fontSize: 11.sp, color: Colors.black54),
                  ),
                  Text(
                    DateFormat('MMMM d, yyyy').format(payment.createdAt),
                    style: getTextStyle(fontSize: 10.sp, color: Colors.black45),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${payment.currency.toUpperCase()} ${payment.amount.toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                5.verticalSpace,
                Text(
                  payment.status.wireValue,
                  style: getTextStyle(
                    fontSize: 9.sp,
                    color: const Color(0xFF22A866),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
