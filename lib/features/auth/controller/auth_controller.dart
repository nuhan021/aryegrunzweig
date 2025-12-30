import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {

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
  final TextEditingController retypePasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  late String countryCode = '';
  late String dialCode = '';
  RxBool isPasswordHidden = true.obs;
  RxBool isRetypePasswordHidden = true.obs;
  RxBool termAndCondition = false.obs;



  // forgot password text field
  final TextEditingController forgotPasswordEmailController = TextEditingController();

  // otp field
  String otp = '';

  var isLoginPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }
}