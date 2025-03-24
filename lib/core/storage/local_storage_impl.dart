import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage.dart';

/// 本地存储实现类（基于SharedPreferences）
class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _preferences;
  
  /// 构造函数
  LocalStorageImpl(this._preferences);
  
  @override
  Future<String?> getString(String key) async {
    return _preferences.getString(key);
  }
  
  @override
  Future<bool> setString(String key, String value) async {
    return _preferences.setString(key, value);
  }
  
  @override
  Future<bool?> getBool(String key) async {
    return _preferences.getBool(key);
  }
  
  @override
  Future<bool> setBool(String key, bool value) async {
    return _preferences.setBool(key, value);
  }
  
  @override
  Future<int?> getInt(String key) async {
    return _preferences.getInt(key);
  }
  
  @override
  Future<bool> setInt(String key, int value) async {
    return _preferences.setInt(key, value);
  }
  
  @override
  Future<double?> getDouble(String key) async {
    return _preferences.getDouble(key);
  }
  
  @override
  Future<bool> setDouble(String key, double value) async {
    return _preferences.setDouble(key, value);
  }
  
  @override
  Future<List<String>?> getStringList(String key) async {
    return _preferences.getStringList(key);
  }
  
  @override
  Future<bool> setStringList(String key, List<String> value) async {
    return _preferences.setStringList(key, value);
  }
  
  @override
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic> json) fromJson) async {
    final jsonString = _preferences.getString(key);
    if (jsonString == null) {
      return null;
    }
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<bool> setObject<T>(String key, T value, Map<String, dynamic> Function(T value) toJson) async {
    try {
      final json = toJson(value);
      final jsonString = jsonEncode(json);
      return _preferences.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> containsKey(String key) async {
    return _preferences.containsKey(key);
  }
  
  @override
  Future<bool> remove(String key) async {
    return _preferences.remove(key);
  }
  
  @override
  Future<bool> clear() async {
    return _preferences.clear();
  }
} 