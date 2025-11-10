import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/home_data_model.dart';
import '../models/product_model.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<AuthResponse> login(String email, String password) async {
    try {
      print('🔐 Attempting login for: $email');

      final response = await _dio.post(
        '/login',
        data: {'email': email.trim(), 'password': password.trim()},
        options: Options(validateStatus: (status) => true),
      );

      return AuthResponse.fromJson(
        response.data is Map ? response.data : {'data': response.data},
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> requestOTP(String email) async {
    try {
      print('📱 Requesting OTP for: $email');

      final response = await _dio.post(
        '/request-otp',
        data: {'email': email.trim()},
        options: Options(validateStatus: (status) => true),
      );

      return AuthResponse.fromJson(
        response.data is Map ? response.data : {'data': response.data},
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OTP request error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> verifyOTP(String email, String otp) async {
    try {
      print('✅ Verifying OTP: $otp for: $email');

      final response = await _dio.post(
        '/verify-email-otp',
        data: {'email': email.trim(), 'otp': otp.trim()},
        options: Options(validateStatus: (status) => true),
      );

      return AuthResponse.fromJson(
        response.data is Map ? response.data : {'data': response.data},
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ OTP verification error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> register(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      print('👤 Registering user: $email');

      final response = await _dio.post(
        '/register',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password.trim(),
          'shop_id': 1,
          'phone_number': phoneNumber.trim(),
        },
        options: Options(validateStatus: (status) => true),
      );

      return AuthResponse.fromJson(
        response.data is Map ? response.data : {'data': response.data},
        statusCode: response.statusCode,
      );
    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    }
  }

  Future<HomeData> getHomeData() async {
    try {
      final response = await _dio.get('/v1/home');
      return HomeData.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load home data: $e');
    }
  }

  Future<List<Product>> getProducts({int page = 1, int pageSize = 100}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {'shop_id': 1, 'page_size': pageSize, 'page': page},
      );

      if (response.data is List) {
        return (response.data as List)
            .map((product) => Product.fromJson(product))
            .toList();
      } else if (response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((product) => Product.fromJson(product))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProductDetail(int productId) async {
    try {
      final response = await _dio.get('/products/$productId');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load product details: $e');
    }
  }
}
