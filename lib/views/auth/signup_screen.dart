import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLandscape = size.width > size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.035 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isLandscape) SizedBox(height: size.height * 0.02),

                    // Header Section
                    _buildHeaderSection(size, isTablet),
                    SizedBox(height: size.height * 0.03),

                    // Form Section
                    _buildFormSection(size, isTablet),

                    if (isLandscape) Spacer(),

                    // Sign Up Button
                    _buildSignUpButton(),

                    SizedBox(height: size.height * 0.02),

                    // Login Redirect
                    _buildLoginRedirect(),

                    if (!isLandscape) SizedBox(height: size.height * 0.05),
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
          'Create Your Account',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.045 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          'Fill in your details to create your account and start shopping',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.025 : 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(Size size, bool isTablet) {
    return Column(
      children: [
        CustomTextField(
          controller: _nameController,
          label: 'Full Name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),

        SizedBox(height: size.height * 0.02),

        CustomTextField(
          controller: _emailController,
          label: 'Email Address',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email address';
            }
            if (!value.isEmail) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),

        SizedBox(height: size.height * 0.02),

        CustomTextField(
          controller: _phoneController,
          label: 'Phone Number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
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

        CustomTextField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),

        SizedBox(height: size.height * 0.03),

        // Terms and Conditions
        Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.blue),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'By signing up, you agree to our Terms and Conditions',
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.02 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return Obx(
      () => CustomButton(
        text: 'Create Account',
        isLoading: _authController.isLoading.value,
        onPressed: _register,
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: RichText(
          text: TextSpan(
            text: "Already have an account? ",
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: "Sign In",
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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      print('🎯 Registration form validated, calling controller...');

      final result = await _authController.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _phoneController.text.trim(),
      );

      print('🎯 Registration result: $result');

      if (result['success'] == true) {
        final shouldNavigate = result['shouldNavigate'] ?? true;

        if (shouldNavigate) {
          print('🚀 Registration successful, navigating to home...');
          Get.offAllNamed('/home');
        }

        Get.snackbar(
          'Success',
          result['message'] ?? 'Account created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Registration failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
