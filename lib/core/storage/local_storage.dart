/// 本地存储接口
abstract class LocalStorage {
  /// 读取字符串
  Future<String?> getString(String key);
  
  /// 保存字符串
  Future<bool> setString(String key, String value);
  
  /// 读取布尔值
  Future<bool?> getBool(String key);
  
  /// 保存布尔值
  Future<bool> setBool(String key, bool value);
  
  /// 读取整数
  Future<int?> getInt(String key);
  
  /// 保存整数
  Future<bool> setInt(String key, int value);
  
  /// 读取双精度浮点数
  Future<double?> getDouble(String key);
  
  /// 保存双精度浮点数
  Future<bool> setDouble(String key, double value);
  
  /// 读取字符串列表
  Future<List<String>?> getStringList(String key);
  
  /// 保存字符串列表
  Future<bool> setStringList(String key, List<String> value);
  
  /// 读取对象
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic> json) fromJson);
  
  /// 保存对象
  Future<bool> setObject<T>(String key, T value, Map<String, dynamic> Function(T value) toJson);
  
  /// 判断是否包含键
  Future<bool> containsKey(String key);
  
  /// 删除键
  Future<bool> remove(String key);
  
  /// 清空所有
  Future<bool> clear();
} 