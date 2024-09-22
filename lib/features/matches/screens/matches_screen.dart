import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, d) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Matches',
            style: TextStyle(
                fontSize: 30,
                color: CColors.secondary,
                fontWeight: FontWeight.w700,
                height: 1.5),
          ),
          actions: [
            Container(
              height: 52,
              width: 52,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFE8E6EA),
                ),
              ),
              child: SvgPicture.asset(
                'assets/svg/match_icon.svg',
              ),
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "This is a list of people who have liked you and your matches.",
                  style: TextStyle(
                    color: Color(0xFF15211F),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Today",
                          style: TextStyle(
                            color: Color(0xFF15211F),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _buildMatchCard('Leilani', 19,
                          'assets/images/onboarding1.png', context),
                      _buildMatchCard('Annabelle', 20,
                          'assets/images/onboarding1.png', context),
                      const SizedBox(height: 10),
                      _buildMatchCard('Reagan', 24,
                          'assets/images/onboarding1.png', context),
                      _buildMatchCard('Hadley', 25,
                          'assets/images/onboarding1.png', context),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Yesterday",
                          style: TextStyle(
                            color: Color(0xFF15211F),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _buildMatchCard('Sophia', 21,
                          'assets/images/onboarding1.png', context),
                      _buildMatchCard('Camilla', 22,
                          'assets/images/onboarding1.png', context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: customBottomBar(context, AppRoutes.matches),
      ),
    );
  }

  Widget _buildMatchCard(
      String name, int age, String imgPath, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imgPath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$name, $age",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Dislike action
                        },
                        child: SvgPicture.asset(
                          'assets/svg/cancel.svg',
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                            Colors.white, // The color you want to apply
                            BlendMode.srcIn, // Blend mode to apply the color
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          // Like action
                        },
                        child: SvgPicture.asset(
                          'assets/svg/heart_icon.svg',
                          height: 30,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
