import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:get/get.dart';

class ViewProfileController extends GetxController {
  // Observable variables for dynamic updates
  var userName = 'John Doe'.obs;
  var userEmail = 'john.doe@example.com'.obs;
  var profileImageUrl = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    // Load user profile data from backend here
    _loadUserProfile();
  }

  void _loadUserProfile() {
    // TODO: Implement backend call to fetch user profile
    // userName.value = response.userName;
    // userEmail.value = response.userEmail;
    // profileImageUrl.value = response.profileImageUrl;
  }

  void handleEditProfile() {
    // TODO: Navigate to edit profile screen
    Get.toNamed(AppRoute.editProfileScreen);
  }

  void handlePaymentMethods() {
    // TODO: Navigate to payment methods screen
    Get.toNamed(AppRoute.paymentMethodsScreen);
  }

  void handleEquipmentDetails() {
    // TODO: Navigate to equipment details screen
    Get.toNamed(AppRoute.equipmentDetailsScreen);
  }

  void handleSavedAddresses() {
    // TODO: Navigate to saved addresses screen
    Get.toNamed(AppRoute.savedAddressesScreen);
  }

  void handleServiceHistory() {
    // TODO: Navigate to service history screen
    Get.toNamed(AppRoute.serviceHistoryScreen);
  }

  void handleNotifications() {
    // TODO: Navigate to notifications screen
    Get.toNamed('/notificationsScreen');
  }

  void handleHelpSupport() {
    // TODO: Navigate to help & support screen
    Get.toNamed(AppRoute.helpSupportScreen);
  }

  void handleTermsPrivacy() {
    // TODO: Navigate to terms & privacy screen
    Get.toNamed(AppRoute.termsPrivacyScreen);
  }

  void handleLogout() {
    // TODO: Implement logout functionality
    // 1. Clear local storage
    // 2. Clear authentication tokens
    // 3. Navigate to login screen
    Get.offAllNamed(AppRoute.loginScreen);
  }
}
