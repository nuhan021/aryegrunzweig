import 'package:aryegrunzweig/features/auth/views/screens/otp_screen.dart';
import 'package:get/get.dart';
import '../features/app_bottom_nav_bar/veiws/app_bottom_nav_bar.dart';
import '../features/auth/views/screens/account_create_success_screen.dart';
import '../features/auth/views/screens/forgot_password_screen.dart';
import '../features/auth/views/screens/login_screen.dart';
import '../features/auth/views/screens/sign_up_screen.dart';
import '../features/onboarding/views/screens/onboarding_screen.dart';

class AppRoute {
  static String onboardingScreen = "/onboardingScreen";
  static String loginScreen = "/loginScreen";
  static String forgotPasswordScreen = "/forgotPasswordScreen";
  static String otpScreen = "/otpScreen";
  static String signUpScreen = "/signUpScreen";
  static String accountCreateSuccessScreen = "/accountCreateSuccessScreen";
  static String appBottomNavBarScreen = "/appBottomNavBarScreen";



  static String getOnboardingScreen() => onboardingScreen;
  static String getLoginScreen() => loginScreen;
  static String getForgotPasswordScreen() => forgotPasswordScreen;
  static String getOtpScreen() => otpScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getAccountCreateSuccessScreen() => accountCreateSuccessScreen;
  static String getAppBottomNavBarScreen() => appBottomNavBarScreen;




  static List<GetPage> routes = [
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: otpScreen, page: () => OtpScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: accountCreateSuccessScreen, page: () => AccountCreateSuccessScreen()),
    GetPage(name: appBottomNavBarScreen, page: () => AppBottomNavBar()),
  ];
}
