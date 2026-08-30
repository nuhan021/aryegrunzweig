import 'package:aryegrunzweig/core/common/styles/global_text_style.dart';
import 'package:aryegrunzweig/core/utils/constants/colors.dart';
import 'package:aryegrunzweig/core/utils/constants/icon_path.dart';
import 'package:aryegrunzweig/features/home/views/widgets/home_activity_cards.dart';
import 'package:aryegrunzweig/features/home/views/widgets/home_quick_action_cards.dart';
import 'package:aryegrunzweig/features/home/views/widgets/shop_products_preview.dart';
import 'package:aryegrunzweig/features/profile/view_profile/controllers/view_profile_controller.dart';
import 'package:aryegrunzweig/features/services/controller/services_controller.dart';
import 'package:aryegrunzweig/features/services/data/service_request_models.dart';
import 'package:aryegrunzweig/features/orders/controller/orders_controller.dart';
import 'package:aryegrunzweig/features/notifications/controllers/notifications_controller.dart';
import 'package:aryegrunzweig/features/shop/data/commerce_models.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ViewProfileController _profileController;
  late final ServicesController _servicesController;
  late final OrdersController _ordersController;

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ViewProfileController>();
    _servicesController = Get.find<ServicesController>();
    _ordersController = Get.find<OrdersController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_profileController.profile.value == null) {
        _profileController.loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // app bar
            HomeAppBar(profileController: _profileController),

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

                    _ServiceRequestActivity(controller: _servicesController),

                    _OrderActivity(controller: _ordersController),

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

class _OrderActivity extends StatelessWidget {
  const _OrderActivity({required this.controller});
  final OrdersController controller;

  @override
  Widget build(BuildContext context) => Obx(() {
    final shipped = controller.orders.firstWhereOrNull(
      (item) => item.api.status == CommerceOrderStatus.shipped,
    );
    if (shipped == null) return const SizedBox.shrink();
    return ShippedCard(
      orderId: '#${shipped.orderCode}',
      title: shipped.itemName,
      trackingNumber: shipped.trackingNumber,
    );
  });
}

class _ServiceRequestActivity extends StatelessWidget {
  const _ServiceRequestActivity({required this.controller});

  final ServicesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quote = controller.requests.firstWhereOrNull(
        (item) => item.api.status == CustomerRequestStatus.quoteSent,
      );
      final scheduled = controller.requests.firstWhereOrNull(
        (item) => item.api.status == CustomerRequestStatus.scheduled,
      );
      if (controller.isLoading.value && controller.requests.isEmpty) {
        return Skeletonizer(
          enabled: true,
          child: QuoteReadyCard(
            price: '\$000.00',
            expiresAt: 'Loading quotation',
            title: 'Service request',
            requestId: 'SR-0000',
            description: 'Loading your latest service activity.',
          ),
        );
      }
      return Column(
        children: [
          if (quote != null)
            QuoteReadyCard(
              price: '\$${quote.quotedAmount.toStringAsFixed(2)}',
              expiresAt: quote.quoteValidUntil == null
                  ? 'Quote available'
                  : 'Expires ${DateFormat('MMM d, h:mm a').format(quote.quoteValidUntil!)}',
              title: quote.title,
              requestId: quote.id,
              description: quote.issueDescription,
            ),
          if (scheduled != null)
            ScheduledCard(
              title: scheduled.title,
              dateTime: scheduled.appointmentDate == null
                  ? 'Appointment time pending'
                  : '${DateFormat('EEEE, MMM d').format(scheduled.appointmentDate!)} · ${scheduled.appointmentTimeRange}',
              technicianName: scheduled.technicianName,
            ),
        ],
      );
    });
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.profileController});

  final ViewProfileController profileController;

  @override
  Widget build(BuildContext context) {
    final notifications = Get.find<NotificationsController>();
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
                      Obx(
                        () => Skeletonizer(
                          enabled: profileController.isLoading.value,
                          effect: ShimmerEffect(
                            baseColor: Colors.white.withValues(alpha: 0.18),
                            highlightColor: Colors.white.withValues(
                              alpha: 0.42,
                            ),
                          ),
                          child: Text(
                            profileController.homeLocation,
                            style: getTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
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
                      child: Obx(
                        () => notifications.unreadCount == 0
                            ? const SizedBox.shrink()
                            : Container(
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
                  color: Colors.black.withValues(alpha: 0.1),
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
