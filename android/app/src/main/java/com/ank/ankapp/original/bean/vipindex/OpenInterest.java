package com.ank.ankapp.original.bean.vipindex;



import java.math.BigDecimal;
import java.util.Date;
import java.util.List;


/**
 *
 *
 * 合约定数据的一个汇总
 */

/*@Getter
@Setter
@FieldNameConstants

@Document("open_interest")*/
public class OpenInterest {

    public static final String BASE_COLLECTS = "open_interest";

    //@Id
    private String id;
    private String exchangeName;//交易所名字
    private String baseCoin;//币名
    private String symbol;//合约定代码
    private String exchangeType;//交易类型;(USDT:U本位 COIN:币本位)
    private String contractType;//合约定类型;(SWAP:永续,FUTURES:交割)
    private String deliveryType;//交割类型;(当周:"this_week", 次周:"next_week", 当季:"quarter",次季:"next_quarter", 永续:PERP)

    private long ts;//时间点
    private List<String> utcIntervals;//时间间隔
    private List<String> utc8Intervals;//时间间隔

    private Boolean atUtc;//UTC时间
    private Boolean atUtc8;//UTC8时间

    private Date createAt;
    private BigDecimal price;//币价格
    private BigDecimal volume = BigDecimal.ZERO;//持仓量张数
    private BigDecimal coinCount=BigDecimal.ZERO;//持仓总币数量
    private BigDecimal coinValue=BigDecimal.ZERO;//持仓总币价值

    private String type;//valid

    public OpenInterest() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public String getExchangeType() {
        return exchangeType;
    }

    public void setExchangeType(String exchangeType) {
        this.exchangeType = exchangeType;
    }

    public String getContractType() {
        return contractType;
    }

    public void setContractType(String contractType) {
        this.contractType = contractType;
    }

    public String getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(String deliveryType) {
        this.deliveryType = deliveryType;
    }

    public long getTs() {
        return ts;
    }

    public void setTs(long ts) {
        this.ts = ts;
    }

    public List<String> getUtcIntervals() {
        return utcIntervals;
    }

    public void setUtcIntervals(List<String> utcIntervals) {
        this.utcIntervals = utcIntervals;
    }

    public List<String> getUtc8Intervals() {
        return utc8Intervals;
    }

    public void setUtc8Intervals(List<String> utc8Intervals) {
        this.utc8Intervals = utc8Intervals;
    }

    public Boolean getAtUtc() {
        return atUtc;
    }

    public void setAtUtc(Boolean atUtc) {
        this.atUtc = atUtc;
    }

    public Boolean getAtUtc8() {
        return atUtc8;
    }

    public void setAtUtc8(Boolean atUtc8) {
        this.atUtc8 = atUtc8;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getVolume() {
        return volume;
    }

    public void setVolume(BigDecimal volume) {
        this.volume = volume;
    }

    public BigDecimal getCoinCount() {
        return coinCount;
    }

    public void setCoinCount(BigDecimal coinCount) {
        this.coinCount = coinCount;
    }

    public BigDecimal getCoinValue() {
        return coinValue;
    }

    public void setCoinValue(BigDecimal coinValue) {
        this.coinValue = coinValue;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
