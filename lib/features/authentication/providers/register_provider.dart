import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final registerProvider =
    StateNotifierProvider<RegisterStateNotifier, Map<String, dynamic>>((ref) {
  return RegisterStateNotifier();
});

class RegisterStateNotifier extends StateNotifier<Map<String, dynamic>> {
  RegisterStateNotifier()
      : super({
          'token': null,
          'name': null,
          'email': null,
          'phone': null,
          'isRegistered': false,
          'isOtpVerified': false,
          'isDetailsFilled': false,
        }) {
    // Load user data when the notifier is initialized
    loadUser();
  }
  // Load user data from SharedPreferences
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final name = prefs.getString('userName');
    final email = prefs.getString('userEmail');
    final phone = prefs.getString('userPhone');
    final isRegistered = prefs.getBool('isRegistered') ?? false;
    final isOtpVerified = prefs.getBool('isOtpVerified') ?? false;
    final isDetailsFilled = prefs.getBool('isDetailsFilled') ?? false;

    state = {
      'token': token,
      'name': name,
      'email': email,
      'phone': phone,
      'isRegistered': isRegistered,
      'isOtpVerified': isOtpVerified,
      'isDetailsFilled': isDetailsFilled,
    };
  }

  // Save user information (including token, name, email, and phone)
  Future<void> saveUserInfo(
      String token, String name, String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userPhone', phone);

    state = {
      'token': token,
      'name': name,
      'email': email,
      'phone': phone,
      ...state,
    };
  }

  // Update isRegistered
  Future<void> updateIsRegistered(bool isRegistered) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegistered', isRegistered);
    state = {
      ...state,
      'isRegistered': isRegistered,
    };
  }

  // Update isOtpVerified
  Future<void> updateIsOtpVerified(bool isOtpVerified) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOtpVerified', isOtpVerified);
    state = {
      ...state,
      'isOtpVerified': isOtpVerified,
    };
  }

  // Update isDetailsFilled
  Future<void> updateIsDetailsFilled(bool isDetailsFilled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDetailsFilled', isDetailsFilled);
    state = {
      ...state,
      'isDetailsFilled': isDetailsFilled,
    };
  }

  // Clear user data (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = {
      'token': null,
      'name': null,
      'email': null,
      'phone': null,
      'isRegistered': false,
      'isOtpVerified': false,
      'isDetailsFilled': false,
    };
  }
}
