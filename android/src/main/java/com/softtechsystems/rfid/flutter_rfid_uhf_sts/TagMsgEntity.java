package com.softtechsystems.rfid.flutter_rfid_uhf_sts;


public class TagMsgEntity {
    // 标签的详细信息
    public String sTagType;// 标签类型
    public String sRssi; // RSSI
    public String sCount;// 总读数
    private String sEPC;// EPC
    private String sTID;// TID
    private String sUser;// User
    private String sANT;// 天线

    public TagMsgEntity() {

    }

    public TagMsgEntity(String sTagType, String sRssi, String sANT, String sEPC, String sTID, String sUser) {
        this.sTagType = sTagType;
        this.sRssi = sRssi;
        this.sANT = sANT;
        this.sEPC = sEPC;
        this.sTID = sTID;
        this.sUser = sUser;
    }

    public String getTagType() {
        return sTagType;
    }

    public void setTagType(String sTagType) {
        this.sTagType = sTagType;
    }

    public String getRssi() {
        return sRssi;
    }

    public void setRssi(String sRssi) {
        this.sRssi = sRssi;
    }

    public String getAntenna() {
        return sANT;
    }

    public void setAntenna(String sANT) {
        this.sANT = sANT;
    }

    public String getEPC() {
        return sEPC;
    }

    public void setEPC(String sEPC) {
        this.sEPC = sEPC;
    }

    public String getTID() {
        return sTID;
    }

    public void setTID(String sTID) {
        this.sTID = sTID;
    }

    public String getUser() {
        return sUser;
    }

    public void setUser(String sUser) {
        this.sUser = sUser;
    }
}
