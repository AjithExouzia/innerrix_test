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
      backgroundColor: Colors.white,
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

                    _buildHeaderSection(size, isTablet),
                    SizedBox(height: size.height * 0.03),

                    _buildEmailSection(size, isTablet),

                    _buildPasswordSection(size, isTablet),

                    _buildForgetPasswordSection(size, isTablet),

                    _buildLoginButton(),

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
            color: Colors.black,
          ),
        ),
        SizedBox(height: size.height * 0.008),
        Text(
          'Enter your email and password to log in',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.025 : 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailSection(Size size, bool isTablet) {
    return CustomTextField(
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
    );
  }

  Widget _buildPasswordSection(Size size, bool isTablet) {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildForgetPasswordSection(Size size, bool isTablet) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          _showForgotPasswordDialog();
        },
        child: Text(
          'Forget Password?',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.025 : 16,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => CustomButton(
        text: 'Log in',
        isLoading: _authController.isLoading.value,
        onPressed: _loginWithCredentials,
      ),
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
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.025 : 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),

        SizedBox(height: size.height * 0.02),

        OutlinedButton(
          onPressed: _loginWithOTPOnly,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.yellow,
            side: BorderSide(color: Colors.yellowAccent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            'Login with OTP only',
            style: TextStyle(
              fontSize: isTablet ? size.width * 0.025 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginSection(Size size, bool isTablet) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.02),

        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'or continue with',
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.025 : 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),

        SizedBox(height: size.height * 0.02),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Google login
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Google', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Facebook login
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, size: 20, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Facebook', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
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
            style: TextStyle(color: Colors.black, fontSize: 14),
            children: [
              TextSpan(
                text: "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginWithCredentials() async {
    if (_formKey.currentState!.validate()) {
      print('🎯 Step 1: Verifying email and password...');

      final result = await _authController.verifyCredentials(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      print('🎯 Credentials verification result: $result');

      if (result['success'] == true) {
        if (result['requiresOTP'] == true) {
          // Step 2: Navigate to OTP verification
          print('📱 Step 2: Navigating to OTP verification...');
          Get.toNamed(
            '/otp-verification',
            arguments: {
              'email': _emailController.text.trim(),
              'isFromLogin': true,
              'isSecondStep': true,
            },
          );
        } else {
          final shouldNavigate = result['shouldNavigate'] ?? true;

          if (shouldNavigate) {
            print('🚀 Single-step login successful, navigating to home...');
            Get.offAllNamed('/home');
          }
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

  void _loginWithOTPOnly() async {
    if (_emailController.text.isEmpty || !_emailController.text.isEmail) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    print('📱 Direct OTP login requested for: ${_emailController.text.trim()}');

    final result = await _authController.directOTPLogin(
      _emailController.text.trim(),
    );

    if (result['success'] == true) {
      Get.toNamed(
        '/otp-verification',
        arguments: {
          'email': _emailController.text.trim(),
          'isFromLogin': true,
          'isSecondStep': false,
        },
      );

      Get.snackbar(
        'Success',
        result['message'] ?? 'OTP sent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to send OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    }
  }

  void _showForgotPasswordDialog() {
    Get.defaultDialog(
      title: 'Forgot Password?',
      titleStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      content: Column(
        children: [
          Text(
            'Enter your email address and we will send you a password reset link.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.snackbar(
            'Success',
            'Password reset link sent to your email',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        child: Text('Send Reset Link'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text('Cancel', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
