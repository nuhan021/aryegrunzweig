import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/models/auth_models.dart';
import '../../data/profile_repository.dart';

class ViewProfileController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();

  final profile = Rxn<UserProfileResponse>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isLoggingOut = false.obs;

  String get userName {
    final value = profile.value;
    return value == null ? '' : '${value.firstName} ${value.lastName}'.trim();
  }

  String get userEmail => profile.value?.email ?? '';
  String? get profileImageUrl => profile.value?.avatarUrl;
  String get displayedUserName =>
      userName.isEmpty ? (isLoading.value ? 'Customer Name' : '—') : userName;
  String get displayedUserEmail => userEmail.isEmpty
      ? (isLoading.value ? 'customer@example.com' : '—')
      : userEmail;

  String get homeLocation {
    final address = primaryAddress;
    if (address == null) {
      return isLoading.value ? 'Loading location...' : 'Location unavailable';
    }
    return [
      address.city.trim(),
      address.state.trim(),
    ].where((part) => part.isNotEmpty).join(', ');
  }

  AddressResponse? get primaryAddress {
    final items = profile.value?.addresses ?? const <AddressResponse>[];
    for (final address in items) {
      if (address.isPrimary) return address;
    }
    return items.isEmpty ? null : items.first;
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    final result = await _repository.getProfile();
    if (result.isSuccess && result.data != null) {
      profile.value = result.data;
      Get.find<AuthController>().currentProfile.value = result.data;
    } else {
      errorMessage.value = result.errorMessage;
    }
    isLoading.value = false;
  }

  Future<void> handleLogout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;
    try {
      await Get.find<AuthController>().logout();
      Get.offAllNamed(AppRoute.loginScreen);
    } finally {
      isLoggingOut.value = false;
    }
  }
}
