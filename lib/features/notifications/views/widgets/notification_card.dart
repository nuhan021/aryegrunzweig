import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:aryegrunzweig/features/notifications/models/notification_model.dart'
    as notif_model;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCard extends StatelessWidget {
  final notif_model.Notification notification;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onTap;
  final bool isLoading;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onDelete,
    this.onMarkAsRead,
    this.onTap,
    this.isLoading = false,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case notif_model.NotificationType.booking:
        return Icons.check_circle;
      case notif_model.NotificationType.offer:
        return Icons.card_giftcard;
      case notif_model.NotificationType.reminder:
        return Icons.notifications;
    }
  }

  Color _getIconBackgroundColor() {
    switch (notification.type) {
      case notif_model.NotificationType.booking:
        return const Color(0x1428C76F);
      case notif_model.NotificationType.offer:
        return AppColors.primary.withValues(alpha: 0.08);
      case notif_model.NotificationType.reminder:
        return const Color(0x1400CFE8);
    }
  }

  Color _getCardBackgroundColor() {
    switch (notification.type) {
      case notif_model.NotificationType.booking:
        return const Color(0xFFE4F1FF);
      case notif_model.NotificationType.offer:
        return const Color(0xFFFFF4E6);
      case notif_model.NotificationType.reminder:
        return const Color(0xFFE8F5FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              onTap?.call();
              if (onTap == null && !notification.isRead) onMarkAsRead?.call();
            },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: ShapeDecoration(
          color: notification.isRead ? Colors.white : _getCardBackgroundColor(),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFF2F4F6)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          shadows: [
            BoxShadow(
              color: const Color(0x3F000000),
              blurRadius: 4,
              offset: const Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon background
            Container(
              width: 40.w,
              height: 40.w,
              decoration: ShapeDecoration(
                color: _getIconBackgroundColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(33554400),
                ),
              ),
              child: Center(
                child: Icon(
                  _getIcon(),
                  size: 20.w,
                  color:
                      notification.type == notif_model.NotificationType.booking
                      ? const Color(0xFF28C76F)
                      : notification.type == notif_model.NotificationType.offer
                      ? AppColors.primary
                      : const Color(0xFF00CFE8),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: getTextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF101727),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (isLoading)
                        SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      else if (!notification.isRead)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF1A73E8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(33554400),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notification.description,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF495565),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    notification.timestamp,
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6E7279),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
