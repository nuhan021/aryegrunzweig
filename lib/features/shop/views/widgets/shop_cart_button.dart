import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/helpers/app_helper.dart';
import '../../controller/shop_controller.dart';
import '../screens/order_summary_screen.dart';

class ShopCartButton extends StatelessWidget {
  const ShopCartButton({
    super.key,
    required this.controller,
    this.onPrimary = false,
  });

  final ShopController controller;
  final bool onPrimary;

  void _openCart(BuildContext context) {
    if (controller.cart.isEmpty) {
      AppHelperFunctions.showSnackBar('Your cart is empty.');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrderSummaryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    final count = controller.cartItemCount;
    final foreground = onPrimary ? Colors.white : AppColors.primary;
    final background = onPrimary
        ? Colors.white.withValues(alpha: 0.16)
        : AppColors.primary.withValues(alpha: 0.08);

    return Semantics(
      button: true,
      label: count == 0 ? 'Cart, empty' : 'Cart, $count items',
      child: InkWell(
        onTap: () => _openCart(context),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12.r),
            border: onPrimary ? null : Border.all(color: foreground),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: foreground,
                size: 22.sp,
              ),
              if (count > 0)
                Positioned(
                  right: 2.w,
                  top: 2.w,
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 16.w,
                      minHeight: 16.w,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  });
}
