import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _userBox = 'userBox';
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  static Future<void> init() async {
    await Hive.openBox(_userBox);
    Hive.registerAdapter(UserAdapter());
  }

  static Future<void> saveToken(String token) async {
    final box = Hive.box(_userBox);
    await box.put(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final box = Hive.box(_userBox);
    return box.get(_tokenKey);
  }

  static Future<void> saveUser(User user) async {
    final box = Hive.box(_userBox);
    await box.put(_userKey, user);
  }

  static Future<User?> getUser() async {
    final box = Hive.box(_userBox);
    return box.get(_userKey);
  }

  static Future<void> clear() async {
    final box = Hive.box(_userBox);
    await box.clear();
  }
}
