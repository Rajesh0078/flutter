import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:dio/dio.dart';
import 'package:swype/features/authentication/providers/register_provider.dart';
import 'package:swype/features/authentication/register/screens/profile_details_screen.dart';
import 'package:swype/routes/api_routes.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/helpers/helper_functions.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  OtpVerificationScreen({required this.phoneNumber});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _timeRemaining = 60;
  bool _isResendAvailable = false;
  bool _isLoading = false;
  Dio dio = Dio();
  Timer? _timer; // Declare Timer variable
  int _resendAttempts = 0;
  final int _maxResendAttempts = 3;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    otpController.dispose();
    super.dispose();
  }

  // Timer for Resend OTP
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        if (!mounted) return; // Ensure widget is still mounted
        setState(() {
          _timeRemaining--;
        });
      } else {
        if (!mounted) return; // Ensure widget is still mounted
        setState(() {
          _isResendAvailable = true;
        });
        timer.cancel(); // Stop the timer when countdown completes
      }
    });
  }

  // OTP Submit Handler
  void _submitOtp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final user = ref.read(registerProvider);

      final formData = FormData.fromMap({
        'phone_number': user['phone'] ?? widget.phoneNumber,
        'otp': otpController.text,
      });

      try {
        final response = await dio.post(
          ApiRoutes.verifyOTP,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
          ),
        );

        // Ensure response status code is 200
        if (response.statusCode == 200) {
          final data = response.data;

          // Check for the status code in the response data
          if (data != null && data['status_code'] == 200) {
            print(data);
            await ref.read(registerProvider.notifier).updateIsOtpVerified(true);
            CHelperFunctions.showToaster(context, data['message']);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ProfileDetailsScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            CHelperFunctions.showToaster(context, data['message']);
            print('Invalid OTP or server response issue');
          }
        } else {
          // Handle non-200 status codes
          CHelperFunctions.showToaster(context, 'Unknown error');
          print('Failed to verify OTP: ${response.statusCode}');
        }
      } catch (e) {
        // Catch any errors during the API call
        CHelperFunctions.showToaster(context, 'Unknown error');
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Resend OTP Handler
  void _resendOtp() async {
    if (!_isResendAvailable || _resendAttempts >= _maxResendAttempts) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your API endpoint
      final response = await dio.post(
        'https://your-api-endpoint.com/resend-otp',
        data: {'phone': widget.phoneNumber},
      );

      if (response.statusCode == 200) {
        setState(() {
          _timeRemaining = 60; // Reset timer to 1 minute
          _isResendAvailable = false;
          _resendAttempts++;
        });
        startTimer();
        CHelperFunctions.showToaster(context, 'OTP resent successfully');
      } else {
        // Handle resend error
        CHelperFunctions.showToaster(context, 'Failed to resend OTP');
        print('Failed to resend OTP');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _timeRemaining ~/ 60;
    int seconds = _timeRemaining % 60;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(52, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: const BorderSide(
                        color: Color(0xFFE8E6EA),
                        width: 1.0,
                      ),
                      shadowColor: Colors.transparent,
                    ),
                    child: SvgPicture.asset('assets/svg/back_button.svg'),
                  )
                ],
              ),
              const SizedBox(height: 42),
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: CColors.secondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: SizedBox(
                  width: 215,
                  child: Text(
                    'Type the verification code we\'ve sent you',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(21, 33, 31, .7),
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 102),
              const Text(
                'OTP via Phone',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(21, 33, 31, .7),
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 13),
              Form(
                key: _formKey,
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  animationType: AnimationType.fade,
                  controller: otpController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 48,
                    fieldWidth: 48,
                    // Check if the field is filled, then change the background and text color
                    activeColor: otpController.text.isNotEmpty
                        ? CColors.primary
                        : Colors.transparent,
                    inactiveColor: const Color(0xFFE8E6EA),
                    selectedColor: otpController.text.isNotEmpty
                        ? CColors.primary
                        : CColors.primary,
                    activeFillColor: otpController.text.isNotEmpty
                        ? CColors.primary
                        : Colors.transparent,
                    inactiveFillColor: Colors.transparent,
                    selectedFillColor: otpController.text.isNotEmpty
                        ? CColors.primary
                        : Colors.transparent,
                  ),
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  textStyle: TextStyle(
                    color: otpController.text.isNotEmpty
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (_isResendAvailable)
                GestureDetector(
                  onTap: _resendOtp,
                  child: const Text(
                    'Resend OTP',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              const SizedBox(height: 74),
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
                        onPressed: _submitOtp,
                        child: const Text('Submit'),
                      ),
                    ),
              const SizedBox(height: 31),
            ],
          ),
        ),
      ),
    );
  }
}
