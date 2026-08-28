import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';

class ShopProductsPreview extends StatelessWidget {
  const ShopProductsPreview({super.key});

  static const List<Map<String, String>> _products = [
    {
      'title': 'Modern Wall Inlets',
      'subtitle': 'Set of 5 Premium Finishes',
      'price': '\$145.00',
    },
    {
      'title': 'Modern Wall Inlets',
      'subtitle': 'Set of 5 Premium Finishes',
      'price': '\$145.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
        SizedBox(
          height: 210.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _products.length,
            separatorBuilder: (_, __) => 12.horizontalSpace,
            itemBuilder: (context, index) {
              final product = _products[index];
              return _ProductCard(
                title: product['title']!,
                subtitle: product['subtitle']!,
                price: product['price']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.subtitle,
    required this.price,
  });

  final String title;
  final String subtitle;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
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
            child: Icon(
              Icons.image_outlined,
              color: Colors.grey.shade400,
              size: 32.sp,
            ),
          ),
          10.verticalSpace,
          Text(
            title,
            style: getTextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              textAlign: TextAlign.left,
            ),
          ),
          2.verticalSpace,
          Text(
            subtitle,
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
                price,
                style: getTextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Container(
                height: 26.w,
                width: 26.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
