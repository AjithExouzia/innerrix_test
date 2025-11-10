import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final bool isFromLogin;
  final bool isSecondStep;

  const OTPVerificationScreen({
    Key? key,
    required this.email,
    this.isFromLogin = true,
    this.isSecondStep = false,
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

    final result =
        widget.isSecondStep
            ? await _authController.resendSecondStepOTP()
            : await _authController.directOTPLogin(_enteredEmail);

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
      backgroundColor: Colors.white,
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
          "Let's verify",
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.05 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: size.height * 0.015),
        Text(
          widget.isSecondStep
              ? 'Second Step Verification'
              : 'Your Google Account',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.03 : 16,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          widget.isSecondStep
              ? 'Enter the OTP sent to your email for second step verification'
              : 'Enter the OTP code we sent to',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.025 : 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: size.height * 0.008),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _enteredEmail,
            style: TextStyle(
              fontSize: isTablet ? size.width * 0.03 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
        ),
        if (!widget.isSecondStep) ...[
          SizedBox(height: size.height * 0.008),
          Text(
            'have to add the word',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? size.width * 0.022 : 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOTPSection(Size size, bool isTablet) {
    final otpFieldSize = isTablet ? size.width * 0.08 : 50.0;

    return Column(
      children: [
        Text(
          'Enter your OTP',
          style: TextStyle(
            fontSize: isTablet ? size.width * 0.028 : 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return Container(
              width: otpFieldSize,
              height: otpFieldSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: TextStyle(
                  fontSize: isTablet ? size.width * 0.03 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
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
              '(${_resendTimer ~/ 60}:${(_resendTimer % 60).toString().padLeft(2, '0')})',
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
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: Obx(
          () =>
              _authController.isLoading.value
                  ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    'Verify OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
        ),
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

    final result =
        widget.isSecondStep
            ? await _authController.verifySecondStepOTP(otp)
            : await _authController.verifyOTP(_enteredEmail, otp);

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
