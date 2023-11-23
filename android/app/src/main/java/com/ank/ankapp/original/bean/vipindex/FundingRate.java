package com.ank.ankapp.original.bean.vipindex;


import java.math.BigDecimal;

/*@Getter
@Setter
@FieldNameConstants

@Document("funding_rate")*/
public class FundingRate {

    public String baseCoin;
    public String exchangeName;
    public String exchangeType;//USDT or COIN
    public String symbol;
    public BigDecimal fundingRate;//实时资金费率
    public BigDecimal estimatedRate;//预测下期资金费率
    public long fundingTime;//资金费率
    public long nextFundingTime;
    public long ts;

    public BigDecimal openFundingRate;//oi fr
    public BigDecimal turnoverFundingRate;//vol fr

    public BigDecimal getOpenFundingRate() {
        return openFundingRate;
    }

    public void setOpenFundingRate(BigDecimal openFundingRate) {
        this.openFundingRate = openFundingRate;
    }

    public BigDecimal getTurnoverFundingRate() {
        return turnoverFundingRate;
    }

    public void setTurnoverFundingRate(BigDecimal turnoverFundingRate) {
        this.turnoverFundingRate = turnoverFundingRate;
    }




    public FundingRate() {
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

    public String getExchangeType() {
        return exchangeType;
    }

    public void setExchangeType(String exchangeType) {
        this.exchangeType = exchangeType;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public BigDecimal getFundingRate() {
        return fundingRate;
    }

    public void setFundingRate(BigDecimal fundingRate) {
        this.fundingRate = fundingRate;
    }

    public BigDecimal getEstimatedRate() {
        return estimatedRate;
    }

    public void setEstimatedRate(BigDecimal estimatedRate) {
        this.estimatedRate = estimatedRate;
    }

    public long getFundingTime() {
        return fundingTime;
    }

    public void setFundingTime(long fundingTime) {
        this.fundingTime = fundingTime;
    }

    public long getNextFundingTime() {
        return nextFundingTime;
    }

    public void setNextFundingTime(long nextFundingTime) {
        this.nextFundingTime = nextFundingTime;
    }

    public long getTs() {
        return ts;
    }

    public void setTs(long ts) {
        this.ts = ts;
    }

}
