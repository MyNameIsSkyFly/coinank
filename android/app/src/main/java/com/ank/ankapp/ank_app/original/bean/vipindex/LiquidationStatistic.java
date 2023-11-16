package com.ank.ankapp.ank_app.original.bean.vipindex;


import java.math.BigDecimal;
import java.util.Map;

/**
 * 爆仓数据统计
 */
/*@Getter
@Setter
@FieldNameConstants

@Document("liquidation_statistic")*/
public class LiquidationStatistic {

    //@MongoId(FieldType.OBJECT_ID)
    private String id;
    private String baseCoin;//币

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getBaseCoin() {
        return baseCoin;
    }

    public void setBaseCoin(String baseCoin) {
        this.baseCoin = baseCoin;
    }

    public Map<String, Detail> getDetails() {
        return details;
    }

    public void setDetails(Map<String, Detail> details) {
        this.details = details;
    }

    public Detail getAll() {
        return all;
    }

    public void setAll(Detail all) {
        this.all = all;
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

    public LiquidationStatistic() {
    }

    private Map<String,Detail> details;//每一个交易所多空爆仓金额
    private Detail all;//所有的交易所多空爆仓金额
    private long ts;//时间
    private String interval;//时间间隔


//    @Getter
//    @Setter
    public static class Detail {
        private BigDecimal longTurnover;//多爆仓金额
        private BigDecimal shortTurnover;//平爆仓金额
        private BigDecimal totalTurnover;//总

    public Detail() {
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

    public BigDecimal getTotalTurnover() {
        return totalTurnover;
    }

    public void setTotalTurnover(BigDecimal totalTurnover) {
        this.totalTurnover = totalTurnover;
    }
}

    public static final String BASE_COLLECTS = "liquidation_statistic";

    //最近几个小时的统计
    public static final String BASE_COLLECTS_NEAREST = "nearest_liquidation_statistic";



}
