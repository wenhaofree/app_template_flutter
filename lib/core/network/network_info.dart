import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 网络状态服务提供者
final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl(Connectivity()));

/// 网络状态接口
abstract class NetworkInfo {
  /// 检查是否有网络连接
  Future<bool> isConnected();
  
  /// 获取连接类型
  Future<ConnectivityResult> getConnectionType();
  
  /// 网络状态变化流
  Stream<ConnectivityResult> get onConnectivityChanged;
}

/// 网络状态实现
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  
  /// 构造函数
  NetworkInfoImpl(this._connectivity);
  
  @override
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  @override
  Future<ConnectivityResult> getConnectionType() async {
    return await _connectivity.checkConnectivity();
  }
  
  @override
  Stream<ConnectivityResult> get onConnectivityChanged => 
      _connectivity.onConnectivityChanged;
} 