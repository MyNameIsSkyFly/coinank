package com.ank.ankapp.original.bean;

public class MarkerTickerVo {

    public String baseCoin;
    public String coinImage;
    public float price;
    public float priceChangeH24;
    public float priceChangeM5;
    public float priceChangeM15;
    public float priceChangeM30;
    public float priceChangeH1;
    public float priceChangeH2;
    public float priceChangeH4;
    public float priceChangeH6;
    public float priceChangeH8;
    public float priceChangeH12;

    public float openInterest;

    public float openInterestCh1;
    public float openInterestCh4;
    public float openInterestCh24;
    public String symbol;
    public String exchangeName;
    public boolean follow;

    public boolean isFollow() {
        return follow;
    }

    public void setFollow(boolean follow) {
        this.follow = follow;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getExchangeName() {
        return exchangeName;
    }

    public void setExchangeName(String exchangeName) {
        this.exchangeName = exchangeName;
    }

    public String getBaseCoin() {
        return baseCoin;
    }

    public void setBaseCoin(String baseCoin) {
        this.baseCoin = baseCoin;
    }

    public String getCoinImage() {
        return coinImage;
    }

    public void setCoinImage(String coinImage) {
        this.coinImage = coinImage;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public float getPriceChangeH24() {
        return priceChangeH24;
    }

    public void setPriceChangeH24(float priceChangeH24) {
        this.priceChangeH24 = priceChangeH24;
    }

    public float getOpenInterest() {
        return openInterest;
    }

    public void setOpenInterest(float openInterest) {
        this.openInterest = openInterest;
    }

    public float getOpenInterestCh1() {
        return openInterestCh1;
    }

    public void setOpenInterestCh1(float openInterestCh1) {
        this.openInterestCh1 = openInterestCh1;
    }

    public float getOpenInterestCh4() {
        return openInterestCh4;
    }

    public void setOpenInterestCh4(float openInterestCh4) {
        this.openInterestCh4 = openInterestCh4;
    }

    public float getOpenInterestCh24() {
        return openInterestCh24;
    }

    public void setOpenInterestCh24(float openInterestCh24) {
        this.openInterestCh24 = openInterestCh24;
    }
}