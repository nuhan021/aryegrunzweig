import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import '../../../shop/controller/shop_controller.dart';
import '../../../shop/views/screens/order_summary_screen.dart';
import '../../../shop/views/screens/product_details_screen.dart';
import '../../../shop/views/widgets/shop_product_card.dart';

class ShopProductsPreview extends StatelessWidget {
  const ShopProductsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShopController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop products',
                    style: getTextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'Browse and buy products for your needs.',
                    style: getTextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Get.find<AppBottomNavBarController>().jumpToScreen(2),
              child: Text(
                'View All',
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ).copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        14.verticalSpace,
        Obx(() {
          if (controller.isLoading.value && controller.products.isEmpty) {
            return SizedBox(
              height: 210.h,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final products = controller.products.take(4).toList(growable: false);
          if (products.isEmpty) {
            return SizedBox(
              height: 80.h,
              child: Center(
                child: Text(
                  controller.errorMessage.value.isEmpty
                      ? 'No products available.'
                      : 'Products could not be loaded.',
                  style: getTextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            height: 220.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => 12.horizontalSpace,
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  width: 160.w,
                  child: ShopProductCard(
                    product: product,
                    isAdding: controller.isAddingProduct(product.id),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsScreen(product: product),
                      ),
                    ),
                    onAddToCart: () async {
                      if (!await controller.addToCart(product) ||
                          !context.mounted) {
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderSummaryScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
