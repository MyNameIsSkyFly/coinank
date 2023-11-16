package com.ank.ankapp.ank_app.original.bean.vipindex;



import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;


public class OpenInterestKLine implements Serializable {

   // @Id
    private String id;

    private Long begin;//开始时间
    private Long end;//结束时间

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Long getBegin() {
        return begin;
    }

    public void setBegin(Long begin) {
        this.begin = begin;
    }

    public Long getEnd() {
        return end;
    }

    public void setEnd(Long end) {
        this.end = end;
    }

    public BigDecimal getOpen() {
        return open;
    }

    public void setOpen(BigDecimal open) {
        this.open = open;
    }

    public BigDecimal getClose() {
        return close;
    }

    public void setClose(BigDecimal close) {
        this.close = close;
    }

    public BigDecimal getLow() {
        return low;
    }

    public void setLow(BigDecimal low) {
        this.low = low;
    }

    public BigDecimal getHigh() {
        return high;
    }

    public void setHigh(BigDecimal high) {
        this.high = high;
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

    public String getInterval() {
        return interval;
    }

    public void setInterval(String interval) {
        this.interval = interval;
    }

    public OpenInterestKLine(String id) {
        this.id = id;
    }

    private BigDecimal open;//开盘价
    private BigDecimal close;//收盘价格

    private BigDecimal low;//最低价
    private BigDecimal high;//最高价格




    private String symbol;//交易对

    private String exchangeName;//交易所名字
    private String baseCoin;//币名

    private String interval;


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OpenInterestKLine openInterestKLine = (OpenInterestKLine) o;
        return Objects.equals(begin, openInterestKLine.begin);
    }



}
