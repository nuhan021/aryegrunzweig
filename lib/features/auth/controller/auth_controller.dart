import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/logging/logger.dart';
import '../../../routes/app_routes.dart';
import '../data/auth_repository.dart';
import '../models/auth_models.dart';

class AuthController extends GetxController {
  AuthController({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;

  final currentUserRole = UserRole.customer.obs;
  final selectedSignupRole = UserRole.customer.obs;
  final currentProfile = Rxn<UserProfileResponse>();
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;
  final infoMessage = ''.obs;

  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

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

  final TextEditingController serviceAreaController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController yearsExperienceController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final TextEditingController forgotPasswordEmailController =
      TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController resetPasswordConfirmController =
      TextEditingController();

  String countryCode = 'CA';
  String dialCode = '+1';
  String otp = '';
  String pendingVerificationEmail = '';
  String pendingResetEmail = '';

  final isPasswordHidden = true.obs;
  final isRetypePasswordHidden = true.obs;
  final isResetPasswordHidden = true.obs;
  final termAndCondition = false.obs;
  final isLoginPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    setRoleFromBackend(StorageService.userRole);
  }

  bool get isTechnician => currentUserRole.value == UserRole.technician;

  bool get isTechnicianSignup =>
      selectedSignupRole.value == UserRole.technician;

  bool get technicianIsVerified =>
      currentProfile.value?.technician?.verificationStatus ==
      TechnicianVerificationStatus.verified;

  String get authenticatedDestination {
    if (isTechnician && !technicianIsVerified) {
      return AppRoute.technicianApprovalPendingScreen;
    }
    return AppRoute.appBottomNavBarScreen;
  }

  void selectSignupRole(UserRole role) {
    if (role != UserRole.admin) selectedSignupRole.value = role;
  }

  void togglePasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void setRoleFromBackend(String? role) {
    if (role == null || role.isEmpty) {
      currentUserRole.value = UserRole.customer;
      return;
    }
    try {
      final parsed = UserRole.fromJson(role);
      currentUserRole.value = parsed == UserRole.admin
          ? UserRole.customer
          : parsed;
    } on FormatException {
      currentUserRole.value = UserRole.customer;
    }
  }

  Future<bool> login() async {
    if (!_beginRequest()) return false;
    final email = loginEmailController.text.trim().toLowerCase();
    final password = loginPasswordController.text;
    if (!_isValidEmail(email) || password.isEmpty) {
      AppLoggerHelper.warning(
        '[Auth] Login validation failed: invalid email or password.',
      );
      return _finishWithError('Enter a valid email and password.');
    }

    final result = await _repository.login(email: email, password: password);
    if (!result.isSuccess || result.data == null) {
      AppLoggerHelper.error(
        '[Auth] Login failed (${result.statusCode}): ${result.errorMessage}',
      );
      return _finishWithError(result.errorMessage);
    }
    final session = result.data!;
    if (session.user.role == UserRole.admin) {
      AppLoggerHelper.warning(
        '[Auth] Login rejected: admin role is unsupported.',
      );
      return _finishWithError('Admin accounts are not supported in this app.');
    }

    await _persistSession(session);
    await _loadCurrentProfile();
    isSubmitting.value = false;
    return true;
  }

  Future<bool> signup() async {
    if (!_beginRequest()) return false;
    final validationError = _validateSignup();
    if (validationError != null) {
      AppLoggerHelper.warning(
        '[Auth] Signup validation failed: $validationError',
      );
      return _finishWithError(validationError);
    }

    final common = _customerSignupRequest();
    final result = isTechnicianSignup
        ? await _repository.signupTechnician(
            TechnicianSignupRequest(
              email: common.email,
              password: common.password,
              firstName: common.firstName,
              lastName: common.lastName,
              phone: common.phone,
              address: common.address,
              apartment: common.apartment,
              city: common.city,
              state: common.state,
              zipCode: common.zipCode,
              acceptTerms: common.acceptTerms,
              termsVersion: common.termsVersion,
              serviceArea: serviceAreaController.text.trim(),
              skills: _technicianSkills,
              employeeId: _optional(employeeIdController.text),
              licenseNumber: _optional(licenseNumberController.text),
              yearsExperience: _optionalNumber(yearsExperienceController.text),
              bio: _optional(bioController.text),
            ),
          )
        : await _repository.signupCustomer(common);

    if (!result.isSuccess || result.data == null) {
      AppLoggerHelper.error(
        '[Auth] ${isTechnicianSignup ? 'Technician' : 'Customer'} signup '
        'failed (${result.statusCode}): ${result.errorMessage}',
      );
      return _finishWithError(result.errorMessage);
    }
    pendingVerificationEmail = common.email;
    infoMessage.value = result.data!.message;
    isSubmitting.value = false;
    return true;
  }

  Future<bool> verifyEmail() async {
    if (!_beginRequest()) return false;
    if (pendingVerificationEmail.isEmpty || !RegExp(r'^\d{5}$').hasMatch(otp)) {
      return _finishWithError('Enter the 5-digit verification code.');
    }

    final result = await _repository.verifyEmail(
      email: pendingVerificationEmail,
      otp: otp,
    );
    if (!result.isSuccess || result.data == null) {
      return _finishWithError(result.errorMessage);
    }
    await _persistSession(result.data!.session);
    await _loadCurrentProfile();
    isSubmitting.value = false;
    return true;
  }

  Future<bool> resendVerification() async {
    if (!_beginRequest()) return false;
    if (pendingVerificationEmail.isEmpty) {
      return _finishWithError('Verification email is missing.');
    }
    final result = await _repository.resendVerification(
      pendingVerificationEmail,
    );
    if (!result.isSuccess || result.data == null) {
      return _finishWithError(result.errorMessage);
    }
    infoMessage.value = result.data!.message;
    isSubmitting.value = false;
    return true;
  }

  Future<bool> requestPasswordReset() async {
    if (!_beginRequest()) return false;
    final email = forgotPasswordEmailController.text.trim().toLowerCase();
    if (!_isValidEmail(email)) {
      return _finishWithError('Enter a valid email address.');
    }
    final result = await _repository.forgotPassword(email);
    if (!result.isSuccess || result.data == null) {
      return _finishWithError(result.errorMessage);
    }
    pendingResetEmail = email;
    infoMessage.value = result.data!.message;
    isSubmitting.value = false;
    return true;
  }

  Future<bool> resetPassword() async {
    if (!_beginRequest()) return false;
    final password = resetPasswordController.text;
    if (pendingResetEmail.isEmpty || !RegExp(r'^\d{5}$').hasMatch(otp)) {
      return _finishWithError('Enter the 5-digit reset code.');
    }
    if (password.length < 8) {
      return _finishWithError('Password must be at least 8 characters.');
    }
    if (password != resetPasswordConfirmController.text) {
      return _finishWithError('Passwords do not match.');
    }

    final result = await _repository.resetPassword(
      email: pendingResetEmail,
      otp: otp,
      password: password,
    );
    if (!result.isSuccess || result.data?.success != true) {
      return _finishWithError(result.errorMessage);
    }
    infoMessage.value = 'Password reset successfully. Please log in.';
    isSubmitting.value = false;
    return true;
  }

  Future<bool> completeOnboarding() async {
    if (!_beginRequest()) return false;
    final result = await _repository.completeOnboarding();
    if (!result.isSuccess || result.data?.success != true) {
      return _finishWithError(result.errorMessage);
    }
    isSubmitting.value = false;
    return true;
  }

  Future<bool> refreshCurrentProfile() async {
    if (!_beginRequest()) return false;
    final result = await _repository.getCurrentUser();
    if (!result.isSuccess || result.data == null) {
      return _finishWithError(result.errorMessage);
    }
    currentProfile.value = result.data;
    currentUserRole.value = result.data!.role;
    await StorageService.updateIdentity(
      userId: result.data!.id,
      userRole: result.data!.role.wireValue,
    );
    isSubmitting.value = false;
    return true;
  }

  Future<void> logout() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    final refreshToken = StorageService.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _repository.logout(refreshToken);
    }
    await StorageService.logoutUser();
    currentProfile.value = null;
    currentUserRole.value = UserRole.customer;
    isSubmitting.value = false;
  }

  CustomerSignupRequest _customerSignupRequest() {
    final localPhone = phoneNumberController.text.trim();
    return CustomerSignupRequest(
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phone: '$dialCode $localPhone'.trim(),
      address: addressController.text.trim(),
      apartment: _optional(aptController.text),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      zipCode: zipController.text.trim(),
      acceptTerms: termAndCondition.value,
      termsVersion: ApiConstants.termsVersion,
    );
  }

  Future<void> _persistSession(AuthSessionResponse session) async {
    await StorageService.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      userId: session.user.id,
      userRole: session.user.role.wireValue,
    );
    currentUserRole.value = session.user.role;
  }

  Future<void> _loadCurrentProfile() async {
    final profileResult = await _repository.getCurrentUser();
    if (profileResult.isSuccess && profileResult.data != null) {
      currentProfile.value = profileResult.data;
      currentUserRole.value = profileResult.data!.role;
      await StorageService.updateIdentity(
        userId: profileResult.data!.id,
        userRole: profileResult.data!.role.wireValue,
      );
    }
  }

  String? _validateSignup() {
    final requiredValues = [
      firstNameController.text,
      lastNameController.text,
      phoneNumberController.text,
      addressController.text,
      cityController.text,
      stateController.text,
      zipController.text,
    ];
    if (requiredValues.any((value) => value.trim().isEmpty)) {
      return 'Complete all required account and address fields.';
    }
    if (!_isValidEmail(emailController.text.trim())) {
      return 'Enter a valid email address.';
    }
    if (passwordController.text.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (passwordController.text != retypePasswordController.text) {
      return 'Passwords do not match.';
    }
    if (!termAndCondition.value) return 'Accept the terms to continue.';
    if (isTechnicianSignup &&
        (serviceAreaController.text.trim().isEmpty ||
            _technicianSkills.isEmpty)) {
      return 'Service area and at least one skill are required.';
    }
    if (yearsExperienceController.text.trim().isNotEmpty &&
        _optionalNumber(yearsExperienceController.text) == null) {
      return 'Years of experience must be a positive number.';
    }
    return null;
  }

  List<String> get _technicianSkills => skillsController.text
      .split(',')
      .map((skill) => skill.trim())
      .where((skill) => skill.isNotEmpty)
      .toList(growable: false);

  bool _beginRequest() {
    if (isSubmitting.value) return false;
    isSubmitting.value = true;
    errorMessage.value = '';
    infoMessage.value = '';
    return true;
  }

  bool _finishWithError(String message) {
    errorMessage.value = message.isEmpty
        ? 'Something went wrong. Please try again.'
        : message;
    isSubmitting.value = false;
    return false;
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value);

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  num? _optionalNumber(String value) {
    final parsed = num.tryParse(value.trim());
    return parsed != null && parsed >= 0 ? parsed : null;
  }
}
