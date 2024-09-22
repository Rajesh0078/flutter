import 'package:flutter/material.dart';
import 'package:swype/features/authentication/login/screens/login/login_screen.dart';
import 'package:swype/features/authentication/login/screens/onboarding/onboarding_screen.dart';
import 'package:swype/features/authentication/register/screens/register_screen.dart';
import 'package:swype/features/authentication/login/screens/splash/splash_screen.dart';
import 'package:swype/features/chat/screens/chat_screen.dart';
import 'package:swype/features/home/screens/discover_screen.dart';
import 'package:swype/features/matches/screens/matches_screen.dart';
import 'package:swype/features/nearby/screens/nearby_screen.dart';
import 'package:swype/features/settings/screens/settings_screen.dart';

class AppRoutes {
  static const String splash = "/";
  static const String onboarding = "/onboarding";
  static const String login = "/login";
  static const String register = "/register";
  static const String home = "/home";
  static const String nearby = "/nearby";
  static const String matches = "/matches";
  static const String chat = "/chat";
  static const String settings = "/settings";

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      login: (context) => LoginScreen(),
      register: (context) => RegistrationScreen(),
      home: (context) => const DiscoverScreen(),
      nearby: (context) => const NearbyScreen(),
      matches: (context) => const MatchesScreen(),
      chat: (context) => const ChatScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
}
