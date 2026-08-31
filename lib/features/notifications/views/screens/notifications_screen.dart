import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controllers/notifications_controller.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_tab_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => NotificationHeader(
                onBackPressed: onBackPressed ?? Get.back,
                onMarkAllRead: controller.markAllAsRead,
                isLoading: controller.isMarkingAllRead.value,
              ),
            ),
            Obx(
              () => NotificationTabBar(
                selectedIndex: controller.selectedTabIndex.value,
                allCount: controller.totalCount,
                unreadCount: controller.unreadCount,
                onTabChanged: controller.changeTab,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.notifications.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.errorMessage.value.isNotEmpty &&
                    controller.notifications.isEmpty) {
                  return _NotificationError(
                    message: controller.errorMessage.value,
                    onRetry: controller.loadNotifications,
                  );
                }
                final items = controller.notificationsForSelectedTab;
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: controller.loadNotifications,
                  child: items.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 150.h),
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 48.w,
                              color: const Color(0xFFCDCDCD),
                            ),
                            16.verticalSpace,
                            Center(
                              child: Text(
                                controller.selectedTabIndex.value == 0
                                    ? 'No notifications yet'
                                    : 'No unread notifications',
                                style: getTextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF99A1AF),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final notification = items[index];
                            return NotificationCard(
                              notification: notification,
                              isLoading:
                                  controller.openingNotificationId.value ==
                                  notification.id,
                              onTap: () => controller.openNotification(
                                context,
                                notification,
                              ),
                            );
                          },
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationError extends StatelessWidget {
  const _NotificationError({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          12.verticalSpace,
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    ),
  );
}
