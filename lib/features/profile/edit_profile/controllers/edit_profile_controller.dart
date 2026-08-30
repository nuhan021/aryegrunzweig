import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/helpers/app_helper.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/models/auth_models.dart';
import '../../data/profile_models.dart';
import '../../data/profile_repository.dart';
import '../../view_profile/controllers/view_profile_controller.dart';

class EditProfileController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();
  final AuthController _authController = Get.find<AuthController>();

  final profileImageUrl = Rxn<String>();
  final selectedImageFile = Rxn<File>();
  final isLoading = false.obs;
  final isInitializing = true.obs;
  final errorMessage = ''.obs;

  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController companyController;
  late final TextEditingController addressController;
  late final TextEditingController apartmentController;
  late final TextEditingController cityController;
  late final TextEditingController stateController;
  late final TextEditingController zipController;

  AddressResponse? _primaryAddress;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    companyController = TextEditingController();
    addressController = TextEditingController();
    apartmentController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    zipController = TextEditingController();
    loadProfile();
  }

  Future<void> loadProfile() async {
    var value = _authController.currentProfile.value;
    if (value == null) {
      final result = await _repository.getProfile();
      if (result.isSuccess) value = result.data;
    }
    if (value == null) {
      errorMessage.value = 'Unable to load your profile.';
      isInitializing.value = false;
      return;
    }
    _authController.currentProfile.value = value;
    fullNameController.text = '${value.firstName} ${value.lastName}'.trim();
    emailController.text = value.email;
    phoneController.text = value.phone ?? '';
    companyController.text = value.company ?? '';
    profileImageUrl.value = value.avatarUrl;
    _primaryAddress = _findPrimary(value.addresses);
    final address = _primaryAddress;
    if (address != null) {
      addressController.text = address.line1;
      apartmentController.text = address.apartment ?? '';
      cityController.text = address.city;
      stateController.text = address.state;
      zipController.text = address.zipCode;
    }
    isInitializing.value = false;
  }

  Future<void> changeProfilePhoto() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImageFile.value = File(image.path);
        profileImageUrl.value = image.path;
      }
    } catch (_) {
      AppHelperFunctions.showErrorSnackBar('Failed to pick image.');
    }
  }

  Future<void> saveChanges() async {
    if (isLoading.value) return;
    final names = fullNameController.text.trim().split(RegExp(r'\s+'));
    if (names.length < 2 || names.first.isEmpty) {
      AppHelperFunctions.showErrorSnackBar('Enter both first and last name.');
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    final profileResult = await _repository.updateProfile(
      ProfileUpdateRequest(
        firstName: names.first,
        lastName: names.sublist(1).join(' '),
        phone: phoneController.text.trim(),
        company: companyController.text.trim(),
        avatarPath: selectedImageFile.value?.path,
      ),
    );
    if (!profileResult.isSuccess) {
      _finishError(profileResult.errorMessage);
      return;
    }

    final addressError = await _savePrimaryAddress();
    if (addressError != null) {
      _finishError(addressError);
      return;
    }

    final refreshed = await _repository.getProfile();
    if (refreshed.isSuccess && refreshed.data != null) {
      _authController.currentProfile.value = refreshed.data;
      if (Get.isRegistered<ViewProfileController>()) {
        Get.find<ViewProfileController>().profile.value = refreshed.data;
      }
    }
    isLoading.value = false;
    AppHelperFunctions.showSuccessSnackBar('Profile updated successfully.');
    Get.back();
  }

  Future<String?> _savePrimaryAddress() async {
    final hasAddress = [
      addressController.text,
      cityController.text,
      stateController.text,
      zipController.text,
    ].any((value) => value.trim().isNotEmpty);
    if (!hasAddress) return null;
    if ([
      addressController.text,
      cityController.text,
      stateController.text,
      zipController.text,
    ].any((value) => value.trim().isEmpty)) {
      return 'Complete all required address fields.';
    }
    final request = AddressRequest(
      line1: addressController.text.trim(),
      apartment: _optional(apartmentController.text),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      zipCode: zipController.text.trim(),
      country: _primaryAddress?.country ?? 'Canada',
      latitude: _primaryAddress?.latitude,
      longitude: _primaryAddress?.longitude,
      isPrimary: true,
    );
    final result = _primaryAddress == null
        ? await _repository.addAddress(request)
        : await _repository.updateAddress(_primaryAddress!.id, request);
    return result.isSuccess ? null : result.errorMessage;
  }

  AddressResponse? _findPrimary(List<AddressResponse> addresses) {
    for (final address in addresses) {
      if (address.isPrimary) return address;
    }
    return addresses.isEmpty ? null : addresses.first;
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  void _finishError(String message) {
    errorMessage.value = message;
    isLoading.value = false;
    AppHelperFunctions.showErrorSnackBar(message);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyController.dispose();
    addressController.dispose();
    apartmentController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.onClose();
  }
}
