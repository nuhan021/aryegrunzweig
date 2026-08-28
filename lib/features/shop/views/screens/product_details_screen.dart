import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/shop_controller.dart';
import '../widgets/shop_product_card.dart';
import 'order_summary_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ShopProduct product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ShopController controller = Get.find<ShopController>();
  int quantity = 1;
  int selectedThumbnail = 0;
  int selectedTab = 0;

  static const _features = [
    (Icons.verified_outlined, '10-Year Comprehensive Warranty'),
    (Icons.local_shipping_outlined, 'Complimentary Professional Installation'),
    (
      Icons.bolt_outlined,
      'Dual-stage motor delivering consistent power across every inlet.',
    ),
    (
      Icons.volume_off_outlined,
      'Advanced acoustic dampening for minimal disruption in the home.',
    ),
    (
      Icons.shield_outlined,
      '99.9% HEPA filtration capturing microscopic allergens and dust.',
    ),
    (
      Icons.settings_outlined,
      'Constructed with high-grade alloys and architectural precision.',
    ),
  ];

  static const _tabs = ['Description', 'Specifications', 'Shipping info'];

  void _incrementQuantity() => setState(() => quantity++);

  void _decrementQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final related = controller.relatedProducts(product);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 16.sp,
                          color: Colors.black87,
                        ),
                        4.horizontalSpace,
                        Text(
                          'Back',
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 260.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey.shade400,
                        size: 56.sp,
                      ),
                    ),
                    14.verticalSpace,

                    SizedBox(
                      height: 70.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (_, __) => 10.horizontalSpace,
                        itemBuilder: (context, index) {
                          final isSelected = selectedThumbnail == index;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedThumbnail = index),
                            child: Container(
                              height: 70.h,
                              width: 70.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.grey.shade200,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.grey.shade400,
                                size: 22.sp,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    20.verticalSpace,

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: getTextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                'Available to order',
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E7D32),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: getTextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    14.verticalSpace,

                    Text(
                      'Quiet-flow technology, the ${product.name} Series redefines architectural cleanliness. Powered by a high-performance dual-stage motor and integrated HEPA filtration, it ensures a pristine environment with whisper-quiet operation and uncompromising suction power.',
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                        lineHeight: 1.5,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    18.verticalSpace,

                    ..._features.map(
                      (feature) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              feature.$1,
                              size: 17.sp,
                              color: AppColors.primary,
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Text(
                                feature.$2,
                                style: getTextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                  lineHeight: 1.4,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    8.verticalSpace,

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _decrementQuantity,
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Icon(
                                Icons.remove,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              '$quantity',
                              style: getTextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _incrementQuantity,
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Icon(
                                Icons.add,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    14.verticalSpace,

                    GestureDetector(
                      onTap: () {
                        controller.addToCart(product, quantity: quantity);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderSummaryScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 50.h,
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'Add to cart',
                          style: getTextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    10.verticalSpace,

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50.h,
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Text(
                          'Request installation service',
                          style: getTextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    24.verticalSpace,

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_tabs.length, (index) {
                          final isSelected = selectedTab == index;
                          return Padding(
                            padding: EdgeInsets.only(right: 14.w),
                            child: GestureDetector(
                              onTap: () => setState(() => selectedTab = index),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _tabs[index],
                                    style: getTextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                  4.verticalSpace,
                                  if (isSelected)
                                    Container(
                                      height: 2.h,
                                      width: 50.w,
                                      color: AppColors.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    16.verticalSpace,

                    _TabContent(tab: selectedTab, product: product),

                    28.verticalSpace,

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You may Also Like',
                                style: getTextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                'Discover more products picked just for you.',
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
                          onTap: () => Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst),
                          child: Text(
                            'View Entire Store',
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
                        itemCount: related.length,
                        separatorBuilder: (_, __) => 12.horizontalSpace,
                        itemBuilder: (context, index) {
                          final relatedProduct = related[index];
                          return SizedBox(
                            width: 160.w,
                            child: ShopProductCard(
                              product: relatedProduct,
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                    product: relatedProduct,
                                  ),
                                ),
                              ),
                              onAddToCart: () {
                                controller.addToCart(relatedProduct);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrderSummaryScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    24.verticalSpace,
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

class _TabContent extends StatelessWidget {
  const _TabContent({required this.tab, required this.product});

  final int tab;
  final ShopProduct product;

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case 1:
        return Text(
          'Detailed technical specifications for the ${product.name} will be available soon.',
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
            lineHeight: 1.5,
            textAlign: TextAlign.left,
          ),
        );
      case 2:
        return Text(
          'This item ships free within 7-10 business days. Professional installation can be scheduled after delivery from the Services tab.',
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
            lineHeight: 1.5,
            textAlign: TextAlign.left,
          ),
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This series represents the pinnacle of modern architectural maintenance. Designed to be integrated seamlessly into high-end residences, it eliminates the noise and inconvenience of portable vacuum units while providing vastly superior air quality.',
              style: getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
                lineHeight: 1.5,
                textAlign: TextAlign.left,
              ),
            ),
            18.verticalSpace,
            Text(
              "Each component is engineered for longevity. The brushless motor technology ensures minimal wear and tear, while the intelligent self-cleaning filter system reduces maintenance frequency. It's more than a utility; it's an infrastructure for wellness.",
              style: getTextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
                lineHeight: 1.5,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
    }
  }
}
