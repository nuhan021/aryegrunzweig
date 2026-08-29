import 'package:aryegrunzweig/features/auth/views/screens/otp_screen.dart';
import 'package:aryegrunzweig/features/chat/individual_chat/views/screens/individual_chat_screen.dart';
import 'package:aryegrunzweig/features/notifications/views/screens/notifications_screen.dart';
import 'package:aryegrunzweig/features/profile/edit_profile/views/screens/edit_profile_screen.dart';
import 'package:aryegrunzweig/features/profile/equipment_details/views/screens/equipment_details_screen.dart';
import 'package:aryegrunzweig/features/profile/help_support/views/screens/help_support_screen.dart';
import 'package:aryegrunzweig/features/profile/payment_methods/views/screens/payment_methods_screen.dart';
import 'package:aryegrunzweig/features/profile/saved_addresses/views/screens/saved_addresses_screen.dart';
import 'package:aryegrunzweig/features/profile/service_history/views/screens/service_history_screen.dart';
import 'package:aryegrunzweig/features/profile/terms_conditions/views/screens/terms_conditions_screen.dart';
import 'package:aryegrunzweig/features/profile/view_profile/views/screens/view_profile_screen.dart';
import 'package:get/get.dart';
import '../features/app_bottom_nav_bar/veiws/app_bottom_nav_bar.dart';
import '../features/auth/views/screens/account_create_success_screen.dart';
import '../features/auth/views/screens/forgot_password_screen.dart';
import '../features/auth/views/screens/login_screen.dart';
import '../features/auth/views/screens/sign_up_screen.dart';
import '../features/auth/views/screens/reset_password_screen.dart';
import '../features/auth/views/screens/technician_approval_pending_screen.dart';
import '../features/onboarding/views/screens/onboarding_screen.dart';

class AppRoute {
  static String onboardingScreen = "/onboardingScreen";
  static String loginScreen = "/loginScreen";
  static String forgotPasswordScreen = "/forgotPasswordScreen";
  static String otpScreen = "/otpScreen";
  static String signUpScreen = "/signUpScreen";
  static String accountCreateSuccessScreen = "/accountCreateSuccessScreen";
  static String resetPasswordScreen = "/resetPasswordScreen";
  static String technicianApprovalPendingScreen =
      "/technicianApprovalPendingScreen";
  static String appBottomNavBarScreen = "/appBottomNavBarScreen";
  static String viewProfileScreen = "/viewProfileScreen";
  static String editProfileScreen = "/editProfileScreen";
  static String paymentMethodsScreen = "/paymentMethodsScreen";
  static String equipmentDetailsScreen = "/equipmentDetailsScreen";
  static String savedAddressesScreen = "/savedAddressesScreen";
  static String serviceHistoryScreen = "/serviceHistoryScreen";
  static String helpSupportScreen = "/helpSupportScreen";
  static String termsPrivacyScreen = "/termsPrivacyScreen";
  static String notificationsScreen = "/notificationsScreen";
  static String individualChatScreen = "/individualChatScreen";

  static String getOnboardingScreen() => onboardingScreen;
  static String getLoginScreen() => loginScreen;
  static String getForgotPasswordScreen() => forgotPasswordScreen;
  static String getOtpScreen() => otpScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getAccountCreateSuccessScreen() => accountCreateSuccessScreen;
  static String getAppBottomNavBarScreen() => appBottomNavBarScreen;
  static String getViewProfileScreen() => viewProfileScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getPaymentMethodsScreen() => paymentMethodsScreen;
  static String getEquipmentDetailsScreen() => equipmentDetailsScreen;
  static String getSavedAddressesScreen() => savedAddressesScreen;
  static String getServiceHistoryScreen() => serviceHistoryScreen;
  static String getHelpSupportScreen() => helpSupportScreen;
  static String getTermsPrivacyScreen() => termsPrivacyScreen;
  static String getNotificationsScreen() => notificationsScreen;
  static String getIndividualChatScreen() => individualChatScreen;

  static List<GetPage> routes = [
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: otpScreen, page: () => OtpScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: resetPasswordScreen, page: () => ResetPasswordScreen()),
    GetPage(
      name: technicianApprovalPendingScreen,
      page: () => TechnicianApprovalPendingScreen(),
    ),
    GetPage(
      name: accountCreateSuccessScreen,
      page: () => AccountCreateSuccessScreen(),
    ),
    GetPage(name: appBottomNavBarScreen, page: () => AppBottomNavBar()),
    GetPage(name: viewProfileScreen, page: () => ViewProfileScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(name: paymentMethodsScreen, page: () => PaymentMethodsScreen()),
    GetPage(name: equipmentDetailsScreen, page: () => EquipmentDetailsScreen()),
    GetPage(name: savedAddressesScreen, page: () => SavedAddressesScreen()),
    GetPage(name: serviceHistoryScreen, page: () => ServiceHistoryScreen()),
    GetPage(name: helpSupportScreen, page: () => HelpSupportScreen()),
    GetPage(name: termsPrivacyScreen, page: () => TermsConditionsScreen()),
    GetPage(name: notificationsScreen, page: () => NotificationsScreen()),
    GetPage(name: individualChatScreen, page: () => IndividualChatScreen()),
  ];
}
