package com.ank.ankapp.original.bean;

public class LongShortTakerBuySellVo {

    private float coinCount;
    private float coinValue;
    private String baseCoin;
    private String exchangeName;
    private String interval;
    private float sellTradeTurnover;
    private float buyTradeTurnover;
    private float longRatio;
    private float shortRatio;

    public float getCoinCount() {
        return coinCount;
    }

    public void setCoinCount(float coinCount) {
        this.coinCount = coinCount;
    }

    public float getCoinValue() {
        return coinValue;
    }

    public void setCoinValue(float coinValue) {
        this.coinValue = coinValue;
    }

    public String getBaseCoin() {
        return baseCoin;
    }

    public void setBaseCoin(String baseCoin) {
        this.baseCoin = baseCoin;
    }

    public String getExchangeName() {
        return exchangeName;
    }

    public void setExchangeName(String exchangeName) {
        this.exchangeName = exchangeName;
    }

    public String getInterval() {
        return interval;
    }

    public void setInterval(String interval) {
        this.interval = interval;
    }

    public float getSellTradeTurnover() {
        return sellTradeTurnover;
    }

    public void setSellTradeTurnover(float sellTradeTurnover) {
        this.sellTradeTurnover = sellTradeTurnover;
    }

    public float getBuyTradeTurnover() {
        return buyTradeTurnover;
    }

    public void setBuyTradeTurnover(float buyTradeTurnover) {
        this.buyTradeTurnover = buyTradeTurnover;
    }

    public float getLongRatio() {
        return longRatio;
    }

    public void setLongRatio(float longRatio) {
        this.longRatio = longRatio;
    }

    public float getShortRatio() {
        return shortRatio;
    }

    public void setShortRatio(float shortRatio) {
        this.shortRatio = shortRatio;
    }
}
