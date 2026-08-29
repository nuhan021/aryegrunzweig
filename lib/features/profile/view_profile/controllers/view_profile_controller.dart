import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:get/get.dart';

class ViewProfileController extends GetxController {
  // Observable variables for dynamic updates
  var userName = 'John Doe'.obs;
  var userEmail = 'sarah.thompson@email.com'.obs;
  var profileImageUrl = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    // Load user profile data from backend here
    _loadUserProfile();
  }

  void _loadUserProfile() {
    // userName.value = response.userName;
    // userEmail.value = response.userEmail;
    // profileImageUrl.value = response.profileImageUrl;
  }

  void handleEditProfile() {
    Get.toNamed(AppRoute.editProfileScreen);
  }

  void handlePaymentMethods() {
    Get.toNamed(AppRoute.paymentMethodsScreen);
  }

  void handleEquipmentDetails() {
    Get.toNamed(AppRoute.equipmentDetailsScreen);
  }

  void handleSavedAddresses() {
    Get.toNamed(AppRoute.savedAddressesScreen);
  }

  void handleServiceHistory() {
    Get.toNamed(AppRoute.serviceHistoryScreen);
  }

  void handleNotifications() {
    Get.toNamed('/notificationsScreen');
  }

  void handleHelpSupport() {
    Get.toNamed(AppRoute.helpSupportScreen);
  }

  void handleTermsPrivacy() {
    Get.toNamed(AppRoute.termsPrivacyScreen);
  }

  void handleLogout() {
    // 1. Clear local storage
    // 2. Clear authentication tokens
    // 3. Navigate to login screen
    Get.offAllNamed(AppRoute.loginScreen);
  }
}
