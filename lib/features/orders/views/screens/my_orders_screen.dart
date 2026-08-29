import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/orders_controller.dart';
import 'order_delivered_screen.dart';
import 'order_tracking_screen.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatelessWidget {
  MyOrdersScreen({super.key});

  final OrdersController controller = Get.put(OrdersController());

  static const _tabs = ['Active orders', 'Delivered', 'Returns'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              isBack: false,
              title: 'My orders',
              subtitle: 'View and manage all your service orders in one place.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: List.generate(_tabs.length, (index) {
                            final isSelected =
                                controller.selectedTabIndex.value == index;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => controller.selectTab(index),
                                child: Container(
                                  height: 40.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    _tabs[index],
                                    style: getTextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    20.verticalSpace,

                    Obx(() {
                      final orders = controller.filteredOrders;
                      if (orders.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: Center(
                            child: Text(
                              'No orders here yet.',
                              style: getTextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: orders
                            .map(
                              (order) => OrderCard(
                                order: order,
                                onTrackOrder: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OrderTrackingScreen(order: order),
                                  ),
                                ),
                                onViewDetails: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        order.status == OrderStatus.delivered
                                        ? OrderDeliveredScreen(order: order)
                                        : OrderTrackingScreen(order: order),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }),
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
