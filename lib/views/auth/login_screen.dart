import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.put(AuthController());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? size.width * 0.05 : 20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.vertical,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isLandscape) SizedBox(height: size.height * 0.05),

                    // Header Section
                    _buildHeaderSection(size, isTablet),
                    SizedBox(height: size.height * 0.03),

                    // Form Section
                    _buildFormSection(size, isTablet),

                    SizedBox(height: size.height * 0.02),

                    // OTP Login Option
                    _buildOTPLoginSection(size, isTablet),

                    if (isLandscape) Spacer(),

                    // Social Login Section
                    _buildSocialLoginSection(size, isTablet),

                    SizedBox(height: size.height * 0.02),

                    // Sign Up Section
                    _buildSignUpSection(),

                    SizedBox(height: size.height * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Size size, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign in to your Account',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.04 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.008),
        Text(
          'Enter your email and password to log in',
          style: TextStyle(fontSize: isTablet ? size.width * 0.025 : 16),
        ),
      ],
    );
  }

  Widget _buildFormSection(Size size, bool isTablet) {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            if (!value.isEmail) {
              return 'Please enter valid email';
            }
            return null;
          },
        ),

        SizedBox(height: size.height * 0.02),

        CustomTextField(
          controller: _passwordController,
          label: 'Password',
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),

        SizedBox(height: size.height * 0.02),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Handle forget password
            },
            child: Text(
              'Forget Password',
              style: TextStyle(fontSize: isTablet ? size.width * 0.025 : 16),
            ),
          ),
        ),

        SizedBox(height: size.height * 0.02),

        Obx(
          () => CustomButton(
            text: 'Log in',
            isLoading: _authController.isLoading.value,
            onPressed: _login,
          ),
        ),
      ],
    );
  }

  Widget _buildOTPLoginSection(Size size, bool isTablet) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'OR',
                style: TextStyle(fontSize: isTablet ? size.width * 0.025 : 16),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),

        SizedBox(height: size.height * 0.02),

        OutlinedButton(
          onPressed: () async {
            if (_emailController.text.isEmpty ||
                !_emailController.text.isEmail) {
              Get.snackbar('Error', 'Please enter a valid email address');
              return;
            }

            final result = await _authController.requestOTP(
              _emailController.text.trim(),
            );

            if (result['success'] == true) {
              Get.toNamed(
                '/otp-verification',
                arguments: {
                  'email': _emailController.text.trim(),
                  'isFromLogin': true,
                },
              );
            } else {
              Get.snackbar(
                'Error',
                result['message'] ?? 'Failed to send OTP',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            'Login with OTP',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginSection(Size size, bool isTablet) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),

        CustomButton(
          text: 'Continue with Google',
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onPressed: () {},
        ),

        SizedBox(height: size.height * 0.01),

        CustomButton(
          text: 'Continue with Facebook',
          backgroundColor: Colors.blue[800]!,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSignUpSection() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/signup');
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      print('🎯 Login form validated, calling controller...');

      final result = await _authController.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      print('🎯 Login result: $result');

      if (result['success'] == true) {
        final shouldNavigate = result['shouldNavigate'] ?? true;

        if (shouldNavigate) {
          print('🚀 Login successful, navigating to home...');
          Get.offAllNamed('/home');
        }

        Get.snackbar(
          'Success',
          result['message'] ?? 'Login successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Login failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
