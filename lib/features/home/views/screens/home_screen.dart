import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:aryegrunzweig/core/utils/constants/icon_path.dart';
import 'package:aryegrunzweig/features/home/views/widgets/home_activity_cards.dart';
import 'package:aryegrunzweig/features/home/views/widgets/home_quick_action_cards.dart';
import 'package:aryegrunzweig/features/home/views/widgets/shop_products_preview.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // app bar
            HomeAppBar(),

            // body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    18.verticalSpace,

                    const HomeQuickActionCards(),

                    18.verticalSpace,

                    const QuoteReadyCard(
                      price: '\$245.00',
                      expiresAt: 'Expires today 4:30 PM',
                      title: 'Central Vacuum Repair',
                      requestId: 'SR-1048',
                      description: 'Low suction throughout the home',
                    ),

                    const ScheduledCard(
                      title: 'Central Vacuum Repair',
                      dateTime: 'Friday, Aug 1 · 9:00 – 10:30 AM',
                      technicianName: 'Marc Anderson',
                    ),

                    const ShippedCard(
                      orderId: '#CC-3084',
                      title: 'Retractable Hose System',
                      trackingNumber: 'UPS 1Z82A4X95012345678',
                    ),

                    10.verticalSpace,

                    const ShopProductsPreview(),

                    25.verticalSpace,
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

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(IconPath.location, width: 20.w),
                  10.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: getTextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        'New York, NY',
                        style: getTextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              GestureDetector(
                onTap: () => Get.toNamed(AppRoute.notificationsScreen),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      IconPath.notification,
                      height: 24.sp,
                      color: Colors.white,
                    ),
                    Positioned(
                      top: -2.h,
                      right: -2.w,
                      child: Container(
                        height: 8.w,
                        width: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          20.verticalSpace,

          TextFormField(
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Search Services...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),

              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),

              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
