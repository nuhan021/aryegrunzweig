import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/shop_controller.dart';
import '../widgets/shop_cart_button.dart';
import '../widgets/shop_product_card.dart';
import 'order_summary_screen.dart';
import 'product_details_screen.dart';

class ShopScreen extends StatelessWidget {
  ShopScreen({super.key});

  final ShopController controller = Get.find<ShopController>();

  void _showCategories(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text('All products'),
              onTap: () {
                Navigator.pop(sheetContext);
                controller.selectCategory(null);
              },
            ),
            ...controller.categories.map(
              (category) => ListTile(
                title: Text(category.name),
                trailing: Text('${category.count}'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  controller.selectCategory(category.name);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              isBack: false,
              title: 'Shop Central Vacuum Products',
              subtitle:
                  'The invisible infrastructure for a healthier home. Discover our range of high-performance power units and precision cleaning kits.',
              action: ShopCartButton(controller: controller, onPrimary: true),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.searchController,
                            onFieldSubmitted: (_) => controller.search(),
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 20.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        GestureDetector(
                          onTap: () => _showCategories(context),
                          child: Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: Colors.black.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Icon(
                              Icons.tune,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,

                    Text(
                      'Products',
                      style: getTextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'Browse products and find what you need',
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    16.verticalSpace,

                    Obx(() {
                      if (controller.isLoading.value &&
                          controller.products.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.errorMessage.value.isNotEmpty &&
                          controller.products.isEmpty) {
                        return Center(
                          child: TextButton(
                            onPressed: controller.loadProducts,
                            child: Text(controller.errorMessage.value),
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          mainAxisExtent: 220.h,
                        ),
                        itemCount: controller.currentPageProducts.length,
                        itemBuilder: (context, index) {
                          final product = controller.currentPageProducts[index];
                          return ShopProductCard(
                            product: product,
                            isAdding: controller.isAddingProduct(product.id),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsScreen(product: product),
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
                          );
                        },
                      );
                    }),

                    20.verticalSpace,

                    _Pagination(controller: controller),
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

class _Pagination extends StatelessWidget {
  const _Pagination({required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = controller.totalPages;
      if (total <= 1) return const SizedBox.shrink();
      return _buildRow(controller.currentPage.value, total);
    });
  }

  Widget _buildRow(int current, int total) {
    final loading = controller.isLoading.value;
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: current > 1 && !loading
                  ? () => controller.goToPage(current - 1)
                  : null,
              icon: const Icon(Icons.chevron_left),
              color: AppColors.primary,
            ),
            SizedBox(
              width: 76.w,
              child: loading
                  ? Center(
                      child: SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Text(
                      'Page $current of $total',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: current < total && !loading
                  ? () => controller.goToPage(current + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
