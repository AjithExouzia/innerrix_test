import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/auth_response_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var requiresOTP = false.obs;
  String? _pendingEmail;

  Future<Map<String, dynamic>> verifyCredentials(
    String email,
    String password,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      requiresOTP.value = false;

      print('🔐 Step 1: Verifying credentials for: $email');

      final response = await _apiService.login(email, password);

      print('🔐 Credentials verification response: ${response.toString()}');

      if (response.success) {
        if (response.data?['requires_otp'] == true ||
            response.message.toLowerCase().contains('otp') ||
            response.token == null) {
          print('📱 OTP required for second verification step');
          _pendingEmail = email;
          requiresOTP.value = true;

          // Request OTP for the second step
          final otpResult = await _apiService.requestOTP(email);

          if (otpResult.success) {
            return {
              'success': true,
              'message': 'Credentials verified. OTP sent to your email.',
              'requiresOTP': true,
              'shouldNavigate': false,
            };
          } else {
            return {
              'success': false,
              'message': 'Credentials verified but failed to send OTP',
              'requiresOTP': false,
              'shouldNavigate': false,
            };
          }
        } else {
          print('✅ Single-step login successful');
          await _completeLogin(response);
          return {
            'success': true,
            'message': response.message,
            'requiresOTP': false,
            'shouldNavigate': true,
          };
        }
      } else {
        print('❌ Credentials verification failed: ${response.message}');
        errorMessage.value = response.message;
        return {
          'success': false,
          'message': response.message,
          'requiresOTP': false,
          'shouldNavigate': false,
        };
      }
    } catch (e) {
      String errorMsg = _extractErrorMessage(e);
      print('💥 Credentials verification exception: $errorMsg');
      errorMessage.value = errorMsg;
      return {
        'success': false,
        'message': errorMsg,
        'requiresOTP': false,
        'shouldNavigate': false,
      };
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> verifySecondStepOTP(String otp) async {
    try {
      if (_pendingEmail == null) {
        return {
          'success': false,
          'message': 'No pending authentication found',
          'shouldNavigate': false,
        };
      }

      isLoading.value = true;
      errorMessage.value = '';

      print('✅ Step 2: Verifying OTP for: $_pendingEmail');

      final response = await _apiService.verifyOTP(_pendingEmail!, otp);

      print('✅ OTP verification response: ${response.toString()}');

      if (response.success) {
        print('🚀 Two-step authentication completed successfully');
        await _completeLogin(response);

        // Clear pending email
        _pendingEmail = null;
        requiresOTP.value = false;

        return {
          'success': true,
          'message': response.message,
          'shouldNavigate': true,
        };
      } else {
        print('❌ OTP verification failed: ${response.message}');
        errorMessage.value = response.message;
        return {
          'success': false,
          'message': response.message,
          'shouldNavigate': false,
        };
      }
    } catch (e) {
      String errorMsg = _extractErrorMessage(e);
      print('💥 OTP verification exception: $errorMsg');
      errorMessage.value = errorMsg;
      return {'success': false, 'message': errorMsg, 'shouldNavigate': false};
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('✅ Direct OTP verification for: $email');

      final response = await _apiService.verifyOTP(email, otp);

      print('✅ Direct OTP verification response: ${response.toString()}');

      if (response.success) {
        print('🚀 Direct OTP authentication completed successfully');
        await _completeLogin(response);

        return {
          'success': true,
          'message': response.message,
          'shouldNavigate': true,
        };
      } else {
        print('❌ Direct OTP verification failed: ${response.message}');
        errorMessage.value = response.message;
        return {
          'success': false,
          'message': response.message,
          'shouldNavigate': false,
        };
      }
    } catch (e) {
      String errorMsg = _extractErrorMessage(e);
      print('💥 Direct OTP verification exception: $errorMsg');
      errorMessage.value = errorMsg;
      return {'success': false, 'message': errorMsg, 'shouldNavigate': false};
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _completeLogin(AuthResponse response) async {
    if (response.token != null && response.token!.isNotEmpty) {
      await StorageService.saveToken(response.token!);
      print('🔑 Token saved: ${response.token}');
    }

    if (response.user != null) {
      await StorageService.saveUser(response.user!);
      print('👤 User data saved: ${response.user!.email}');
    }

    if (response.token == null &&
        response.data != null &&
        response.data!['token'] != null) {
      final token = response.data!['token'].toString();
      await StorageService.saveToken(token);
      print('🔑 Token saved from data: $token');
    }
  }

  Future<Map<String, dynamic>> resendSecondStepOTP() async {
    if (_pendingEmail == null) {
      return {'success': false, 'message': 'No pending authentication found'};
    }

    print('🔄 Resending OTP for second step: $_pendingEmail');

    final result = await _apiService.requestOTP(_pendingEmail!);

    if (result.success) {
      return {
        'success': true,
        'message': result.message ?? 'OTP sent successfully',
      };
    } else {
      return {
        'success': false,
        'message': result.message ?? 'Failed to resend OTP',
      };
    }
  }

  // Direct OTP login (bypasses password verification)
  Future<Map<String, dynamic>> directOTPLogin(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📱 Direct OTP login for: $email');

      final response = await _apiService.requestOTP(email);

      if (response.success) {
        _pendingEmail = email;
        requiresOTP.value = true;
        return {
          'success': true,
          'message': response.message ?? 'OTP sent to your email',
          'requiresOTP': true,
        };
      } else {
        errorMessage.value = response.message;
        return {
          'success': false,
          'message': response.message ?? 'Failed to send OTP',
          'requiresOTP': false,
        };
      }
    } catch (e) {
      String errorMsg = _extractErrorMessage(e);
      errorMessage.value = errorMsg;
      return {'success': false, 'message': errorMsg, 'requiresOTP': false};
    } finally {
      isLoading.value = false;
    }
  }

  // Traditional login (for backward compatibility)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔐 Traditional login for: $email');

      final response = await _apiService.login(email, password);

      if (response.success) {
        await _completeLogin(response);
        return {
          'success': true,
          'message': response.message,
          'shouldNavigate': true,
        };
      } else {
        errorMessage.value = response.message;
        return {
          'success': false,
          'message': response.message,
          'shouldNavigate': false,
        };
      }
    } catch (e) {
      String errorMsg = _extractErrorMessage(e);
      errorMessage.value = errorMsg;
      return {'success': false, 'message': errorMsg, 'shouldNavigate': false};
    } finally {
      isLoading.value = false;
    }
  }

  // Registration
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('👤 Registering user: $email');

      final response = await _apiService.register(
        name,
        email,
        password,
        phoneNumber,
      );

      if (response.success) {
        await _completeLogin(response);
        return {
          'success': true,
          'message': response.message,
          'shouldNavigate': true,
        };
      } else {
        errorMessage.value = response.message;
        return {
          'success': false,
          'message': response.message,
          'shouldNavigate': false,
        };
      }
    } catch (e) {
      String errorMsg = _extractErrorMessage(e);
      errorMessage.value = errorMsg;
      return {'success': false, 'message': errorMsg, 'shouldNavigate': false};
    } finally {
      isLoading.value = false;
    }
  }

  String _extractErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final data = error.response?.data;
        if (data is Map) {
          return data['message'] ??
              data['error'] ??
              error.message ??
              'Unknown error';
        } else if (data is String) {
          return data;
        }
        return error.response?.statusMessage ??
            'HTTP Error ${error.response?.statusCode}';
      }
      return error.message ?? 'Network error';
    }
    return error.toString();
  }

  // Clear pending authentication
  void clearPendingAuth() {
    _pendingEmail = null;
    requiresOTP.value = false;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await StorageService.getToken();
    final user = await StorageService.getUser();
    return token != null || user != null;
  }

  // Logout
  Future<void> logout() async {
    try {
      await StorageService.clear();
      clearPendingAuth();
      Get.offAllNamed('/login');
    } catch (e) {
      print('💥 Logout error: $e');
    }
  }
}
