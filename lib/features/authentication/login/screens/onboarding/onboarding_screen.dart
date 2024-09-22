import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/login/controllers/onboarding_controller.dart';
import 'package:swype/utils/constants/colors.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingState();
}

class _OnboardingState extends ConsumerState<OnboardingScreen> {
  late final OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const Spacer(flex: 6),
                  CarouselSlider(
                    items: _controller.onboardingData.map((item) {
                      return SizedBox(
                        child: ClipRect(
                          child: Image.asset(
                            item['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: screenHeight * 0.45,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.65,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _controller.onPageChanged(index);
                        });
                      },
                    ),
                    carouselController: _controller.carouselController,
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Text(
                    _controller.onboardingData[_controller.currentPage]
                        ['title']!,
                    key: ValueKey<int>(_controller.currentPage),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      _controller.onboardingData[_controller.currentPage]
                          ['description']!,
                      key: ValueKey<int>(_controller.currentPage),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _controller.onboardingData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => {_controller.handleRegister(context)},
                        child: const Text(
                          "Create an account",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          _controller.handleLoginButton(context);
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(227, 29, 53, .7),
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _controller.currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color: _controller.currentPage == index
            ? CColors.primary
            : const Color.fromRGBO(0, 0, 0, .1),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
