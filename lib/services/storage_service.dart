import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _userBox = 'userBox';
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  static Future<void> init() async {
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserAdapter());
      }

      await Hive.openBox(_userBox);
      print('✅ Hive initialized successfully');
    } catch (e) {
      print('❌ Hive initialization error: $e');
      await Hive.deleteBoxFromDisk(_userBox);
      await Hive.openBox(_userBox);
    }
  }

  static Future<void> saveToken(String token) async {
    final box = Hive.box(_userBox);
    await box.put(_tokenKey, token);
    print('🔑 Token saved: $token');
  }

  static Future<String?> getToken() async {
    final box = Hive.box(_userBox);
    final token = box.get(_tokenKey);
    print('🔑 Token retrieved: ${token != null ? "exists" : "null"}');
    return token;
  }

  static Future<void> saveUser(User user) async {
    final box = Hive.box(_userBox);
    await box.put(_userKey, user);
    print('👤 User saved: ${user.email}');
  }

  static Future<User?> getUser() async {
    final box = Hive.box(_userBox);
    final user = box.get(_userKey);
    print('👤 User retrieved: ${user != null ? user.email : "null"}');
    return user;
  }

  static Future<void> clear() async {
    final box = Hive.box(_userBox);
    await box.clear();
    print('🗑️ Storage cleared');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    final user = await getUser();
    return token != null || user != null;
  }
}
