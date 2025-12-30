import 'package:aryegrunzweig/features/auth/views/screens/otp_screen.dart';
import 'package:get/get.dart';
import '../features/auth/views/screens/forgot_password_screen.dart';
import '../features/auth/views/screens/login_screen.dart';
import '../features/onboarding/views/screens/onboarding_screen.dart';

class AppRoute {
  static String onboardingScreen = "/onboardingScreen";
  static String loginScreen = "/loginScreen";
  static String forgotPasswordScreen = "/forgotPasswordScreen";
  static String otpScreen = "/otpScreen";


  static String getOnboardingScreen() => onboardingScreen;
  static String getLoginScreen() => loginScreen;
  static String getForgotPasswordScreen() => forgotPasswordScreen;
  static String getOtpScreen() => otpScreen;


  static List<GetPage> routes = [
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: otpScreen, page: () => OtpScreen()),
  ];
}
