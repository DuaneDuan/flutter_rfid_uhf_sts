package com.softtechsystems.rfid.flutter_rfid_uhf_sts;

import androidx.annotation.NonNull;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.widget.Toast;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterRfidUhfStsPlugin */
public class FlutterRfidUhfStsPlugin implements FlutterPlugin, MethodCallHandler, RFID_API.TagReceiverListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private BroadcastReceiver keyReceiver;
  // 确保所有 invokeMethod 在主线程执行，避免后台线程（如轮询 Timer）导致崩溃
  private final android.os.Handler mainHandler = new android.os.Handler(android.os.Looper.getMainLooper());

  private static final String CHANNEL_IsScaning = "isScaning";
  private static final String CHANNEL_StartScan = "startScaning";
  private static final String CHANNEL_StopScan = "stopScaning";
  private static final String CHANNEL_ClearData = "clearData";
  private static final String CHANNEL_IsEmptyTags = "isEmptyTags";
  private static final String CHANNEL_Close = "close";
  private static final String CHANNEL_Connect = "connect";
  private static final String CHANNEL_DisConnect = "disConnect";
  private static final String CHANNEL_IsConnected = "isConnected";
  private static final String CHANNEL_SetPower = "setPower";
  private static final String CHANNEL_ScanMode = "setScanMode";
  private static final String CHANNEL_ConnectedStatus = "ConnectedStatus";
  private static final String CHANNEL_TagsStatus = "TagsStatus";
  private static final String CHANNEL_WriteData = "writeData";
  private static final String CHANNEL_ReadData = "readData";
  private static final String CHANNEL_EraseData = "eraseData";
  private static final String CHANNEL_SetBandPosition = "SetBandPosition";
  private static final String CHANNEL_SetScanEpc = "SetScanEpc";
  private static final String CHANNEL_SetScanTid = "SetScanTid";
  private static final String CHANNEL_SetScanUser = "SetScanUser";
  private static final String CHANNEL_SetUserPtr = "SetUserPtr";
  private static final String CHANNEL_SetUserLen = "SetUserLen";
  private static final String CHANNEL_SetScanCount = "SetScanCount";
  private static final String CHANNEL_SetScanTime = "SetScanTime";
  private static final String CHANNEL_SetShowAnts = "SetShowAnts";
  private static final String CHANNEL_SetShowRssi = "SetShowRssi";
  private static final String CHANNEL_GetConfigure = "getConfigure";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "CH_flutter_rfid_uhf_sts");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
    RFID_API.getInstance(this.context).addTagReceiverListener(this);
    registerReceiver();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    handleMethods(call, result);
  }

  private void handleMethods(MethodCall call, Result result) {
    String power, mode;
    int userPtr, userLen, band, scanCount, scanTime;
    boolean isScanUser, isShowAnts, isShowRssi, isScanTid, isScanEpc;
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      case CHANNEL_IsScaning:
        result.success(RFID_API.getInstance(this.context).isScan());
        break;
      case CHANNEL_StartScan:
        RFID_API.getInstance(this.context).startScan();
        result.success(RFID_API.getInstance(this.context).isScan());
        break;
      case CHANNEL_StopScan:
        RFID_API.getInstance(this.context).stopScan();
        result.success(RFID_API.getInstance(this.context).isScan());
        break;
      case CHANNEL_ClearData:
        RFID_API.getInstance(this.context).clearData();
        result.success(true);
        break;
      case CHANNEL_IsEmptyTags:
        result.success(RFID_API.getInstance(this.context).isEmptyTags());
        break;
      case CHANNEL_Close:
        RFID_API.getInstance(this.context).close();
        result.success(true);
        break;
      case CHANNEL_Connect:
        result.success(RFID_API.getInstance(this.context).connect(context));
        break;
      case CHANNEL_DisConnect:
        RFID_API.getInstance(this.context).disconnect();
        result.success(true);
        break;
      case CHANNEL_IsConnected:
        result.success(RFID_API.getInstance(this.context).isConnected());
        break;

      case CHANNEL_ScanMode:
        mode = call.argument("mode");  // 默认扫描模式“EPC” 另外一个是 “TID”
        RFID_API.getInstance(this.context).setScanMode(mode);
        result.success(true);
        break;
      case CHANNEL_SetPower://天线功率设置 传入数字
        power = call.argument("power");
        Map<String, Object> powerParams = new HashMap<>();
        powerParams.put("selectedPower", power);
        RFID_API.getInstance(this.context).saveConfig(powerParams);
        result.success(true);
        break;
      case CHANNEL_SetBandPosition: //工作频段三种: CN(0),FCC(1),EU(2)，传入数字
        band = call.argument("band");
        Map<String, Object> bandParams = new HashMap<>();
        bandParams.put("selectedBandPosition", band);
        RFID_API.getInstance(this.context).saveConfig(bandParams);
        result.success(true);
        break;
      case CHANNEL_SetScanEpc:
        isScanEpc = call.argument("isScanEpc");
        Map<String, Object> IsScanEpcParams = new HashMap<>();
        IsScanEpcParams.put("isScanEpc", isScanEpc);
        RFID_API.getInstance(this.context).saveConfig(IsScanEpcParams);
        result.success(true);
        break;
      case CHANNEL_SetScanTid:
        isScanTid = call.argument("isScanTid");
        Map<String, Object> isScanTidParams = new HashMap<>();
        isScanTidParams.put("isScanTid", isScanTid);
        RFID_API.getInstance(this.context).saveConfig(isScanTidParams);
        result.success(true);
        break;
      case CHANNEL_SetScanUser:
        isScanUser = call.argument("isScanUser");
        Map<String, Object> isScanUserParams = new HashMap<>();
        isScanUserParams.put("isScanUser", isScanUser);
        RFID_API.getInstance(this.context).saveConfig(isScanUserParams);
        result.success(true);
        break;
      case CHANNEL_SetUserPtr:
        userPtr = call.argument("userPtr");
        Map<String, Object> userPtrParams = new HashMap<>();
        userPtrParams.put("userPtr", userPtr);
        RFID_API.getInstance(this.context).saveConfig(userPtrParams);
        result.success(true);
        break;
      case CHANNEL_SetUserLen:
        userLen = call.argument("userLen");
        Map<String, Object> userLenParams = new HashMap<>();
        userLenParams.put("userLen", userLen);
        RFID_API.getInstance(this.context).saveConfig(userLenParams);
        result.success(true);
        break;
      case CHANNEL_SetScanCount:
        scanCount = call.argument("scanCount");
        Map<String, Object> scanCountParams = new HashMap<>();
        scanCountParams.put("scanCount", scanCount);
        RFID_API.getInstance(this.context).saveConfig(scanCountParams);
        result.success(true);
        break;
      case CHANNEL_SetScanTime:
        scanTime = call.argument("scanTime");
        Map<String, Object> scanTimeParams = new HashMap<>();
        scanTimeParams.put("scanTime", scanTime);
        RFID_API.getInstance(this.context).saveConfig(scanTimeParams);
        result.success(true);
        break;
      case CHANNEL_SetShowAnts:
        isShowAnts = call.argument("isShowAnts");
        Map<String, Object> isShowAntsParams = new HashMap<>();
        isShowAntsParams.put("isShowAnts", isShowAnts);
        RFID_API.getInstance(this.context).saveConfig(isShowAntsParams);
        result.success(true);
        break;
      case CHANNEL_SetShowRssi:
        isShowRssi = call.argument("isShowRssi");
        Map<String, Object> isShowRssiParams = new HashMap<>();
        isShowRssiParams.put("isShowRssi", isShowRssi);
        RFID_API.getInstance(this.context).saveConfig(isShowRssiParams);
        result.success(true);
        break;
      case CHANNEL_WriteData:
        String psw = call.argument("tagPassword");
        int ptr = call.argument("ptr");
        String data = call.argument("data");
        Map<String, Object> params = new HashMap<>();
        params.put("ptr", ptr);
        params.put("data", data);

        int sourcePtr = call.argument("sourcePtr");
        String sourceData = call.argument("sourceData");
        Map<String, Object> sourceParams = new HashMap<>();
        sourceParams.put("ptr", sourcePtr);
        sourceParams.put("data", sourceData);
        result.success(RFID_API.getInstance(this.context).writeData(psw,params,sourceParams));
        break;
      case CHANNEL_ReadData:
        result.success(RFID_API.getInstance(this.context).getScannedTags());
        break;
      case CHANNEL_GetConfigure:
        result.success(RFID_API.getInstance(this.context).getConfigure());
        break;
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    RFID_API.getInstance(this.context).removeTagReceiverListener(this);
    unregisterReceiver();
  }

  @Override
  public void onTagReceived(final Map<String, Object> tagMap) {
    if (channel == null) return;
    mainHandler.post(() -> {
      if (tagMap.containsKey("tagData")) {
        // 轮询定时器推送的完整标签列表，使用专用的 tagListUpdate 方法
        channel.invokeMethod("tagListUpdate", tagMap);
      } else {
        // SDK 回调的单条标签
        channel.invokeMethod("sendData", tagMap);
      }
    });
  }

  private void registerReceiver() {
    keyReceiver = new KeyReceiver();
    IntentFilter filter1 = new IntentFilter();
    filter1.addAction("android.rfid.FUN_KEY");
    filter1.addAction("android.intent.action.FUN_KEY");
    context.registerReceiver(keyReceiver, filter1);
  }

  private void unregisterReceiver() {
    if (keyReceiver != null) {
      context.unregisterReceiver(keyReceiver);
      keyReceiver = null;
    }
  }

  private class KeyReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
      int keyCode = intent.getIntExtra("keyCode", 0);
      if (keyCode == 0) {
        keyCode = intent.getIntExtra("keycode", 0);
      }
      if (keyCode != 134)
        return;
      if (!intent.getBooleanExtra("keydown", true))
        return;

      // 参考原版 App 逻辑：直接 toggle 扫描状态，不依赖 Dart 层的奇偶计数
      RFID_API api = RFID_API.getInstance(context);
      if (!api.isConnected()) {
        // 未连接时先尝试连接
        boolean connected = api.connect(context);
        if (!connected) {
          // 连接失败，仅发 keyDown 通知
          if (channel != null) channel.invokeMethod("keyDown", null);
          return;
        }
      }

      boolean currentlyScanning = api.isScan();
      if (!currentlyScanning) {
        // 当前未在扫描 → 开始扫描
        try {
          api.startScan();
        } catch (Exception e) {
          if (channel != null) channel.invokeMethod("keyDown", null);
          return;
        }
        if (channel != null) {
          channel.invokeMethod("scanStateChanged", true);
          channel.invokeMethod("keyDown", null);
        }
      } else {
        // 当前在扫描 → 停止扫描
        api.stopScan();
        if (channel != null) {
          channel.invokeMethod("scanStateChanged", false);
          channel.invokeMethod("keyDown", null);
        }
      }
    }
  }

}
