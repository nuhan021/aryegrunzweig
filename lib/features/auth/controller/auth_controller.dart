import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {

  // login text field
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  // forgot password text field
  final TextEditingController forgotPasswordEmailController = TextEditingController();

  // otp field
  String otp = '';

  var isLoginPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }
}