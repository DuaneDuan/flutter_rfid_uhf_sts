import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 负责将测试日志写入设备的本地文件 (如 Download 目录)
class FileLogger {
  static String _logPath = '';
  static final List<String> _inMemoryLogs = [];

  static List<String> get inMemoryLogs => _inMemoryLogs;

  /// 获取日志文件路径，优先使用设备的 Download 目录
  static Future<String> getLogFilePath() async {
    if (_logPath.isNotEmpty) return _logPath;

    // 动态请求存储权限
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    // 尝试寻找公共 Download 目录
    Directory downloadDir = Directory('/storage/emulated/0/Download');
    if (await downloadDir.exists()) {
      _logPath = '${downloadDir.path}/rfid_test_log.txt';
      return _logPath;
    }

    downloadDir = Directory('/sdcard/Download');
    if (await downloadDir.exists()) {
      _logPath = '${downloadDir.path}/rfid_test_log.txt';
      return _logPath;
    }

    // 备用：应用私有外部存储目录
    try {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        _logPath = '${externalDir.path}/rfid_test_log.txt';
        return _logPath;
      }
    } catch (e) {
      // 忽略错误并尝试下一步
    }

    // 终极备用：应用文档目录
    final docDir = await getApplicationDocumentsDirectory();
    _logPath = '${docDir.path}/rfid_test_log.txt';
    return _logPath;
  }

  /// 记录一条日志，同时输出到控制台、内存及本地文件
  static Future<void> log(String message) async {
    final timeStr =
        DateTime.now().toIso8601String().substring(11, 23); // HH:mm:ss.SSS
    final logLine = '[$timeStr] $message';

    // 输出到 IDE 控制台
    print(logLine);

    // 在内存中保留最近 100 条日志供 UI 显示
    _inMemoryLogs.add(logLine);
    if (_inMemoryLogs.length > 100) {
      _inMemoryLogs.removeAt(0);
    }

    try {
      final path = await getLogFilePath();
      final file = File(path);
      await file.writeAsString('$logLine\n',
          mode: FileMode.append, flush: true);
    } catch (e) {
      print('Failed to write log to file: $e');
    }
  }

  /// 清空日志
  static Future<void> clearLogs() async {
    _inMemoryLogs.clear();
    try {
      final path = await getLogFilePath();
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Failed to clear log file: $e');
    }
  }
}
