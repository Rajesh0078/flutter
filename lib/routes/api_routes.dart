class ApiRoutes {
  static const String baseUrl = 'https://swype.co.il/api/v1';

  // Authentication Routes
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String verifyOTP = '$baseUrl/verify-phone-otp';
  static const String logout = '$baseUrl/logout';
  static const String refreshToken = '$baseUrl/refresh';
  static const String socialLogin = '$baseUrl/social-register-with-login';

  // Get User Profile
  static const String getUser = '$baseUrl/get-user-profile';
  static const String updateUser = '$baseUrl/user-profile-update';

  // Advance Search
  static const String advanceSearch = '$baseUrl/advanced-search';

  // Update password
  static const String updatePassword = '$baseUrl/update-password';

  // Security
  static const String enableTwoFactor = '$baseUrl/enable-two-factor-auth';
  static const String verifyTwoFactor = '$baseUrl/verify-two-factor-auth';
  static const String disableTwoFactor = '$baseUrl/disable-two-factor-auth';
}
