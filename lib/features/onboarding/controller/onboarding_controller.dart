import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/onboarding_preferences.dart';

class OnboardingController extends GetxController {
  final PageController controller = PageController(
    viewportFraction: 1.0,
    keepPage: true,
  );
  var currentPage = 0.obs;

  bool get isLastPage => currentPage.value == 2;

  void skipPage() {
    controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  Future<void> nextPage() async {
    if (isLastPage) {
      await OnboardingPreferences.markCompleted();
      Get.offAllNamed(AppRoute.loginScreen);
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
