package com.ank.ankapp.ank_app.original.bean;

public class LiquidationVo {

    private String baseCoin;
    private String exchangeName;
    private float totalTurnover;
    private float longTurnover;
    private float shortTurnover;

    private float percentage;
    private float longRatio;
    private float shortRatio;
    private String interval;

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

    public float getTotalTurnover() {
        return totalTurnover;
    }

    public void setTotalTurnover(float totalTurnover) {
        this.totalTurnover = totalTurnover;
    }

    public float getLongTurnover() {
        return longTurnover;
    }

    public void setLongTurnover(float longTurnover) {
        this.longTurnover = longTurnover;
    }

    public float getShortTurnover() {
        return shortTurnover;
    }

    public void setShortTurnover(float shortTurnover) {
        this.shortTurnover = shortTurnover;
    }

    public float getPercentage() {
        return percentage;
    }

    public void setPercentage(float percentage) {
        this.percentage = percentage;
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

    public String getInterval() {
        return interval;
    }

    public void setInterval(String interval) {
        this.interval = interval;
    }
}
