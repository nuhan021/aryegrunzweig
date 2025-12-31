import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:aryegrunzweig/core/utils/constants/icon_path.dart';
import 'package:aryegrunzweig/core/utils/helpers/app_helper.dart';
import 'package:aryegrunzweig/features/home/views/screens/select_issue_screen.dart';
import 'package:aryegrunzweig/features/home/views/widgets/service_grid_view.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/widgets/custom_button.dart';
import '../widgets/offer_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // app bar
            HomeAppBar(),

            // body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.verticalSpace,

                    // image carasol
                    OfferCarousel(),

                    Column(
                      children: [
                        // services
                        Text(
                          'Services',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        20.verticalSpace,

                        ServiceGridView(),

                        25.verticalSpace,

                        CustomButton(
                          text: 'Quick Book Service',
                          onPressed: () => AppHelperFunctions.navigateToScreen(
                            context,
                            SelectIssueScreen(),
                          ),
                        ),

                        25.verticalSpace,
                      ],
                    ).paddingSymmetric(horizontal: 11.w),
                  ],
                ).paddingSymmetric(horizontal: 5.w),
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
                child: Container(
                  height: 36.h,
                  width: 36.w,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Badge(
                    label: Text(
                      '5',
                      style: getTextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),

                    child: Image.asset(
                      IconPath.notification,
                      height: 20.sp,
                    ).paddingOnly(top: 3.h, left: 3.w),
                  ),
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
              hintText: 'Search material name...',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),

              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),

              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),

              // বর্ডার স্টাইল
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
