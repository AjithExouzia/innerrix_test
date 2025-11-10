import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final bool isFromLogin;

  const OTPVerificationScreen({
    Key? key,
    required this.email,
    this.isFromLogin = true,
  }) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendTimer = 40;
  bool _canResend = false;
  late String _enteredEmail;

  @override
  void initState() {
    super.initState();
    _enteredEmail = widget.email;
    _startResendTimer();

    // Auto-focus first OTP field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  void _startResendTimer() {
    _resendTimer = 40;
    _canResend = false;
    setState(() {});

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _resendTimer--;
        });
        if (_resendTimer > 0) {
          _startResendTimer();
        } else {
          _canResend = true;
        }
      }
    });
  }

  void _resendOTP() async {
    if (!_canResend) return;

    print('🔄 Resending OTP to: $_enteredEmail');

    final result = await _authController.requestOTP(_enteredEmail);

    if (result['success'] == true) {
      Get.snackbar(
        'Success',
        result['message'] ?? 'OTP sent successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      _startResendTimer();
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'Failed to resend OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLandscape = size.width > size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OTP Verification',
          style: TextStyle(fontSize: isTablet ? size.width * 0.035 : 20),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLandscape) SizedBox(height: size.height * 0.05),

                  // Header Section
                  _buildHeaderSection(size, isTablet),
                  SizedBox(height: size.height * 0.04),

                  // OTP Illustration
                  _buildOTPIllustration(size, isTablet),
                  SizedBox(height: size.height * 0.04),

                  // OTP Input Section
                  _buildOTPSection(size, isTablet),
                  SizedBox(height: size.height * 0.03),

                  // Resend Code Section
                  _buildResendSection(size, isTablet),
                  SizedBox(height: size.height * 0.04),

                  // Verify Button
                  _buildVerifyButton(),

                  if (isLandscape) Spacer(),

                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Size size, bool isTablet) {
    return Column(
      children: [
        Text(
          "Verify Your Account",
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.045 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: size.height * 0.015),
        Text(
          'We have sent a verification code to',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.025 : 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: size.height * 0.008),
        Text(
          _enteredEmail,
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.03 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[600],
          ),
        ),
        SizedBox(height: size.height * 0.008),
        Text(
          'Enter the 6-digit code below to verify your account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.022 : 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildOTPIllustration(Size size, bool isTablet) {
    return Container(
      width: isTablet ? size.width * 0.2 : 100,
      height: isTablet ? size.width * 0.2 : 100,
      decoration: BoxDecoration(color: Colors.blue[50], shape: BoxShape.circle),
      child: Icon(
        Icons.sms_outlined,
        size: isTablet ? size.width * 0.08 : 50,
        color: Colors.blue[600],
      ),
    );
  }

  Widget _buildOTPSection(Size size, bool isTablet) {
    final otpFieldSize = isTablet ? size.width * 0.08 : 50.0;
    final spacing = isTablet ? size.width * 0.02 : 8.0;

    return Column(
      children: [
        Text(
          'Enter OTP Code',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.025 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: otpFieldSize,
              height: otpFieldSize,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.03 : 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  if (value.length == 1 && index < 5) {
                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                  } else if (value.isEmpty && index > 0) {
                    FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                  }

                  // Auto verify when all fields are filled
                  if (index == 5 && value.isNotEmpty) {
                    _verifyOTP();
                  }
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildResendSection(Size size, bool isTablet) {
    return Column(
      children: [
        Text(
          _canResend ? 'Didn\'t receive the code?' : 'Resend code in',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.022 : 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        _canResend
            ? GestureDetector(
              onTap: _resendOTP,
              child: Text(
                'RESEND OTP',
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.025 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
            : Text(
              '${_resendTimer ~/ 60}:${(_resendTimer % 60).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: isTablet ? size.width * 0.025 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return Obx(
      () => CustomButton(
        text: 'Verify & Continue',
        isLoading: _authController.isLoading.value,
        onPressed: _verifyOTP,
      ),
    );
  }

  void _verifyOTP() async {
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter complete 6-digit OTP code',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    print('✅ Verifying OTP: $otp for email: $_enteredEmail');

    final result = await _authController.verifyOTP(_enteredEmail, otp);

    if (result['success'] == true) {
      final shouldNavigate = result['shouldNavigate'] ?? true;

      if (shouldNavigate) {
        print('🚀 OTP verification successful, navigating to home...');
        Get.offAllNamed('/home');
      }

      Get.snackbar(
        'Success',
        result['message'] ?? 'Account verified successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Error',
        result['message'] ?? 'OTP verification failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );

      // Clear OTP fields on failure
      for (var controller in _otpControllers) {
        controller.clear();
      }
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
