import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/register/screens/otp_verification_screen.dart';
import 'package:swype/features/authentication/register/screens/profile_details_screen.dart';
import 'package:swype/features/home/screens/discover_screen.dart';

class SplashController {
  final WidgetRef ref;

  SplashController(this.ref);

  void navigationHandler(BuildContext context) async {
    ref.read(authProvider.notifier);
    ref.read(registerProvider.notifier);
    await Future.delayed(const Duration(seconds: 3));

    final isAuthenticated = ref.read(authProvider).isAuthenticated;

    final userState = ref.read(registerProvider);
    final isRegistered = userState['isRegistered'];
    final isOtpVerified = userState['isOtpVerified'];
    final isDetailsFilled = userState['isDetailsFilled'];

    if (isRegistered && !isOtpVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            phoneNumber: userState['phone'],
          ),
        ),
      );
    } else if (isRegistered && isOtpVerified && !isDetailsFilled) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileDetailsScreen(),
        ),
      );
    } else if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DiscoverScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }
}
