package com.ank.ankapp.ank_app.original.bean.vipindex;
import java.math.BigDecimal;

/**
 * 爆仓数据统计
 */
/*@Getter
@Setter
@FieldNameConstants

@Document("liquidation_symbol")*/
public class LiquidationSymbol {

    private String symbol;//交易对

    public LiquidationSymbol() {
    }

    private String baseCoin;//币

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

    public long getTs() {
        return ts;
    }

    public void setTs(long ts) {
        this.ts = ts;
    }

    public String getInterval() {
        return interval;
    }

    public void setInterval(String interval) {
        this.interval = interval;
    }

    public BigDecimal getLongTurnover() {
        return longTurnover;
    }

    public void setLongTurnover(BigDecimal longTurnover) {
        this.longTurnover = longTurnover;
    }

    public BigDecimal getShortTurnover() {
        return shortTurnover;
    }

    public void setShortTurnover(BigDecimal shortTurnover) {
        this.shortTurnover = shortTurnover;
    }

    private String  exchangeName;//交易所
    private long ts;//时间
    private String interval;//时间间隔
    private BigDecimal longTurnover = BigDecimal.ZERO;//多爆仓金额
    private BigDecimal shortTurnover = BigDecimal.ZERO;//平爆仓金额




    public static final String BASE_COLLECTS = "liquidation_symbol";





}
