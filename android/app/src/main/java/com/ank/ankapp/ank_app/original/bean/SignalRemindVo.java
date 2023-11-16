package com.ank.ankapp.ank_app.original.bean;

public class SignalRemindVo {

    private String symbol;
    private String exchanName;
    private String interval;
    private float price;
    private String type;
    private long ts;

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getExchanName() {
        return exchanName;
    }

    public void setExchanName(String exchanName) {
        this.exchanName = exchanName;
    }

    public String getInterval() {
        return interval;
    }

    public void setInterval(String interval) {
        this.interval = interval;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public long getTs() {
        return ts;
    }

    public void setTs(long ts) {
        this.ts = ts;
    }
}