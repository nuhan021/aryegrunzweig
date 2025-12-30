

import 'package:aryegrunzweig/features/auth/controller/auth_controller.dart';
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

  }
}