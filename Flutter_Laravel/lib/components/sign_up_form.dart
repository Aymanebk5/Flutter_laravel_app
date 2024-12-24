import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/components/button.dart';
import 'package:flutter_laravel/models/auth_model.dart';
import 'package:flutter_laravel/providers/dio_provider.dart';
import 'package:flutter_laravel/main.dart'; // Adjust import based on your project structure
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Name',
              labelText: 'Name',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outline),
              prefixIconColor: Config.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: Config.primaryColor,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obsecurePass = !obsecurePass;
                  });
                },
                icon: obsecurePass
                    ? const Icon(
                  Icons.visibility_off_outlined,
                  color: Colors.black38,
                )
                    : const Icon(
                  Icons.visibility_outlined,
                  color: Config.primaryColor,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign Up',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Validate the form fields before attempting registration
                    final userRegistration = await DioProvider().registerUser(
                        _nameController.text,
                        _emailController.text,
                        _passController.text);

                    // If register success, proceed to login
                    if (userRegistration) {
                      final token = await DioProvider()
                          .getToken(_emailController.text, _passController.text);

                      if (token) {
                        // Successful login
                        final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        final tokenValue = prefs.getString('token') ?? '';

                        if (tokenValue.isNotEmpty && tokenValue != '') {
                          // Get user data
                          final response =
                          await DioProvider().getUser(tokenValue);
                          if (response != null) {
                            setState(() {
                              // JSON decode user data
                              final user = json.decode(response);

                              // Example: Get appointment data from user JSON (adjust this based on your actual user JSON structure)
                              Map<String, dynamic> appointment = {};
                              if (user['doctor'] != null && user['doctor'].isNotEmpty) {
                                for (var doctorData in user['doctor']) {
                                  if (doctorData['appointments'] != null) {
                                    appointment = doctorData;
                                    break; // Assuming we only need the first appointment found
                                  }
                                }
                              }

                              // Call loginSuccess with user and appointment
                              auth.loginSuccess(user, appointment);
                              MyApp.navigatorKey.currentState!.pushNamed('main');
                            });
                          }
                        }
                      } else {
                        // Handle failed login
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Registration successful, but login failed.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      // Handle failed registration
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration failed.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                disable: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
