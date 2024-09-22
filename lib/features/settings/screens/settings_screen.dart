import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/features/settings/controllers/logout_service.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  LogoutService logoutService = LogoutService();
  bool isLoading = false;
  bool isUserLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void logoutUser() async {
    setState(() {
      isLoading = true;
    });
    final response = await logoutService.logoutUser(ref, context);
    if (response) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout Success')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, d) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFDECEE),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFDECEE),
          title: Text(
            'General Settings',
            style: TextStyle(
              color: CColors.secondary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDECEE),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 55,
                              width: 55,
                              child: Image.asset(
                                'assets/images/onboarding2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'username',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                  color: CColors.secondary,
                                ),
                              ),
                              Text(
                                'email@gmail.com',
                                style: TextStyle(
                                  color: CColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: buildSettingsList(),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: customBottomBar(context, AppRoutes.settings),
      ),
    );
  }

  // Widget for displaying Settings Options
  Widget buildSettingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account Settings
        const Text(
          "Account Settings",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(21, 33, 31, .7),
            height: 1.5,
          ),
        ),
        buildSettingOption(
          "Update User Preferences",
          'assets/svg/filter.svg',
          "/update-preferences",
        ),
        buildSettingOption(
          "Enable 2 Factor Authentication (2FA)",
          'assets/svg/two_factor_icon.svg',
          "/enable-2fa",
        ),
        buildSettingOption(
          "Face ID",
          'assets/svg/face_id_icon.svg',
          "/face-id",
        ),
        buildSettingOption(
          "Update Preferred Language",
          'assets/svg/flag.svg',
          "/update-language",
        ),
        buildSettingOption(
          "Change Password",
          'assets/svg/change_password_icon.svg',
          "/change-password",
        ),

        const SizedBox(height: 10),

        // Community Settings
        const Text(
          "Community Settings",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(21, 33, 31, .7),
            height: 1.5,
          ),
        ),
        buildSettingOption(
          "Friends & Social",
          'assets/svg/groups.svg',
          "/friends-social",
        ),
        buildSettingOption(
          "Following List",
          'assets/svg/dotted_bar.svg',
          "/following-list",
        ),

        const SizedBox(height: 10),

        // Others
        const Text(
          "Others",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(21, 33, 31, .7),
            height: 1.5,
          ),
        ),
        buildSettingOption(
          "FAQ",
          'assets/svg/faq.svg',
          "/faq",
        ),
        buildSettingOption(
          "Help Center",
          'assets/svg/help_center_icon.svg',
          "/help-center",
        ),
        buildSettingOption(
          "Question/Answer",
          'assets/svg/q&a.svg',
          "/q&a",
        ),
        const SizedBox(height: 10),

        // Others
        const Text(
          "Delete Account",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(21, 33, 31, .7),
            height: 1.5,
          ),
        ),
        buildSettingOption(
          "Delete Account",
          'assets/svg/delete_icon.svg',
          "/delete-account",
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: logoutUser,
            child: isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24.0,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3.0,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Logging out...",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )
                : const Text("Logout"),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // Reusable widget to create setting options
  Widget buildSettingOption(String title, String icon, String route) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      leading: SvgPicture.asset(
        height: 24,
        width: 24,
        icon,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: CColors.secondary,
          height: 1.5,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color.fromRGBO(21, 33, 31, .7),
        size: 20,
      ),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
