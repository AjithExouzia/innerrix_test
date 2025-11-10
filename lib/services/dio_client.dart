import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../utills/debug_utils.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://app.ecominnerix.com/api',
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token if available
          final token = await StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            print('🔑 Token added to request');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          DebugUtils.printApiDetails(response.requestOptions, response, null);
          return handler.next(response);
        },
        onError: (error, handler) {
          DebugUtils.printApiDetails(error.requestOptions, null, error);

          if (error.response?.statusCode == 401) {
            print('🔐 Unauthorized - Clearing storage');
            StorageService.clear();
            Get.offAllNamed('/login');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
