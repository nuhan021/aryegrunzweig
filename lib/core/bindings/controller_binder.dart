import 'package:aryegrunzweig/features/app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import 'package:aryegrunzweig/features/auth/controller/auth_controller.dart';
import 'package:aryegrunzweig/features/auth/data/auth_repository.dart';
import 'package:aryegrunzweig/features/home/controller/home_controller.dart';
import 'package:aryegrunzweig/features/onboarding/controller/onboarding_controller.dart';
import 'package:aryegrunzweig/features/profile/data/profile_repository.dart';
import 'package:aryegrunzweig/features/profile/view_profile/controllers/view_profile_controller.dart';
import 'package:aryegrunzweig/features/services/data/service_request_repository.dart';
import 'package:aryegrunzweig/features/services/controller/services_controller.dart';
import 'package:aryegrunzweig/features/shop/controller/shop_controller.dart';
import 'package:aryegrunzweig/features/shop/data/commerce_repository.dart';
import 'package:aryegrunzweig/features/orders/controller/orders_controller.dart';
import 'package:aryegrunzweig/features/notifications/controllers/notifications_controller.dart';
import 'package:aryegrunzweig/features/notifications/data/notifications_repository.dart';
import 'package:aryegrunzweig/features/technician/controller/technician_equipment_controller.dart';
import 'package:aryegrunzweig/features/technician/controller/technician_jobs_controller.dart';
import 'package:aryegrunzweig/features/technician/data/technician_repository.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:get/get.dart';

import '../services/api_client.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(
      ApiClient(
        onSessionExpired: () {
          if (Get.currentRoute != AppRoute.loginScreen) {
            Get.offAllNamed(AppRoute.loginScreen);
          }
        },
      ),
      permanent: true,
    );

    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );

    Get.put<AuthController>(
      AuthController(repository: AuthRepository(Get.find<ApiClient>())),
      permanent: true,
    );

    Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<ViewProfileController>(
      () => ViewProfileController(),
      fenix: true,
    );

    Get.lazyPut<ServiceRequestRepository>(
      () => ServiceRequestRepository(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<ServicesController>(() => ServicesController(), fenix: true);

    Get.lazyPut<CommerceRepository>(
      () => CommerceRepository(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<ShopController>(() => ShopController(), fenix: true);
    Get.lazyPut<OrdersController>(() => OrdersController(), fenix: true);

    Get.lazyPut<AppBottomNavBarController>(
      () => AppBottomNavBarController(),
      fenix: true,
    );

    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    Get.lazyPut<NotificationsRepository>(
      () => NotificationsRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true,
    );

    Get.lazyPut<TechnicianRepository>(
      () => TechnicianRepository(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<TechnicianJobsController>(
      () => TechnicianJobsController(),
      fenix: true,
    );
    Get.lazyPut<TechnicianEquipmentController>(
      () => TechnicianEquipmentController(),
      fenix: true,
    );
  }
}
