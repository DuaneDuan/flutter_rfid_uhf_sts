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
public class FlutterRfidUhfStsPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private BroadcastReceiver keyReceiver;

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
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "demo1");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
    registerReceiver();
//        registerSendTags();
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
        result.success(RFID_API.getInstance().isScan());
        break;
      case CHANNEL_StartScan:
        RFID_API.getInstance().startScan();
        result.success(RFID_API.getInstance().isScan());
        break;
      case CHANNEL_StopScan:
        RFID_API.getInstance().stopScan();
        result.success(RFID_API.getInstance().isScan());
        break;
      case CHANNEL_ClearData:
        RFID_API.getInstance().clearData();
        result.success(true);
        break;
      case CHANNEL_IsEmptyTags:
        result.success(RFID_API.getInstance().isEmptyTags());
        break;
      case CHANNEL_Close:
        RFID_API.getInstance().close();
        result.success(true);
        break;
      case CHANNEL_Connect:
        result.success(RFID_API.getInstance().connect(context));
        break;
      case CHANNEL_DisConnect:
        RFID_API.getInstance().disconnect();
        result.success(true);
        break;
      case CHANNEL_IsConnected:
        result.success(RFID_API.getInstance().isConnected());
        break;

//
//      case CHANNEL_ScanMode:
//        mode = call.argument("mode");  // 默认扫描模式“EPC” 另外一个是 “TID”
//        result.success(RFID_API.getInstance().setScanMode(mode));
//        break;
//      case CHANNEL_SetPower://天线功率设置 传入数字
//        power = call.argument("power");
//        Map<String, Object> powerParams = new HashMap<>();
//        powerParams.put("selectedPower", power);
//        result.success(RFID_API.getInstance().saveConfig(powerParams));
//        break;
//      case CHANNEL_SetBandPosition: //工作频段三种: CN(0),FCC(1),EU(2)，传入数字
//        band = call.argument("band");
//        Map<String, Object> bandParams = new HashMap<>();
//        bandParams.put("selectedBandPosition", band);
//        result.success(RFID_API.getInstance().saveConfig(bandParams));
//        break;
//      case CHANNEL_SetScanEpc:
//        isScanEpc = call.argument("isScanEpc");//传入数字
//        Map<String, Object> IsScanEpcParams = new HashMap<>();
//        IsScanEpcParams.put("isScanEpc", isScanEpc);
//        result.success(RFID_API.getInstance().saveConfig(IsScanEpcParams));
//        break;
//      case CHANNEL_SetScanTid:
//        isScanTid = call.argument("isScanTid");
//        Map<String, Object> isScanTidParams = new HashMap<>();
//        isScanTidParams.put("isScanTid", isScanTid);
//        result.success(RFID_API.getInstance().saveConfig(isScanTidParams));
//        break;
//      case CHANNEL_SetScanUser:
//        isScanUser = call.argument("isScanUser");
//        Map<String, Object> isScanUserParams = new HashMap<>();
//        isScanUserParams.put("isScanUser", isScanUser);
//        result.success(RFID_API.getInstance().saveConfig(isScanUserParams));
//        break;
//      case CHANNEL_SetUserPtr:
//        userPtr = call.argument("userPtr");
//        Map<String, Object> userPtrParams = new HashMap<>();
//        userPtrParams.put("userPtr", userPtr);
//        result.success(RFID_API.getInstance().saveConfig(userPtrParams));
//        break;
//      case CHANNEL_SetUserLen:
//        userLen = call.argument("userLen");
//        Map<String, Object> userLenParams = new HashMap<>();
//        userLenParams.put("userLen", userLen);
//        result.success(RFID_API.getInstance().saveConfig(userLenParams));
//        break;
//      case CHANNEL_SetScanCount:
//        scanCount = call.argument("scanCount");
//        Map<String, Object> scanCountParams = new HashMap<>();
//        scanCountParams.put("userLen", scanCount);
//        result.success(RFID_API.getInstance().saveConfig(scanCountParams));
//        break;
//      case CHANNEL_SetScanTime:
//        scanTime = call.argument("scanTime");
//        Map<String, Object> scanTimeParams = new HashMap<>();
//        scanTimeParams.put("scanTime", scanTime);
//        result.success(RFID_API.getInstance().saveConfig(scanTimeParams));
//        break;
//      case CHANNEL_SetShowAnts:
//        isShowAnts = call.argument("isShowAnts");
//        Map<String, Object> isShowAntsParams = new HashMap<>();
//        isShowAntsParams.put("isShowAnts", isShowAnts);
//        result.success(RFID_API.getInstance().saveConfig(isShowAntsParams));
//        break;
//      case CHANNEL_SetShowRssi:
//        isShowRssi = call.argument("isShowRssi");
//        Map<String, Object> isShowRssiParams = new HashMap<>();
//        isShowRssiParams.put("isShowRssi", isShowRssi);
//        result.success(RFID_API.getInstance().saveConfig(isShowRssiParams));
//        break;
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
        result.success(RFID_API.getInstance().writeData(psw,params,sourceParams));
        break;
      case CHANNEL_ReadData:
        result.success(RFID_API.getInstance().getScannedTags());
        break;
      case CHANNEL_GetConfigure:
        result.success(RFID_API.getInstance().getConfigure());
        break;
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    unregisterReceiver();
  }

  private void registerReceiver() {
    keyReceiver = new KeyReceiver();
    IntentFilter filter1 = new IntentFilter();
    filter1.addAction("android.rfid.FUN_KEY");
    filter1.addAction("android.intent.action.FUN_KEY");
    filter1.addAction("com.sts.app.action.TAG");
    context.registerReceiver(keyReceiver, filter1);
  }

//    private void registerSendTags(){
//       tagReceiver = new tagReceiver();
//        IntentFilter filter2 = new IntentFilter();
//        filter2.addAction("com.sts.app.action.TAG");
//       context.registerReceiver(tagReceiver, filter2);
//
//    }

  private void unregisterReceiver() {
    if (keyReceiver != null) {
      context.unregisterReceiver(keyReceiver);
//            context.unregisterReceiver(tagReceiver);
      keyReceiver = null;
    }
  }

  private class KeyReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
      String action = intent.getAction();
//      System.out.println(action);
      if ("com.sts.app.action.TAG".equals(action)) {
//        发送一个消息给Flutter，这样Flutter去取数据
//        System.out.println("数dd据收到");
        channel.invokeMethod("sendData", null);
        return;
      }

      int keyCode = intent.getIntExtra("keyCode", 0);
      if (keyCode != 134 )
        return;
      if (intent.getBooleanExtra("keydown", true)) {

        // 发送一个KEY DOWN消息给Flutter
        // System.out.println("keyDown");
        channel.invokeMethod("keyDown", null);
      }
    }
  }
//
//    private class tagReceiver extends BroadcastReceiver {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            // 获取传入的 Intent 对象
//            String action = intent.getAction();
//            System.out.println("中午1");
//            System.out.println(action);
//            // 根据动作进行过滤
//            if ("com.sts.app.action.TAG".equals(action)) {
//                 Toast.makeText(context, "数据收到", Toast.LENGTH_LONG).show();
//                 channel.invokeMethod("sendData", null);
//            }
//        }
//    }

}
