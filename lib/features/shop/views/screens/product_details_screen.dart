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
  late ShopProduct product;

  static const _tabs = ['Description', 'Specifications', 'Shipping info'];

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final loaded = await controller.loadProductDetails(product);
    if (loaded != null && mounted) {
      setState(() {
        product = loaded;
        selectedThumbnail = 0;
      });
    }
  }

  void _incrementQuantity() => setState(() => quantity++);

  void _decrementQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  @override
  Widget build(BuildContext context) {
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
                      child: product.api.imageUrls.isEmpty
                          ? Icon(
                              Icons.image_outlined,
                              color: Colors.grey.shade400,
                              size: 56.sp,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(14.r),
                              child: Image.network(
                                product.api.imageUrls[selectedThumbnail],
                                width: double.maxFinite,
                                height: double.maxFinite,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image_outlined),
                              ),
                            ),
                    ),
                    14.verticalSpace,

                    if (product.api.imageUrls.isNotEmpty)
                      SizedBox(
                        height: 70.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: product.api.imageUrls.length,
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    product.api.imageUrls[index],
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.broken_image_outlined),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (product.api.imageUrls.isNotEmpty) 20.verticalSpace,

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
                      product.api.description,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                        lineHeight: 1.5,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    18.verticalSpace,

                    ...product.api.features.map(
                      (feature) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 17.sp,
                              color: AppColors.primary,
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Text(
                                feature,
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
                      onTap: () async {
                        if (!await controller.addToCart(
                              product,
                              quantity: quantity,
                            ) ||
                            !context.mounted) {
                          return;
                        }
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
                              onAddToCart: () async {
                                if (!await controller.addToCart(
                                      relatedProduct,
                                    ) ||
                                    !context.mounted) {
                                  return;
                                }
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
        final specifications = product.api.specifications;
        if (specifications == null || specifications.isEmpty) {
          return const Text('No specifications provided.');
        }
        return Column(
          children: specifications.entries
              .map(
                (entry) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(entry.key),
                  trailing: Text('${entry.value}'),
                ),
              )
              .toList(growable: false),
        );
      case 2:
        return Text(
          product.api.shippingInfo ?? 'No shipping information provided.',
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
            lineHeight: 1.5,
            textAlign: TextAlign.left,
          ),
        );
      default:
        return Text(
          product.api.description,
          style: getTextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade700,
            lineHeight: 1.5,
            textAlign: TextAlign.left,
          ),
        );
    }
  }
}
