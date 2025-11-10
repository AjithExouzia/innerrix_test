import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String message;
  final User? user;
  final String? token;
  final Map<String, dynamic>? data;
  final int? statusCode;

  AuthResponse({
    required this.success,
    required this.message,
    this.user,
    this.token,
    this.data,
    this.statusCode,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    print('🔍 Parsing Auth Response: $json');

    // Handle different success indicators
    bool success = false;
    if (json['success'] != null) {
      success = json['success'] == true || json['success'] == 'true';
    } else if (json['status'] != null) {
      success = json['status'] == 'success' || json['status'] == true;
    } else if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      success = true;
    }

    // Handle different message fields
    String message =
        json['message'] ??
        json['msg'] ??
        json['Message'] ??
        (success ? 'Operation completed successfully' : 'Operation failed');

    // Extract user data
    User? user;
    if (json['user'] != null && json['user'] is Map) {
      user = User.fromJson(Map<String, dynamic>.from(json['user']));
    } else if (json['data'] != null && json['data']['user'] != null) {
      user = User.fromJson(Map<String, dynamic>.from(json['data']['user']));
    }

    // Extract token
    String? token =
        json['token'] ??
        json['access_token'] ??
        json['Token'] ??
        json['data']?['token'] ??
        json['data']?['access_token'];

    return AuthResponse(
      success: success,
      message: message,
      user: user,
      token: token,
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : json,
      statusCode: statusCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
      'token': token,
      'data': data,
      'statusCode': statusCode,
    };
  }

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message, user: $user, token: $token)';
  }
}
