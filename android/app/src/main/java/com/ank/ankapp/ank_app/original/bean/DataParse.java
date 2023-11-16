package com.ank.ankapp.ank_app.original.bean;

import com.ank.ankapp.ank_app.original.bean.vipindex.KlineIndc;
import com.ank.ankapp.ank_app.original.bean.vipindex.LongShortRatioVo;
import com.ank.ankapp.ank_app.original.chart.IndexRenderParam;
import com.ank.ankapp.ank_app.original.utils.AppUtils;
import com.ank.ankapp.ank_app.original.utils.MLog;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.data.CandleEntry;
import com.github.mikephil.charting.data.Entry;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class DataParse {
    public IndexParamVo indexParamVo = new IndexParamVo();

    private ArrayList<MinutesBean> datas = new ArrayList<>();
    public ArrayList<KLineItem> kLineList = new ArrayList<>();
    private ArrayList<BarEntry> volBarEntries = new ArrayList<>();//成交量数据
    private ArrayList<CandleEntry> candleEntries = new ArrayList<>();//K线数据

    private ArrayList<Entry> ma01DataL = new ArrayList<>();
    private ArrayList<Entry> ma02DataL = new ArrayList<>();
    private ArrayList<Entry> ma03DataL = new ArrayList<>();
    private ArrayList<Entry> ma04DataL = new ArrayList<>();
    private ArrayList<Entry> ma05DataL = new ArrayList<>();

    public ArrayList<Entry> getMa05DataL() {
        return ma05DataL;
    }

    public void setMa05DataL(ArrayList<Entry> ma05DataL) {
        this.ma05DataL = ma05DataL;
    }

    private ArrayList<Entry> ma5DataV = new ArrayList<>();
    private ArrayList<Entry> ma10DataV = new ArrayList<>();
    private ArrayList<Entry> ma20DataV = new ArrayList<>();
    private ArrayList<Entry> ma30DataV = new ArrayList<>();

    private List<BarEntry> macdData = new ArrayList<>();
    private List<Entry> deaData = new ArrayList<>();
    private List<Entry> difData = new ArrayList<>();

    private List<BarEntry> barDatasKDJ = new ArrayList<>();
    private List<Entry> kData = new ArrayList<>();
    private List<Entry> dData = new ArrayList<>();
    private List<Entry> jData = new ArrayList<>();

    private List<BarEntry> barDatasWR = new ArrayList<>();
    private List<Entry> wrData13 = new ArrayList<>();
    private List<Entry> wrData34 = new ArrayList<>();
    private List<Entry> wrData89 = new ArrayList<>();

    private List<BarEntry> barDatasRSI = new ArrayList<>();
    private List<Entry> rsiData6 = new ArrayList<>();
    private List<Entry> rsiData12 = new ArrayList<>();
    private List<Entry> rsiData24 = new ArrayList<>();

    private List<BarEntry> barDatasBOLL = new ArrayList<>();
    private List<Entry> bollDataUP = new ArrayList<>();
    private List<Entry> bollDataMB = new ArrayList<>();
    private List<Entry> bollDataDN = new ArrayList<>();

    //EMA
    private List<BarEntry> barDatasEXPMA = new ArrayList<>();
    private List<Entry> expmaData1 = new ArrayList<>();
    private List<Entry> expmaData2 = new ArrayList<>();
    private List<Entry> expmaData3 = new ArrayList<>();
    private List<Entry> expmaData4 = new ArrayList<>();
    private List<Entry> expmaData5 = new ArrayList<>();

    public List<Entry> getExpmaData5() {
        return expmaData5;
    }

    public void setExpmaData5(List<Entry> expmaData5) {
        this.expmaData5 = expmaData5;
    }


    private List<BarEntry> barDatasDMI = new ArrayList<>();
    private List<Entry> dmiDataDI1 = new ArrayList<>();
    private List<Entry> dmiDataDI2 = new ArrayList<>();
    private List<Entry> dmiDataADX = new ArrayList<>();
    private List<Entry> dmiDataADXR = new ArrayList<>();


    public LongShortRatioVo longShortPersonVo = new LongShortRatioVo();
    private List<BarEntry> barLsPersonList = new ArrayList<>();
    private List<Entry> lineLsPersonList = new ArrayList<>();

    public LongShortRatioVo longShortAccountVo = new LongShortRatioVo();
    private List<BarEntry> barLsAccountList = new ArrayList<>();
    private List<Entry> lineLsAccountList = new ArrayList<>();

    public LongShortRatioVo longShortPositionVo = new LongShortRatioVo();
    private List<BarEntry> barLsPositionList = new ArrayList<>();
    private List<Entry> lineLsPositionList = new ArrayList<>();

    public KlineIndc vipIndexObj = new KlineIndc();

    private float baseValue;
    private float permaxmin;
    private float volmax;

    public boolean success;
    public int code;
    public String msg;

    public int pricePrecision = 0;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public void parseMinutes(JSONObject object) {

    }

    //清除K线数据和vip指标数据
    public void clearData()
    {
        kLineList.clear();
        longShortPersonVo.getTss().clear();
        longShortPersonVo.getLongShortRatio().clear();

        longShortAccountVo.getTss().clear();
        longShortAccountVo.getLongShortRatio().clear();

        longShortPositionVo.getTss().clear();
        longShortPositionVo.getLongShortRatio().clear();

        vipIndexObj.oiList.clear();
        vipIndexObj.fundingRateList.clear();

        vipIndexObj.oiDelta.clear();
        vipIndexObj.barOIDelta.clear();

        vipIndexObj.oiWeightFrData.clear();
        vipIndexObj.volumeWeightFrData.clear();

        vipIndexObj.barOIWeightFrData.clear();
        vipIndexObj.barVolumeWeightFrData.clear();

        vipIndexObj.liqCoinLongList.clear();
        vipIndexObj.liqCoinShortList.clear();
        vipIndexObj.liqSymbolLongList.clear();
        vipIndexObj.liqSymbolShortList.clear();

        vipIndexObj.oiListK.clear();
        vipIndexObj.frListK.clear();
        vipIndexObj.coinOIListK.clear();

        vipIndexObj.lsAccountsRatioK.clear();
        vipIndexObj.lsTopAccountsRatioK.clear();
        vipIndexObj.lsTopPositionsRatioK.clear();
    }



    /**
     * 将jsonobject转换为K线数据
     *
     * @param obj
     */
    public ArrayList<KLineItem> parseKLine(JSONObject obj, boolean isLoadMore) {
        ArrayList<KLineItem> tempList = new ArrayList<>();
        boolean b = false;
        if (obj != null)
        {
            b = obj.optBoolean("success", false);
        }

        if(b)
        {
            JSONArray jarr = obj.optJSONArray("data");
            if(jarr != null)
            {
                int count = jarr.length();
                for(int i = 0; i < count; i++)
                {
                    JSONArray jitem = jarr.optJSONArray(i);
                    KLineItem kLineItem = new KLineItem();
                    kLineItem.timestamp = jitem.optString(0);
                    kLineItem.date = AppUtils.timeStamp2Date(kLineItem.timestamp);
                    kLineItem.endTime = jitem.optLong(1);
                    kLineItem.open = (float) jitem.optDouble(2);
                    kLineItem.close = (float) jitem.optDouble(3);
                    kLineItem.high = (float) jitem.optDouble(4);
                    kLineItem.low = (float) jitem.optDouble(5);
                    //kLineItem.vol = (float) jitem.optDouble(7);
                    kLineItem.vol = (float) jitem.optDouble(6, 0);
                    //MLog.d("close: vol: txn" + kLineItem.close + " " + kLineItem.vol + " "
                     //               + (float) jitem.optDouble(7)
                      //      );
                    tempList.add(kLineItem);

                    volmax = Math.max(kLineItem.vol, volmax);
                }//end for
            }//end if
        }//end if

        if(isLoadMore){
            this.kLineList.addAll(0, tempList);//插入左边
        }
        else{
            this.kLineList.clear();//清除，重新加载
            this.kLineList.addAll(tempList);
        }


        MLog.d("parseKLine kline size is:" + kLineList.size());

        return tempList;
    }

    //得到成交量
    public void initKLineAndVolDatas(ArrayList<KLineItem> datas) {
        if (null == datas) {
            return;
        }

        volBarEntries.clear();
        candleEntries.clear();

        volBarEntries = new ArrayList<>();//成交量数据
        candleEntries = new ArrayList<>();//K线数据
        for (int i = 0; i < datas.size(); i++) {
            volBarEntries.add(new BarEntry(i, datas.get(i).vol, datas.get(i).close >= datas.get(i).open ? 0 : 1));
            candleEntries.add(new CandleEntry(i, datas.get(i).high, datas.get(i).low,
                    datas.get(i).open, datas.get(i).close, datas.get(i).date));
        }
    }

    /**
     * 初始化K线图均线
     *
     * @param datas
     */
    public void initMA(ArrayList<KLineItem> datas) {
       if (null == datas) {
             return;
       }

        ma01DataL.clear();
        ma02DataL.clear();
        ma03DataL.clear();
        ma04DataL.clear();
        ma05DataL.clear();
        KMAEntity kmaEntity01 = new KMAEntity(datas, indexParamVo.getMA1());
        KMAEntity kmaEntity02 = new KMAEntity(datas, indexParamVo.getMA2());
        KMAEntity kmaEntity03 = new KMAEntity(datas, indexParamVo.getMA3());
        KMAEntity kmaEntity04 = new KMAEntity(datas, indexParamVo.getMA4());
        KMAEntity kmaEntity05 = new KMAEntity(datas, indexParamVo.getMA5());
        MLog.d("ma size:" + kmaEntity01.getMAs().size() + " " +
                kmaEntity02.getMAs().size() + " " + kmaEntity03.getMAs().size());
        for (int i = 0; i < datas.size(); i++) {
            if(indexParamVo.isMa1Toggle() && i>=indexParamVo.getMA1() && i < kmaEntity01.getMAs().size())
                ma01DataL.add(new Entry(i, kmaEntity01.getMAs().get(i), 0));
            if(indexParamVo.isMa2Toggle() &&  i>=indexParamVo.getMA2() && i < kmaEntity02.getMAs().size())
                ma02DataL.add(new Entry(i, kmaEntity02.getMAs().get(i), 0));
            if(indexParamVo.isMa3Toggle() && i>=indexParamVo.getMA3() && i < kmaEntity03.getMAs().size())
                ma03DataL.add(new Entry(i, kmaEntity03.getMAs().get(i), 0));
            if(indexParamVo.isMa4Toggle() && i>=indexParamVo.getMA4() && i < kmaEntity04.getMAs().size())
                ma04DataL.add(new Entry(i, kmaEntity04.getMAs().get(i), 0));
            if(indexParamVo.isMa5Toggle() && i>=indexParamVo.getMA5() && i < kmaEntity05.getMAs().size())
                ma05DataL.add(new Entry(i, kmaEntity05.getMAs().get(i), 0));
        }

    }

    /**
     * 初始化成交量均线
     *
     * @param datas
     */
    public void initVolMa(ArrayList<KLineItem> datas) {
        if (null == datas) {
            return;
        }

        ma5DataV.clear();
        ma10DataV.clear();
        ma20DataV.clear();
        ma30DataV.clear();

        VMAEntity vmaEntity5 = new VMAEntity(datas, 5);
        VMAEntity vmaEntity10 = new VMAEntity(datas, 10);
        VMAEntity vmaEntity20 = new VMAEntity(datas, 20);
        VMAEntity vmaEntity30 = new VMAEntity(datas, 30);
        for (int i = 0; i < vmaEntity5.getMAs().size(); i++) {
            if (i >= 5) ma5DataV.add(new Entry(i, vmaEntity5.getMAs().get(i), datas.get(i).date));
            if (i >= 10) ma10DataV.add(new Entry(i, vmaEntity10.getMAs().get(i), datas.get(i).date));
            ma20DataV.add(new Entry(i, vmaEntity20.getMAs().get(i), datas.get(i).date));
            ma30DataV.add(new Entry(i, vmaEntity30.getMAs().get(i), datas.get(i).date));
        }

    }

    public void initOIDelta(ArrayList<Float> datas) {
        vipIndexObj.barOIDelta.clear();
        vipIndexObj.barOIDelta = new ArrayList<>();
        for (int i = 0; i < datas.size(); i++) {
            float val = datas.get(i);
            //预先需要设置2个颜色进去，initSubChartDataSet函数里面设置
            //最后参数传Null,颜色会取K线红绿颜色，具体见offsetBarRenderer类的drawDataSet函数设置画笔部分
            //macd同理
            vipIndexObj.barOIDelta.add(new BarEntry(i, val, null));
        }
    }

    /**
     * 初始化MACD
     *
     * @param datas
     */
    public void initMACD(ArrayList<KLineItem> datas) {
        MACDEntity macdEntity = new MACDEntity(datas, indexParamVo.getMacd_short(), indexParamVo.getMacd_long(),
                indexParamVo.getMacd_ma());

        macdData.clear();
        deaData.clear();
        difData.clear();
        macdData = new ArrayList<>();
        deaData = new ArrayList<>();
        difData = new ArrayList<>();

        IndexRenderParam param = new IndexRenderParam();
        param.data = null;
        param.indexType = ChartNode.ChartType.MACD;

        for (int i = 0; i < macdEntity.getMACD().size(); i++) {
            macdData.add(new BarEntry(i, macdEntity.getMACD().get(i), param));
            deaData.add(new Entry(i, macdEntity.getDEA().get(i), datas.get(i).date));
            difData.add(new Entry(i, macdEntity.getDIF().get(i), datas.get(i).date));
        }
    }

    public void initOIKline(ArrayList<KLineItem> datas) {
        if (null == datas) {
            return;
        }

        vipIndexObj.candleOIListK.clear();
        vipIndexObj.candleOIListK = new ArrayList<>();//K线数据
        for (int i = 0; i < datas.size(); i++) {
            vipIndexObj.candleOIListK.add(new CandleEntry(i, datas.get(i).high, datas.get(i).low,
                    datas.get(i).open, datas.get(i).close,0));
        }
    }


    public void initLSAccountsRatioK(ArrayList<KLineItem> datas) {
        if (null == datas) {
            return;
        }

        vipIndexObj.candleLsAccountsRatioK.clear();
        vipIndexObj.candleLsAccountsRatioK = new ArrayList<>();
        for (int i = 0; i < datas.size(); i++) {
            vipIndexObj.candleLsAccountsRatioK.add(new CandleEntry(i, datas.get(i).high, datas.get(i).low,
                    datas.get(i).open, datas.get(i).close,0));
        }
    }

    public void initTopTraderAccountsRatioK(ArrayList<KLineItem> datas) {
        if (null == datas) {
            return;
        }

        vipIndexObj.candleTopAccountsRatioK.clear();
        vipIndexObj.candleTopAccountsRatioK = new ArrayList<>();
        for (int i = 0; i < datas.size(); i++) {
            vipIndexObj.candleTopAccountsRatioK.add(new CandleEntry(i, datas.get(i).high, datas.get(i).low,
                    datas.get(i).open, datas.get(i).close,0));
        }
    }

    public void initTopTraderPositionsRatioK(ArrayList<KLineItem> datas) {
        if (null == datas) {
            return;
        }

        vipIndexObj.candleTopPostionsRatioK.clear();
        vipIndexObj.candleTopPostionsRatioK = new ArrayList<>();
        for (int i = 0; i < datas.size(); i++) {
            vipIndexObj.candleTopPostionsRatioK.add(new CandleEntry(i, datas.get(i).high, datas.get(i).low,
                    datas.get(i).open, datas.get(i).close,0));
        }
    }

    public void initCoinOIKline(ArrayList<KLineItem> datas) {
        if (null == datas) {
            return;
        }

        vipIndexObj.coinCandleOIListK.clear();
        vipIndexObj.coinCandleOIListK = new ArrayList<>();
        for (int i = 0; i < datas.size(); i++) {
            vipIndexObj.coinCandleOIListK.add(new CandleEntry(i, datas.get(i).high, datas.get(i).low,
                    datas.get(i).open, datas.get(i).close,0));
        }
    }

    public void initFrKline(ArrayList<KLineItem> datas) {
        if (null == datas) {
            return;
        }

        vipIndexObj.candleFrListK.clear();
        vipIndexObj.candleFrListK = new ArrayList<>();
        for (int i = 0; i < datas.size(); i++) {
            vipIndexObj.candleFrListK.add(new CandleEntry(i, datas.get(i).high, datas.get(i).low,
                    datas.get(i).open, datas.get(i).close,0));
        }
    }

    public void initSymbolLiq(KlineIndc datas) {
        if (datas == null)
            return;

        vipIndexObj.barLongSymbolLiqList.clear();
        vipIndexObj.barShortSymbolLiqList.clear();
        vipIndexObj.barLongSymbolLiqList = new ArrayList<>();
        vipIndexObj.barShortSymbolLiqList = new ArrayList<>();
        for (int i = 0; i < datas.liqSymbolLongList.size(); i++) {
            vipIndexObj.barLongSymbolLiqList.add(new BarEntry(i, datas.liqSymbolLongList.get(i), 0));
            vipIndexObj.barShortSymbolLiqList.add(new BarEntry(i, -datas.liqSymbolShortList.get(i), 0));
            //vipIndexObj.lineOIList.add(new Entry(i, datas.getOiList().get(i), 0));
        }
    }

    public void initCoinLiq(KlineIndc datas) {
        if (datas == null)
            return;

        vipIndexObj.barLongCoinLiqList.clear();
        vipIndexObj.barShortCoinLiqList.clear();
        vipIndexObj.barLongCoinLiqList = new ArrayList<>();
        vipIndexObj.barShortCoinLiqList = new ArrayList<>();
        for (int i = 0; i < datas.liqCoinLongList.size(); i++) {
            vipIndexObj.barLongCoinLiqList.add(new BarEntry(i, datas.liqCoinLongList.get(i), 0));
            vipIndexObj.barShortCoinLiqList.add(new BarEntry(i, -datas.liqCoinShortList.get(i), 0));
            //vipIndexObj.lineOIList.add(new Entry(i, datas.getOiList().get(i), 0));
        }
    }

    public void initOIVipIndex(KlineIndc datas) {
        if (datas == null)
            return;

        vipIndexObj.barOIList.clear();
        vipIndexObj.lineOIList.clear();
        vipIndexObj.barOIList = new ArrayList<>();
        vipIndexObj.lineOIList = new ArrayList<>();
        for (int i = 0; i < datas.getOiList().size(); i++) {
            vipIndexObj.lineOIList.add(new Entry(i, datas.getOiList().get(i), 0));
        }
    }

    public void initOIFundingRateVipIndex(KlineIndc datas) {
        if (datas == null)
            return;

        vipIndexObj.barOIWeightFrData.clear();
        for (int i = 0; i < datas.oiWeightFrData.size(); i++) {
            vipIndexObj.barOIWeightFrData.add(new BarEntry(i, datas.oiWeightFrData.get(i), null));
        }
    }

    public void initVolumeFundingRateVipIndex(KlineIndc datas) {
        if (datas == null)
            return;

        vipIndexObj.barVolumeWeightFrData.clear();
        for (int i = 0; i < datas.volumeWeightFrData.size(); i++) {
            vipIndexObj.barVolumeWeightFrData.add(new BarEntry(i, datas.volumeWeightFrData.get(i), null));
        }
    }

    public void initFundingRateVipIndex(KlineIndc datas) {
        if (datas == null)
            return;

        vipIndexObj.barFRlist.clear();
        for (int i = 0; i < datas.fundingRateList.size(); i++) {
            vipIndexObj.barFRlist.add(new BarEntry(i, datas.fundingRateList.get(i), null));
        }
    }

    public void initLongShortPositionRatio(LongShortRatioVo datas) {
        if (datas == null)
            return;

        barLsPositionList.clear();
        lineLsPositionList.clear();
        barLsPositionList = new ArrayList<>();
        lineLsPositionList = new ArrayList<>();
        for (int i = 0; i < datas.getLongShortRatio().size(); i++) {
           // barDataLongShortPositionRatio.add(new BarEntry(i, Float.NaN, AppUtils.timeStamp2Date(datas.getTss().get(i))));
            lineLsPositionList.add(new Entry(i, datas.getLongShortRatio().get(i), 0));
        }
    }

    public void initLongShortAccountRatio(LongShortRatioVo datas) {
        if (datas == null)
            return;

        barLsAccountList.clear();
        lineLsAccountList.clear();
        barLsAccountList = new ArrayList<>();
        lineLsAccountList = new ArrayList<>();
        for (int i = 0; i < datas.getLongShortRatio().size(); i++) {
            //barDataLongShortAccountRatio.add(new BarEntry(i, Float.NaN, AppUtils.timeStamp2Date(datas.getTss().get(i))));
            lineLsAccountList.add(new Entry(i, datas.getLongShortRatio().get(i), 0));
        }
    }

    public void initLongShortPersonRatio(LongShortRatioVo datas) {
        if (datas == null)
            return;

        barLsPersonList.clear();
        lineLsPersonList.clear();
        barLsPersonList = new ArrayList<>();
        lineLsPersonList = new ArrayList<>();
        for (int i = 0; i < datas.getLongShortRatio().size(); i++) {
            //barDataLongShortPersonRatio.add(new BarEntry(i, Float.NaN, AppUtils.timeStamp2Date(datas.getTss().get(i))));
            lineLsPersonList.add(new Entry(i, datas.getLongShortRatio().get(i), 0));
        }
    }

    /**
     * 初始化KDJ
     *
     * @param datas
     */
    public void initKDJ(ArrayList<KLineItem> datas) {
        KDJEntity kdjEntity = new KDJEntity(datas, indexParamVo.getK(),
                indexParamVo.getD(), indexParamVo.getJ());
        barDatasKDJ.clear();
        kData.clear();
        dData.clear();
        jData.clear();
        barDatasKDJ = new ArrayList<>();
        kData = new ArrayList<>();
        dData = new ArrayList<>();
        jData = new ArrayList<>();
        for (int i = 0; i < kdjEntity.getD().size(); i++) {
            //barDatasKDJ.add(new BarEntry(i, 0, datas.get(i).date));
            kData.add(new Entry(i, kdjEntity.getK().get(i), datas.get(i).date));
            dData.add(new Entry(i, kdjEntity.getD().get(i), datas.get(i).date));
            jData.add(new Entry(i, kdjEntity.getJ().get(i), datas.get(i).date));
        }
    }

    /**
     * 初始化RSI
     *
     * @param datas
     */
    public void initRSI(ArrayList<KLineItem> datas) {
        RSIEntity rsiEntity = new RSIEntity(datas, indexParamVo.getRSI1(),
                indexParamVo.getRSI2(), indexParamVo.getRSI3());

        barDatasRSI.clear();
        rsiData6.clear();
        rsiData12.clear();
        rsiData24.clear();
        barDatasRSI = new ArrayList<>();
        rsiData6 = new ArrayList<>();
        rsiData12 = new ArrayList<>();
        rsiData24 = new ArrayList<>();
        for (int i = 0; i < rsiEntity.getRSIs1().size(); i++) {
            //barDatasRSI.add(new BarEntry(i, 0, datas.get(i).date));
            rsiData6.add(new Entry(i, rsiEntity.getRSIs1().get(i), datas.get(i).date));
            rsiData12.add(new Entry(i, rsiEntity.getRSIs2().get(i), datas.get(i).date));
            rsiData24.add(new Entry(i, rsiEntity.getRSIs3().get(i), datas.get(i).date));
        }
    }


    /**
     * 初始化WR
     *
     * @param datas
     */
    public void initWR(ArrayList<KLineItem> datas) {
        WREntity wrEntity13 = new WREntity(datas, 13);
        WREntity wrEntity34 = new WREntity(datas, 34);
        WREntity wrEntity89 = new WREntity(datas, 89);

        barDatasWR = new ArrayList<>();
        wrData13 = new ArrayList<>();
        wrData34 = new ArrayList<>();
        wrData89 = new ArrayList<>();
        for (int i = 0; i < wrEntity13.getWRs().size(); i++) {
            barDatasWR.add(new BarEntry(0, i));
            wrData13.add(new Entry(i, wrEntity13.getWRs().get(i), datas.get(i).date));
            wrData34.add(new Entry(i, wrEntity34.getWRs().get(i), datas.get(i).date));
            wrData89.add(new Entry(i, wrEntity89.getWRs().get(i), datas.get(i).date));
        }
    }

    /**
     * 初始化BOLL
     *
     * @param datas
     */
    public void initBOLL(ArrayList<KLineItem> datas) {
        BOLLEntity bollEntity = new BOLLEntity(datas, indexParamVo.getBoll_md(), indexParamVo.getBoll_up());

        barDatasBOLL.clear();
        bollDataUP.clear();
        bollDataMB.clear();
        bollDataDN.clear();

        barDatasBOLL = new ArrayList<>();
        bollDataUP = new ArrayList<>();
        bollDataMB = new ArrayList<>();
        bollDataDN = new ArrayList<>();
        for (int i = 0; i < bollEntity.getUPs().size(); i++) {
            if ( i >= indexParamVo.getBoll_md())
            {
                barDatasBOLL.add(new BarEntry(0, i));
                bollDataUP.add(new Entry(i, bollEntity.getUPs().get(i), datas.get(i).date));
                bollDataMB.add(new Entry(i, bollEntity.getMBs().get(i), datas.get(i).date));
                bollDataDN.add(new Entry(i, bollEntity.getDNs().get(i), datas.get(i).date));
            }
        }
    }

    /**
     * 初始化BOLL
     *
     * @param datas
     */
    public void initEXPMA(ArrayList<KLineItem> datas) {
        if (datas == null) return;

        EXPMAEntity expmaEntity1 = new EXPMAEntity(datas, indexParamVo.getEMA1());
        EXPMAEntity expmaEntity2 = new EXPMAEntity(datas, indexParamVo.getEMA2());
        EXPMAEntity expmaEntity3 = new EXPMAEntity(datas, indexParamVo.getEMA3());
        EXPMAEntity expmaEntity4 = new EXPMAEntity(datas, indexParamVo.getEMA4());
        EXPMAEntity expmaEntity5 = new EXPMAEntity(datas, indexParamVo.getEMA5());

        expmaData1.clear();
        expmaData2.clear();
        expmaData3.clear();
        expmaData4.clear();
        expmaData5.clear();
        expmaData1 = new ArrayList<>();
        expmaData2 = new ArrayList<>();
        expmaData3 = new ArrayList<>();
        expmaData4 = new ArrayList<>();
        expmaData5 = new ArrayList<>();
        for (int i = 0; i < datas.size(); i++) {
            expmaData1.add(new Entry(i, expmaEntity1.getEXPMAs().get(i), 0));
            expmaData2.add(new Entry(i, expmaEntity2.getEXPMAs().get(i), 0));
            expmaData3.add(new Entry(i, expmaEntity3.getEXPMAs().get(i), 0));
            expmaData4.add(new Entry(i, expmaEntity4.getEXPMAs().get(i), 0));
            expmaData5.add(new Entry(i, expmaEntity5.getEXPMAs().get(i), 0));
        }
    }

    /**
     * 初始化DMI
     *
     * @param datas
     */
    public void initDMI(ArrayList<KLineItem> datas) {
        DMIEntity dmiEntity = new DMIEntity(datas, 12, 7, 6, true);

        barDatasDMI = new ArrayList<>();
        dmiDataDI1 = new ArrayList<>();
        dmiDataDI2 = new ArrayList<>();
        dmiDataADX = new ArrayList<>();
        dmiDataADXR = new ArrayList<>();
        for (int i = 0; i < dmiEntity.getDI1s().size(); i++) {
            barDatasDMI.add(new BarEntry(0, i));
            dmiDataDI1.add(new Entry(i, dmiEntity.getDI1s().get(i), datas.get(i).date));
            dmiDataDI2.add(new Entry(i, dmiEntity.getDI2s().get(i), datas.get(i).date));
            dmiDataADX.add(new Entry(i, dmiEntity.getADXs().get(i), datas.get(i).date));
            dmiDataADXR.add(new Entry(i, dmiEntity.getADXRs().get(i), datas.get(i).date));
        }
    }

    /**
     * 得到Y轴最小值
     *
     * @return
     */
    public float getMin() {
        return baseValue - permaxmin;
    }

    /**
     * 得到Y轴最大值
     *
     * @return
     */
    public float getMax() {
        return baseValue + permaxmin;
    }

    /**
     * 得到百分百最大值
     *
     * @return
     */
    public float getPercentMax() {
        return permaxmin / baseValue;
    }

    /**
     * 得到百分比最小值
     *
     * @return
     */
    public float getPercentMin() {
        return -getPercentMax();
    }

    /**
     * 得到成交量最大值
     *
     * @return
     */
    public float getVolmax() {
        return volmax;
    }


    /**
     * 得到分时图数据
     *
     * @return
     */
    public ArrayList<MinutesBean> getDatas() {
        return datas;
    }

    /**
     * 得到K线图数据
     *
     * @return
     */
    public ArrayList<KLineItem> getKlineItemsList() {
        return kLineList;
    }

    /**
     * 得到K线数据
     *
     * @return
     */
    public ArrayList<CandleEntry> getCandleEntries() {
        return candleEntries;
    }

    /**
     * 得到成交量数据
     *
     * @return
     */
    public ArrayList<BarEntry> getVolBarEntries() {
        return volBarEntries;
    }


    /**
     * 得到K线图5日均线
     *
     * @return
     */
    public ArrayList<Entry> getMa01DataL() {
        return ma01DataL;
    }


    /**
     * 得到K线图10日均线
     *
     * @return
     */
    public ArrayList<Entry> getMa02DataL() {
        return ma02DataL;
    }

    /**
     * 得到K线图20日均线
     *
     * @return
     */
    public ArrayList<Entry> getMa03DataL() {
        return ma03DataL;
    }

    /**
     * 得到K线图30日均线
     *
     * @return
     */
    public ArrayList<Entry> getMa04DataL() {
        return ma04DataL;
    }

    /**
     * 得到成交量5日均线
     *
     * @return
     */
    public ArrayList<Entry> getMa5DataV() {
        return ma5DataV;
    }

    /**
     * 得到成交量10日均线
     *
     * @return
     */
    public ArrayList<Entry> getMa10DataV() {
        return ma10DataV;
    }

    /**
     * 得到成交量20日均线
     *
     * @return
     */
    public ArrayList<Entry> getMa20DataV() {
        return ma20DataV;
    }

    /**
     * 得到K线图30日均线
     *
     * @return
     */
    public ArrayList<Entry> getMa30DataV() {
        return ma30DataV;
    }

    /**
     * 得到MACD bar
     *
     * @return
     */
    public List<BarEntry> getMacdData() {
        return macdData;
    }

    /**
     * 得到MACD dea
     *
     * @return
     */
    public List<Entry> getDeaData() {
        return deaData;
    }

    /**
     * 得到MACD dif
     *
     * @return
     */
    public List<Entry> getDifData() {
        return difData;
    }

    public List<BarEntry> getBarLsAccountList() {
        return barLsAccountList;
    }

    public void setBarLsAccountList(List<BarEntry> barLsAccountList) {
        this.barLsAccountList = barLsAccountList;
    }

    public List<BarEntry> getBarLsPositionList() {
        return barLsPositionList;
    }

    public void setBarLsPositionList(List<BarEntry> barLsPositionList) {
        this.barLsPositionList = barLsPositionList;
    }

    public List<Entry> getLineLsPositionList() {
        return lineLsPositionList;
    }

    public void setLineLsPositionList(List<Entry> lineLsPositionList) {
        this.lineLsPositionList = lineLsPositionList;
    }

    public List<Entry> getLineLsAccountList() {
        return lineLsAccountList;
    }

    public void setLineLsAccountList(List<Entry> lineLsAccountList) {
        this.lineLsAccountList = lineLsAccountList;
    }

    public List<BarEntry> getBarLsPersonList() {
        return barLsPersonList;
    }

    public List<Entry> getLineLsPersonList() {
        return lineLsPersonList;
    }


    /**
     * 得到KDJ bar
     *
     * @return
     */
    public List<BarEntry> getBarDatasKDJ() {
        return barDatasKDJ;
    }



    /**
     * 得到DKJ k
     *
     * @return
     */
    public List<Entry> getkData() {
        return kData;
    }

    /**
     * 得到KDJ d
     *
     * @return
     */
    public List<Entry> getdData() {
        return dData;
    }

    /**
     * 得到KDJ j
     *
     * @return
     */
    public List<Entry> getjData() {
        return jData;
    }

    /**
     * 得到WR bar
     *
     * @return
     */
    public List<BarEntry> getBarDatasWR() {
        return barDatasWR;
    }

    /**
     * 得到WR 13
     *
     * @return
     */
    public List<Entry> getWrData13() {
        return wrData13;
    }

    /**
     * 得到WR 34
     *
     * @return
     */
    public List<Entry> getWrData34() {
        return wrData34;
    }

    /**
     * 得到WR 89
     *
     * @return
     */
    public List<Entry> getWrData89() {
        return wrData89;
    }

    /**
     * 得到RSI bar
     *
     * @return
     */
    public List<BarEntry> getBarDatasRSI() {
        return barDatasRSI;
    }

    /**
     * 得到RSI 6
     *
     * @return
     */
    public List<Entry> getRsiData6() {
        return rsiData6;
    }

    /**
     * 得到RSI 12
     *
     * @return
     */
    public List<Entry> getRsiData12() {
        return rsiData12;
    }

    /**
     * 得到RSI 24
     *
     * @return
     */
    public List<Entry> getRsiData24() {
        return rsiData24;
    }

    public List<BarEntry> getBarDatasBOLL() {
        return barDatasBOLL;
    }

    public List<Entry> getBollDataUP() {
        return bollDataUP;
    }

    public List<Entry> getBollDataMB() {
        return bollDataMB;
    }

    public List<Entry> getBollDataDN() {
        return bollDataDN;
    }

    public List<BarEntry> getBarDatasEXPMA() {
        return barDatasEXPMA;
    }

    public List<Entry> getExpmaData1() {
        return expmaData1;
    }

    public List<Entry> getExpmaData2() {
        return expmaData2;
    }

    public List<Entry> getExpmaData3() {
        return expmaData3;
    }

    public List<Entry> getExpmaData4() {
        return expmaData4;
    }

    public List<BarEntry> getBarDatasDMI() {
        return barDatasDMI;
    }

    public List<Entry> getDmiDataDI1() {
        return dmiDataDI1;
    }

    public List<Entry> getDmiDataDI2() {
        return dmiDataDI2;
    }

    public List<Entry> getDmiDataADX() {
        return dmiDataADX;
    }

    public List<Entry> getDmiDataADXR() {
        return dmiDataADXR;
    }

    public void clearAll()
    {
        datas.clear();
        datas = null;
        kLineList.clear();
        kLineList = null;
        volBarEntries.clear();
        volBarEntries = null;
        candleEntries.clear();
        candleEntries = null;
        ma01DataL.clear();
        ma01DataL = null;
        ma02DataL.clear();
        ma02DataL = null;
        ma03DataL.clear();
        ma03DataL = null;
        ma04DataL.clear();ma04DataL = null;
        ma5DataV.clear();ma5DataV = null;
        ma10DataV.clear();ma10DataV = null;
        ma20DataV.clear();ma20DataV = null;

        ma30DataV.clear();ma30DataV = null;
        macdData.clear();macdData = null;
        deaData.clear();deaData = null;
        difData.clear();difData = null;
        barDatasKDJ.clear();barDatasKDJ = null;
        kData.clear();kData = null;
        dData.clear();dData = null;

        jData.clear();jData = null;
        barDatasRSI.clear();barDatasRSI = null;
        rsiData6.clear();rsiData6 = null;
        rsiData12.clear();rsiData12 = null;
        rsiData24.clear();rsiData24 = null;
        barDatasBOLL.clear();barDatasBOLL = null;
        bollDataUP.clear();bollDataUP = null;
        bollDataMB.clear();bollDataMB = null;
        bollDataDN.clear();bollDataDN = null;

        barDatasEXPMA.clear();barDatasEXPMA = null;
        expmaData1.clear();
        expmaData1 = null;
        expmaData2.clear();
        expmaData2 = null;
        expmaData3.clear();
        expmaData3 = null;
        expmaData4.clear();
        expmaData4 = null;
    }
}
