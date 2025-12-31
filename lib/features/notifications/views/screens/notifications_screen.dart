import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/features/notifications/controllers/notifications_controller.dart';
import 'package:aryegrunzweig/features/notifications/views/widgets/notification_card.dart';
import 'package:aryegrunzweig/features/notifications/views/widgets/notification_header.dart';
import 'package:aryegrunzweig/features/notifications/views/widgets/notification_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      init: NotificationsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                NotificationHeader(
                  onBackPressed: () => Get.back(),
                  onClearAll: () {
                    _showClearAllDialog(context, controller);
                  },
                ),

                // Tab Bar
                Obx(
                  () => NotificationTabBar(
                    selectedIndex: controller.selectedTabIndex.value,
                    allCount: controller.totalCount,
                    unreadCount: controller.unreadCount,
                    onTabChanged: (index) {
                      controller.changeTab(index);
                    },
                  ),
                ),

                // Mark All as Read Button
                Obx(
                  () => controller.unreadCount > 0
                      ? Padding(
                          padding: EdgeInsets.all(12.w),
                          child: GestureDetector(
                            onTap: () {
                              controller.markAllAsRead();
                              Get.snackbar(
                                'Success',
                                'All notifications marked as read',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 16.w,
                              ),
                              decoration: ShapeDecoration(
                                color: const Color(0xFF1C4F50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Mark All as Read',
                                  style: getTextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Notifications List
                Expanded(
                  child: Obx(() {
                    final notificationsList = controller
                        .getNotificationsByTab();

                    if (notificationsList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off,
                              size: 48.w,
                              color: const Color(0xFFCDCDCD),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              controller.selectedTabIndex.value == 0
                                  ? 'No notifications yet'
                                  : 'No unread notifications',
                              style: getTextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF99A1AF),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      itemCount: notificationsList.length,
                      itemBuilder: (context, index) {
                        final notification = notificationsList[index];
                        return NotificationCard(
                          notification: notification,
                          onMarkAsRead: () {
                            controller.markAsRead(notification.id);
                          },
                          onDelete: () {
                            controller.deleteNotification(notification.id);
                            Get.snackbar(
                              'Deleted',
                              'Notification removed',
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                            );
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClearAllDialog(
    BuildContext context,
    NotificationsController controller,
  ) {
    Get.defaultDialog(
      title: 'Clear All Notifications',
      content: Text(
        'Are you sure you want to clear all notifications?',
        style: getTextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF495565),
        ),
      ),
      textConfirm: 'Clear',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.clearAll();
        Get.back();
        Get.snackbar(
          'Success',
          'All notifications cleared',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      onCancel: () {
        Get.back();
      },
    );
  }
}
