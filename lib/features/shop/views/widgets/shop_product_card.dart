import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/shop_controller.dart';

class ShopProductCard extends StatelessWidget {
  const ShopProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onTap,
    this.isAdding = false,
  });

  final ShopProduct product;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;
  final bool isAdding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100.h,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
              ),
              alignment: Alignment.center,
              child: product.imageUrl == null
                  ? Icon(
                      Icons.image_outlined,
                      color: Colors.grey.shade400,
                      size: 32.sp,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        product.imageUrl!,
                        width: double.maxFinite,
                        height: double.maxFinite,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
            ),
            10.verticalSpace,
            Text(
              product.name,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                textAlign: TextAlign.left,
              ),
            ),
            2.verticalSpace,
            Text(
              product.subtitle,
              style: getTextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
                textAlign: TextAlign.left,
              ),
            ),
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: getTextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                GestureDetector(
                  onTap: isAdding ? null : onAddToCart,
                  child: Container(
                    height: 26.w,
                    width: 26.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: isAdding
                        ? SizedBox(
                            width: 13.w,
                            height: 13.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: AppColors.primary,
                            ),
                          )
                        : Icon(
                            Icons.shopping_cart_outlined,
                            size: 14.sp,
                            color: AppColors.primary,
                          ),
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
