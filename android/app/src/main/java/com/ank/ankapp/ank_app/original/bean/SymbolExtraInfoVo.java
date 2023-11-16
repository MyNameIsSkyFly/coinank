package com.ank.ankapp.ank_app.original.bean;

import android.text.TextUtils;

public class SymbolExtraInfoVo {
    private String lastPrice;
    private String turnover24h;
    private String priceChange24h;
    private String low24h;
    private String exchangeName;
    private String symbol;
    private String high24h;
    private String vol24h;
    private String volCcy24h;

    public String getVolCcy24h() {
        return volCcy24h;
    }

    public void setVolCcy24h(String volCcy24h) {
        this.volCcy24h = volCcy24h;
    }

    public String getLastPrice() {
        return lastPrice;
    }

    public void setLastPrice(String lastPrice) {
        this.lastPrice = lastPrice;
    }

    public String getTurnover24h() {
        return turnover24h;
    }

    public void setTurnover24h(String turnover24h) {
        this.turnover24h = turnover24h;
    }

    public String getPriceChange24h() {
        if (TextUtils.isEmpty(priceChange24h))
            priceChange24h = "0";

        return priceChange24h;
    }

    public void setPriceChange24h(String priceChange24h) {
        this.priceChange24h = priceChange24h;
    }

    public String getLow24h() {
        return low24h;
    }

    public void setLow24h(String low24h) {
        this.low24h = low24h;
    }

    public String getExchangeName() {
        return exchangeName;
    }

    public void setExchangeName(String exchangeName) {
        this.exchangeName = exchangeName;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getHigh24h() {
        return high24h;
    }

    public void setHigh24h(String high24h) {
        this.high24h = high24h;
    }

    public String getVol24h() {
        return vol24h;
    }

    public void setVol24h(String vol24h) {
        this.vol24h = vol24h;
    }
}
