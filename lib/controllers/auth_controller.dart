import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🎯 Starting login process for: $email');

      final response = await _apiService.login(email, password);

      print('🎯 Login response: ${response.toString()}');

      if (response.success) {
        print('✅ Login successful, processing data...');

        // Check if we have a token to save
        if (response.token != null && response.token!.isNotEmpty) {
          print('🔑 Saving token: ${response.token}');
          await StorageService.saveToken(response.token!);
        } else {
          print('⚠️ No token received in response');
        }

        // Check if we have user data to save
        if (response.user != null) {
          print('👤 Saving user data');
          await StorageService.saveUser(response.user!);
        } else {
          print('⚠️ No user data received in response');
        }

        // Check if we have any data that might contain token/user
        if (response.data != null) {
          print('📦 Additional response data: ${response.data}');

          // Try to extract token from data if not already set
          if (response.token == null && response.data!['token'] != null) {
            final token = response.data!['token'].toString();
            print('🔑 Saving token from data: $token');
            await StorageService.saveToken(token);
          }
        }

        // Verify we have what we need to proceed
        final token = await StorageService.getToken();
        final user = await StorageService.getUser();

        print('🔍 Post-login verification:');
        print('   Token exists: ${token != null}');
        print('   User exists: ${user != null}');

        if (token != null || user != null) {
          print('🚀 Navigation conditions met, proceeding to home...');
          return {
            'success': true,
            'message': response.message,
            'shouldNavigate': true,
          };
        } else {
          print('⚠️ No token or user data saved, but API returned success');
          return {
            'success': true,
            'message': response.message,
            'shouldNavigate': true, // Still try to navigate
          };
        }
      } else {
        print('❌ Login failed: ${response.message}');
        errorMessage.value = response.message;
        return {
          'success': false,
          'message': response.message,
          'shouldNavigate': false,
        };
      }
    } catch (e) {
      String errorMsg = _extractErrorMessage(e);
      print('💥 Login exception: $errorMsg');
      errorMessage.value = errorMsg;
      return {'success': false, 'message': errorMsg, 'shouldNavigate': false};
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> requestOTP(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📱 Requesting OTP for: $email');

      final response = await _apiService.requestOTP(email);

      print('📱 OTP Request response: ${response.toString()}');

      if (response.success) {
        return {
          'success': true,
          'message': response.message,
          'shouldNavigate': false,
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
      print('💥 OTP Request exception: $errorMsg');
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

      print('✅ Verifying OTP: $otp for: $email');

      final response = await _apiService.verifyOTP(email, otp);

      print('✅ OTP Verification response: ${response.toString()}');

      if (response.success) {
        print('✅ OTP verification successful, processing data...');

        // Check if we have a token to save
        if (response.token != null && response.token!.isNotEmpty) {
          print('🔑 Saving token: ${response.token}');
          await StorageService.saveToken(response.token!);
        } else {
          print('⚠️ No token received in OTP response');
        }

        // Check if we have user data to save
        if (response.user != null) {
          print('👤 Saving user data');
          await StorageService.saveUser(response.user!);
        } else {
          print('⚠️ No user data received in OTP response');
        }

        // Check if we have any data that might contain token/user
        if (response.data != null) {
          print('📦 Additional OTP response data: ${response.data}');

          // Try to extract token from data if not already set
          if (response.token == null && response.data!['token'] != null) {
            final token = response.data!['token'].toString();
            print('🔑 Saving token from OTP data: $token');
            await StorageService.saveToken(token);
          }
        }

        // Verify we have what we need to proceed
        final token = await StorageService.getToken();
        final user = await StorageService.getUser();

        print('🔍 Post-OTP verification:');
        print('   Token exists: ${token != null}');
        print('   User exists: ${user != null}');

        if (token != null || user != null) {
          print('🚀 OTP verification conditions met, proceeding to home...');
          return {
            'success': true,
            'message': response.message,
            'shouldNavigate': true,
          };
        } else {
          print(
            '⚠️ No token or user data saved from OTP, but API returned success',
          );
          return {
            'success': true,
            'message': response.message,
            'shouldNavigate': true, // Still try to navigate
          };
        }
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
      print('💥 OTP Verification exception: $errorMsg');
      errorMessage.value = errorMsg;
      return {'success': false, 'message': errorMsg, 'shouldNavigate': false};
    } finally {
      isLoading.value = false;
    }
  }

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

      print('👤 Registration response: ${response.toString()}');

      if (response.success) {
        print('✅ Registration successful, processing data...');

        // Check if we have a token to save
        if (response.token != null && response.token!.isNotEmpty) {
          print('🔑 Saving token: ${response.token}');
          await StorageService.saveToken(response.token!);
        } else {
          print('⚠️ No token received in registration response');
        }

        // Check if we have user data to save
        if (response.user != null) {
          print('👤 Saving user data');
          await StorageService.saveUser(response.user!);
        } else {
          print('⚠️ No user data received in registration response');
        }

        // Check if we have any data that might contain token/user
        if (response.data != null) {
          print('📦 Additional registration data: ${response.data}');

          // Try to extract token from data if not already set
          if (response.token == null && response.data!['token'] != null) {
            final token = response.data!['token'].toString();
            print('🔑 Saving token from registration data: $token');
            await StorageService.saveToken(token);
          }
        }

        // Verify we have what we need to proceed
        final token = await StorageService.getToken();
        final user = await StorageService.getUser();

        print('🔍 Post-registration verification:');
        print('   Token exists: ${token != null}');
        print('   User exists: ${user != null}');

        if (token != null || user != null) {
          print('🚀 Registration conditions met, proceeding to home...');
          return {
            'success': true,
            'message': response.message,
            'shouldNavigate': true,
          };
        } else {
          print(
            '⚠️ No token or user data saved from registration, but API returned success',
          );
          return {
            'success': true,
            'message': response.message,
            'shouldNavigate': true, // Still try to navigate
          };
        }
      } else {
        print('❌ Registration failed: ${response.message}');
        errorMessage.value = response.message;
        return {
          'success': false,
          'message': response.message,
          'shouldNavigate': false,
        };
      }
    } catch (e) {
      String errorMsg = _extractErrorMessage(e);
      print('💥 Registration exception: $errorMsg');
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

  // Logout method
  Future<void> logout() async {
    try {
      await StorageService.clear();
      Get.offAllNamed('/login');
    } catch (e) {
      print('💥 Logout error: $e');
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await StorageService.getToken();
    final user = await StorageService.getUser();
    return token != null || user != null;
  }
}
