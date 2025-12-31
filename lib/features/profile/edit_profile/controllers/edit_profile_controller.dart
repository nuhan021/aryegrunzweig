import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileController extends GetxController {
  // Observable variables for form data
  var fullName = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var address = ''.obs;
  var apartment = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var zipCode = ''.obs;
  var profileImageUrl = Rxn<String>();
  var selectedImageFile = Rxn<File>();
  var isLoading = false.obs;

  // Text editing controllers
  late final fullNameController;
  late final emailController;
  late final phoneController;
  late final addressController;
  late final apartmentController;
  late final cityController;
  late final stateController;
  late final zipController;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadUserProfile();
  }

  void _initializeControllers() {
    fullNameController = TextEditingController(text: fullName.value);
    emailController = TextEditingController(text: email.value);
    phoneController = TextEditingController(text: phoneNumber.value);
    addressController = TextEditingController(text: address.value);
    apartmentController = TextEditingController(text: apartment.value);
    cityController = TextEditingController(text: city.value);
    stateController = TextEditingController(text: state.value);
    zipController = TextEditingController(text: zipCode.value);
  }

  void _loadUserProfile() {
    // userName.value = response.userName;
    // email.value = response.email;
    // phoneNumber.value = response.phoneNumber;
    // address.value = response.address;
    // apartment.value = response.apartment;
    // city.value = response.city;
    // state.value = response.state;
    // zipCode.value = response.zipCode;
    // profileImageUrl.value = response.profileImageUrl;
  }

  void updateFullName(String value) => fullName.value = value;
  void updateEmail(String value) => email.value = value;
  void updatePhoneNumber(String value) => phoneNumber.value = value;
  void updateAddress(String value) => address.value = value;
  void updateApartment(String value) => apartment.value = value;
  void updateCity(String value) => city.value = value;
  void updateState(String value) => state.value = value;
  void updateZipCode(String value) => zipCode.value = value;

  Future<void> changeProfilePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImageFile.value = File(image.path);
        profileImageUrl.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> saveChanges() async {
    try {
      isLoading.value = true;

      // var response = await profileService.updateProfile(
      //   fullName: fullName.value,
      //   email: email.value,
      //   phoneNumber: phoneNumber.value,
      //   address: address.value,
      //   apartment: apartment.value,
      //   city: city.value,
      //   state: state.value,
      //   zipCode: zipCode.value,
      //   profileImage: profileImageUrl.value,
      // );

      // Show success message
      // Get.snackbar('Success', 'Profile updated successfully');
      // Get.back();
    } catch (e) {
      // Show error message
      // Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    apartmentController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.onClose();
  }
}
