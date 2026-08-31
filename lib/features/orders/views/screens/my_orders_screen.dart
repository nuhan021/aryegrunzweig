import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/orders_controller.dart';
import '../../../shop/data/commerce_models.dart';
import 'order_details_screen.dart';
import 'order_tracking_screen.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatelessWidget {
  MyOrdersScreen({super.key});

  final OrdersController controller = Get.find<OrdersController>();
  final RxnString _openingOrderAction = RxnString();

  static const _tabs = ['Active orders', 'Delivered', 'Returns'];

  Future<void> _openOrder(
    BuildContext context,
    ShopOrder order, {
    required bool details,
  }) async {
    if (_openingOrderAction.value != null) return;
    final actionKey = '${order.id}:${details ? 'details' : 'tracking'}';
    _openingOrderAction.value = actionKey;
    try {
      final refreshed = await controller.refreshOrder(order) ?? order;
      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => details
              ? OrderDetailsScreen(order: refreshed)
              : OrderTrackingScreen(order: refreshed),
        ),
      );
    } finally {
      _openingOrderAction.value = null;
    }
  }

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
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: controller.loadAll,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
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
                        if (controller.isLoading.value &&
                            controller.orders.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (controller.selectedTabIndex.value == 2) {
                          if (controller.returns.isEmpty) {
                            return _EmptyOrders(
                              message: 'No return requests yet.',
                            );
                          }
                          return Column(
                            children: controller.returns
                                .map((item) => _ReturnCard(item: item))
                                .toList(growable: false),
                          );
                        }
                        final orders = controller.filteredOrders;
                        if (orders.isEmpty) {
                          return _EmptyOrders(message: 'No orders here yet.');
                        }
                        return Column(
                          children: orders
                              .map(
                                (order) => OrderCard(
                                  order: order,
                                  isTracking:
                                      _openingOrderAction.value ==
                                      '${order.id}:tracking',
                                  isOpeningDetails:
                                      _openingOrderAction.value ==
                                      '${order.id}:details',
                                  actionsEnabled:
                                      _openingOrderAction.value == null,
                                  onTrackOrder: () => _openOrder(
                                    context,
                                    order,
                                    details: false,
                                  ),
                                  onViewDetails: () =>
                                      _openOrder(context, order, details: true),
                                ),
                              )
                              .toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 40.h),
    child: Center(
      child: Text(
        message,
        style: getTextStyle(fontSize: 13.sp, color: Colors.grey.shade500),
      ),
    ),
  );
}

class _ReturnCard extends StatelessWidget {
  const _ReturnCard({required this.item});
  final CommerceReturnRequest item;

  @override
  Widget build(BuildContext context) => Container(
    width: double.maxFinite,
    margin: EdgeInsets.only(bottom: 14.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.status.wireValue,
              style: getTextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              item.orderNumber ?? item.orderId,
              style: getTextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
          ],
        ),
        10.verticalSpace,
        Text(
          item.reason,
          style: getTextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        if (item.resolution?.isNotEmpty ?? false) 6.verticalSpace,
        if (item.resolution?.isNotEmpty ?? false)
          Text(
            item.resolution!,
            style: getTextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
      ],
    ),
  );
}
