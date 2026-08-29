import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';

enum AppUserRole { customer, technician }

class AuthController extends GetxController {
  final currentUserRole = AppUserRole.customer.obs;

  // login text field
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  // sign up text field
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aptController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  late String countryCode = '';
  late String dialCode = '';
  RxBool isPasswordHidden = true.obs;
  RxBool isRetypePasswordHidden = true.obs;
  RxBool termAndCondition = false.obs;

  // forgot password text field
  final TextEditingController forgotPasswordEmailController =
      TextEditingController();

  // otp field
  String otp = '';

  var isLoginPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    setRoleFromBackend(StorageService.userRole);
  }

  void togglePasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  bool get isTechnician => currentUserRole.value == AppUserRole.technician;

  void setRoleFromBackend(String? role) {
    final normalizedRole = role?.trim().toLowerCase();
    currentUserRole.value =
        normalizedRole == 'technician' ||
            normalizedRole == 'technical' ||
            normalizedRole == 'tech'
        ? AppUserRole.technician
        : AppUserRole.customer;
  }

  void prepareLocalDemoRole() {
    final email = loginEmailController.text.trim().toLowerCase();
    setRoleFromBackend(
      email.contains('technician') || email.contains('tech')
          ? 'technician'
          : 'customer',
    );
  }
}
