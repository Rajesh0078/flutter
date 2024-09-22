import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/commons/widgets/custom_bottom_bar.dart';
import 'package:swype/features/home/controllers/advanced_search_controller.dart';
import 'package:swype/features/home/data/users_dummy_data.dart';
import 'package:swype/features/home/widgets/filter_bottom_sheet.dart';
import 'package:swype/features/home/widgets/profile_bottom_sheet.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _ExamplePageState();
}

class _ExamplePageState extends ConsumerState<DiscoverScreen> {
  final CardSwiperController controller = CardSwiperController();
  final AdvancedSearchController advancedSearchController =
      AdvancedSearchController();
  UsersDummyData dummyData = UsersDummyData();
  int swipingCardIndex = 0;
  String swipeDir = '';
  Map<String, dynamic> appliedFilters = {};

  @override
  void initState() {
    super.initState();
  }

  void applyFilters(Map<String, dynamic> filters) async {
    print(filters);
    final response =
        await advancedSearchController.performAdvancedSearch(filters);
    print(response);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Text(
              "Discover",
              style: TextStyle(
                color: CColors.secondary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
            Text("Chicago, IL",
                style: TextStyle(
                  color: CColors.secondary.withOpacity(.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                )),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return SizedBox(
                      width: double.infinity,
                      child: FilterBottomSheet(
                        onApplyFilter: applyFilters, // Pass the callback
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 52,
                width: 52,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFE8E6EA),
                  ),
                ),
                child: SvgPicture.asset(
                  'assets/svg/filter.svg',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: dummyData.candidates.isEmpty
                  ? const Center(child: Text('No more users to display!'))
                  : CardSwiper(
                      controller: controller,
                      cardsCount: dummyData.candidates.length,
                      allowedSwipeDirection:
                          const AllowedSwipeDirection.symmetric(
                        horizontal: true,
                      ),
                      numberOfCardsDisplayed: 2,
                      scale: 0.9,
                      maxAngle: 120,
                      backCardOffset: const Offset(0, -36),
                      padding: const EdgeInsets.all(20.0),
                      onSwipeDirectionChange:
                          (horizontalDirection, verticalDirection) => {
                        setState(() {
                          swipeDir = horizontalDirection.name;
                        })
                      },
                      onSwipe: (prevInx, currInx, dir) {
                        setState(() {
                          swipingCardIndex = currInx!;
                        });
                        return true;
                      },
                      cardBuilder: (
                        context,
                        index,
                        horizontalThresholdPercentage,
                        verticalThresholdPercentage,
                      ) {
                        final user = dummyData.candidates[index];
                        return ExampleCard(
                          user,
                          isSwiping: index == swipingCardIndex,
                          swipeDir: swipeDir,
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: SizedBox(
                  height: 78,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //  Dislike
                      GestureDetector(
                        onTap: () => controller.swipe(CardSwiperDirection.left),
                        child: Container(
                          height: 78,
                          width: 78,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                offset: const Offset(0, 20),
                                blurRadius: 50,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset('assets/svg/cancel.svg'),
                        ),
                      ),
                      //  Like
                      GestureDetector(
                        onTap: () =>
                            controller.swipe(CardSwiperDirection.right),
                        child: Container(
                          height: 78,
                          width: 78,
                          padding: const EdgeInsets.only(
                            top: 22,
                            left: 18,
                            right: 18,
                            bottom: 17,
                          ),
                          decoration: BoxDecoration(
                            color: CColors.primary,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(233, 64, 87, 0.2),
                                offset: Offset(0, 15),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/favorite.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      //  Profile View Button
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            builder: (BuildContext context) {
                              return ProfileBottomSheet(
                                user: dummyData.candidates[swipingCardIndex],
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 78,
                          width: 78,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                offset: const Offset(0, 20),
                                blurRadius: 50,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/user.svg',
                            colorFilter: ColorFilter.mode(
                              CColors.borderColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: customBottomBar(context, AppRoutes.home),
    );
  }
}

class ExampleCard extends StatelessWidget {
  final dynamic user;
  final bool isSwiping;
  final String swipeDir;

  ExampleCard(this.user, {this.isSwiping = false, this.swipeDir = ''});

  @override
  Widget build(BuildContext context) {
    final username = user.name ?? 'No username available';
    final age = user.age ?? '18';
    final country = user.profession ?? 'No country available';
    final imgUrl = user.imageUrl ?? 'ntg';

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imgUrl.isNotEmpty
                      ? imgUrl
                      : 'https://i.pinimg.com/564x/ba/6f/57/ba6f5764aaa4e756d81ccb6a55fdc354.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isSwiping && swipeDir == 'right')
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x4DE31D35),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: 0.3,
                        child: Container(
                            width: 78,
                            height: 78,
                            padding: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svg/favorite.svg',
                                height: 36,
                                colorFilter: ColorFilter.mode(
                                  CColors.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            if (isSwiping && swipeDir == 'left')
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(77, 211, 127, 75),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Transform.rotate(
                          angle: -0.3,
                          child: Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/svg/cancel.svg',
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0)),
                  color: Colors.black.withOpacity(0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$username, $age",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      country,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
