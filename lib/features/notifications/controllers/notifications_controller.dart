import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers/app_helper.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';
import '../../orders/controller/orders_controller.dart';
import '../../orders/views/screens/order_delivered_screen.dart';
import '../../orders/views/screens/order_tracking_screen.dart';
import '../../services/controller/services_controller.dart';
import '../../services/data/service_request_models.dart';
import '../../services/views/screens/quote_details_screen.dart';
import '../../services/views/screens/service_appointment_screen.dart';
import '../../services/views/screens/service_complete_screen.dart';
import '../../services/views/screens/service_payment_method_screen.dart';
import '../../services/views/screens/service_request_overview_screen.dart';
import '../../technician/controller/technician_jobs_controller.dart';
import '../../technician/views/screens/technician_job_details_screen.dart';
import '../data/notifications_repository.dart';
import '../data/notification_stream_service.dart';
import '../models/notification_model.dart' as app_notification;

class NotificationsController extends GetxController {
  final NotificationsRepository _repository =
      Get.find<NotificationsRepository>();
  final NotificationStreamService _streamService =
      Get.find<NotificationStreamService>();
  StreamSubscription<Map<String, dynamic>>? _streamSubscription;
  final notifications = <app_notification.Notification>[].obs;
  final selectedTabIndex = 0.obs;
  final isLoading = false.obs;
  final isActionLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    _streamSubscription = _streamService.connect().listen(_handleStreamEvent);
  }

  void _handleStreamEvent(Map<String, dynamic> event) {
    final payload = event['notification'] is Map
        ? Map<String, dynamic>.from(event['notification'] as Map)
        : event;
    if (!payload.containsKey('id') || !payload.containsKey('createdAt')) return;
    try {
      final notification = app_notification.Notification.fromJson(payload);
      final index = notifications.indexWhere(
        (item) => item.id == notification.id,
      );
      if (index >= 0) {
        notifications[index] = notification;
      } else {
        notifications.insert(0, notification);
      }
    } on FormatException {
      // Ignore non-notification SSE events such as connection heartbeats.
    }
  }

  Future<void> loadNotifications() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _repository.list();
    isLoading.value = false;
    if (!result.isSuccess || result.data == null) {
      errorMessage.value = result.errorMessage;
      return;
    }
    notifications.assignAll(result.data!);
  }

  List<app_notification.Notification> get allNotifications => notifications;
  List<app_notification.Notification> get unreadNotifications =>
      notifications.where((item) => !item.isRead).toList(growable: false);
  List<app_notification.Notification> get notificationsForSelectedTab =>
      selectedTabIndex.value == 0 ? allNotifications : unreadNotifications;

  void changeTab(int index) => selectedTabIndex.value = index;

  Future<bool> markAsRead(app_notification.Notification notification) async {
    if (notification.isRead) return true;
    final result = await _repository.markAsRead(notification.id);
    if (!result.isSuccess || result.data != true) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    notification.readAt = DateTime.now().toUtc();
    notifications.refresh();
    return true;
  }

  Future<bool> markAllAsRead() async {
    if (unreadCount == 0 || isActionLoading.value) return true;
    isActionLoading.value = true;
    final result = await _repository.markAllAsRead();
    isActionLoading.value = false;
    if (!result.isSuccess || result.data != true) {
      AppHelperFunctions.showErrorSnackBar(result.errorMessage);
      return false;
    }
    final now = DateTime.now().toUtc();
    for (final notification in notifications) {
      notification.readAt ??= now;
    }
    notifications.refresh();
    AppHelperFunctions.showSuccessSnackBar('All notifications marked as read.');
    return true;
  }

  Future<void> openNotification(
    BuildContext context,
    app_notification.Notification notification,
  ) async {
    if (isActionLoading.value) return;
    isActionLoading.value = true;
    await markAsRead(notification);
    if (!context.mounted) {
      isActionLoading.value = false;
      return;
    }
    switch (notification.targetType) {
      case app_notification.NotificationTargetType.serviceRequest:
        await _openServiceRequest(context, notification.serviceRequestId!);
        break;
      case app_notification.NotificationTargetType.order:
        await _openOrder(context, notification.orderId!);
        break;
      case app_notification.NotificationTargetType.conversation:
        Get.toNamed(
          AppRoute.individualChatScreen,
          arguments: {'conversationId': notification.conversationId},
        );
        break;
      case app_notification.NotificationTargetType.none:
        break;
    }
    isActionLoading.value = false;
  }

  Future<void> _openServiceRequest(BuildContext context, String id) async {
    final auth = Get.find<AuthController>();
    if (auth.isTechnician) {
      final controller = Get.find<TechnicianJobsController>();
      final job = await controller.selectJobById(id);
      if (job == null || !context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TechnicianJobDetailsScreen(controller: controller),
        ),
      );
      return;
    }

    final controller = Get.find<ServicesController>();
    final request = await controller.requestById(id);
    if (request == null || !context.mounted) return;
    final Widget screen;
    if (request.api.status == CustomerRequestStatus.accepted) {
      screen = ServicePaymentMethodScreen(request: request);
    } else {
      screen = switch (request.status) {
        ServiceRequestStatus.quoteReady => QuoteDetailsScreen(request: request),
        ServiceRequestStatus.underReview => ServiceRequestOverviewScreen(
          request: request,
        ),
        ServiceRequestStatus.scheduled => ServiceAppointmentScreen(
          request: request,
        ),
        ServiceRequestStatus.completed => ServiceCompleteScreen(
          request: request,
        ),
      };
    }
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _openOrder(BuildContext context, String id) async {
    final controller = Get.find<OrdersController>();
    final order = await controller.orderById(id);
    if (order == null || !context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => order.status == OrderStatus.delivered
            ? OrderDeliveredScreen(order: order)
            : OrderTrackingScreen(order: order),
      ),
    );
  }

  int get unreadCount => unreadNotifications.length;
  int get totalCount => allNotifications.length;

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
