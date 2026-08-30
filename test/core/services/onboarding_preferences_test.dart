import 'package:aryegrunzweig/core/services/onboarding_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('onboarding is incomplete by default and persists completion', () async {
    SharedPreferences.setMockInitialValues({});

    expect(await OnboardingPreferences.isCompleted(), isFalse);

    await OnboardingPreferences.markCompleted();

    expect(await OnboardingPreferences.isCompleted(), isTrue);
  });
}
