

import 'package:aryegrunzweig/features/app_bottom_nav_bar/controller/app_bottom_nav_bar_controller.dart';
import 'package:aryegrunzweig/features/auth/controller/auth_controller.dart';
import 'package:aryegrunzweig/features/home/controller/home_controller.dart';
import 'package:aryegrunzweig/features/onboarding/controller/onboarding_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
          () => OnboardingController(),
      fenix: true,
    );

    Get.lazyPut<AuthController>(
          () => AuthController(),
      fenix: true,
    );

    Get.lazyPut<AppBottomNavBarController>(
          () => AppBottomNavBarController(),
      fenix: true,
    );

    Get.lazyPut<HomeController>(
          () => HomeController(),
      fenix: true,
    );

  }
}