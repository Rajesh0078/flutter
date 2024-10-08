import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swype/features/authentication/register/controllers/register_controller.dart';
import 'package:swype/utils/constants/colors.dart';
import 'package:swype/utils/constants/image_strings.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username, _email, _password, _confirmPassword, _phone;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  final RegisterController _registerController = RegisterController();

  @override
  void initState() {
    super.initState();
  }

  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _registerController.registerUser(
          context,
          ref,
          _username!,
          _email!,
          _password!,
          _confirmPassword!,
          _phone!,
          _agreedToTerms,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loader
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  ImageStrings.mainLogo,
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'User Registration',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 29),

              // Username Field
              TextFormField(
                decoration: const InputDecoration(labelText: "User Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value,
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value,
              ),
              const SizedBox(height: 16),

              // Phone Number Field
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Country flag
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 21, right: 8),
                              child: SvgPicture.asset(
                                'assets/svg/country_flag.svg',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '(+972)', // Country code
                                    style: TextStyle(
                                      color: CColors.secondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    " | ",
                                    style: TextStyle(
                                      color: Color.fromRGBO(21, 33, 31, .2),
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                      onSaved: (value) => _phone = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Terms and Conditions Checkbox
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to the top
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreedToTerms = !_agreedToTerms;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _agreedToTerms
                              ? CColors.primary
                              : const Color(0xFFE8E6EA),
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      width: 20.0,
                      height: 20.0,
                      child: _agreedToTerms
                          ? Icon(
                              Icons.check,
                              size: 18.0,
                              color: CColors.primary,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      'These terms and conditions outline the rules and regulations for the use of Swype App, located at https://swype.co.il',
                      style: TextStyle(
                        color: CColors.textOpacity,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? ElevatedButton(
                        onPressed: () {},
                        child: const SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3.0,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (!_agreedToTerms) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  'You must agree to the terms and conditions',
                                ),
                              ));
                            } else {
                              _formKey.currentState!.save();
                              _registerUser(); // Call Dio API
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
