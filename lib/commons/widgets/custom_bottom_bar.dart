import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';

Widget customBottomBar(context, currentRouteName) {
  return Container(
    width: double.infinity,
    height: 75,
    color: const Color(0xFFF3F3F3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildbottombutton('Home', AppRoutes.home, 'assets/svg/home.svg',
            currentRouteName, context),
        buildbottombutton('Nearby', AppRoutes.nearby, 'assets/svg/location.svg',
            currentRouteName, context),
        buildbottombutton('Matches', AppRoutes.matches,
            'assets/svg/favorite.svg', currentRouteName, context),
        buildbottombutton('Chat', AppRoutes.chat, 'assets/svg/chat.svg',
            currentRouteName, context),
        buildbottombutton('Profile', AppRoutes.settings, 'assets/svg/user.svg',
            currentRouteName, context),
      ],
    ),
  );
}

Expanded buildbottombutton(String label, String route, String icon,
    String currentRouteName, BuildContext context) {
  final textColor =
      route == currentRouteName ? CColors.primary : CColors.borderColor;
  final Color borderColor =
      currentRouteName == route ? CColors.primary : const Color(0xFFE8E6EA);
  return Expanded(
    child: GestureDetector(
      onTap: () {
        if (currentRouteName == route) {
          return;
        } else {
          // For any other route, navigate normally
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: borderColor,
              width: 1.5,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 26,
              colorFilter: ColorFilter.mode(
                textColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    ),
  );
}
