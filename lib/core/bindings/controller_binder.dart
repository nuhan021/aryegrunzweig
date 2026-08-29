import 'package:aryegrunzweig/features/app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import 'package:aryegrunzweig/features/auth/controller/auth_controller.dart';
import 'package:aryegrunzweig/features/auth/data/auth_repository.dart';
import 'package:aryegrunzweig/features/home/controller/home_controller.dart';
import 'package:aryegrunzweig/features/onboarding/controller/onboarding_controller.dart';
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

    Get.lazyPut<AppBottomNavBarController>(
      () => AppBottomNavBarController(),
      fenix: true,
    );

    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
