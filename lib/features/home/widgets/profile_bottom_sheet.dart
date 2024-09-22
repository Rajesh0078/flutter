import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/features/home/data/users_dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:swype/utils/constants/colors.dart';

class ProfileBottomSheet extends StatefulWidget {
  final Candidate user;
  const ProfileBottomSheet({super.key, required this.user});

  @override
  State<ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<ProfileBottomSheet> {
  bool isReadMore = false;
  String dropdownValue = 'Bachelor\'s Degree';
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/onboarding1.png',
                      height: 425,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                          bottom: Radius.circular(0),
                        ),
                      ),
                      width: double.infinity,
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 40,
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white),
                      color: const Color(0xFFE8E6EA).withOpacity(0.5),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Navigate back
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 400,
                  child: Container(
                      height: 52,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white),
                        color: Colors.white,
                      ),
                      child: const SizedBox.shrink()),
                ),
                Positioned(
                  top: 353,
                  child: SizedBox(
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => {},
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
                          GestureDetector(
                            onTap: () => {},
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
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            //Profile content Starts from here
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                  bottom: Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.user.name}, ${widget.user.age}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold, height: 1.5),
                  ),
                  Text(
                    widget.user.profession,
                    style: const TextStyle(
                        fontSize: 14, color: Color.fromRGBO(21, 33, 31, 0.7)),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Location',
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Jerusalem, Israel',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(21, 33, 31, 0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'About',
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'My name is Abigail Cohen and I enjoy meeting new people and finding ways to help them have an uplifting experience. I enjoy reading, traveling, and photography.',
                    maxLines: !isReadMore ? 3 : 10,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(21, 33, 31, 0.7),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isReadMore = !isReadMore;
                      });
                    },
                    child: Text(
                      isReadMore ? 'Read less' : 'Read more',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Gallery',
                        style: TextStyle(
                          color: CColors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      const Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/onboarding2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/onboarding3.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/onboarding1.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/onboarding2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Add spacing between the images
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/onboarding3.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Other Details',
                    style: TextStyle(
                      color: CColors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 17),
                  _buildOtherDetails(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildOtherDetails() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildDetailRow('Education', "2"),
      _buildDetailRow('Body Type', 'Slim'),
      _buildDetailRow('Marital Status', 'Single'),
      _buildDetailRow('Smoking Habits', 'Never'),
      _buildDetailRow('Drinking Habits', 'Never'),
    ],
  );
}

Widget _buildDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '$title:',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(21, 33, 31, .70),
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
        )
      ],
    ),
  );
}
