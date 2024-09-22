import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart'; // Import the package
import 'app_routes.dart'; // Ensure correct path
import 'package:swype/features/authentication/login/screens/login/login_screen.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/authentication/register/screens/register_screen.dart';
import 'package:swype/features/authentication/login/screens/splash/splash_screen.dart';
import 'package:swype/features/chat/screens/chat_screen.dart';
import 'package:swype/features/home/screens/discover_screen.dart';
import 'package:swype/features/matches/screens/matches_screen.dart';
import 'package:swype/features/nearby/screens/nearby_screen.dart';
import 'package:swype/features/settings/screens/settings_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Widget page;

  switch (settings.name) {
    case AppRoutes.splash:
      page = const SplashScreen();
      break;
    case AppRoutes.onboarding:
      page = const OnboardingScreen();
      break;
    case AppRoutes.login:
      page = LoginScreen();
      break;
    case AppRoutes.register:
      page = RegistrationScreen();
      break;
    case AppRoutes.home:
      page = const DiscoverScreen();
      break;
    case AppRoutes.nearby:
      page = const NearbyScreen();
      break;
    case AppRoutes.matches:
      page = const MatchesScreen();
      break;
    case AppRoutes.chat:
      page = const ChatScreen();
      break;
    case AppRoutes.settings:
      page = const SettingsScreen();
      break;
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }

  return PageAnimationTransition(
    page: page,
    pageAnimationType:
        FadeAnimationTransition(), // Change animation type as needed
  );
}
