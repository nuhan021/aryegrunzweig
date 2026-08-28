import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../home/views/widgets/service_request_buttons.dart';
import '../../controller/shop_controller.dart';
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

  void _incrementQuantity() => setState(() => quantity++);

  void _decrementQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: product.name, subtitle: product.subtitle),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 220.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.grey.shade400,
                        size: 56.sp,
                      ),
                    ),
                    20.verticalSpace,

                    Text(
                      product.name,
                      style: getTextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    6.verticalSpace,
                    Text(
                      product.subtitle,
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    14.verticalSpace,
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: getTextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),

                    20.verticalSpace,
                    Divider(color: Colors.grey.shade200, height: 1),
                    20.verticalSpace,

                    Text(
                      'Description',
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    8.verticalSpace,
                    Text(
                      'High-quality central vacuum accessory built for durability and performance. Designed to integrate seamlessly with your existing system for reliable, long-lasting use.',
                      style: getTextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                        textAlign: TextAlign.left,
                      ),
                    ),

                    24.verticalSpace,
                    Text(
                      'Quantity',
                      style: getTextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    10.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _decrementQuantity,
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Icon(
                                Icons.remove,
                                size: 16.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
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
                              padding: EdgeInsets.all(8.w),
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SrPrimaryButton(
                text: 'Add to Cart · \$${(product.price * quantity).toStringAsFixed(2)}',
                onPressed: () {
                  controller.addToCart(product, quantity: quantity);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderSummaryScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
