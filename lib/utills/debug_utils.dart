import 'package:dio/dio.dart';

class DebugUtils {
  static void printApiDetails(
    RequestOptions options,
    Response? response,
    DioException? error,
  ) {
    print('🚀 === API CALL DETAILS ===');
    print('📤 URL: ${options.method} ${options.uri}');
    print('📦 HEADERS: ${options.headers}');
    print('📥 REQUEST DATA: ${options.data}');

    if (response != null) {
      print('✅ RESPONSE STATUS: ${response.statusCode}');
      print('📦 RESPONSE DATA: ${response.data}');
      print('📦 RESPONSE HEADERS: ${response.headers}');
    }

    if (error != null) {
      print('❌ ERROR TYPE: ${error.type}');
      print('❌ ERROR MESSAGE: ${error.message}');
      print('❌ ERROR RESPONSE: ${error.response?.data}');
    }
    print('🚀 === END API CALL ===');
  }
}
