package com.softtechsystems.rfid.flutter_rfid_uhf_sts;


import static rfid.uhfapi_y2007.core.Util.ConvertByteArrayToHexWordString;

// import rfid.uhfapi_y2007.ApiApplication;
import rfid.uhfapi_y2007.Rs232Port;
import rfid.uhfapi_y2007.entities.AntennaPowerStatus;
import rfid.uhfapi_y2007.entities.ConnectResponse;
import rfid.uhfapi_y2007.entities.FrequencyArea;
import rfid.uhfapi_y2007.entities.InventoryConfig;
import rfid.uhfapi_y2007.entities.RxdTagData;
import rfid.uhfapi_y2007.entities.MemoryBank;
import rfid.uhfapi_y2007.entities.TagParameter;
import rfid.uhfapi_y2007.entities.WriteTagParameter;
import rfid.uhfapi_y2007.protocol.vrp.Msg6CTagFieldConfig;
import rfid.uhfapi_y2007.protocol.vrp.MsgPowerConfig;
import rfid.uhfapi_y2007.protocol.vrp.MsgPowerOff;
import rfid.uhfapi_y2007.protocol.vrp.MsgReaderCapabilityQuery;
import rfid.uhfapi_y2007.protocol.vrp.MsgRfidStatusQuery;
import rfid.uhfapi_y2007.protocol.vrp.MsgTagInventory;
import rfid.uhfapi_y2007.protocol.vrp.MsgTagRead;
import rfid.uhfapi_y2007.protocol.vrp.MsgUhfBandConfig;
import rfid.uhfapi_y2007.protocol.vrp.Reader;
import rfid.uhfapi_y2007.protocol.vrp.MsgTagWrite;
import rfid.uhfapi_y2007.utils.Event;
import rfid.uhfapi_y2007.core.Util;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RFID_API {

    private static RFID_API instance;
    private Reader reader;
    public boolean isConnected = false;
    private String scanMode = "EPC"; // 默认扫描模式 另外一个是 “TID”
    private boolean isScan = false;
    private Event inventoryReceived = new Event(this, "reader_OnInventoryReceived");

    private List<TagMsgEntity> scannedTags = new ArrayList<>();

    private Map<String, Object> configJson = new HashMap();

    public static InventoryConfig inventoryConfig = new InventoryConfig();

    private RFID_API() {
        // 初始化SDK
        reader = new Reader("reader1", new Rs232Port("COM13,115200"));
    }

    public static synchronized RFID_API getInstance() {
        if (instance == null) {
            instance = new RFID_API();
        }
        return instance;
    }

    /**
     * 连接到RFID模块
     **/
    public boolean connect() {
        if (reader.getIsConnected()) {
            return true;
        }

        ConnectResponse response = reader.Connect();
        if (response.IsSucessed) {
            reader.OnInventoryReceived.addEvent(inventoryReceived);
            this.isConnected = true;
            return true;
        } else {
            return false;
        }
    }

    /**
     * 断开与RFID模块的连接
     */
    public void disconnect() {
        if (reader.getIsConnected()) {
            reader.OnInventoryReceived.removeEvent(inventoryReceived);
            reader.Disconnect();
            this.isConnected = false;
            this.isScan = false;
        }
    }

    /**
     * 设置扫描模式
     *
     * @param mode 扫描模式 EPC,TID
     */
    public void setScanMode(String mode) {
        this.scanMode = mode;
    }

    /**
     * 开始扫描
     */
    public void startScan() {
        if (!isConnected) {
            throw new IllegalStateException("Reader not connected!");
        }

        switch (scanMode) {
            case "EPC":
                // 调用Reader的EPC扫描方法
                reader.Send(new MsgTagInventory());
                this.isScan = true;
                break;
            case "TID":
                // 调用Reader的TID扫描方法
                reader.Send(new MsgTagRead());
                this.isScan = true;
                break;
            default:
                throw new UnsupportedOperationException("Unsupported scan mode: " + scanMode);
        }
    }

    /**
     * 停止扫描
     */
    public void stopScan() {
        // 通过Reader对象停止扫描
        this.isScan = false;
        if (isConnected)
            reader.Send(new MsgPowerOff());
    }

    private static Map<String, Object> convertTagMsgEntityToMap(TagMsgEntity tagMsgEntity) {
        Map<String, Object> map = new HashMap<>();
        map.put("sTagType", tagMsgEntity.getTagType());
        map.put("sRssi", tagMsgEntity.getRssi());
        map.put("sANT", tagMsgEntity.getAntenna());
        map.put("sEPC", tagMsgEntity.getEPC());
        map.put("sTID", tagMsgEntity.getTID());
        map.put("sUser", tagMsgEntity.getUser());
        return map;
    }

    private void reader_OnInventoryReceived(Reader sender, RxdTagData tagData) {
        if (tagData == null)
            return;

        String epc = ConvertByteArrayToHexWordString(tagData.getEPC());
        String tid = ConvertByteArrayToHexWordString(tagData.getTID());
        String user = ConvertByteArrayToHexWordString(tagData.getUser());
        String ant = (tagData.getAntenna() == 0) ? "" : "" + tagData.getAntenna();
        String rssi = (tagData.getRSSI() == 0) ? "" : "" + tagData.getRSSI();

        TagMsgEntity tag = new TagMsgEntity("6C", rssi, ant, epc, tid, user);
        scannedTags.add(tag);
    }

    /**
     * 获取扫描到的标签数据
     */
    public List<Map<String, Object>> getScannedTags() {

        Map<String, Object> map = new HashMap<>();
        List<Map<String, Object>> mapList = new ArrayList<>();
        for (TagMsgEntity tagMsgEntity : scannedTags) {
            Map<String, Object> e = convertTagMsgEntityToMap(tagMsgEntity);
            mapList.add(e);
        }
        return mapList;
    }

    public Map<String, Object> getConfigure() {
        inventoryConfigQuery();
        return configJson;
    }

    public void clearData() {
        scannedTags.clear();
    }

    public boolean isScan() {
        return this.isScan;
    }

    public boolean isEmptyTags() {
        return scannedTags != null && !scannedTags.isEmpty();
    }

    public void close() {
        this.isScan = false;
        this.isConnected = false;
        clearData();
    }

    public boolean isConnected() {
        return this.isConnected;
    }

    /**
     * 获取机器配置数据
     */
    private void inventoryConfigQuery() {

        int antCount = 0;
        int minPower = 0;
        int maxPower = 0;
        int regionValue = -1;
        String powerValue = "";//天线power值
        boolean antennaPowerStatus = false; //天线power状态
        boolean conAntStatus;
        boolean conIsScanTid;
        boolean conIsScanEpc;
        boolean conIsScanUser;
        int conUserPtr;
        int conScanCount;
        int conScanTime;
        int conUserLen;
        boolean antennaIsEnable;
        boolean rssiIsEnable;


        MsgReaderCapabilityQuery msg = new MsgReaderCapabilityQuery();
        if (reader.Send(msg)) {
            antCount = msg.getReceivedMessage().getAntennaCount();
            minPower = msg.getReceivedMessage().getMinPowerValue();
            maxPower = msg.getReceivedMessage().getMaxPowerValue();

            if (antCount > 0) {
                //powers 从最小到最大的power清单
                String[] powers = new String[maxPower - minPower + 1];
                for (int j = minPower; j <= maxPower; j++) {
                    powers[j - minPower] = j + "";
                }
                //configJson.put("powerValueList" , powers);

                //region 查天线状态
                MsgRfidStatusQuery msgState = new MsgRfidStatusQuery();
                if (reader.Send(msgState)) {
                    AntennaPowerStatus[] aps = msgState.getReceivedMessage().getAntennas();
                    for (AntennaPowerStatus a : aps) {
                        if (a.AntennaNO == 1) {
                            powerValue = a.PowerValue + "";
                            antennaPowerStatus = a.IsEnable;
                        }
                        break;
                    }
                }

                //endregion
                //region 查工作频段
                MsgUhfBandConfig msgBand = new MsgUhfBandConfig();
                if (reader.Send(msgBand)) {
                    regionValue = msgBand.getReceivedMessage().getUhfBand().getValue();
                }
                //endregion
            }
        }

        InventoryConfig config = inventoryConfig;
        if ((Integer.parseInt(config.Ants == null ? "1" : config.Ants) & 0x01) > 0) {
            conAntStatus = true;
        } else {
            conAntStatus = false;
        }
        conIsScanEpc = config.IsScanEpc;
        conIsScanTid = config.IsScanTid;
        conIsScanUser = config.IsScanUser;
        conUserPtr = config.UserPtr;
        conScanCount = config.ScanCount;
        conScanTime = config.ScanTime;
        conUserLen = config.UserLen;
        antennaIsEnable = reader.getIsEnableAntenna();
        rssiIsEnable = reader.getIsEnableRSSI();

        configJson.put("minPowerValue", minPower);
        configJson.put("maxPowerValue", maxPower);
        configJson.put("antennaCount", antCount);
        configJson.put("powerValue", powerValue);
        configJson.put("antennaPowerStatus", antennaPowerStatus);
        configJson.put("regionValue", regionValue);
        configJson.put("conAntStatus", conAntStatus);
        configJson.put("conIsScanEpc", conIsScanEpc);
        configJson.put("conIsScanTid", conIsScanTid);
        configJson.put("conIsScanUser", conIsScanUser);
        configJson.put("conUserPtr", conUserPtr);
        configJson.put("conScanCount", conScanCount);
        configJson.put("conScanTime", conScanTime);
        configJson.put("conUserLen", conUserLen);
        configJson.put("antennaIsEnable", antennaIsEnable);
        configJson.put("rssiIsEnable", rssiIsEnable);

    }

    public void saveConfig(Map<String, Object> params) {
        // 创建相应的消息对象
        Msg6CTagFieldConfig msg = new Msg6CTagFieldConfig();

        // 根据参数设置天线功率
        if (params.containsKey("selectedPower")) {
            String selectedPower = (String) params.get("selectedPower");
            MsgPowerConfig pMsg = new MsgPowerConfig(new byte[]{(byte) Integer.parseInt(selectedPower)});

            if (!reader.Send(pMsg)) {
                System.out.println("天线功率设置失败！" + pMsg.getErrorInfo().getErrMsg());
                return;
            }
        }

        // 根据参数设置工作频段
        if (params.containsKey("selectedBandPosition")) {
            int selectedBandPosition = (int) params.get("selectedBandPosition");
            MsgUhfBandConfig bMsg = new MsgUhfBandConfig(FrequencyArea.valueOf(selectedBandPosition));

            if (!reader.Send(bMsg)) {
                System.out.println("工作频段设置失败！" + bMsg.getErrorInfo().getErrMsg());
                return;
            }
        }

        InventoryConfig config = new InventoryConfig();
        boolean isScanEpc = params.containsKey("isScanEpc") ? (boolean) params.get("isScanEpc") : false;
        config.IsScanEpc = isScanEpc;

        if (params.containsKey("isScanUser")) {
            boolean isScanUser = (boolean) params.get("isScanUser");
            config.IsScanUser = isScanUser;
//            if (!reader.Send(msg)) {
//                System.out.println("isScanUser Set Failed！" + msg.getErrorInfo().getErrMsg());
//                return;
//            }
        }
        if (params.containsKey("userPtr")) {
            int userPtr = (int) params.get("userPtr");
            config.UserPtr = userPtr;
//            if (!reader.Send(msg)) {
//                System.out.println("userPtr Set Failed！" + msg.getErrorInfo().getErrMsg());
//                return;
//            }
        }
        if (params.containsKey("userLen")) {
            int userLen = (int) params.get("userLen");
            config.UserLen = (byte) userLen;
//            if (!reader.Send(msg)) {
//                System.out.println("userLen Set Failed！" + msg.getErrorInfo().getErrMsg());
//                return;
//            }
        }
        if (params.containsKey("scanCount")) {
            int scanCount = (int) params.get("scanCount");
            config.ScanCount = scanCount;
//            if (!reader.Send(msg)) {
//                System.out.println("scanCount Set Failed！" + msg.getErrorInfo().getErrMsg());
//                return;
//            }
        }
        if (params.containsKey("scanTime")) {
            int scanTime = (int) params.get("scanTime");
            config.ScanTime = scanTime;
//            if (!reader.Send(msg)) {
//                System.out.println("scanTime Set Failed！" + msg.getErrorInfo().getErrMsg());
//                return;
//            }
        }

        // 根据参数设置天线和RSSI
        if (params.containsKey("isShowAnts") || params.containsKey("isShowRssi")) {
            boolean isShowAnts = params.containsKey("isShowAnts") ? (boolean) params.get("isShowAnts") : inventoryConfig.IsShowAnts;
            boolean isShowRssi = params.containsKey("isShowRssi") ? (boolean) params.get("isShowRssi") : inventoryConfig.IsShowRssi;

            if (inventoryConfig.IsShowAnts != isShowAnts || inventoryConfig.IsShowRssi != isShowRssi) {
                if (!reader.Send(msg)) {
                    System.out.println("天线和RSSI设置失败！" + msg.getErrorInfo().getErrMsg());
                    return;
                }
            }
        }

        reader.Send(msg); // 更新configure file
        inventoryConfig = config;
        // 执行其他保存逻辑，如保存到数据库等

        System.out.println("配置完成");
    }

    /**
     * 写入数据，需要三个参数，params为目标数据，selectedParams为来源数据
     * params格式：
     * {
     *   “ptr”:0, //EPC起始地址不能小于2 起始地址应为10进制数据
     *   "data":"string" //EPC/或TID的数据 必须为16进制字符，长度为4的整数倍
     * }
     */
    public boolean writeData(String accessPassword, Map<String, Object> params,Map<String, Object> selectedParams) {

        int ptr = 2;
        String data = "";
        //获取目标参数数据
        if (params.containsKey("ptr")) {
            ptr = (int) params.get("ptr");
        }
        if (params.containsKey("data")) {
            data = (String) params.get("data");
        }
        //获取来源参数数据
        int source_ptr = 2;
        String source_data = "";
        //获取参数数据
        if (selectedParams.containsKey("ptr")) {
            source_ptr = (int) selectedParams.get("ptr");
        }
        if (selectedParams.containsKey("data")) {
            source_data = (String) selectedParams.get("data");
        }

        // 创建WriteTagParameter对象
        WriteTagParameter writeTagParameter = new WriteTagParameter();

        // 设置选择的标签参数
        TagParameter SourceParameter = new TagParameter();
        SourceParameter.MemoryBank = MemoryBank.EPCMemory;
        SourceParameter.Ptr = source_ptr;
        SourceParameter.TagData = Util.ConvertHexStringToByteArray(source_data);

        writeTagParameter.SelectTagParam = SourceParameter;

        //设置访问密码 注意： 需要检查accessPassword为 8位16进制的密码字符
        if(checkTagPwd(accessPassword)) {
            // Toast.makeText(this.context, "请输入8位16进制的密码字符", 0).show();
            writeTagParameter.AccessPassword = Util.ConvertHexStringToByteArray(accessPassword);

        }


        // 创建TagParameter对象并设置写入数据
        TagParameter tagParameter = new TagParameter();
        tagParameter.MemoryBank = MemoryBank.EPCMemory;

        tagParameter.Ptr = ptr;

        tagParameter.TagData = Util.ConvertHexStringToByteArray(data);
        writeTagParameter.WriteDataAry = new TagParameter[]{tagParameter};

        // 调用writeTag方法
        boolean success = writeTagData(writeTagParameter);

        // 处理写标签结果
        if (success) {
            System.out.println("写标签成功");
        } else {
            System.out.println("写标签失败");
        }

        return success;

    }

    private boolean writeTagData(WriteTagParameter writeTagParameter) {
        MsgTagWrite msg = new MsgTagWrite(writeTagParameter);
        if (reader.Send(msg)) {
            return true;
        } else {
            String errorMessage = msg.getErrorInfo().getErrMsg();
            // 处理写标签失败的逻辑
            // ...
            return false;
        }
    }

    private boolean checkTagPwd(String paramText) {
        String str = paramText;
        if (str.equals("") || str.length() != 8 || !Util.IsHexString(str)) {
            //Toast.makeText(this.context, "请输入8位16进制的密码字符", 0).show();
            return false;
        }
        // String accPwd = Util.ConvertHexStringToByteArray(str);
        return true;
    }
}
