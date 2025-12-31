import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/features/profile/payment_methods/models/payment_method_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final VoidCallback? onSetDefault;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const PaymentCard({
    super.key,
    required this.paymentMethod,
    this.onSetDefault,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFF9FAFB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.00, 0.00),
                end: const Alignment(1.00, 1.00),
                colors: [
                  paymentMethod.gradientStart,
                  paymentMethod.gradientEnd,
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card icon and type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('💳', style: TextStyle(fontSize: 30.sp)),
                    Opacity(
                      opacity: 0.80,
                      child: Text(
                        paymentMethod.cardTypeString,
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (paymentMethod.isDefault)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33554400),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 12.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Default',
                              style: getTextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Card number
                Text(
                  paymentMethod.maskedCardNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 24.h),
                // Card holder and expiry
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.70,
                          child: Text(
                            'Card Holder',
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          paymentMethod.cardHolder,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.70,
                          child: Text(
                            'Expires',
                            style: getTextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          paymentMethod.expiryDate,
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Card footer
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFFE5E7EB)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (paymentMethod.isDefault)
                  Text(
                    'Default',
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF99A1AE),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: onSetDefault,
                    child: Text(
                      'Set as Default',
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1A73E8),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    _showCardMenu(context, onEdit: onEdit, onDelete: onDelete);
                  },
                  child: Icon(
                    Icons.more_vert,
                    size: 20.w,
                    color: const Color(0xFF99A1AE),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCardMenu(
    BuildContext context, {
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onEdit?.call();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20.w),
                    SizedBox(width: 12.w),
                    Text(
                      'Edit',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1.h),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20.w, color: Colors.red),
                    SizedBox(width: 12.w),
                    Text(
                      'Delete',
                      style: getTextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.red,
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
