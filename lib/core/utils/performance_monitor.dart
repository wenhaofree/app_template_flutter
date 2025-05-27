import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'log_service.dart';

/// 性能监控工具
class PerformanceMonitor {
  static final LogService _logger = LogService();
  static final Map<String, DateTime> _startTimes = {};
  static final Map<String, List<Duration>> _measurements = {};

  /// 开始计时
  static void startTimer(String name) {
    _startTimes[name] = DateTime.now();
    if (kDebugMode) {
      developer.Timeline.startSync(name);
    }
  }

  /// 结束计时
  static Duration? endTimer(String name) {
    final startTime = _startTimes.remove(name);
    if (startTime == null) {
      _logger.w('Timer $name was not started');
      return null;
    }

    final duration = DateTime.now().difference(startTime);

    // 记录测量结果
    _measurements.putIfAbsent(name, () => []).add(duration);

    if (kDebugMode) {
      developer.Timeline.finishSync();
      _logger.d('$name took ${duration.inMilliseconds}ms');
    }

    // 如果耗时过长，记录警告
    if (duration.inMilliseconds > 1000) {
      _logger.w('$name took ${duration.inMilliseconds}ms (slow operation)');
    }

    return duration;
  }

  /// 测量函数执行时间
  static Future<T> measureAsync<T>(
    String name,
    Future<T> Function() function,
  ) async {
    startTimer(name);
    try {
      final result = await function();
      return result;
    } finally {
      endTimer(name);
    }
  }

  /// 测量同步函数执行时间
  static T measureSync<T>(
    String name,
    T Function() function,
  ) {
    startTimer(name);
    try {
      return function();
    } finally {
      endTimer(name);
    }
  }

  /// 获取性能统计
  static Map<String, PerformanceStats> getStats() {
    final stats = <String, PerformanceStats>{};

    for (final entry in _measurements.entries) {
      final measurements = entry.value;
      if (measurements.isNotEmpty) {
        final totalMs = measurements.fold<int>(
          0,
          (sum, duration) => sum + duration.inMilliseconds,
        );
        final avgMs = totalMs / measurements.length;
        final maxMs = measurements
            .map((d) => d.inMilliseconds)
            .reduce((a, b) => a > b ? a : b);
        final minMs = measurements
            .map((d) => d.inMilliseconds)
            .reduce((a, b) => a < b ? a : b);

        stats[entry.key] = PerformanceStats(
          name: entry.key,
          count: measurements.length,
          totalMs: totalMs,
          averageMs: avgMs,
          maxMs: maxMs,
          minMs: minMs,
        );
      }
    }

    return stats;
  }

  /// 打印性能统计
  static void printStats() {
    if (!kDebugMode) return;

    final stats = getStats();
    if (stats.isEmpty) {
      _logger.d('No performance measurements recorded');
      return;
    }

    _logger.d('=== Performance Statistics ===');
    for (final stat in stats.values) {
      _logger.d(
        '${stat.name}: ${stat.count} calls, '
        'avg: ${stat.averageMs.toStringAsFixed(2)}ms, '
        'max: ${stat.maxMs}ms, '
        'min: ${stat.minMs}ms, '
        'total: ${stat.totalMs}ms',
      );
    }
    _logger.d('==============================');
  }

  /// 清除统计数据
  static void clearStats() {
    _measurements.clear();
    _startTimes.clear();
  }

  /// 监控内存使用
  static Future<MemoryInfo?> getMemoryInfo() async {
    if (!kDebugMode) return null;

    try {
      final info = await developer.Service.getInfo();
      // 这里可以获取更详细的内存信息
      return MemoryInfo(
        used: 0, // 实际实现中需要从系统获取
        total: 0,
        free: 0,
      );
    } catch (e) {
      _logger.w('Failed to get memory info', e);
      return null;
    }
  }

  /// 监控帧率
  static void startFrameMonitoring() {
    if (!kDebugMode) return;

    WidgetsBinding.instance.addTimingsCallback((timings) {
      for (final timing in timings) {
        final frameTime = timing.totalSpan.inMilliseconds;
        if (frameTime > 16) { // 超过16ms表示掉帧
          _logger.w('Frame drop detected: ${frameTime}ms');
        }
      }
    });
  }
}

/// 性能统计数据
class PerformanceStats {
  final String name;
  final int count;
  final int totalMs;
  final double averageMs;
  final int maxMs;
  final int minMs;

  const PerformanceStats({
    required this.name,
    required this.count,
    required this.totalMs,
    required this.averageMs,
    required this.maxMs,
    required this.minMs,
  });
}

/// 内存信息
class MemoryInfo {
  final int used;
  final int total;
  final int free;

  const MemoryInfo({
    required this.used,
    required this.total,
    required this.free,
  });

  double get usagePercentage => total > 0 ? (used / total) * 100 : 0;
}

/// 性能监控装饰器
class PerformanceWidget extends StatefulWidget {
  final Widget child;
  final String name;

  const PerformanceWidget({
    super.key,
    required this.child,
    required this.name,
  });

  @override
  State<PerformanceWidget> createState() => _PerformanceWidgetState();
}

class _PerformanceWidgetState extends State<PerformanceWidget> {
  @override
  void initState() {
    super.initState();
    PerformanceMonitor.startTimer('${widget.name}_build');
  }

  @override
  void dispose() {
    PerformanceMonitor.endTimer('${widget.name}_build');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
