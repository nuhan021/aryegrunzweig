import 'package:aryegrunzweig/features/notifications/models/notification_model.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final notifications = <Notification>[].obs;
  final selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    notifications.assignAll([
      Notification(
        id: '1',
        title: 'Booking Confirmed',
        description:
            'once they ask for a booking i will respond with a price and they will receive a notification and will reply with a confirm and then they get a notification of booking confirmed',
        type: NotificationType.booking,
        timestamp: '5 mins ago',
        isRead: false,
      ),
      Notification(
        id: '2',
        title: 'Booking Confirmed',
        description:
            'once they ask for a booking i will respond with a price and they will receive a notification and will reply with a confirm and then they get a notification of booking confirmed',
        type: NotificationType.booking,
        timestamp: '5 mins ago',
        isRead: false,
      ),
      Notification(
        id: '3',
        title: 'Special Offer!',
        description:
            'Get 20% off on your next electrical service. Limited time only!',
        type: NotificationType.offer,
        timestamp: '1 day ago',
        isRead: true,
      ),
      Notification(
        id: '4',
        title: 'Upcoming Service',
        description:
            'Reminder: Deep cleaning scheduled for tomorrow at 10:00 AM',
        type: NotificationType.reminder,
        timestamp: '2 days ago',
        isRead: true,
      ),
      Notification(
        id: '5',
        title: 'Payment Received',
        description: 'Your payment of \$250 has been received successfully',
        type: NotificationType.booking,
        timestamp: '3 days ago',
        isRead: true,
      ),
    ]);
  }

  List<Notification> get allNotifications => notifications;

  List<Notification> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  List<Notification> getNotificationsByTab() {
    if (selectedTabIndex.value == 0) {
      return allNotifications;
    } else {
      return unreadNotifications;
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void markAsRead(String notificationId) {
    final notification = notifications.firstWhere(
      (n) => n.id == notificationId,
    );
    notification.isRead = true;
    notifications.refresh();
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
  }

  void clearAll() {
    notifications.clear();
  }

  int get unreadCount => unreadNotifications.length;
  int get totalCount => allNotifications.length;
}
