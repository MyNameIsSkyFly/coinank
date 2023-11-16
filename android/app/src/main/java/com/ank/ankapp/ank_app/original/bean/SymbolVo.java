package com.ank.ankapp.ank_app.original.bean;

import java.util.Objects;

public class SymbolVo {


    //交易对名
    private String symbol;
    //基础货币
    private String baseCoin;
    //交易所字对
    private String exchangeName;
    //产品类型 //永续/或交割
    private String productType;
    //
    private String symbolType;
    //月,周,下周
    private String deliveryType;//交割类型

    private long expireAt;//过期时间

    private long updateAt;

    private boolean bSel;//用于listview adapter是否选中

    private String lastPrice;//上一次价格

    private String quoteAsset;//symbol结算币种

    public String getPricePrecision() {
        return pricePrecision;
    }

    public void setPricePrecision(String pricePrecision) {
        this.pricePrecision = pricePrecision;
    }

    private String pricePrecision;

    public String getQuoteAsset() {
        return quoteAsset;
    }

    public void setQuoteAsset(String quoteAsset) {
        this.quoteAsset = quoteAsset;
    }

    public String getLastPrice() {
        return lastPrice;
    }

    public void setLastPrice(String lastPrice) {
        this.lastPrice = lastPrice;
    }

    public String getKey() {
        return  symbol + exchangeName;
    }

    @Override
    public boolean equals(Object o) {
        if (symbol == null || exchangeName == null) return false;
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SymbolVo symbolVo = (SymbolVo) o;
        if (symbolVo.symbol == null || symbolVo.exchangeName == null) return false;
        return symbol.equals(symbolVo.symbol) && exchangeName.equals(symbolVo.exchangeName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(symbol, exchangeName);
    }

    public String getSubscribeArgs() {
        return  String.format("kline@%s@%s@30m", symbol, exchangeName);
    }

    @Override
    public String toString() {
        return "{" +
                "symbol='" + symbol + '\'' +
                ", baseCoin='" + baseCoin + '\'' +
                ", exchangeName='" + exchangeName + '\'' +
                ", productType='" + productType + '\'' +
                ", symbolType='" + symbolType + '\'' +
                ", deliveryType='" + deliveryType + '\'' +
                ", expireAt=" + expireAt +
                ", updateAt=" + updateAt +
                '}';
    }

    public boolean isbSel() {
        return bSel;
    }

    public void setbSel(boolean bSel) {
        this.bSel = bSel;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
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

    public String getProductType() {
        return productType;
    }

    public void setProductType(String productType) {
        this.productType = productType;
    }

    public String getSymbolType() {
        return symbolType;
    }

    public void setSymbolType(String symbolType) {
        this.symbolType = symbolType;
    }

    public String getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(String deliveryType) {
        this.deliveryType = deliveryType;
    }

    public long getExpireAt() {
        return expireAt;
    }

    public void setExpireAt(long expireAt) {
        this.expireAt = expireAt;
    }

    public long getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(long updateAt) {
        this.updateAt = updateAt;
    }
}
