package com.ank.ankapp.ank_app.original.bean;

public class BaseCoinFuturesInfoVo {

    //    "baseCoin": "BTC",
//            "symbol": "BTCUSDT",
//            "exchangeName": "Binance",
//            "contractType": "FUTURES",
//            "lastPrice": 20372.30,
//            "open24h": 20096.00,
//            "high24h": 20531.00,
//            "low24h": 20087.30,
//            "priceChange24h": 1.375,
//            "volCcy24h": 405797.236,
//            "vol24h": null,
//            "turnover24h": 8256736757.65,
//            "tradeTimes": 2825103,
//            "oiUSD": 1960546956.09,
//            "oiCcy": 96209.942,
//            "oiVol": 96209.942,
//            "fundingRate": -0.00003954,
//            "expireAt": 4133404800000
    public String baseCoin;
    public String symbol;
    public String exchangeName;
    public String contractType;
    public float fundingRate;
    public float lastPrice;
    public float turnover24h;
    public float oiUSD;

    public String getColVal(int col)
    {

        switch (col)
        {
            case 0:
                return exchangeName;
            case 1:
                return String.valueOf(lastPrice);
            case 2:
                return String.valueOf(turnover24h);
            case 3:
                return String.valueOf(oiUSD);
            case 4:
                return String.format("%04f", fundingRate*100) + "%";
        }

        return "";
    }

}