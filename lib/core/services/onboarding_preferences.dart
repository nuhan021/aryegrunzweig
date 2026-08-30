import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreferences {
  OnboardingPreferences._();

  static const String _completedKey = 'has_completed_app_onboarding';

  static Future<bool> isCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_completedKey) ?? false;
  }

  static Future<void> markCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_completedKey, true);
  }
}
