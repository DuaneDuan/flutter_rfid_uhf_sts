import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_rfid_uhf_sts/flutter_rfid_uhf_sts.dart';

import 'logger.dart';
import 'screens/inventory_screen.dart';
import 'screens/read_screen.dart';
import 'screens/write_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/log_panel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _rfidPlugin = FlutterRfidUhfSts();

  // 核心共享状态
  String _platformVersion = 'Unknown';
  bool _isConnected = false;
  bool _isScanning = false;
  Map<dynamic, dynamic> _configFile = {};
  List<Map<String, dynamic>> _tagData = [];
  int _keyDownCount = 0;
  int _scanTimes = 0;
  String _logFilePath = 'Loading log path...';

  // 当前激活的 Tab 页索引
  int _currentIndex = 0;

  // 配置参数值 (Settings Screen 共享)
  String _powerValue = '30'; // 默认功率 30dBm
  int _bandPosition = 1; // 区域频段默认值
  bool _scanEpc = true;
  bool _scanTid = false;
  bool _scanUser = false;
  int _userPtr = 0;
  int _userLen = 6;

  // 写卡参数值 (Write Screen 共享)
  final TextEditingController _passwordController =
      TextEditingController(text: '00000000');
  final TextEditingController _ptrController = TextEditingController(text: '2');
  final TextEditingController _dataController =
      TextEditingController(text: '112233445566778899001122');
  final TextEditingController _sourcePtrController =
      TextEditingController(text: '2');
  final TextEditingController _sourceDataController = TextEditingController();

  StreamSubscription<Map<String, dynamic>>? _dataSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _initLogger();
    _initRfidStream();
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _rfidPlugin.streamClose();
    _passwordController.dispose();
    _ptrController.dispose();
    _dataController.dispose();
    _sourcePtrController.dispose();
    _sourceDataController.dispose();
    super.dispose();
  }

  // 初始化日志路径
  Future<void> _initLogger() async {
    final path = await FileLogger.getLogFilePath();
    setState(() {
      _logFilePath = path;
    });
    FileLogger.log("App started. Log file located at: $path");
  }

  // 初始化 RFID 按键与标签数据流
  Future<void> _initRfidStream() async {
    try {
      await _rfidPlugin.streamInit();
      FileLogger.log("RFID Stream initialized.");
    } catch (e) {
      FileLogger.log("Failed to initialize RFID Stream: $e");
    }

    _dataSubscription = _rfidPlugin.dataStream.listen((newValue) async {
      FileLogger.log("Stream received data: $newValue");

      // 处理物理按键触发
      if (newValue['keyCount'] != null) {
        int keyCount = newValue['keyCount'];
        FileLogger.log("Physical scan key trigger count: $keyCount");

        if (keyCount % 2 == 0) {
          if (_isConnected) {
            bool? stopResult = await _rfidPlugin.stopScan;
            FileLogger.log(
                "Auto-Stop scan via physical key. Result: $stopResult");
            setState(() {
              _isScanning = stopResult ?? false;
            });
          }
        } else {
          if (!_isConnected) {
            bool? connResult = await _rfidPlugin.connect;
            FileLogger.log(
                "Auto-Connect via physical key. Result: $connResult");
            setState(() {
              _isConnected = connResult ?? false;
            });
          }
          if (_isConnected) {
            bool? startResult = await _rfidPlugin.startScan;
            FileLogger.log(
                "Auto-Start scan via physical key. Result: $startResult");
            setState(() {
              _isScanning = startResult ?? false;
            });
          }
        }
      }

      // 接收扫描标签列表
      if (newValue['tagData'] != null) {
        List<dynamic> rawTags = newValue['tagData'];
        List<Map<String, dynamic>> parsedTags = rawTags
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList();

        setState(() {
          _tagData = parsedTags;
          _scanTimes++;
        });

        FileLogger.log(
            "Scanned tags count: ${parsedTags.length}, Total scan pulses: $_scanTimes");
        if (parsedTags.isNotEmpty) {
          FileLogger.log("Sample scanned tag: ${parsedTags.first}");
        }
      }

      if (newValue['keyCount'] != null) {
        setState(() {
          _keyDownCount = newValue['keyCount'] ?? 0;
        });
      }
    });
  }

  // 获取平台版本
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _rfidPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException catch (e) {
      platformVersion = 'Failed to get platform version: ${e.message}';
    }

    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
    FileLogger.log("Platform version: $platformVersion");
  }

  // 连接设备
  Future<void> _connectDevice() async {
    FileLogger.log("Attempting to connect...");
    try {
      bool? isConnected = await _rfidPlugin.connect;
      FileLogger.log("Connection result: $isConnected");
      setState(() {
        _isConnected = isConnected ?? false;
      });
      if (_isConnected) {
        await _fetchConfiguration();
      }
    } catch (e) {
      FileLogger.log("Connection exception: $e");
    }
  }

  // 断开设备
  Future<void> _disconnectDevice() async {
    FileLogger.log("Disconnecting...");
    try {
      bool? isDisconnected = await _rfidPlugin.disconnect;
      FileLogger.log("Disconnection result: $isDisconnected");
      setState(() {
        _isConnected = !(isDisconnected ?? true);
        _isScanning = false;
      });
    } catch (e) {
      FileLogger.log("Disconnection exception: $e");
    }
  }

  // 获取配置
  Future<void> _fetchConfiguration() async {
    FileLogger.log("Fetching configuration...");
    try {
      Map<dynamic, dynamic>? config = await _rfidPlugin.getConfigure();
      FileLogger.log("Fetched configuration: $config");
      if (config != null) {
        setState(() {
          _configFile = config;
        });
      }
    } catch (e) {
      FileLogger.log("Fetch configuration exception: $e");
    }
  }

  // 检测连接状态
  Future<void> _checkConnectStatus() async {
    FileLogger.log("Checking status...");
    try {
      bool? isConnected = await _rfidPlugin.isConnected;
      FileLogger.log("Reported status: $isConnected");
      setState(() {
        _isConnected = isConnected ?? false;
      });
    } catch (e) {
      FileLogger.log("Check connection exception: $e");
    }
  }

  // 开始扫描
  Future<void> _startScan() async {
    FileLogger.log("Starting scan...");
    if (!_isConnected) {
      await _connectDevice();
    }
    if (_isConnected) {
      try {
        bool? isScanning = await _rfidPlugin.startScan;
        FileLogger.log("Start scan result: $isScanning");
        setState(() {
          _isScanning = isScanning ?? false;
        });
      } catch (e) {
        FileLogger.log("Start scan exception: $e");
      }
    }
  }

  // 停止扫描
  Future<void> _stopScan() async {
    FileLogger.log("Stopping scan...");
    try {
      bool? isScanning = await _rfidPlugin.stopScan;
      FileLogger.log("Stop scan result: $isScanning");
      setState(() {
        _isScanning = isScanning ?? false;
      });
    } catch (e) {
      FileLogger.log("Stop scan exception: $e");
    }
  }

  // 手动获取标签数据
  Future<void> _readTagDataManual() async {
    FileLogger.log("Manually fetching tag data...");
    try {
      List<Map<String, dynamic>>? tagData = await _rfidPlugin.getTagData();
      FileLogger.log("Manually fetched tags count: ${tagData?.length}");
      if (tagData != null && tagData.isNotEmpty) {
        FileLogger.log("Sample manually fetched tag: ${tagData.first}");
      }
      if (tagData != null) {
        setState(() {
          _tagData = tagData;
        });
      }
    } catch (e) {
      FileLogger.log("Manual read exception: $e");
    }
  }

  // 清空已扫描标签列表
  Future<void> _clearTagData() async {
    FileLogger.log("Clearing scanned tags...");
    try {
      await _rfidPlugin.clearData();
      setState(() {
        _tagData = [];
        _scanTimes = 0;
      });
      FileLogger.log("Scanned tags cleared.");
    } catch (e) {
      FileLogger.log("Clear tag data exception: $e");
    }
  }

  // 应用配置
  Future<void> _applySettings() async {
    if (!_isConnected) {
      FileLogger.log("Connect device first.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect device first')),
      );
      return;
    }

    FileLogger.log("Applying configurations...");
    try {
      bool? powerRes = await _rfidPlugin.setPower(_powerValue);
      FileLogger.log("Set Power to $_powerValue dBm: $powerRes");

      bool? bandRes = await _rfidPlugin.setBandPosition(_bandPosition);
      FileLogger.log("Set Band Position to $_bandPosition: $bandRes");

      bool? epcRes = await _rfidPlugin.setScanEpc(_scanEpc);
      FileLogger.log("Set Scan EPC to $_scanEpc: $epcRes");

      bool? tidRes = await _rfidPlugin.setScanTid(_scanTid);
      FileLogger.log("Set Scan TID to $_scanTid: $tidRes");

      bool? userRes = await _rfidPlugin.setScanUser(_scanUser);
      FileLogger.log("Set Scan User to $_scanUser: $userRes");

      if (_scanUser) {
        bool? userPtrRes = await _rfidPlugin.setUserPtr(_userPtr);
        bool? userLenRes = await _rfidPlugin.setUserLen(_userLen);
        FileLogger.log(
            "Set User Ptr to $_userPtr ($userPtrRes), User Len to $_userLen ($userLenRes)");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings applied successfully')),
      );

      await _fetchConfiguration();
    } catch (e) {
      FileLogger.log("Error applying settings: $e");
    }
  }

  // 数据写入
  Future<void> _writeDataTest() async {
    if (!_isConnected) {
      FileLogger.log("Please connect the device first before writing data.");
      return;
    }

    final password = _passwordController.text;
    final ptr = int.tryParse(_ptrController.text) ?? 2;
    final data = _dataController.text;
    final sourcePtr = int.tryParse(_sourcePtrController.text) ?? 2;
    final sourceData = _sourceDataController.text;

    FileLogger.log("Executing Write Data:");
    FileLogger.log("- Password: $password");
    FileLogger.log("- Target Pointer: $ptr");
    FileLogger.log("- Write Hex Data: $data");
    FileLogger.log("- Source Pointer: $sourcePtr");
    FileLogger.log("- Source Data: $sourceData");

    try {
      bool? writeSuccess = await _rfidPlugin.writeData(
        tagPassword: password,
        ptr: ptr,
        data: data,
        sourcePtr: sourcePtr,
        sourceData: sourceData,
      );
      FileLogger.log("Write Data result: $writeSuccess");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(writeSuccess == true ? 'Write Success' : 'Write Failed'),
          backgroundColor: writeSuccess == true ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      FileLogger.log("Write Data Exception: $e");
    }
  }

  // 重置日志文件
  Future<void> _clearLogFile() async {
    await FileLogger.clearLogs();
    setState(() {});
    FileLogger.log("Log file reset.");
  }

  // 在扫描页选择目标 EPC 自动填充到写入过滤输入框并跳转到写入页
  void _selectEpcForWrite(String epc) {
    setState(() {
      _sourceDataController.text = epc;
      _currentIndex = 2; // 自动跳转至 Write Tab (index 2)
    });
  }

  @override
  Widget build(BuildContext context) {
    // 根据 Tab 导航来切换中间渲染的页面
    final List<Widget> screens = [
      InventoryScreen(
        isConnected: _isConnected,
        isScanning: _isScanning,
        keyDownCount: _keyDownCount,
        tagData: _tagData,
        onConnect: _connectDevice,
        onDisconnect: _disconnectDevice,
        onCheckStatus: _checkConnectStatus,
        onStartScan: _startScan,
        onStopScan: _stopScan,
        onManualRead: _readTagDataManual,
        onClearTags: _clearTagData,
        onEpcSelectedForWrite: _selectEpcForWrite,
      ),
      ReadScreen(
        isConnected: _isConnected,
        tagData: _tagData,
        onManualRead: _readTagDataManual,
        onEpcSelectedForWrite: _selectEpcForWrite,
      ),
      WriteScreen(
        isConnected: _isConnected,
        passwordController: _passwordController,
        ptrController: _ptrController,
        dataController: _dataController,
        sourcePtrController: _sourcePtrController,
        sourceDataController: _sourceDataController,
        onWriteData: _writeDataTest,
      ),
      SettingsScreen(
        isConnected: _isConnected,
        powerValue: _powerValue,
        onPowerChanged: (val) {
          if (val != null) setState(() => _powerValue = val);
        },
        bandPosition: _bandPosition,
        onBandPositionChanged: (val) {
          if (val != null) setState(() => _bandPosition = val);
        },
        scanEpc: _scanEpc,
        onScanEpcChanged: (val) => setState(() => _scanEpc = val ?? true),
        scanTid: _scanTid,
        onScanTidChanged: (val) => setState(() => _scanTid = val ?? false),
        scanUser: _scanUser,
        onScanUserChanged: (val) => setState(() => _scanUser = val ?? false),
        userPtr: _userPtr,
        onUserPtrChanged: (val) => _userPtr = int.tryParse(val) ?? 0,
        userLen: _userLen,
        onUserLenChanged: (val) => _userLen = int.tryParse(val) ?? 6,
        onApplySettings: _applySettings,
        configFile: _configFile,
      ),
    ];

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('UHF RFID STS Demo'),
          backgroundColor: Colors.teal.shade800,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => initPlatformState(),
              tooltip: 'Get OS Version',
            )
          ],
        ),
        body: Column(
          children: [
            // 顶层状态卡片
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                color: Colors.grey.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OS: $_platformVersion | Key Count: $_keyDownCount',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.amber),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('Status: ',
                              style: TextStyle(fontSize: 12)),
                          Icon(
                            _isConnected ? Icons.check_circle : Icons.error,
                            color: _isConnected ? Colors.green : Colors.red,
                            size: 14,
                          ),
                          Text(
                            _isConnected ? ' Connected' : ' Disconnected',
                            style: TextStyle(
                              color: _isConnected ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          const Text('Scanning: ',
                              style: TextStyle(fontSize: 12)),
                          Icon(
                            _isScanning ? Icons.sensors : Icons.sensors_off,
                            color: _isScanning ? Colors.blue : Colors.grey,
                            size: 14,
                          ),
                          Text(
                            _isScanning ? ' ON' : ' OFF',
                            style: TextStyle(
                              color: _isScanning ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 中间切换区域
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: screens,
              ),
            ),
            // 底部日志区域
            LogPanel(
              logFilePath: _logFilePath,
              onClearLogs: _clearLogFile,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.tealAccent,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.grey.shade900,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.sensors),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: 'Read',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_document),
              label: 'Write',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
