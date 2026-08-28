import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/shop_controller.dart';
import '../widgets/shop_product_card.dart';
import 'order_summary_screen.dart';

class ShopScreen extends StatelessWidget {
  ShopScreen({super.key});

  final ShopController controller = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Shop Central Vacuum Products',
              subtitle:
                  'The invisible infrastructure for a healthier home. Discover our range of high-performance power units and precision cleaning kits.',
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
                                  color: Colors.black.withOpacity(0.1),
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
                        Container(
                          height: 50.h,
                          width: 50.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: AppColors.primary,
                            size: 20.sp,
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

                    Obx(
                      () => GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
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
                            onAddToCart: () {
                              controller.addToCart(product);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderSummaryScreen(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

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
      final current = controller.currentPage.value;
      final total = controller.totalPages;

      return _buildRow(current, total);
    });
  }

  Row _buildRow(int current, int total) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => controller.goToPage(current - 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back,
                size: 13.sp,
                color: current > 1 ? AppColors.primary : Colors.grey.shade400,
              ),
              3.horizontalSpace,
              Text(
                'Previous',
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: current > 1
                      ? AppColors.primary
                      : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(min(total, 7), (i) {
                final page = i + 1;
                final isLast = i == 6 && total > 7;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: isLast
                      ? Text(
                          '...',
                          style: getTextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey.shade500,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => controller.goToPage(page),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: page == current
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              '$page',
                              style: getTextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: page == current
                                    ? AppColors.primary
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                );
              }),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => controller.goToPage(current + 1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Next',
                style: getTextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: current < total
                      ? AppColors.primary
                      : Colors.grey.shade400,
                ),
              ),
              3.horizontalSpace,
              Icon(
                Icons.arrow_forward,
                size: 13.sp,
                color: current < total
                    ? AppColors.primary
                    : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

