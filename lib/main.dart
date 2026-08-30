import 'package:aryegrunzweig/app.dart';
import 'package:aryegrunzweig/core/services/api_client.dart';
import 'package:aryegrunzweig/core/services/session_service.dart';
import 'package:aryegrunzweig/core/services/storage_service.dart';
import 'package:aryegrunzweig/core/services/onboarding_preferences.dart';
import 'package:aryegrunzweig/routes/app_routes.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();

  final bootstrapClient = ApiClient();
  final session = await SessionService(apiClient: bootstrapClient).bootstrap();
  bootstrapClient.close();
  final hasCompletedOnboarding = await OnboardingPreferences.isCompleted();

  runApp(
    MyApp(
      initialRoute: session.isAuthenticated
          ? session.canOpenRoleHome
                ? AppRoute.appBottomNavBarScreen
                : AppRoute.technicianApprovalPendingScreen
          : hasCompletedOnboarding
          ? AppRoute.loginScreen
          : AppRoute.onboardingScreen,
    ),
  );
}
