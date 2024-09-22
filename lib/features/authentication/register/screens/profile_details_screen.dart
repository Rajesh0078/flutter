import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:swype/features/authentication/providers/auth_provider.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/routes/app_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'dart:io';

import 'package:swype/utils/helpers/helper_functions.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  _ProfileDetailsScreenState createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String selectedGender = 'Male';
  DateTime? selectedDate;
  XFile? _profileImage;
  Dio dio = Dio();
  bool _isLoading = false;

  // Handle image picker
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = pickedImage;
      });
    }
  }

  // Handle date picker for birthday
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: CColors.primary),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            textTheme: TextTheme(
              headlineLarge: TextStyle(
                color: CColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(
                color: CColors.secondary, // Date text color
                fontSize: 16,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Submit profile details
  void _submitProfileDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userNotifier = ref.read(registerProvider.notifier);
      final authNotifier = ref.read(authProvider.notifier);
      final user = ref.read(registerProvider);
      FormData formData = FormData.fromMap({
        'username': user['name'],
        'email': user['email'],
        'phone': user['phone'],
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'gender': selectedGender.toLowerCase(),
        'date_of_birth': selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
            : null,
        if (_profileImage != null)
          'profile_picture': await MultipartFile.fromFile(_profileImage!.path),
      });

      // Replace with your actual API endpoint
      final response = await dio.post(
        ApiRoutes.updateUser,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'Authorization': 'Bearer ${user['token']}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status_code'] == 200) {
          await userNotifier.updateIsDetailsFilled(true);
          await authNotifier.login(user['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            ModalRoute.withName(AppRoutes.splash),
          );
        } else {
          CHelperFunctions.showToaster(context, data['message']);
        }
      } else {
        // Handle error
        CHelperFunctions.showToaster(context, 'Error updating profile');
        print('Error updating profile');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Profile details",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26), // Circular shape
                      border: Border.all(
                        color: Colors.white, // White border
                        width: 10,
                      ),
                    ),
                    height: 120,
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image(
                        image: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : const AssetImage(
                                    'assets/images/placeholder_image.png')
                                as ImageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: CColors.primary, // Background color
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: TextButton(
                        onPressed: _pickImage,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/camera.svg',
                          height: 19,
                          width: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // First Name Field
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: "First name*",
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(21, 33, 31, .4),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(21, 33, 31, .4),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8E6EA),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: CColors.primary,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8E6EA),
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                ),
              ),
              const SizedBox(height: 21),
              // Last Name Field
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: "Last name*",
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(21, 33, 31, .4),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(21, 33, 31, .4),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8E6EA),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: CColors.primary,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8E6EA),
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                ),
              ),

              SizedBox(height: 21),
              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: "i am a*",
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(21, 33, 31, .4),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(21, 33, 31, .4),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8E6EA),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: CColors.primary,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFE8E6EA),
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                ),
              ),

              const SizedBox(height: 21),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: const Color(0xFFFCE8EB),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align content to the start
                      children: [
                        SvgPicture.asset('assets/svg/calender.svg'),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'Choose birthday date*'
                                : DateFormat('dd/MM/yyyy')
                                    .format(selectedDate!),
                            style: TextStyle(
                              color: CColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              _isLoading
                  ? SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitProfileDetails,
                        child: const Text('Confirm'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
