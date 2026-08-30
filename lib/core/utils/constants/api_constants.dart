class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://vacuumcare-server.onrender.com';

  static const String refreshToken = '/api/auth/refresh';
  static const String currentUser = '/api/auth/me';
  static const String customerSignup = '/api/auth/customer/signup';
  static const String technicianSignup = '/api/auth/technician/signup';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String resendVerification = '/api/auth/resend-verification';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String completeOnboarding = '/api/users/me/onboarding/complete';
  static const String profile = '/api/users/me';
  static const String notificationPreferences = '/api/users/me/preferences';
  static const String technicianProfile = '/api/users/me/technician';
  static const String addresses = '/api/users/me/addresses';
  static const String paymentHistory = '/api/users/me/payments';
  static const String payments = '/api/payments';
  static const String contact = '/api/contact';
  static const String publicSettings = '/api/public/settings';

  // Swagger SignupDto currently requires this version and the public settings
  // response does not expose one yet. Replace it when that contract is added.
  static const String termsVersion = '2026-08-17';
}
