import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/styles/global_text_style.dart';
import '../../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../../core/utils/constants/colors.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  static final List<_PaymentRecord> _payments = [
    _PaymentRecord(
      title: 'Elite 500 Performance',
      reference: 'Order #CC-3084',
      date: DateTime(2026, 7, 29),
      amount: 349,
      icon: Icons.shopping_bag_outlined,
    ),
    _PaymentRecord(
      title: 'Central vacuum service',
      reference: 'Service #SR-2186',
      date: DateTime(2026, 7, 18),
      amount: 129,
      icon: Icons.home_repair_service_outlined,
    ),
    _PaymentRecord(
      title: 'Modern Wall Inlets',
      reference: 'Order #CC-2977',
      date: DateTime(2026, 7, 10),
      amount: 145,
      icon: Icons.shopping_bag_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _payments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

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
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 22.h, 16.w, 28.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.8),
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
                            '${_payments.length} completed payments',
                            style: getTextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
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
                    ..._payments.map(
                      (payment) => _PaymentTile(payment: payment),
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

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.payment});

  final _PaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(payment.icon, size: 21.sp, color: AppColors.primary),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF172231),
                    textAlign: TextAlign.left,
                  ),
                ),
                5.verticalSpace,
                Text(
                  payment.reference,
                  style: getTextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF667C9B),
                  ),
                ),
                4.verticalSpace,
                Text(
                  DateFormat('MMMM d, yyyy').format(payment.date),
                  style: getTextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF99A7B9),
                  ),
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${payment.amount.toStringAsFixed(2)}',
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF172231),
                ),
              ),
              7.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F0),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Paid',
                  style: getTextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF22A866),
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

class _PaymentRecord {
  const _PaymentRecord({
    required this.title,
    required this.reference,
    required this.date,
    required this.amount,
    required this.icon,
  });

  final String title;
  final String reference;
  final DateTime date;
  final double amount;
  final IconData icon;
}
