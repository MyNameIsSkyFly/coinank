package com.ank.ankapp.ank_app.original.bean.vipindex;

import com.ank.ankapp.ank_app.original.bean.KLineItem;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.data.CandleEntry;
import com.github.mikephil.charting.data.Entry;

import java.util.ArrayList;
import java.util.List;

public class KlineIndc {

    public KlineIndc() {
    }

    public List<KLineItem> klines = new ArrayList<>();

    public ArrayList<KLineItem> coinOIListK = new ArrayList<>();
    public List<CandleEntry> coinCandleOIListK = new ArrayList<>();

    public ArrayList<KLineItem> oiListK = new ArrayList<>();
    public List<CandleEntry> candleOIListK = new ArrayList<>();

    public ArrayList<KLineItem> lsAccountsRatioK = new ArrayList<>();
    public List<CandleEntry> candleLsAccountsRatioK = new ArrayList<>();

    public ArrayList<KLineItem> lsTopAccountsRatioK = new ArrayList<>();
    public List<CandleEntry> candleTopAccountsRatioK = new ArrayList<>();

    public ArrayList<KLineItem> lsTopPositionsRatioK = new ArrayList<>();
    public List<CandleEntry> candleTopPostionsRatioK = new ArrayList<>();

    public ArrayList<Float> oiDelta = new ArrayList<>();
    public List<BarEntry> barOIDelta = new ArrayList<>();

    public List<Float> oiWeightFrData = new ArrayList<>();
    public List<BarEntry> barOIWeightFrData = new ArrayList<>();

    public List<Float> volumeWeightFrData = new ArrayList<>();
    public List<BarEntry> barVolumeWeightFrData = new ArrayList<>();

    public ArrayList<KLineItem> frListK = new ArrayList<>();
    public List<CandleEntry> candleFrListK = new ArrayList<>();

    public List<Float> oiList = new ArrayList<>();
    public List<BarEntry> barOIList = new ArrayList<>();
    public List<Entry> lineOIList = new ArrayList<>();

    public List<Float> fundingRateList = new ArrayList<>();
    public List<BarEntry> barFRlist = new ArrayList<>();
    public List<Entry> lineFrList = new ArrayList<>();

    public List<Float> liqCoinLongList = new ArrayList<>();
    public List<BarEntry> barLongCoinLiqList = new ArrayList<>();
    public List<Entry> lineLongCoinLiqList = new ArrayList<>();

    public List<Float> liqCoinShortList = new ArrayList<>();
    public List<BarEntry> barShortCoinLiqList = new ArrayList<>();
    public List<Entry> lineShortCoinLiqList = new ArrayList<>();

    public List<Float> liqSymbolLongList = new ArrayList<>();
    public List<BarEntry> barLongSymbolLiqList = new ArrayList<>();
    public List<Entry> lineLongSymbolLiqList = new ArrayList<>();

    public List<Float> liqSymbolShortList = new ArrayList<>();
    public List<BarEntry> barShortSymbolLiqList = new ArrayList<>();
    public List<Entry> lineShortSymbolLiqList = new ArrayList<>();

    public List<Long>  timeList = new ArrayList<>();

    public List<Float> getOiList() {
        return oiList;
    }

    public void setOiList(List<Float> oiList) {
        this.oiList = oiList;
    }

    public List<Float> getFundingRateList() {
        return fundingRateList;
    }

    public void setFundingRateList(List<Float> fundingRateList) {
        this.fundingRateList = fundingRateList;
    }

    public List<Float> getLiqCoinLongList() {
        return liqCoinLongList;
    }

    public void setLiqCoinLongList(List<Float> liqCoinLongList) {
        this.liqCoinLongList = liqCoinLongList;
    }

    public List<Float> getLiqCoinShortList() {
        return liqCoinShortList;
    }

    public void setLiqCoinShortList(List<Float> liqCoinShortList) {
        this.liqCoinShortList = liqCoinShortList;
    }

    public List<Float> getLiqSymbolLongList() {
        return liqSymbolLongList;
    }

    public void setLiqSymbolLongList(List<Float> liqSymbolLongList) {
        this.liqSymbolLongList = liqSymbolLongList;
    }

    public List<Float> getLiqSymbolShortList() {
        return liqSymbolShortList;
    }

    public void setLiqSymbolShortList(List<Float> liqSymbolShortList) {
        this.liqSymbolShortList = liqSymbolShortList;
    }

    public List<Long> getTimeList() {
        return timeList;
    }

    public void setTimeList(List<Long> timeList) {
        this.timeList = timeList;
    }

    public KlineIndc(List<Float> oiList, List<Float> fundingRateList, List<Float> liqCoinLongList, List<Float> liqCoinShortList, List<Float> liqSymbolLongList, List<Float> liqSymbolShortList, List<Long> timeList) {
        this.oiList = oiList;
        this.fundingRateList = fundingRateList;
        this.liqCoinLongList = liqCoinLongList;
        this.liqCoinShortList = liqCoinShortList;
        this.liqSymbolLongList = liqSymbolLongList;
        this.liqSymbolShortList = liqSymbolShortList;
        this.timeList = timeList;
    }


}
