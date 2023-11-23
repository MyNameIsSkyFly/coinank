package com.ank.ankapp.original.activity;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import androidx.core.content.ContextCompat;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.bean.ChartManager;
import com.ank.ankapp.original.bean.ChartNode;
import com.ank.ankapp.original.bean.DataParse;
import com.ank.ankapp.original.bean.JsonVo;
import com.ank.ankapp.original.bean.KLineItem;
import com.ank.ankapp.original.bean.ResponseSymbolVo;
import com.ank.ankapp.original.bean.SymbolExtraInfoVo;
import com.ank.ankapp.original.bean.SymbolRealPriceVo;
import com.ank.ankapp.original.bean.SymbolVo;
import com.ank.ankapp.original.bean.vipindex.KlineIndc;
import com.ank.ankapp.original.bean.vipindex.KlineUtils;
import com.ank.ankapp.original.bean.vipindex.LongShortRatioVo;
import com.ank.ankapp.original.chart.ChartFingerTouchListener;
import com.ank.ankapp.original.chart.CoupleChartGestureListener;
import com.ank.ankapp.original.chart.CoupleChartValueSelectedListener;
import com.ank.ankapp.original.chart.HighlightCombinedRenderer;
import com.ank.ankapp.original.chart.InBoundXAxisRenderer;
import com.ank.ankapp.original.chart.InBoundYAxisRenderer;
import com.ank.ankapp.original.fragment.EmbedWebviewFragment;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.utils.AppUtils;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.OkHttpUtil;
import com.ank.ankapp.original.utils.SQLiteKV;
import com.ank.ankapp.original.utils.WebSocketUtils;
import com.ank.ankapp.original.widget.LeftChooseSymbolDialog;
import com.ank.ankapp.original.widget.LoadingDialog;
import com.ank.ankapp.original.widget.refresh.PullScrollView;
import com.ank.ankapp.original.widget.refresh.PullToRefreshLayout;
import com.ank.ankapp.original.widget.refresh.ResourceConfig;
import com.github.mikephil.charting.charts.CombinedChart;
import com.github.mikephil.charting.components.AxisBase;
import com.github.mikephil.charting.components.LimitLine;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.data.CandleData;
import com.github.mikephil.charting.data.CandleDataSet;
import com.github.mikephil.charting.data.CandleEntry;
import com.github.mikephil.charting.data.CombinedData;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.IAxisValueFormatter;
import com.github.mikephil.charting.interfaces.datasets.ICandleDataSet;
import com.github.mikephil.charting.utils.Transformer;
import com.github.mikephil.charting.utils.Utils;
import com.github.mikephil.charting.utils.ViewPortHandler;
import com.google.android.material.tabs.TabLayout;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import okhttp3.WebSocket;


public class KLineActivity extends BaseActivity implements View.OnClickListener,
        TabLayout.OnTabSelectedListener, CoupleChartGestureListener.OnDoSomething,
        CoupleChartValueSelectedListener.ValueSelectedListener, ChartFingerTouchListener.HighlightListener{

    private PullToRefreshLayout mRefreshLayout;
    private PullScrollView ll_pullview;
    private TabLayout tabLayout;
    private TextView tv_price;
    private TextView tvLine;

    private TextView tv_percent, tv_24h_high_price, tv_24h_low_price, tv_24h_vol;

    private TextView tvMoreTime;
    private TextView tv_chart_vol;
    private LinearLayout ll_highlightview;
    private TextView tv_datetime, tv_open, tv_high, tv_low, tv_close, tv_chg, tv_ampl, tv_highlight_vol;

    private CombinedChart mChartKline;
    private CombinedChart mChartVol;

    private boolean toLeft;
    private float maxRange = 40;//配置值，初始屏幕只显示40根K线
    private final float mDragOffsetX = 100.0F;//K线初始显示时，距离屏幕右边的偏移

    private float highVisX;//切屏时X轴的最大值

    private DataParse mDataParse = new DataParse();
    private Map<Integer, String> xValuesDatetime = new HashMap<>();
    private LineDataSet lineSetMin;//分时线

    private LineDataSet ma01set;
    private LineDataSet ma02set;
    private LineDataSet ma03set;
    private LineDataSet ma04set;
    private LineDataSet ma05set;

    private LineDataSet vma5set;
    private LineDataSet vma10set;

    private CandleDataSet candleSet;
    private CombinedData klineCombinedData;
    private BarDataSet volBarSet;
    private final float volBarOffset = 0.0F;//BarChart偏移量 -0.5

    private Context mCot;

    private final String[] tabKlineTimeText = {"Time", "15m", "1h", "4h"};

    private final int[] KLINE_PERIOD_ID_ARRA = {R.id.tv_1m, R.id.tv_3m, R.id.tv_5m, R.id.tv_30m, R.id.tv_2h,
                                    R.id.tv_6h, R.id.tv_8h, R.id.tv_12h, R.id.tv_1d, R.id.tv_1w, R.id.tv_1mon};

    private final String[] TAB_KLINE_ARGS = {"1m", "15m", "1h", "4h"};
    private final String[] KLINE_STR_TEXT = {"1m", "3m", "5m", "30m", "2h",
            "6h", "8h", "12h", "1d", "1w", "1mon"};

    private TextView[] klineTvArrs = new TextView[11];


    private final int[] mainResIds = {R.id.tv_ma, R.id.tv_boll, R.id.tv_ema};
    private final int[] subResIds = {R.id.tv_macd, R.id.tv_kdj, R.id.tv_rsi,
            R.id.tv_funding, R.id.tv_oi, R.id.tv_symbol_liq,
            R.id.tv_funding_kl, R.id.tv_oi_kl, R.id.tv_coin_liq,
            R.id.tv_longshort_people, R.id.tv_top_position, R.id.tv_top_account,
            R.id.tv_coin_oi_kline, R.id.tv_oi_delta,R.id.tv_oi_fr, R.id.tv_vol_fr,
            R.id.tv_ls_accounts_k,R.id.tv_top_accounts_k,R.id.tv_top_positions_K
    };

    private final  static int SUB_INDEX_COUNT = 19;//为subResIds.length

    private TextView[] mainChartIndicArrs = new TextView[3];//mainResIds.length
    private TextView[] subChartIndicArrs = new TextView[SUB_INDEX_COUNT];

    private LoadingDialog loadingDialog;

    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault());

    private Handler mHandler;
    private ChartManager mChartManager;
    private String currSymbol, currExchangeName, currBaseCoin, currSwapType;
    private String currPeriod = "15m";
    private int klinePeriodIndex = 1;//TabLayout选中下标

    private FragmentManager mFragmentManager;
    private EmbedWebviewFragment marketOrderWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_kline);
        if (Global.mulKLineActivity != null)
            Global.mulKLineActivity.finish();

        registerBroadcast();
        currExchangeName = getIntent().getStringExtra(Config.TYPE_EXCHANGENAME);
        currSymbol = getIntent().getStringExtra(Config.TYPE_SYMBOL);
        currBaseCoin = getIntent().getStringExtra(Config.TYPE_BASECOIN);
        currSwapType = getIntent().getStringExtra(Config.TYPE_SWAP);
        currPeriod = Config.getMMKV(this).getString(Config.CONF_KLINE_PERIOD, "15m");
        maxRange = Config.getMMKV(this).getFloat(Config.CONF_VISIBLE_XRANGE, 40.0F);
        MLog.d(currExchangeName + currSymbol + "  "  + currPeriod);
        mCot = this;
        tabKlineTimeText[0] = getString(R.string.s_minute_time);
        mChartManager = new ChartManager(this);

        mFragmentManager = this.getSupportFragmentManager();
        OkHttpUtil.initOkHttp();
        initChartColors();
        initToolBar();
        initView();

        Global.getAnalytics(this).logEvent("user_action",
                Global.createBundle("oncreate " + getCurrSymbolJson(), getClass().getSimpleName()));

        sw = getWindowManager().getDefaultDisplay().getWidth();
        sh = getWindowManager().getDefaultDisplay().getHeight();
        //MLog.d("sw, sh:" + sw + " " + sh);
        loadData();

        WebSocketUtils.getInstance().createWebSocket();
        WebSocketUtils.getInstance().addSubscribe(getSubscribeArgs());
        WebSocketUtils.getInstance().setOnMsgListener(new WebSocketUtils.OnMessageListener() {

            @Override
            public void onMsg(String json) {
            }

            @Override
            public void onMsg(WebSocket webSocket,String json) {
                //MLog.d("onMsg:" + json);
                if (json.contains("pong"))
                {
                    //MLog.d("kline onMsg:" + json);
                    return;
                }

                if (json.contains("kline@") &&
                        json.contains("true") &&
                        json.contains("push"))
                {
                    //tvMoreTime.setText("aaa");
                    //MLog.d("onMsg:" + json);
                    SymbolRealPriceVo<List<String>> responseVo;

                    Gson gson = new GsonBuilder().create();
                    responseVo = gson.fromJson(json, new TypeToken<SymbolRealPriceVo<List<String>>>() {}.getType());

                    String args = getArgsNoPeriod();
                    if (!responseVo.getArgs().contains(args))
                    {
                        MLog.d("removeSubscribe:" + responseVo.getArgs());
                        WebSocketUtils.getInstance().sendMsg(webSocket, 1, responseVo.getArgs());
                        WebSocketUtils.getInstance().closeWebSocket(webSocket);
                        return;
                    }

                    Message msg = new Message();
                    msg.what = 0;
                    msg.obj = responseVo;
                    mHandler.sendMessage(msg);
                }
                else if (json.contains("tickers@") &&
                        json.contains("true") &&
                        json.contains("push"))
                {
                    //MLog.d("onMsg:" + json);
                    SymbolRealPriceVo<SymbolExtraInfoVo> responseVo;

                    Gson gson = new GsonBuilder().create();
                    responseVo = gson.fromJson(json, new TypeToken<SymbolRealPriceVo<SymbolExtraInfoVo>>() {}.getType());

                    String args = getTickersArg();
                    if (!responseVo.getArgs().contains(args))
                    {
                        MLog.d("tickers exception:" + responseVo.getArgs());
                        return;
                    }

                    Message msg = new Message();
                    msg.what = 2;
                    msg.obj = responseVo;
                    mHandler.sendMessage(msg);
                }
            }

            @Override
            public void doEvent() {

            }
        });

        mHandler = new Handler(new Handler.Callback() {
            @Override
            public boolean handleMessage(Message msg) {
                if (msg.what == 0) {
                    SymbolRealPriceVo<List<String>> responseVo = (SymbolRealPriceVo<List<String>>)msg.obj;
                    if (mDataParse != null)
                    {
                        refreshLastKlineLiveInfo(responseVo);
                    }
                }
                else if (msg.what == 2) {
                    SymbolRealPriceVo<SymbolExtraInfoVo> responseVo = (SymbolRealPriceVo<SymbolExtraInfoVo>)msg.obj;
                    if (mDataParse != null)
                    {
                        updateSymbolExtraInfo(responseVo);
                    }
                }
                else if (msg.what == 3) {
                   settingKlineChart(tabLayout);
                }
                else if (msg.what == 4) {
                    setKlineStyle();
                    mChartKline.invalidate();
                }
                else if (msg.what == 5) {
                    setMaLineWidth();
                    mChartKline.invalidate();
                }
                else if(msg.what == 1)//刷新K线倒计时
                {
                    if (mDataParse != null && mDataParse.kLineList.size() > 0 && vma5set.getEntryCount() > 0)
                    {
                        int count = mDataParse.kLineList.size();
                        KLineItem item = mDataParse.kLineList.get(count - 1);
                        refreshLivePriceLine(item.open, item.close, count, true);
                    }

                    if (mDataParse != null)
                        mHandler.sendEmptyMessageDelayed(1, 1000);
                }

                return false;
            }
        });

        mHandler.sendEmptyMessageDelayed(1, 1000);
        pauseTime = System.currentTimeMillis();
    }

    private long pauseTime = 0;
    @Override
    protected void onPause() {
        super.onPause();
        pauseTime = System.currentTimeMillis();//毫秒
    }

    private boolean isFirst = true;
    @Override
    protected void onResume() {
        super.onResume();
        loadIndexConfig();
        if (!isFirst)
        {
            long curr = System.currentTimeMillis();
            if (curr - pauseTime > 30*1000)
            {
                MLog.d("@@@@kline need refresh data");
                pauseTime = System.currentTimeMillis();

                loadData();

                return;
            }

            pauseTime = System.currentTimeMillis();
            configData();

            getFavoriteList();
            if (favoriteList.contains(getCurrentSymbol()))
            {
                iv_favorite.setImageResource(R.drawable.favorite_sel);
            }
            else
            {
                if (Config.isNightMode)
                {
                    iv_favorite.setImageResource(R.drawable.favorite_night);
                }
                else
                {
                    iv_favorite.setImageResource(R.drawable.favorite_light);
                }
            }
        }

        isFirst = false;
    }

    List<SymbolVo> favoriteList = null;
    private void getFavoriteList()
    {
        String json = Config.getMMKV(this).getString(Config.CONF_KLINE_FAVORITE_SYMBOL, "");
        Gson gson = new GsonBuilder().create();

        if (favoriteList != null)
        {
            favoriteList.clear();
            favoriteList = null;
        }

        favoriteList = gson.fromJson(json, new TypeToken<List<SymbolVo>>() {}.getType());
        if (favoriteList == null) favoriteList = new ArrayList<>();
    }

    //更新指标左上角的文字描述以及显示触摸或者最新的值
    //param idx is the data list index postion, from 0 to size-1
    private void updateIndexLastVal(int idx)
    {
        String str = "";

        //idx 为触摸点在list里面的索引
        //处理主图指标点击和长按时，指标数据需要处理偏移，否则会崩溃，
        // 具体就是ma ,ema  boll这些指标的点数没有K线数据多，会导致指标对应的list索引越界
        if (mainChartIndicIdx == ChartNode.ChartType.MA)
        {
            int offset = candleSet.getEntries().size() - idx;
            int offsetma1 = ma01set.getEntries().size() - offset;
            int offsetma2 = ma02set.getEntries().size() - offset;
            int offsetma3 = ma03set.getEntries().size() - offset;
            int offsetma4 = ma04set.getEntries().size() - offset;
            int offsetma5 = ma05set.getEntries().size() - offset;
            float val1 = 0f, val2 = 0f, val3 = 0f, val4 = 0f, val5 = 0f;

            if (offsetma1 >= 0 && mDataParse.indexParamVo.isMa1Toggle())
            {
                val1 = ma01set.getEntries().get(offsetma1).getY();
            }

            if (offsetma2 >= 0 && mDataParse.indexParamVo.isMa2Toggle())
            {
                val2 = ma02set.getEntries().get(offsetma2).getY();
            }

            if (offsetma3 >= 0 && mDataParse.indexParamVo.isMa3Toggle())
            {
                val3 = ma03set.getEntries().get(offsetma3).getY();
            }

            if (offsetma4 >= 0 && mDataParse.indexParamVo.isMa4Toggle())
            {
                val4 = ma04set.getEntries().get(offsetma4).getY();
            }

            if (offsetma5 >= 0 && mDataParse.indexParamVo.isMa5Toggle())
            {
                val5 = ma05set.getEntries().get(offsetma5).getY();
            }

            String s1 = AppUtils.getColorHexString(ma01color);
            String s2 = AppUtils.getColorHexString(ma02color);
            String s3 = AppUtils.getColorHexString(ma03color);
            String s4 = AppUtils.getColorHexString(ma04color);
            String s5 = AppUtils.getColorHexString(ma05color);

            final String s = "<font color=#%s>MA%d:%s</font> ";
            if (mDataParse.indexParamVo.isMa1Toggle())
            {
                str  = str + String.format(s, s1, mDataParse.indexParamVo.getMA1(),
                        AppUtils.getFormatStringValue(val1, mDataParse.pricePrecision));
            }

            if (mDataParse.indexParamVo.isMa2Toggle())
            {
                str  = str + String.format(s, s2, mDataParse.indexParamVo.getMA2(),
                        AppUtils.getFormatStringValue(val2, mDataParse.pricePrecision));
            }

            if (mDataParse.indexParamVo.isMa3Toggle())
            {
                str  = str + String.format(s, s3, mDataParse.indexParamVo.getMA3(),
                        AppUtils.getFormatStringValue(val3, mDataParse.pricePrecision));
            }

            if (mDataParse.indexParamVo.isMa4Toggle())
            {
                str  = str + String.format(s, s4, mDataParse.indexParamVo.getMA4(),
                        AppUtils.getFormatStringValue(val4, mDataParse.pricePrecision));
            }

            if (mDataParse.indexParamVo.isMa5Toggle())
            {
                str  = str + String.format(s, s5, mDataParse.indexParamVo.getMA5(),
                        AppUtils.getFormatStringValue(val5, mDataParse.pricePrecision));
            }

        }
        else if (mainChartIndicIdx == ChartNode.ChartType.EMA)
        {
            String s1 = AppUtils.getColorHexString(ma01color);
            String s2 = AppUtils.getColorHexString(ma02color);
            String s3 = AppUtils.getColorHexString(ma03color);
            String s4 = AppUtils.getColorHexString(ma04color);
            String s5 = AppUtils.getColorHexString(ma05color);

            final String s = "<font color=#%s>EMA%d:%s</font> ";
            if (mDataParse.indexParamVo.isEma1Toggle())
            {
                str  = str + String.format(s, s1, mDataParse.indexParamVo.getEMA1(),
                        AppUtils.getFormatStringValue(ma01set.getEntries().get(idx).getY(), mDataParse.pricePrecision));
            }

            if (mDataParse.indexParamVo.isEma2Toggle())
            {
                str  = str + String.format(s, s2, mDataParse.indexParamVo.getEMA2(),
                        AppUtils.getFormatStringValue(ma02set.getEntries().get(idx).getY(), mDataParse.pricePrecision));
            }

            if (mDataParse.indexParamVo.isEma3Toggle())
            {
                str  = str + String.format(s, s3, mDataParse.indexParamVo.getEMA3(),
                        AppUtils.getFormatStringValue(ma03set.getEntries().get(idx).getY(), mDataParse.pricePrecision));
            }

            if (mDataParse.indexParamVo.isEma4Toggle())
            {
                str  = str + String.format(s, s4, mDataParse.indexParamVo.getEMA4(),
                        AppUtils.getFormatStringValue(ma04set.getEntries().get(idx).getY(), mDataParse.pricePrecision));
            }

            if (mDataParse.indexParamVo.isEma5Toggle())
            {
                str  = str + String.format(s, s5, mDataParse.indexParamVo.getEMA5(),
                        AppUtils.getFormatStringValue(ma05set.getEntries().get(idx).getY(), mDataParse.pricePrecision));
            }

        }
        else if (mainChartIndicIdx == ChartNode.ChartType.BOLL)
        {
            int offset = candleSet.getEntries().size() - idx;
            int offsetma1 = ma01set.getEntries().size() - offset;
            int offsetma2 = ma02set.getEntries().size() - offset;
            int offsetma3 = ma03set.getEntries().size() - offset;
            float val1 = 0F, val2 = 0f, val3 = 0f;

            if (offsetma1 >= 0)
            {
                val1 = ma01set.getEntries().get(offsetma1).getY();
            }

            if (offsetma2 >= 0)
            {
                val2 = ma02set.getEntries().get(offsetma2).getY();
            }

            if (offsetma3 >= 0)
            {
                val3 = ma03set.getEntries().get(offsetma3).getY();
            }

            str = "<font color=#%s>BOLL(%d,%d)</font> " +
                    "<font color=#%s>UP:%s</font> " +
                    "<font color=#%s>MID:%s</font> " +
                    "<font color=#%s>LB:%s</font>";
            String s1 = AppUtils.getColorHexString(ma02color);
            String s2 = AppUtils.getColorHexString(ma01color);
            String s3 = AppUtils.getColorHexString(ma03color);
            str = String.format(str, AppUtils.getColorHexString(blackgray),
                    mDataParse.indexParamVo.getBoll_md(), mDataParse.indexParamVo.getBoll_up(),
                    s1, AppUtils.getFormatStringValue(val1, mDataParse.pricePrecision),
                    s2, AppUtils.getFormatStringValue(val2, mDataParse.pricePrecision),
                    s3, AppUtils.getFormatStringValue(val3, mDataParse.pricePrecision)
            );
        }

        //MLog.d(str);
        tv_chart_vol.setText("VOL:" + AppUtils.getFormatStringValue(mDataParse.kLineList.get(idx).vol));

        if (tabLayout.getSelectedTabPosition() != 0) {
            tvLine.setText(AppUtils.fromHtml(str));
        }
        else
        {
            tvLine.setText("");
        }

        //副图指标，触摸值和最新值显示
        for (int i = 2; i < mChartManager.getNodeCount(); i++)
        {
            ChartNode node = mChartManager.getNode(i);
            if (node.chartType == ChartNode.ChartType.MACD)
            {
                str = "<font color=#%s>MACD(%d,%d,%d)</font> " +
                        "<font color=#%s>DIF:%s</font> " +
                        "<font color=#%s>DEA:%s</font> " +
                        "<font color=#%s>MACD:%s</font> ";
                String s1 = AppUtils.getColorHexString(ma01color);
                String s2 = AppUtils.getColorHexString(ma02color);
                float macdVal = mDataParse.getMacdData().get(idx).getY();
                String s3 = AppUtils.getColorHexString(red);
                if (macdVal >= 0)
                {
                    s3 = AppUtils.getColorHexString(green);
                }

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        mDataParse.indexParamVo.getMacd_short(), mDataParse.indexParamVo.getMacd_long(),
                        mDataParse.indexParamVo.getMacd_ma(),
                        s1, AppUtils.getFormatStringValue(mDataParse.getDifData().get(idx).getY(), mDataParse.pricePrecision),
                        s2, AppUtils.getFormatStringValue(mDataParse.getDeaData().get(idx).getY(), mDataParse.pricePrecision),
                        s3, AppUtils.getFormatStringValue(macdVal, mDataParse.pricePrecision)
                );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));

            }
            else if (node.chartType == ChartNode.ChartType.KDJ)
            {
                str = "<font color=#%s>KDJ(%d,%d,%d)</font> " +
                        "<font color=#%s>K:%s</font> " +
                        "<font color=#%s>D:%s</font> " +
                        "<font color=#%s>J:%s</font> ";
                String s1 = AppUtils.getColorHexString(ma01color);
                String s2 = AppUtils.getColorHexString(ma02color);
                String s3 = AppUtils.getColorHexString(ma03color);
                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        mDataParse.indexParamVo.getK(), mDataParse.indexParamVo.getD(),
                        mDataParse.indexParamVo.getJ(),
                        s1, AppUtils.getFormatStringValue(mDataParse.getkData().get(idx).getY(), 2),
                        s2, AppUtils.getFormatStringValue(mDataParse.getdData().get(idx).getY(), 2),
                        s3, AppUtils.getFormatStringValue(mDataParse.getjData().get(idx).getY(), 2)
                );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));

            }
            else if (node.chartType == ChartNode.ChartType.RSI)
            {
                str = "<font color=#%s>RSI(%d,%d,%d)</font> " +
                        "<font color=#%s>RSI%d:%s</font> " +
                        "<font color=#%s>RSI%d:%s</font> " +
                        "<font color=#%s>RSI%d:%s</font> ";
                String s1 = AppUtils.getColorHexString(ma01color);
                String s2 = AppUtils.getColorHexString(ma02color);
                String s3 = AppUtils.getColorHexString(ma03color);
                int r1 = mDataParse.indexParamVo.getRSI1();
                int r2 = mDataParse.indexParamVo.getRSI2();
                int r3 = mDataParse.indexParamVo.getRSI3();

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        r1, r2, r3,
                        s1, r1, AppUtils.getFormatStringValue(mDataParse.getRsiData6().get(idx).getY(), 2),
                        s2, r2, AppUtils.getFormatStringValue(mDataParse.getRsiData12().get(idx).getY(), 2),
                        s3, r3, AppUtils.getFormatStringValue(mDataParse.getRsiData24().get(idx).getY(), 2)
                );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));

            }
            else if (node.chartType == ChartNode.ChartType.OPENINTEREST)
            {
                float val = 0.0F;
                if (mDataParse.vipIndexObj.lineOIList.size() > idx)
                {
                    val = mDataParse.vipIndexObj.lineOIList.get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> ";
                String s1 = AppUtils.getColorHexString(sub_chart_single_color);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_open_interest),
                        s1,   AppUtils.getLargeFormatString(val));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO)
            {
                float val = 0.0F;
                if (mDataParse.getLineLsPersonList().size() > idx)
                {
                    val = mDataParse.getLineLsPersonList().get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> ";

                int c = green;
                if (val < 1.0F) c = red;
                String s1 = AppUtils.getColorHexString(c);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_longshort_person),
                        s1,   AppUtils.getFormatStringValue(val, 2));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.TOP_ACCOUNT_RATIO)
            {
                float val = 0.0F;
                if (mDataParse.getLineLsAccountList().size() > idx)
                {
                    val = mDataParse.getLineLsAccountList().get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> ";

                int c = green;
                if (val < 1.0F) c = red;
                String s1 = AppUtils.getColorHexString(c);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_top_trader_accounts_ratio),
                        s1,  AppUtils.getFormatStringValue(val, 2));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.TOP_POSITION_RATIO)
            {
                float val = 0.0F;
                if (mDataParse.getLineLsPositionList().size() > idx)
                {
                    val = mDataParse.getLineLsPositionList().get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> ";

                int c = green;
                if (val < 1.0F) c = red;
                String s1 = AppUtils.getColorHexString(c);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_top_trader_position_ratio),
                        s1,   AppUtils.getFormatStringValue(val, 2));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.FUNDING_RATE)
            {
                float val = 0.0F;
                if (mDataParse.vipIndexObj.barFRlist.size() > idx)
                {
                    val = mDataParse.vipIndexObj.barFRlist.get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> ";

                String s1 = AppUtils.getColorHexString(red);
                if (val >= 0)
                {
                    s1 = AppUtils.getColorHexString(green);
                }

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_funding_rate),
                        s1,   AppUtils.getFormatStringValue(val));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.OI_FR)
            {
                float val = 0.0F;
                if (mDataParse.vipIndexObj.barOIWeightFrData.size() > idx)
                {
                    val = mDataParse.vipIndexObj.barOIWeightFrData.get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> ";

                String s1 = AppUtils.getColorHexString(red);
                if (val >= 0)
                {
                    s1 = AppUtils.getColorHexString(green);
                }

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_oi_fr),
                        s1,   AppUtils.getFormatStringValue(val));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.VOL_FR)
            {
                float val = 0.0F;
                if (mDataParse.vipIndexObj.barVolumeWeightFrData.size() > idx)
                {
                    val = mDataParse.vipIndexObj.barVolumeWeightFrData.get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> ";

                String s1 = AppUtils.getColorHexString(red);
                if (val >= 0)
                {
                    s1 = AppUtils.getColorHexString(green);
                }

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_vol_fr),
                        s1,   AppUtils.getFormatStringValue(val));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.OI_DELTA)
            {
                float val = 0.0F;
                if (mDataParse.vipIndexObj.barOIDelta.size() > idx)
                {
                    val = mDataParse.vipIndexObj.barOIDelta.get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> ";

                String s1 = AppUtils.getColorHexString(red);
                if (val >= 0)
                {
                    s1 = AppUtils.getColorHexString(green);
                }

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_oi_delta),
                        s1,   AppUtils.getFormatStringValue(val));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.SYMBOL_LIQUIDATION)
            {
                float val = 0.0F;
                float val2 = 0.0F;
                if (mDataParse.vipIndexObj.barLongSymbolLiqList.size() > idx)
                {
                    val = mDataParse.vipIndexObj.barLongSymbolLiqList.get(idx).getY();
                    val2 = -mDataParse.vipIndexObj.barShortSymbolLiqList.get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> "+
                        "<font color=#%s>%s</font> ";

                String s1 = AppUtils.getColorHexString(green);
                String s2 = AppUtils.getColorHexString(red);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_symbol_liq),
                        s1,AppUtils.getLargeFormatString(val),
                        s2,  AppUtils.getLargeFormatString(val2));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.COIN_LIQUIDATION)
            {
                float val = 0.0F;
                float val2 = 0.0F;
                if (mDataParse.vipIndexObj.barLongCoinLiqList.size() > idx)
                {
                    val = mDataParse.vipIndexObj.barLongCoinLiqList.get(idx).getY();
                    val2 = -mDataParse.vipIndexObj.barShortCoinLiqList.get(idx).getY();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s</font> "+
                        "<font color=#%s>%s</font> ";

                String s1 = AppUtils.getColorHexString(green);
                String s2 = AppUtils.getColorHexString(red);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_coin_liquidation),
                        s1,AppUtils.getLargeFormatString(val),
                        s2,  AppUtils.getLargeFormatString(val2));

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE)
            {
                float o = 0.0F;
                float h = 0.0F;
                float c = 0.0F;
                float l = 0.0F;

                if (mDataParse.vipIndexObj.candleFrListK.size() > idx)
                {
                    o = mDataParse.vipIndexObj.candleFrListK.get(idx).getOpen();
                    h = mDataParse.vipIndexObj.candleFrListK.get(idx).getHigh();
                    l = mDataParse.vipIndexObj.candleFrListK.get(idx).getLow();
                    c = mDataParse.vipIndexObj.candleFrListK.get(idx).getClose();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s %s %s %s</font> ";

                String s1 = AppUtils.getColorHexString(green);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_fr_kline),
                        s1,
                        AppUtils.getFormatStringValue(o),
                        AppUtils.getFormatStringValue(h),
                        AppUtils.getFormatStringValue(l),
                        AppUtils.getFormatStringValue(c)
                        );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.COIN_OI_KLINE)
            {
                float o = 0.0F;
                float h = 0.0F;
                float c = 0.0F;
                float l = 0.0F;

                if (mDataParse.vipIndexObj.coinCandleOIListK.size() > idx)
                {
                    o = mDataParse.vipIndexObj.coinCandleOIListK.get(idx).getOpen();
                    h = mDataParse.vipIndexObj.coinCandleOIListK.get(idx).getHigh();
                    l = mDataParse.vipIndexObj.coinCandleOIListK.get(idx).getLow();
                    c = mDataParse.vipIndexObj.coinCandleOIListK.get(idx).getClose();
                }

                str = "<font color=#%s>%s(%s):</font> " +
                        "<font color=#%s>%s %s %s %s</font> ";

                String s1 = AppUtils.getColorHexString(green);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_coin_oi_kline),currBaseCoin,
                        s1,
                        AppUtils.getLargeFormatString(o),
                        AppUtils.getLargeFormatString(h),
                        AppUtils.getLargeFormatString(l),
                        AppUtils.getLargeFormatString(c)
                );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.OI_KLINE)
            {
                float o = 0.0F;
                float h = 0.0F;
                float c = 0.0F;
                float l = 0.0F;

                if (mDataParse.vipIndexObj.candleOIListK.size() > idx)
                {
                    o = mDataParse.vipIndexObj.candleOIListK.get(idx).getOpen();
                    h = mDataParse.vipIndexObj.candleOIListK.get(idx).getHigh();
                    l = mDataParse.vipIndexObj.candleOIListK.get(idx).getLow();
                    c = mDataParse.vipIndexObj.candleOIListK.get(idx).getClose();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s %s %s %s</font> ";

                String s1 = AppUtils.getColorHexString(green);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_oi_kline),
                        s1,
                        AppUtils.getLargeFormatString(o),
                        AppUtils.getLargeFormatString(h),
                        AppUtils.getLargeFormatString(l),
                        AppUtils.getLargeFormatString(c)
                );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K)
            {
                float o = 0.0F;
                float h = 0.0F;
                float c = 0.0F;
                float l = 0.0F;

                if (mDataParse.vipIndexObj.candleLsAccountsRatioK.size() > idx)
                {
                    o = mDataParse.vipIndexObj.candleLsAccountsRatioK.get(idx).getOpen();
                    h = mDataParse.vipIndexObj.candleLsAccountsRatioK.get(idx).getHigh();
                    l = mDataParse.vipIndexObj.candleLsAccountsRatioK.get(idx).getLow();
                    c = mDataParse.vipIndexObj.candleLsAccountsRatioK.get(idx).getClose();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s %s %s %s</font> ";

                String s1 = AppUtils.getColorHexString(green);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_ls_accounts_k),
                        s1,
                        AppUtils.getFormatStringValue(o, 2),
                        AppUtils.getFormatStringValue(h,2),
                        AppUtils.getFormatStringValue(l,2),
                        AppUtils.getFormatStringValue(c,2)
                );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K)
            {
                float o = 0.0F;
                float h = 0.0F;
                float c = 0.0F;
                float l = 0.0F;

                if (mDataParse.vipIndexObj.candleTopAccountsRatioK.size() > idx)
                {
                    o = mDataParse.vipIndexObj.candleTopAccountsRatioK.get(idx).getOpen();
                    h = mDataParse.vipIndexObj.candleTopAccountsRatioK.get(idx).getHigh();
                    l = mDataParse.vipIndexObj.candleTopAccountsRatioK.get(idx).getLow();
                    c = mDataParse.vipIndexObj.candleTopAccountsRatioK.get(idx).getClose();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s %s %s %s</font> ";

                String s1 = AppUtils.getColorHexString(green);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_ls_top_accounts_k),
                        s1,
                        AppUtils.getFormatStringValue(o, 2),
                        AppUtils.getFormatStringValue(h,2),
                        AppUtils.getFormatStringValue(l,2),
                        AppUtils.getFormatStringValue(c,2)
                );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
            else if (node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K)
            {
                float o = 0.0F;
                float h = 0.0F;
                float c = 0.0F;
                float l = 0.0F;

                if (mDataParse.vipIndexObj.candleTopPostionsRatioK.size() > idx)
                {
                    o = mDataParse.vipIndexObj.candleTopPostionsRatioK.get(idx).getOpen();
                    h = mDataParse.vipIndexObj.candleTopPostionsRatioK.get(idx).getHigh();
                    l = mDataParse.vipIndexObj.candleTopPostionsRatioK.get(idx).getLow();
                    c = mDataParse.vipIndexObj.candleTopPostionsRatioK.get(idx).getClose();
                }

                str = "<font color=#%s>%s:</font> " +
                        "<font color=#%s>%s %s %s %s</font> ";

                String s1 = AppUtils.getColorHexString(green);

                str = String.format(str, AppUtils.getColorHexString(blackgray),
                        getResources().getString(R.string.s_ls_top_positions_ratio_k),
                        s1,
                        AppUtils.getFormatStringValue(o, 2),
                        AppUtils.getFormatStringValue(h,2),
                        AppUtils.getFormatStringValue(l,2),
                        AppUtils.getFormatStringValue(c,2)
                );

                ((TextView)node.rll.findViewById(R.id.tv_chart_info)).setText(AppUtils.fromHtml(str));
            }
        }

        //长按K线界面图表时，在K线图区域会弹出一个框显示触摸位置的信息
        if (isHighlight)
        {
            tv_datetime.setText(mDataParse.kLineList.get(idx).date);
            tv_open.setText(AppUtils.getFormatStringValue(mDataParse.kLineList.get(idx).open));
            tv_high.setText(AppUtils.getFormatStringValue(mDataParse.kLineList.get(idx).high));
            tv_low.setText(AppUtils.getFormatStringValue(mDataParse.kLineList.get(idx).low));
            tv_close.setText(AppUtils.getFormatStringValue(mDataParse.kLineList.get(idx).close));
            tv_highlight_vol.setText(AppUtils.getFormatStringValue(mDataParse.kLineList.get(idx).vol));

            float dif = mDataParse.kLineList.get(idx).close - mDataParse.kLineList.get(idx).open;
            float percent = dif/mDataParse.kLineList.get(idx).open;

            String format = "%." + AppUtils.getPrecision(String.valueOf(mDataParse.kLineList.get(idx).close)) + "f";
            String schg = String.format(Locale.ENGLISH,"%.2f", (percent*100)) + "%(" + AppUtils.getFormatStringValue(dif, mDataParse.pricePrecision)  + ")";


            tv_chg.setText(schg);
            if (dif > 0)
            {
                tv_chg.setTextColor(green);
            }
            else
            {
                tv_chg.setTextColor(red);
            }
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);


        setIntent(intent);
        String oldArgs = getSubscribeArgs();
        currExchangeName = getIntent().getStringExtra(Config.TYPE_EXCHANGENAME);
        currSymbol = getIntent().getStringExtra(Config.TYPE_SYMBOL);
        currBaseCoin = getIntent().getStringExtra(Config.TYPE_BASECOIN);
        currSwapType = getIntent().getStringExtra(Config.TYPE_SWAP);

        if (!oldArgs.equals(getSubscribeArgs()))
        {
            pauseTime = System.currentTimeMillis();//此处加载后，onresume函数里面就不再判断后台唤醒刷新
            loadNewData(oldArgs);
        }

        Global.getAnalytics(this).logEvent("user_action",
                Global.createBundle("onNewIntent " + getCurrSymbolJson(), getClass().getSimpleName()));
    }

    private void loadNewData(String oldArgs)
    {
        stopTranslate();
        tv_price.setText("0");
        //WebSocketUtils.getInstance().removeSubscribe(oldArgs);
        WebSocketUtils.getInstance().removeAllSubscribe();
        loadData();
        WebSocketUtils.getInstance().addSubscribe(getSubscribeArgs());
    }

    private void loadIndexConfig()
    {

        SQLiteKV mmkv = Config.getMMKV(this);
        mDataParse.indexParamVo.setMA1(Integer.valueOf(mmkv.getString("MA1","7")));
        mDataParse.indexParamVo.setMA2(Integer.valueOf(mmkv.getString("MA2","25")));
        mDataParse.indexParamVo.setMA3(Integer.valueOf(mmkv.getString("MA3","99")));
        mDataParse.indexParamVo.setMA4(Integer.valueOf(mmkv.getString("MA4","60")));
        mDataParse.indexParamVo.setMA5(Integer.valueOf(mmkv.getString("MA5","120")));

        mDataParse.indexParamVo.setMa1Toggle(mmkv.getBoolean("ma_ck_01", true));
        mDataParse.indexParamVo.setMa2Toggle(mmkv.getBoolean("ma_ck_02", true));
        mDataParse.indexParamVo.setMa3Toggle(mmkv.getBoolean("ma_ck_03", true));
        mDataParse.indexParamVo.setMa4Toggle(mmkv.getBoolean("ma_ck_04", false));
        mDataParse.indexParamVo.setMa5Toggle(mmkv.getBoolean("ma_ck_05", false));

        mDataParse.indexParamVo.setEma1Toggle(mmkv.getBoolean("ema_ck_01", true));
        mDataParse.indexParamVo.setEma2Toggle(mmkv.getBoolean("ema_ck_02", true));
        mDataParse.indexParamVo.setEma3Toggle(mmkv.getBoolean("ema_ck_03", true));
        mDataParse.indexParamVo.setEma4Toggle(mmkv.getBoolean("ema_ck_04", false));
        mDataParse.indexParamVo.setEma5Toggle(mmkv.getBoolean("ema_ck_05", false));

        mDataParse.indexParamVo.setEMA1(Integer.valueOf(mmkv.getString("EMA1","7")));
        mDataParse.indexParamVo.setEMA2(Integer.valueOf(mmkv.getString("EMA2","25")));
        mDataParse.indexParamVo.setEMA3(Integer.valueOf(mmkv.getString("EMA3","99")));
        mDataParse.indexParamVo.setEMA4(Integer.valueOf(mmkv.getString("EMA4","60")));
        mDataParse.indexParamVo.setEMA5(Integer.valueOf(mmkv.getString("EMA5","120")));

        mDataParse.indexParamVo.setRSI1(Integer.valueOf(mmkv.getString("RSI1","6")));
        mDataParse.indexParamVo.setRSI2(Integer.valueOf(mmkv.getString("RSI2","12")));
        mDataParse.indexParamVo.setRSI3(Integer.valueOf(mmkv.getString("RSI3","24")));

        mDataParse.indexParamVo.setK(Integer.valueOf(mmkv.getString("K","9")));
        mDataParse.indexParamVo.setD(Integer.valueOf(mmkv.getString("D","3")));
        mDataParse.indexParamVo.setJ(Integer.valueOf(mmkv.getString("J","3")));

        mDataParse.indexParamVo.setBoll_md(Integer.valueOf(mmkv.getString("boll_md","20")));
        mDataParse.indexParamVo.setBoll_up(Integer.valueOf(mmkv.getString("boll_up","2")));

        mDataParse.indexParamVo.setMacd_short(Integer.valueOf(mmkv.getString("macd_short","12")));
        mDataParse.indexParamVo.setMacd_long(Integer.valueOf(mmkv.getString("macd_long","26")));
        mDataParse.indexParamVo.setMacd_ma(Integer.valueOf(mmkv.getString("macd_ma","9")));
    }

    private String getSubscribeArgs()
    {
        String args = "kline@%s@%s@%s";
        args = String.format(args, currSymbol, currExchangeName, currPeriod);
        MLog.d("kline args:" + args);
        return args;
    }

    private String getArgsNoPeriod()
    {
        String args = "kline@%s@%s";
        args = String.format(args, currSymbol, currExchangeName);
        return args;
    }

    private String getTickersArg()
    {
        String args = "tickers@%s@%s@";
        args = String.format(args, currSymbol, currExchangeName);
        return args;
    }

    //K线界面右上角 更新24h最高价，最低价，24H成交量 ，实时百分比
    private void updateSymbolExtraInfo(SymbolRealPriceVo<SymbolExtraInfoVo> responseVo)
    {
        SymbolExtraInfoVo vo = (SymbolExtraInfoVo)responseVo.getData();
        tv_24h_high_price.setText(vo.getHigh24h());
        tv_24h_low_price.setText(vo.getLow24h());
        //tv_24h_vol.setText(AppUtils.getFormatStringValue(vo.getVol24h(), 2));
        if (!TextUtils.isEmpty(vo.getTurnover24h()))
        {
           tv_24h_vol.setText(AppUtils.getFormatStringValue(vo.getTurnover24h(), 2));
        }
        else
        {
           tv_24h_vol.setText("--");
        }

        tv_percent.setText(AppUtils.getFormatStringValue(vo.getPriceChange24h(), 2) + "%");
        if (Float.parseFloat(vo.getPriceChange24h()) >= 0)
        {
            tv_percent.setTextColor(Config.greenColor);
        }
        else
        {
            tv_percent.setTextColor(Config.redColor);
        }
    }

    //添加一个新的数值点到vip指标list数据中
    private void addAPoint2VipIndexData()
    {
        for (int i = 2; i < mChartManager.getNodeCount(); i++)
        {
            ChartNode node = mChartManager.getNode(i);
            if (node.chartType == ChartNode.ChartType.TOP_POSITION_RATIO)
            {
                int cnt = mDataParse.longShortPositionVo.getLongShortRatio().size();
                if (cnt > 0) {
                    float val = mDataParse.longShortPositionVo.getLongShortRatio().get(cnt - 1);
                    mDataParse.longShortPositionVo.getLongShortRatio().add(val);
                }
            }
            else if (node.chartType == ChartNode.ChartType.TOP_ACCOUNT_RATIO)
            {
                int cnt = mDataParse.longShortAccountVo.getLongShortRatio().size();
                if (cnt > 0){
                    float val = mDataParse.longShortAccountVo.getLongShortRatio().get(cnt - 1);
                    mDataParse.longShortAccountVo.getLongShortRatio().add(val);
                }
            }
            else if (node.chartType == ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO)
            {
                int cnt = mDataParse.longShortPersonVo.getLongShortRatio().size();
                if (cnt > 0){
                    float val = mDataParse.longShortPersonVo.getLongShortRatio().get(cnt - 1);
                    mDataParse.longShortPersonVo.getLongShortRatio().add(val);
                }
            }
            else if (node.chartType == ChartNode.ChartType.OPENINTEREST)
            {
                int cnt = mDataParse.vipIndexObj.oiList.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.oiList.get(cnt - 1);
                    mDataParse.vipIndexObj.oiList.add(val);
                }
            }
            else if (node.chartType == ChartNode.ChartType.FUNDING_RATE)
            {
                int cnt = mDataParse.vipIndexObj.fundingRateList.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.fundingRateList.get(cnt - 1);
                    mDataParse.vipIndexObj.fundingRateList.add(val);
                }
            }
            else if (node.chartType == ChartNode.ChartType.OI_FR)
            {
                int cnt = mDataParse.vipIndexObj.oiWeightFrData.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.oiWeightFrData.get(cnt - 1);
                    mDataParse.vipIndexObj.oiWeightFrData.add(val);
                }
            }
            else if (node.chartType == ChartNode.ChartType.VOL_FR)
            {
                int cnt = mDataParse.vipIndexObj.volumeWeightFrData.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.volumeWeightFrData.get(cnt - 1);
                    mDataParse.vipIndexObj.volumeWeightFrData.add(val);
                }
            }
            else if (node.chartType == ChartNode.ChartType.OI_DELTA)
            {
                int cnt = mDataParse.vipIndexObj.oiDelta.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.oiDelta.get(cnt - 1);
                    mDataParse.vipIndexObj.oiDelta.add(val);
                }
            }
            else if (node.chartType == ChartNode.ChartType.SYMBOL_LIQUIDATION)
            {
                mDataParse.vipIndexObj.liqSymbolLongList.add(0.0F);
                mDataParse.vipIndexObj.liqSymbolShortList.add(0.0F);
            }
            else if (node.chartType == ChartNode.ChartType.COIN_LIQUIDATION)
            {
                mDataParse.vipIndexObj.liqCoinLongList.add(0.0F);
                mDataParse.vipIndexObj.liqCoinShortList.add(0.0F);
            }
            else if (node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE)
            {
                int cnt = mDataParse.vipIndexObj.frListK.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.frListK.get(cnt - 1).close;
                    KLineItem item = new KLineItem();
                    item.open = val;
                    item.close = val;
                    item.low = val;
                    item.high = val;
                    mDataParse.vipIndexObj.frListK.add(item);
                }
            }
            else if (node.chartType == ChartNode.ChartType.OI_KLINE)
            {
                int cnt = mDataParse.vipIndexObj.oiListK.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.oiListK.get(cnt - 1).close;
                    KLineItem item = new KLineItem();
                    item.open = val;
                    item.close = val;
                    item.low = val;
                    item.high = val;
                    mDataParse.vipIndexObj.oiListK.add(item);
                }

            }
            else if (node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K)
            {
                int cnt = mDataParse.vipIndexObj.lsAccountsRatioK.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.lsAccountsRatioK.get(cnt - 1).close;
                    KLineItem item = new KLineItem();
                    item.open = val;
                    item.close = val;
                    item.low = val;
                    item.high = val;
                    mDataParse.vipIndexObj.lsAccountsRatioK.add(item);
                }

            }
            else if (node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K)
            {
                int cnt = mDataParse.vipIndexObj.lsTopAccountsRatioK.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.lsTopAccountsRatioK.get(cnt - 1).close;
                    KLineItem item = new KLineItem();
                    item.open = val;
                    item.close = val;
                    item.low = val;
                    item.high = val;
                    mDataParse.vipIndexObj.lsTopAccountsRatioK.add(item);
                }

            }
            else if (node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K)
            {
                int cnt = mDataParse.vipIndexObj.lsTopAccountsRatioK.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.lsTopAccountsRatioK.get(cnt - 1).close;
                    KLineItem item = new KLineItem();
                    item.open = val;
                    item.close = val;
                    item.low = val;
                    item.high = val;
                    mDataParse.vipIndexObj.lsTopAccountsRatioK.add(item);
                }

            }
            else if (node.chartType == ChartNode.ChartType.COIN_OI_KLINE)
            {
                int cnt = mDataParse.vipIndexObj.coinOIListK.size();
                if (cnt > 0)
                {
                    float val = mDataParse.vipIndexObj.coinOIListK.get(cnt - 1).close;
                    KLineItem item = new KLineItem();
                    item.open = val;
                    item.close = val;
                    item.low = val;
                    item.high = val;
                    mDataParse.vipIndexObj.coinOIListK.add(item);
                }
            }
        }
    }

    //更新最后一根K线的实时价格
    private String s6 = "", lastPrice = "";
    private void refreshLastKlineLiveInfo(SymbolRealPriceVo<List<String>> responseVo)
    {
        String stime = responseVo.getData().get(0);
        float open = Float.parseFloat(responseVo.getData().get(2));
        float close = Float.parseFloat(responseVo.getData().get(3));
        float high = Float.parseFloat(responseVo.getData().get(4));
        float low = Float.parseFloat(responseVo.getData().get(5));
        s6 = responseVo.getData().get(6);
        if (TextUtils.isEmpty(s6)) s6 = "0";
        float vol = Float.parseFloat(s6);

        if (mDataParse == null)
        {
            return;
        }

        //if (mDataParse.pricePrecision == 0)
        {
            mDataParse.pricePrecision = AppUtils.getPrecision(responseVo.getData().get(3));
//            MLog.d("mDataParse.pricePrecision " + mDataParse.pricePrecision + " "
//                     + responseVo.getData().get(3));

        }

        boolean bTimePeriod = (tabLayout.getSelectedTabPosition() == 0 && getCurrPeriodSelIdx() == -1);
        CandleData candData = mChartKline.getCandleData();
        BarData volBarData = mChartVol.getBarData();
        //如果不是分时模式
        if (candData != null && !bTimePeriod) {
            int indexLast = getLastDataSetIndex(candData);
            //MLog.d("getLastDataSetIndex:" + indexLast);
            CandleDataSet candleSet = (CandleDataSet) candData.getDataSetByIndex(indexLast);
            BarDataSet barDataSet = (BarDataSet) volBarData.getDataSetByIndex(indexLast);
            if (candleSet != null) {
                int count = candleSet.getEntryCount();
                if (count > 0)
                {
                    lastPrice = tv_price.getText().toString();
                    tv_price.setText(AppUtils.getFormatStringValue(close, mDataParse.pricePrecision));

                    if (close > Float.parseFloat(lastPrice))
                    {
                        tv_price.setTextColor(green);
                    }
                    else
                    {
                        tv_price.setTextColor(red);
                    }


                    //如果websocket推送过来的实时k线开始时间戳大于 最后一根K线的开始时间，
                    //则认为是新的一根K线开始了，然后开始处理list，构造K线对象，插入到list最后面
                    long lastTi = Long.parseLong(mDataParse.getKlineItemsList().get(count - 1).timestamp);
                    long currTi = Long.parseLong(responseVo.getData().get(0).toString());
                    if (currTi > lastTi)
                    {
                        MLog.d("count " + count + " size:" + mDataParse.kLineList.size());
                        MLog.d("t1:" + mDataParse.getKlineItemsList().get(count - 1).timestamp);
                        MLog.d("t2:" + responseVo.getData().get(0).toString());
                        MLog.d("*********need add kline************");
                        //添加新K线
                        KLineItem item = new KLineItem();
                        item.timestamp =stime;
                        item.date = AppUtils.timeStamp2Date(stime);
                        item.open = open;
                        item.close = close;
                        item.high = high;
                        item.low = low;
                        item.vol = vol;
                        mDataParse.getKlineItemsList().add(item);
                        //vip指标在此作处理，添加新的一个图表点数据
                        addAPoint2VipIndexData();
                        configData();//刷新其它指标数据
                    }
                    else
                    {
                        candleSet.getEntries().get(count - 1).setOpen(open);
                        candleSet.getEntries().get(count - 1).setClose(close);
                        candleSet.getEntries().get(count - 1).setHigh(high);
                        candleSet.getEntries().get(count - 1).setLow(low);
                        barDataSet.getEntries().get(count - 1).setY(vol);
                        barDataSet.getEntries().get(count - 1).setData(close >= open ? 0 : 1);

                        mDataParse.getKlineItemsList().get(count - 1).open = open;
                        mDataParse.getKlineItemsList().get(count - 1).close = close;
                        mDataParse.getKlineItemsList().get(count - 1).high = high;
                        mDataParse.getKlineItemsList().get(count - 1).low = low;
                        mDataParse.getKlineItemsList().get(count - 1).vol = vol;

                        mDataParse.getVolBarEntries().get(count - 1).setY(vol);
                        mDataParse.getVolBarEntries().get(count - 1).setData(close >= open ? 0 : 1);
                    }

                    if (!isHighlight)
                    {
                        updateIndexLastVal(count-1);
                    }

                    int color = green;
                    if (close < open)
                    {
                        color = red;
                    }

                    //更新实时价格虚线
                    refreshLivePriceLine(open, close, count, false);

                    for (int i = 0; i < mChartManager.getNodeCount(); i++)
                    {
                        mChartManager.getNode(i).chart.notifyDataSetChanged();
                        mChartManager.getNode(i).chart.invalidate();
                    }
                }
            }
        }
        else if (bTimePeriod)
        {
            LineData minLineData = mChartKline.getLineData();
            if (minLineData != null)
            {
                LineDataSet minLineSet =  (LineDataSet)minLineData.getDataSetByIndex(0);
                BarDataSet barDataSet = (BarDataSet) volBarData.getDataSetByIndex(0);

                if (minLineSet != null && minLineSet.getEntryCount() > 0)
                {
                    int count = minLineSet.getEntryCount();

                    lastPrice = tv_price.getText().toString();
                    tv_price.setText(AppUtils.getFormatStringValue(close, mDataParse.pricePrecision));

                    if (close > Float.parseFloat(lastPrice))
                    {
                        tv_price.setTextColor(green);
                    }
                    else
                    {
                        tv_price.setTextColor(red);
                    }

                    long lastTi = Long.parseLong(mDataParse.getKlineItemsList().get(count - 1).timestamp);
                    long currTi = Long.parseLong(responseVo.getData().get(0).toString());

                    if (currTi > lastTi)
                    {
                        MLog.d("t1:" + mDataParse.getKlineItemsList().get(count - 1).timestamp);
                        MLog.d("t2:" + responseVo.getData().get(0).toString());
                        MLog.d("*********need add kline************");
                        //添加新K线
                        KLineItem item = new KLineItem();
                        item.timestamp =stime;
                        item.date = AppUtils.timeStamp2Date(stime);
                        item.open = open;
                        item.close = close;
                        item.high = high;
                        item.low = low;
                        item.vol = vol;
                        mDataParse.getKlineItemsList().add(item);
                        addAPoint2VipIndexData();
                        configData();
                    }
                    else
                    {
                        barDataSet.getEntries().get(count - 1).setY(vol);
                        barDataSet.getEntries().get(count - 1).setData(close >= open ? 0 : 1);
                        minLineSet.getEntries().get(count - 1).setY(close);

                        mDataParse.getKlineItemsList().get(count - 1).open = open;
                        mDataParse.getKlineItemsList().get(count - 1).close = close;
                        mDataParse.getKlineItemsList().get(count - 1).high = high;
                        mDataParse.getKlineItemsList().get(count - 1).low = low;
                        mDataParse.getKlineItemsList().get(count - 1).vol = vol;

                        mDataParse.getVolBarEntries().get(count - 1).setY(vol);
                        mDataParse.getVolBarEntries().get(count - 1).setData(close >= open ? 0 : 1);
                    }

                    if (!isHighlight)
                    {
                        updateIndexLastVal(count-1);
                    }

                    int textColor = green;
                    if (close < open)
                    {
                        textColor = red;
                    }
                    //int lineColor = ContextCompat.getColor(this, android.R.color.transparent);
                    refreshLivePriceLine(open, close, count, false);

                    for (int i = 0; i < mChartManager.getNodeCount(); i++)
                    {
                        mChartManager.getNode(i).chart.notifyDataSetChanged();
                        mChartManager.getNode(i).chart.invalidate();
                    }
                }
            }
        }
    }

    //更新K线实时价格虚线，修改了图表库源码
    private void refreshLivePriceLine(float open, float close, int count, boolean isRefresh)
    {
        int bgcolor = green;
        if (close < open)
        {
            bgcolor = red;
        }

        LimitLine hightLimit = new LimitLine(
                close, AppUtils.getFormatStringValue(close, mDataParse.pricePrecision));
        hightLimit.setLineWidth(0.5F);  //设置线宽
        hightLimit.setTextSize(10f);   //设置限制线上label字体大小
        hightLimit.setLineColor(bgcolor); //设置线的颜色 getColorById(R.color.white)
        hightLimit.setTextColor(bgcolor);  //设置限制线上label字体的颜色
        hightLimit.setLabelPosition(LimitLine.LimitLabelPosition.RIGHT_TOP);//标签位置
        hightLimit.enableDashedLine(5f,4.0F,0);  //设置虚线
        hightLimit.setTextStyle(Paint.Style.FILL_AND_STROKE);
        //修改了图表库LimitLine类，实现了倒计时框的绘制
        hightLimit.setLabelBgColor(graydashline);
        hightLimit.setExtLabel(AppUtils.getDifTime(System.currentTimeMillis(),
                Long.valueOf(mDataParse.getKlineItemsList().get(count - 1).timestamp) + getPeriodMillis()));


        mChartKline.getAxisRight().setDrawLimitLinesBehindData(false);
        mChartKline.getAxisRight().removeAllLimitLines(); //先清除原来的线
        mChartKline.getAxisRight().addLimitLine(hightLimit);

        if (isRefresh)
        {
            mChartKline.notifyDataSetChanged();
            mChartKline.invalidate();
        }
    }

    private long getPeriodMillis()
    {
        long ms = 1000;
        String[] s_period = {"1m", "3m", "5m", "30m", "2h",
                "6h", "8h", "12h", "1d","1h", "4h", "15m"};
        long[] s_period_millis = {60, 180, 300, 1800, 2*3600, 6*3600, 8*3600, 12*3600, 24*3600,
                                3600, 4*3600, 15*60};
        int len = s_period.length;
        for (int i = 0; i < len; i++)
        {
           if (currPeriod.equals(s_period[i]))
           {
               return ms*s_period_millis[i];
           }
        }

        return 0;
    }

    /**
     * 获取最后一个CandleDataSet的索引
     */
    private int getLastDataSetIndex(CandleData candleData) {
        int dataSetCount = candleData.getDataSetCount();
        return dataSetCount > 0 ? (dataSetCount - 1) : 0;
    }

    private void removeFavoriteSymbol(SymbolVo symbolVo)
    {
        if (favoriteList.contains(symbolVo))
        {
            favoriteList.remove(symbolVo);
            saveFavoriteList();
        }
    }

    private void addFavoriteSymbol(SymbolVo symbolVo)
    {
        if (!favoriteList.contains(symbolVo))
        {
            favoriteList.add(symbolVo);
            saveFavoriteList();
        }
    }

    private void saveFavoriteList()
    {
        Gson gson = new GsonBuilder().create();
        String s = gson.toJson(favoriteList);
        Config.getMMKV(this).putString(Config.CONF_KLINE_FAVORITE_SYMBOL, s);
    }

    private String getFloatPointLen()
    {
        String json = Config.getMMKV(getApplicationContext()).getString(Config.CONF_ALL_SYMBOLS, "");

        ResponseSymbolVo mData = new ResponseSymbolVo();
        Gson gson = new GsonBuilder().create();
        mData = gson.fromJson(json, new TypeToken<ResponseSymbolVo>() {}.getType());
        if (mData != null && mData.getData() != null && mData.getData().size() > 0)
        {
            for (int i = 0; i < mData.getData().size(); i++)
            {
                SymbolVo vo = mData.getData().get(i);
                if (vo.getSymbol().equals(currSymbol) && vo.getExchangeName().equals(currExchangeName))
                {
                    MLog.d("sss:" + String.format("%f", Float.parseFloat(vo.getPricePrecision())));
                    MLog.d("vo.getPricePrecision:" + vo.getPricePrecision());
                    MLog.d("\n####coin len:" + AppUtils.getPrecision(vo.getPricePrecision()));
                    return vo.getPricePrecision();
                }
            }
        }

        return "0.01";
    }

    private String getCurrSymbolJson()
    {
        Gson gson = new GsonBuilder().create();
        String s = gson.toJson(getCurrentSymbol());
        MLog.d("symbol json:" + s);
        return s;
    }

    private SymbolVo getCurrentSymbol()
    {
        SymbolVo vo = new SymbolVo();
        vo.setExchangeName(currExchangeName);
        vo.setSymbol(currSymbol);
        vo.setDeliveryType(currSwapType);
        vo.setbSel(true);
        vo.setBaseCoin(currBaseCoin);
        vo.setPricePrecision(getFloatPointLen());

        return vo;
    }

    //打开K线界面下边的实时挂单和最新成交
    private void openDepthPage() {
        FragmentTransaction ft = mFragmentManager.beginTransaction();
        Bundle mBundle = null;
        ft.add(R.id.fl_market_order,
                marketOrderWebView = EmbedWebviewFragment.getInstance(mBundle = new Bundle()), EmbedWebviewFragment.class.getName());
        MLog.d("depth url:" + Config.urlDepth);
        mBundle.putString(EmbedWebviewFragment.URL_KEY, Config.urlDepth);
        ft.commit();
    }

    private void initView() {

        openDepthPage();//打开K线界面下边的webview，用来显示实时挂单和最新成交订单数据

        ll_pullview = (PullScrollView)findViewById(R.id.ll_pullscrollview);
        ll_pullview.setPullUpEnable(false);
        //ll_pullview.setPullDownEnable(false);
        ll_pullview.setListener(new PullScrollView.OnPullDownListener() {
            @Override
            public void doEvent() {
                if (isHighlight)
                {
                    ll_pullview.setPullDownEnable(false);
                }
            }
        });


        mRefreshLayout = (PullToRefreshLayout)findViewById(R.id.pullToRefreshLayout);
        mRefreshLayout.getRefreshFooterView().setVisibility(View.GONE);
        ResourceConfig resourceConfig = new ResourceConfig() {

            @Override
            public int[] configImageResIds() {
                return null;
            }

            @Override
            public int[] configTextResIds() {
                return new int[]{R.string.pull_to_refresh, R.string.release_to_refresh, R.string.refreshing,
                        R.string.refresh_succeeded, R.string.refresh_failed, R.string.pull_up_to_load,
                        R.string.release_to_load, R.string.loading, R.string.load_succeeded,
                        R.string.load_failed};
            }
        };

        //mRefreshLayout.setShowRefreshResultEnable(true);
        mRefreshLayout.setResourceConfig(resourceConfig);
        mRefreshLayout.setOnRefreshListener(new PullToRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
                WebSocketUtils.getInstance().deinitWebSocket();//先销毁
                WebSocketUtils.getInstance().createWebSocket();//创建
                loadNewData(getSubscribeArgs());
            }

            @Override
            public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
            }
        });

        rl_title.setOnClickListener(this);
        iv_mul_kline.setOnClickListener(this);
        iv_mul_kline.setVisibility(View.VISIBLE);
        iv_favorite.setOnClickListener(this);
        iv_favorite.setVisibility(View.VISIBLE);
        iv_switch_symbol.setVisibility(View.VISIBLE);
        tv_swap_type.setVisibility(View.VISIBLE);
        mBackImageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        ImageView ivOri = findViewById(R.id.iv_klOrientation);
        if (!Config.getMMKV(this).getBoolean(Config.DAY_NIGHT_MODE, false))
        {
            ivOri.setImageResource(R.drawable.kline_go_land_light);
        }

        tabLayout = findViewById(R.id.tl_kl);
        tv_price = findViewById(R.id.tv_price);
        TextView tv_setting = findViewById(R.id.tv_setting);
        tvMoreTime = findViewById(R.id.tv_more_time);
        tv_chart_vol = findViewById(R.id.tv_chart_vol);

        tv_percent = findViewById(R.id.tv_percent);
        tv_24h_high_price = findViewById(R.id.tv_24h_high_price);
        tv_24h_low_price = findViewById(R.id.tv_24h_low_price);
        tv_24h_vol = findViewById(R.id.tv_24h_vol);


        ll_highlightview = findViewById(R.id.high_view);
        tv_datetime = findViewById(R.id.tv_datetime);
        tv_open = findViewById(R.id.tv_open);
        tv_high = findViewById(R.id.tv_high);
        tv_low = findViewById(R.id.tv_low);
        tv_close = findViewById(R.id.tv_close);
        tv_chg = findViewById(R.id.tv_chg);
        tv_ampl = findViewById(R.id.tv_ampl);
        tv_highlight_vol = findViewById(R.id.tv_highlight_vol);
        ll_highlightview.setVisibility(View.INVISIBLE);

        TextView tvIndicator = findViewById(R.id.tv_indic);
        tvLine = findViewById(R.id.tv_klLineInfo);

        mChartKline = findViewById(R.id.cc_kl);
        mChartVol = findViewById(R.id.bc_kl);

        ivOri.setOnClickListener(this);
        tvMoreTime.setOnClickListener(this);
        tvIndicator.setOnClickListener(this);
        tv_setting.setOnClickListener(this);

        initPeriodStatus();
        setKLineChartHeight(Config.getMMKV(this).getInt(Config.CONF_KCHART_HEIGHT, 80));
        for (int i = 0; i < tabKlineTimeText.length; i++) {
            TextView v = (TextView) LayoutInflater.from(this).inflate(R.layout.item_tab_kline, null);
            v.setText(tabKlineTimeText[i]);
            tabLayout.addTab(tabLayout.newTab().setCustomView(v), i == klinePeriodIndex);
        }
        tabLayout.addOnTabSelectedListener(this);

        mChartManager.removeAllNode();
        this.mChartManager.addNode(new ChartNode(mChartKline));
        this.mChartManager.addNode(new ChartNode(mChartVol));
        initKlineChart();
        initKLineDataSet();
        initVolChart();
        initVolChartDataSet();

        loadIndicChartsConfig();
    }

    //初始化K线周期选择状态
    private void initPeriodStatus()
    {
        klinePeriodIndex = -1;
        int len = TAB_KLINE_ARGS.length;
        boolean b = Config.getMMKV(this).getBoolean(Config.CONF_IS_MIN_PERIOD, false);

        if (b && TAB_KLINE_ARGS[0].equals(currPeriod))
        {
            klinePeriodIndex = 0;
            return;
        }

        for (int i = 1; i < len; i++)
        {
            if (TAB_KLINE_ARGS[i].equals(currPeriod))
            {
                klinePeriodIndex = i;
                return;
            }
        }

        int len2 = KLINE_STR_TEXT.length;
        for (int i = 0; i < len2; i++)
        {
            if (KLINE_STR_TEXT[i].equals(currPeriod))
            {
                tvMoreTime.setTextColor(bluecolor);
                tvMoreTime.setText(KLINE_STR_TEXT[i]);
                break;
            }
        }


        if (currPeriod.equals("1M"))
        {
            currPeriod = "1M";
            tvMoreTime.setTextColor(bluecolor);
            tvMoreTime.setText(KLINE_STR_TEXT[len2 - 1]);
        }
    }

    private void setKlineStyle()
    {
        if (0 == Config.getMMKV(getApplicationContext()).getInt(Config.CONF_UP_CANDLE_STYLE, 1))
        {
            candleSet.setIncreasingPaintStyle(Paint.Style.STROKE);
        }
        else
        {
            candleSet.setIncreasingPaintStyle(Paint.Style.FILL);
        }
    }

    private void setMaLineWidth()
    {
        float line_width = Config.getMMKV(this).getFloat(Config.CONF_MA_LINE_WIDTH,
                Config.line_width_small);
        ma01set.setLineWidth(line_width);
        ma02set.setLineWidth(line_width);
        ma03set.setLineWidth(line_width);
        ma04set.setLineWidth(line_width);
        ma05set.setLineWidth(line_width);

    }

    private void initKLineDataSet()
    {
        float highlightWidth = 0.5F;//高亮线的线宽
        //蜡烛图
        candleSet = new CandleDataSet(new ArrayList<CandleEntry>(), "Kline");
        candleSet.setAxisDependency(YAxis.AxisDependency.LEFT);
        candleSet.setDrawHorizontalHighlightIndicator(false);
        candleSet.setHighlightLineWidth(highlightWidth);
        candleSet.setHighLightColor(highlightColor);
        candleSet.setShadowWidth(0.7f);
        candleSet.setIncreasingColor(green);//上涨为green
        candleSet.setIncreasingPaintStyle(Paint.Style.FILL);
        setKlineStyle();

        candleSet.setDecreasingColor(red);//下跌为red
        candleSet.setDecreasingPaintStyle(Paint.Style.FILL);
        candleSet.setNeutralColor(green);
        candleSet.setShadowColorSameAsCandle(true);
        candleSet.setDrawValues(false);
        candleSet.setHighlightEnabled(false);
        candleSet.setValueTextColor(ContextCompat.getColor(this, R.color.yellow));
        //均线
        ma01set = new LineDataSet(new ArrayList<Entry>(), "MA1");
        ma01set.setAxisDependency(YAxis.AxisDependency.LEFT);
        ma01set.setDrawCircles(false);
        ma01set.setDrawValues(false);
        ma01set.setHighlightEnabled(false);

        ma02set = new LineDataSet(new ArrayList<Entry>(), "MA2");
        ma02set.setAxisDependency(YAxis.AxisDependency.LEFT);
        ma02set.setDrawCircles(false);
        ma02set.setDrawValues(false);
        ma02set.setHighlightEnabled(false);

        ma03set = new LineDataSet(new ArrayList<Entry>(), "MA3");
        ma03set.setAxisDependency(YAxis.AxisDependency.LEFT);
        ma03set.setDrawCircles(false);
        ma03set.setDrawValues(false);
        ma03set.setHighlightEnabled(false);

        ma04set = new LineDataSet(new ArrayList<Entry>(), "MA4");
        ma04set.setAxisDependency(YAxis.AxisDependency.LEFT);
        ma04set.setDrawCircles(false);
        ma04set.setDrawValues(false);
        ma04set.setHighlightEnabled(false);

        ma05set = new LineDataSet(new ArrayList<Entry>(), "MA4");
        ma05set.setAxisDependency(YAxis.AxisDependency.LEFT);
        ma05set.setDrawCircles(false);
        ma05set.setDrawValues(false);
        ma05set.setHighlightEnabled(false);

        setMaLineWidth();


        //分时线
        lineSetMin = new LineDataSet(new ArrayList<Entry>(), "Minutes");
        lineSetMin.setAxisDependency(YAxis.AxisDependency.LEFT);
        lineSetMin.setColor(sub_chart_single_color);//Color.WHITE
        lineSetMin.setHighLightColor(highlightColor);
        lineSetMin.setDrawCircles(false);
        lineSetMin.setDrawValues(false);
        lineSetMin.setHighlightEnabled(false);
        lineSetMin.setDrawFilled(true);//填充方式画
        lineSetMin.setFillColor(sub_chart_single_color);//填充颜色 gray
        lineSetMin.setFillAlpha(60);
    }

    private void initVolChartDataSet()
    {
        float highlightWidth = 0.5F;//高亮线的线宽

        //vol均线
        vma5set = new LineDataSet(new ArrayList<Entry>(), "VMA5");
        vma5set.setAxisDependency(YAxis.AxisDependency.LEFT);
        vma5set.setColor(getColorById(R.color.purple));
        vma5set.setDrawCircles(false);
        vma5set.setDrawValues(false);
        vma5set.setHighlightEnabled(false);

        vma10set = new LineDataSet(new ArrayList<Entry>(), "VMA10");
        vma10set.setAxisDependency(YAxis.AxisDependency.LEFT);
        vma10set.setColor(getColorById(R.color.yellow));
        vma10set.setDrawCircles(false);
        vma10set.setDrawValues(false);
        vma10set.setHighlightEnabled(false);

        volBarSet = new BarDataSet(new ArrayList<BarEntry>(), "VOL");
        volBarSet.setHighLightColor(highlightColor);
        volBarSet.setColors(green, red);
        volBarSet.setDrawValues(false);
        volBarSet.setHighlightEnabled(false);
    }


    private int getCurrPeriodSelIdx()
    {
        for(int i = 0; i < KLINE_PERIOD_ID_ARRA.length; i++)
        {
            if(klineTvArrs[i] != null && klineTvArrs[i].getText().toString().contains(tvMoreTime.getText().toString()))
            {
                return i;
            }
        }

        return -1;
    }

    private void setPopupBtnColor(int sel_idx, boolean isShow)
    {
        int gray = getColorById(R.color.blackgray);
        if(isShow)
        {
            for(int i = 0; i < KLINE_PERIOD_ID_ARRA.length; i++)
            {
                if(sel_idx == i){
                    klineTvArrs[i].setTextColor(bluecolor);//设置选中为蓝色
                }
                else{
                    klineTvArrs[i].setTextColor(gray);
                }
            }
        }

        if(sel_idx >= 0)
        {
            tvMoreTime.setTextColor(bluecolor);
            tvMoreTime.setText(KLINE_STR_TEXT[sel_idx]);
        }
        else
        {
            tvMoreTime.setTextColor(gray);
            tvMoreTime.setText(getResources().getString(R.string.s_more_time));
            MLog.d("tvSelTime  22");
        }
    }

    private void doKLinePeroidChangeListener(int resid)
    {
        int sel_idx = -1;
        for(int i = 0; i < KLINE_PERIOD_ID_ARRA.length; i++){
            if(resid == KLINE_PERIOD_ID_ARRA[i])
            {
                MLog.d("doKLinePeroidChangeListener:" + KLINE_STR_TEXT[i]);
                stopTranslate();
                sel_idx = i;
                removeTabSelStage();
                setPopupBtnColor(sel_idx, true);
                mPeriodPopupMenu.dismiss();
                //WebSocketUtils.getInstance().removeSubscribe(getSubscribeArgs());
                WebSocketUtils.getInstance().removeAllSubscribe();
                currPeriod = KLINE_STR_TEXT[i];
                if (currPeriod.equals("1mon"))
                {
                    currPeriod = "1M";
                }
                Config.getMMKV(this).putString(Config.CONF_KLINE_PERIOD, currPeriod);
                Config.getMMKV(this).putBoolean(Config.CONF_IS_MIN_PERIOD, false);
                loadData();
                WebSocketUtils.getInstance().addSubscribe(getSubscribeArgs());
                return;
            }
        }

        setPopupBtnColor(sel_idx, false);
    }

    private PopupWindow mPeriodPopupMenu, mIndicPopupMenu;
    private void showIndicPopupMenu(View view) {
        View contentView = LayoutInflater.from(mCot).inflate(R.layout.layout_popup_indic, null);

        mIndicPopupMenu = new PopupWindow(contentView, ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT, true);
        mIndicPopupMenu.setTouchable(true);
        mIndicPopupMenu.setOutsideTouchable(true);
        mIndicPopupMenu.setTouchInterceptor(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return false;
            }
        });

        initIndicPopupBtns(contentView);
        mIndicPopupMenu.setBackgroundDrawable(mCot.getResources().getDrawable(R.color.colorPrimary));
        int width = mIndicPopupMenu.getWidth();
        int[] xy = new int[2];
        view.getLocationInWindow(xy);
        float y = xy[1] + tabLayout.getHeight();
        mIndicPopupMenu.showAtLocation(view, Gravity.NO_GRAVITY,
                0, (int)y);
    }

    //从配置中加载指标
    private void loadIndicChartsConfig()
    {
        mainChartIndicIdx = Config.getMMKV(this).
                getInt(Config.CONF_MAIN_CHART_INDIC, ChartNode.ChartType.CHART_NONE);
        mapSubCharts = getSubCharts();
        //如果第一次进入 K线界面，则默认添加下边3个指标
        if (mapSubCharts.size() <= 0 && Config.getMMKV(this).
                getBoolean(Config.CONF_IS_FIRST_ENTER_KLINE_PAGE, true))
        {
            Config.getMMKV(this).
                    putBoolean(Config.CONF_IS_FIRST_ENTER_KLINE_PAGE, false);
            mapSubCharts.put(ChartNode.ChartType.OI_KLINE, 1);
            mapSubCharts.put(ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO, 1);
            mapSubCharts.put(ChartNode.ChartType.OI_DELTA, 1);
            saveSubChartsConfig();//更新副图指标配置
        }

        for(Integer key : mapSubCharts.keySet()) {
            addChart(key.intValue(), false);
        }
    }

    private int mainChartIndicIdx = ChartNode.ChartType.CHART_NONE;
    //key sub chart chartType  value 1
    private Map<Integer,Integer> mapSubCharts;
    private Map<Integer,Integer> getSubCharts()
    {
        String json = Config.getMMKV(this).getString(Config.CONF_SUB_CHART_INDIC, "");
        Gson gson = new GsonBuilder().create();
        Map<Integer,Integer> map = gson.fromJson(json, new TypeToken<Map<Integer,Integer>>() {
        }.getType());


        if (map == null) {
            map = new HashMap<>();
        }

        return map;
    }

    private void saveSubChartsConfig()
    {
        Gson gson = new GsonBuilder().create();
        String json = gson.toJson(mapSubCharts);
        Config.getMMKV(this).putString(Config.CONF_SUB_CHART_INDIC, json);
    }

    private void initIndicPopupBtns(View view)
    {
        for(int i = 0; i < mainResIds.length; i++) {
            mainChartIndicArrs[i] = (TextView) view.findViewById(mainResIds[i]);
            mainChartIndicArrs[i].setOnClickListener(this);
        }

        int mainIndic = Config.getMMKV(this).getInt(Config.CONF_MAIN_CHART_INDIC, ChartNode.ChartType.CHART_NONE);
        if (mainIndic != ChartNode.ChartType.CHART_NONE)
        {
            mainChartIndicArrs[mainIndic].setTextColor(bluecolor);
        }

        //值参考ChartNode.ChartType
        for(int i = 0; i < subResIds.length; i++){
            subChartIndicArrs[i] = (TextView) view.findViewById(subResIds[i]);
            subChartIndicArrs[i].setOnClickListener(this);
            if (mapSubCharts.containsKey(i))
            {
                subChartIndicArrs[i].setTextColor(bluecolor);
            }
        }

    }

    //主图指标点击事件
    private void doMainIndicClick(View view)
    {
        int mainIndic = Config.getMMKV(this).
                getInt(Config.CONF_MAIN_CHART_INDIC, ChartNode.ChartType.CHART_NONE);
        for (int j = 0; j < mainResIds.length; j++)
        {
            mainChartIndicArrs[j].setTextColor(blackgray);
        }

        for (int i = 0; i < mainResIds.length; i++)
        {
            if (view.getId() == mainResIds[i] )
            {
                //如果之前是选中，则取消，并更新配置
                if (mainIndic == i)
                {
                    Config.getMMKV(this).
                            putInt(Config.CONF_MAIN_CHART_INDIC, ChartNode.ChartType.CHART_NONE);
                }
                else
                {
                    //如果之前没有选中，则选中并更新配置
                    mainChartIndicArrs[i].setTextColor(bluecolor);
                    Config.getMMKV(this).
                            putInt(Config.CONF_MAIN_CHART_INDIC, i);

                }

                stopTranslate();
                configData();
                mIndicPopupMenu.dismiss();
                break;
            }
        }

    }

    //副图指标按钮点击事件
    private void doSubIndicClick(View view)
    {
        for (int i = 0; i < subResIds.length; i++)
        {
            if (view.getId() == subResIds[i])
            {
                stopTranslate();//停止图表的左右滑动动画

                if (mapSubCharts.containsKey(i))
                {
                    subChartIndicArrs[i].setTextColor(blackgray);
                    mapSubCharts.remove(i);
                    saveSubChartsConfig();//更新副图指标配置
                    //去掉图表
                    removeChart(i);
                }
                else
                {
                    subChartIndicArrs[i].setTextColor(bluecolor);
                    mapSubCharts.put(i, 1);
                    saveSubChartsConfig();//更新副图指标配置
                    //添加图表
                    addChart(i, true);
                }

                mIndicPopupMenu.dismiss();
                break;
            }//end if
        }//END FOR
    }

    private void initPopupViewBtns(View view)
    {
        int len = KLINE_PERIOD_ID_ARRA.length;
        for(int i = 0; i < len; i++)
        {
            klineTvArrs[i] = (TextView) view.findViewById(KLINE_PERIOD_ID_ARRA[i]);
            klineTvArrs[i].setOnClickListener(this);
            if( klineTvArrs[i].getText().toString().equals(tvMoreTime.getText().toString()))
            {
                klineTvArrs[i].setTextColor(bluecolor);//设置选中周期颜色
            }
        }
    }

    private void showPopupMenu(View view) {
        View contentView = LayoutInflater.from(mCot).inflate(R.layout.layout_popup_sel_time, null);

        mPeriodPopupMenu = new PopupWindow(contentView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT, true);
        mPeriodPopupMenu.setTouchable(true);
        mPeriodPopupMenu.setOutsideTouchable(true);
        mPeriodPopupMenu.setTouchInterceptor(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return false;
            }
        });

        initPopupViewBtns(contentView);
        mPeriodPopupMenu.setBackgroundDrawable(mCot.getResources().getDrawable(R.color.colorPrimary));
        int width = mPeriodPopupMenu.getWidth();
        int[] xy = new int[2];
        view.getLocationInWindow(xy);
        float y = xy[1] + tabLayout.getHeight();
        //mPopupWindow.setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        mPeriodPopupMenu.showAtLocation(view, Gravity.NO_GRAVITY,
                0, (int)y);

//        mPopupWindow.showAsDropDown(view, 100, 100);
    }

    private void setKLineChartHeight(int height)
    {
        ViewGroup.LayoutParams params = mChartKline.getLayoutParams();
        params.height = (int)Utils.convertDpToPixel(150+height);
        mChartKline.setLayoutParams(params);
    }

    protected SeekBar seekbar;
    private void initSeekBar(View v)
    {
        seekbar = (SeekBar) v.findViewById(R.id.seek_height);
        int height = Config.getMMKV(this).getInt(Config.CONF_KCHART_HEIGHT, 80);
        seekbar.setProgress(height);
        seekbar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                MLog.d("onProgressChanged:" + seekBar.getProgress() + " " + progress);
                Config.getMMKV(getApplicationContext()).putInt(Config.CONF_KCHART_HEIGHT, progress);
                setKLineChartHeight(progress);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
                MLog.d("onStartTrackingTouch:" + seekBar.getProgress());
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                MLog.d(" onStopTrackingTouch:" + seekBar.getProgress());
                Config.getMMKV(getApplicationContext()).putInt(Config.CONF_KCHART_HEIGHT, seekBar.getProgress());
                setKLineChartHeight(seekBar.getProgress());
            }
        });
    }

    private void settingKlineChart(View view) {
        View contentView = LayoutInflater.from(mCot).inflate(R.layout.layout_popup_setting_chart_height, null);

        mPeriodPopupMenu = new PopupWindow(contentView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT, true);
        mPeriodPopupMenu.setTouchable(true);
        mPeriodPopupMenu.setOutsideTouchable(true);
        mPeriodPopupMenu.setTouchInterceptor(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return false;
            }
        });

        initSeekBar(contentView);
        mPeriodPopupMenu.setBackgroundDrawable(mCot.getResources().getDrawable(R.color.colorPrimary));
        int width = mPeriodPopupMenu.getWidth();
        int[] xy = new int[2];
        view.getLocationInWindow(xy);
        float y = xy[1] + tabLayout.getHeight();
        //mPopupWindow.setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        mPeriodPopupMenu.showAtLocation(view, Gravity.NO_GRAVITY,
                0, (int)y);

//        mPopupWindow.showAsDropDown(view, 100, 100);
    }

    //参数，副图指标类型
    private void removeChart(int chartType)
    {
        LinearLayout linearLayout = findViewById(R.id.ll_charts);
        RelativeLayout rll = mChartManager.getChartByType(chartType);
        mChartManager.removeNode(mChartManager.getNodeByType(chartType).chartIdx);
        linearLayout.removeView(rll);
    }

    private void addChart(int chartType, boolean isNeedReload)
    {
        LinearLayout linearLayout = findViewById(R.id.ll_charts);
        RelativeLayout rll = (RelativeLayout)(LayoutInflater.from(mCot).inflate(R.layout.layout_chart_item, null));
        ViewGroup.LayoutParams vlp = new ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                (int)Utils.convertDpToPixel(70));
        rll.setLayoutParams(vlp);
        linearLayout.addView(rll);

        ChartNode node = new ChartNode(this, rll, chartType);
        mChartManager.addNode(node);
        initSubChart(node);//初始化副图控件节点
        initSubChartDataSet(node);//初始化副图控件数据集
        setSubChartData(node);//设置副图数据
        //开启线程延时20毫秒,然后再把新添加的副图状态位置同K线主图进行同步
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(20);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                //在UI线程中执行syncCharts  刷新图表
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        syncCharts(mChartKline, node.chart);
                    }
                });
            }
        }).start();


        if (isNeedReload)
        {
            if (node.chartType >= ChartNode.ChartType.SUB_TYPE_MIN &&
                    node.chartType <= ChartNode.ChartType.SUB_TYPE_MAX)
            {
            /*
            WebSocketUtils.getInstance().deinitWebSocket();//先销毁
                WebSocketUtils.getInstance().createWebSocket();//创建
                loadNewData(getSubscribeArgs());
            */
                loadData();
            }
        }

    }



    private void syncCharts(CombinedChart srcChart, CombinedChart dstChart) {
        Matrix srcMatrix;
        float[] srcVals = new float[9];
        Matrix dstMatrix;
        float[] dstVals = new float[9];
        srcMatrix = srcChart.getViewPortHandler().getMatrixTouch();
        srcMatrix.getValues(srcVals);

        dstMatrix = dstChart.getViewPortHandler().getMatrixTouch();
        dstMatrix.getValues(dstVals);

        dstVals[Matrix.MSCALE_X] = srcVals[Matrix.MSCALE_X];
        dstVals[Matrix.MSKEW_X] = srcVals[Matrix.MSKEW_X];
        dstVals[Matrix.MTRANS_X] = srcVals[Matrix.MTRANS_X];
        dstVals[Matrix.MSKEW_Y] = srcVals[Matrix.MSKEW_Y];
        dstVals[Matrix.MSCALE_Y] = srcVals[Matrix.MSCALE_Y];
        dstVals[Matrix.MTRANS_Y] = srcVals[Matrix.MTRANS_Y];
        dstVals[Matrix.MPERSP_0] = srcVals[Matrix.MPERSP_0];
        dstVals[Matrix.MPERSP_1] = srcVals[Matrix.MPERSP_1];
        dstVals[Matrix.MPERSP_2] = srcVals[Matrix.MPERSP_2];

        dstMatrix.setValues(dstVals);
        dstChart.getViewPortHandler().refresh(dstMatrix, dstChart, true);
    }

    private void initKlineChart() {
        //K线
        mChartKline.setDragOffsetX(mDragOffsetX);
        mChartKline.setNoDataTextColor(gray);//无数据时提示文字的颜色
        mChartKline.setDescription(null);//取消描述
        mChartKline.getLegend().setEnabled(false);//取消图例

        mChartKline.setMinOffset(0);//设置外边缘偏移量
        mChartKline.setExtraBottomOffset(6);//设置底部外边缘偏移量 便于显示X轴

        mChartKline.setDoubleTapToZoomEnabled(false);
        mChartKline.setScaleEnabled(true);//可缩放
        mChartKline.setDragEnabled(true);
        mChartKline.setScaleYEnabled(false);
        mChartKline.setDragDecelerationEnabled(true);//惯性滑动
        mChartKline.setDragDecelerationFrictionCoef(Config.FrictionCoef);
        mChartKline.setAutoScaleMinMaxEnabled(true);

        mChartKline.setDrawOrder(new CombinedChart.DrawOrder[]{CombinedChart.DrawOrder.CANDLE,
                CombinedChart.DrawOrder.LINE});

        Transformer trans = mChartKline.getTransformer(YAxis.AxisDependency.RIGHT);
        //自定义X轴标签位置
        mChartKline.setXAxisRenderer(new InBoundXAxisRenderer(mChartKline.getViewPortHandler(), mChartKline.getXAxis(), trans, 10));
        //自定义Y轴标签位置
        mChartKline.setRendererLeftYAxis(new InBoundYAxisRenderer(mChartKline.getViewPortHandler(),
                mChartKline.getAxisLeft(), trans));
        mChartKline.setRendererRightYAxis(new InBoundYAxisRenderer(mChartKline.getViewPortHandler(),
                mChartKline.getAxisRight(), trans));

        //自定义渲染器 重绘高亮
        mChartKline.setRenderer(new HighlightCombinedRenderer(mChartKline,
                mChartKline.getAnimator(), mChartKline.getViewPortHandler(), Config.highlightTextSize));

        //X轴
        XAxis xac = mChartKline.getXAxis();
        xac.setPosition(XAxis.XAxisPosition.BOTTOM);
        xac.setGridColor(red);//网格线颜色
        xac.setDrawGridLines(false);//不画X轴竖线
        xac.setTextColor(gray);//标签颜色
        xac.setTextSize(8);//标签字体大小
        xac.setAxisLineColor(black);//轴线颜色
        xac.disableAxisLineDashedLine();//取消轴线虚线设置
        xac.setAvoidFirstLastClipping(true);//避免首尾端标签被裁剪
        xac.setLabelCount(4, true);//强制显示4个标签
        xac.setValueFormatter(new IAxisValueFormatter() {//转换X轴的数字为文字
            @Override
            public String getFormattedValue(float value, AxisBase axis) {
                int v = (int) value;
                if (!xValuesDatetime.containsKey(v) && xValuesDatetime.containsKey(v - 1)) {
                    v = v - 1;
                }
                String x = xValuesDatetime.get(v);
                return TextUtils.isEmpty(x) ? "" : x;
            }
        });

        //左Y轴带网格线
        YAxis yac = mChartKline.getAxisLeft();
        yac.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART);//标签显示在内侧
        yac.setGridColor(red);
        yac.setTextColor(gray);
        yac.setDrawGridLines(false);
        yac.setDrawAxisLine(false);
        yac.setDrawLabels(false);//不画label
        yac.setTextSize(8);
        yac.setLabelCount(6, false);
        yac.enableGridDashedLine(10, 10, 0);//横向网格线设置为虚线
        yac.setSpaceTop(10);
        yac.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {//只显示部分标签
                int index = getIndexY(value, axis.getAxisMinimum(), axis.getAxisMaximum());
                //return index == 0 || index == 2 ? format4p.format(value) : "";//不显示的标签不能返回null
                //return format4p.format(value);
                return "";
            }
        });

        YAxis yRight = mChartKline.getAxisRight();
        yRight.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART);//标签显示在内侧
        yRight.setGridColor(graydashline);
        yRight.setTextColor(blackgray);
        yRight.setDrawAxisLine(false);
        yRight.setGridLineWidth(0.4f);
        yRight.setTextSize(8);
        yRight.setDrawLabels(true);
        yRight.setLabelCount(6, true);
        yRight.enableGridDashedLine(10, 10, 0);//横向网格线设置为虚线
        yRight.setSpaceTop(10);
        yRight.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {//只显示部分标签
                int index = getIndexY(value, axis.getAxisMinimum(), axis.getAxisMaximum());
                return AppUtils.getFormatStringValue(value, mDataParse.pricePrecision);
            }
        });

        //右Y轴
        yRight.setEnabled(true);
    }

    private void initCandleChart(ChartNode node) {
        //K线
        node.chart.setDragOffsetX(mDragOffsetX);
        node.chart.setNoDataTextColor(gray);//无数据时提示文字的颜色
        node.chart.setDescription(null);//取消描述
        node.chart.getLegend().setEnabled(false);//取消图例

        node.chart.setMinOffset(0);//设置外边缘偏移量
        //node.chart.setExtraBottomOffset(6);//设置底部外边缘偏移量 便于显示X轴

        node.chart.setDoubleTapToZoomEnabled(false);
        node.chart.setScaleEnabled(true);//可缩放
        node.chart.setDragEnabled(true);
        node.chart.setScaleYEnabled(false);
        node.chart.setDragDecelerationEnabled(true);//惯性滑动
        node.chart.setDragDecelerationFrictionCoef(Config.FrictionCoef);
        node.chart.setAutoScaleMinMaxEnabled(true);

        node.chart.setDrawOrder(new CombinedChart.DrawOrder[]{CombinedChart.DrawOrder.CANDLE,
                CombinedChart.DrawOrder.LINE});

        Transformer trans = node.chart.getTransformer(YAxis.AxisDependency.RIGHT);
        //自定义X轴标签位置
        node.chart.setXAxisRenderer(new InBoundXAxisRenderer(node.chart.getViewPortHandler(), node.chart.getXAxis(), trans, 10));
        //自定义Y轴标签位置
        node.chart.setRendererLeftYAxis(new InBoundYAxisRenderer(node.chart.getViewPortHandler(),
                node.chart.getAxisLeft(), trans));
        node.chart.setRendererRightYAxis(new InBoundYAxisRenderer(node.chart.getViewPortHandler(),
                node.chart.getAxisRight(), trans));

        //自定义渲染器 重绘高亮
        node.chart.setRenderer(new HighlightCombinedRenderer(node.chart,
                node.chart.getAnimator(), node.chart.getViewPortHandler(), Config.highlightTextSize));

        //X轴
        XAxis xac = node.chart.getXAxis();
        xac.setPosition(XAxis.XAxisPosition.BOTTOM);
        xac.setGridColor(red);//网格线颜色
        xac.setDrawGridLines(false);//不画X轴竖线
        xac.setTextColor(gray);//标签颜色
        xac.setTextSize(8);//标签字体大小
        xac.setAxisLineColor(black);//轴线颜色
        xac.disableAxisLineDashedLine();//取消轴线虚线设置
        xac.setAvoidFirstLastClipping(true);//避免首尾端标签被裁剪
        xac.setLabelCount(4, true);//强制显示4个标签
        xac.setValueFormatter(new IAxisValueFormatter() {//转换X轴的数字为文字
            @Override
            public String getFormattedValue(float value, AxisBase axis) {
                return "";
            }
        });

        xac.setEnabled(false);//禁用X轴

        //左Y轴带网格线
        YAxis yac = node.chart.getAxisLeft();
        yac.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART);//标签显示在内侧
        yac.setGridColor(red);
        yac.setTextColor(gray);
        yac.setDrawGridLines(false);
        yac.setDrawAxisLine(false);
        yac.setDrawLabels(false);//不画label
        yac.setTextSize(8);
        yac.setLabelCount(2, false);
        //yac.enableGridDashedLine(10, 10, 0);//横向网格线设置为虚线
        yac.setSpaceTop(10);
        yac.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {//只显示部分标签
                int index = getIndexY(value, axis.getAxisMinimum(), axis.getAxisMaximum());
                //return index == 0 || index == 2 ? format4p.format(value) : "";//不显示的标签不能返回null
                //return format4p.format(value);
                return "";
            }
        });

        YAxis yRight = node.chart.getAxisRight();
        yRight.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART);//标签显示在内侧
        yRight.setGridColor(graydashline);
        yRight.setTextColor(blackgray);
        yac.setDrawGridLines(false);
        yac.setDrawAxisLine(false);
        yRight.setGridLineWidth(0.4f);
        yRight.setTextSize(8);
        yRight.setDrawLabels(true);
        yRight.setLabelCount(2, true);
        //yRight.enableGridDashedLine(10, 10, 0);//横向网格线设置为虚线
        yRight.setSpaceTop(10);
        yRight.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {//只显示部分标签
                int t = 0;
                if (node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE)
                {
                    t = 6;
                }

                if (node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K ||
                        node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K ||
                        node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K)

                {
                    t = 2;
                }

                return AppUtils.getFormatStringValue(value, t);
            }
        });

        //右Y轴
        yRight.setEnabled(true);
    }

    private void initSubChart(ChartNode node) {

        if (node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE ||
        node.chartType == ChartNode.ChartType.OI_KLINE ||
                node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K ||
                node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K ||
                node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K ||
        node.chartType == ChartNode.ChartType.COIN_OI_KLINE
        )
        {
            initCandleChart(node);
            return;
        }

        int black = getColorById(R.color.black3B);
        int gray = getColorById(R.color.gray8B);
        //成交量
        CombinedChart chart = node.chart;
        chart.setDragOffsetX(mDragOffsetX);
        chart.setDoubleTapToZoomEnabled(false);
        chart.setNoDataTextColor(gray);
        chart.setDescription(null);
        chart.getLegend().setEnabled(false);
        chart.setMinOffset(0);//设置外边缘偏移量
        chart.setDragEnabled(true);
        chart.setScaleEnabled(true);
        chart.setScaleYEnabled(false);
        chart.setDragDecelerationEnabled(true);
        chart.setDragDecelerationFrictionCoef(Config.FrictionCoef);

        //自定义Y轴标签位置
        chart.setRendererLeftYAxis(new InBoundYAxisRenderer(chart.getViewPortHandler(),
                chart.getAxisLeft(),
                chart.getTransformer(YAxis.AxisDependency.RIGHT)));//old left
        chart.setRendererRightYAxis(new InBoundYAxisRenderer(chart.getViewPortHandler(),
                chart.getAxisRight(),
                chart.getTransformer(YAxis.AxisDependency.RIGHT)));

        //设置渲染器控制颜色、偏移，以及高亮
        chart.setRenderer(new HighlightCombinedRenderer(chart,
                chart.getAnimator(), chart.getViewPortHandler(), Config.highlightTextSize));
        chart.setDrawOrder(new CombinedChart.DrawOrder[]{CombinedChart.DrawOrder.CANDLE, CombinedChart.DrawOrder.BAR,
                CombinedChart.DrawOrder.LINE});

        chart.getXAxis().setEnabled(false);
        YAxis yab = chart.getAxisLeft();
        yab.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART);//标签显示在内侧
        yab.setDrawAxisLine(false);
        yab.setGridColor(black);
        yab.setTextColor(gray);
        yab.setTextSize(8);
        yab.setSpaceTop(10);
        yab.setLabelCount(2, true);
        //yab.setAxisMinimum(0);//取消设置，负值才会画
        yab.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {
                return "";
            }
        });

        yab = chart.getAxisRight();
        yab.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART);//标签显示在内侧
        yab.setDrawAxisLine(false);
        yab.setGridColor(black);
        yab.setTextColor(gray);
        yab.setTextSize(8);
        yab.setSpaceTop(10);
        yab.setLabelCount(2, true);
        //yab.setAxisMinimum(0);//取消设置，负值才会画
        yab.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {
                if (value == 0)
                    return "";

                int t = 2;
                if (node.chartType == ChartNode.ChartType.KDJ ||
                        node.chartType == ChartNode.ChartType.RSI
                )
                {
                    t = 0;
                }
                else if (node.chartType == ChartNode.ChartType.MACD)
                {
                    t = mDataParse.pricePrecision;
                }
                else if (node.chartType == ChartNode.ChartType.FUNDING_RATE ||
                        node.chartType == ChartNode.ChartType.OI_FR ||
                        node.chartType == ChartNode.ChartType.VOL_FR)
                {
                    t = 6;
                    return AppUtils.getFormatStringValue(value, t);
                }
                else if (node.chartType == ChartNode.ChartType.OPENINTEREST)
                {
                    t = 0;
                    return AppUtils.getFormatStringValue(value, t);
                }
                else if (node.chartType == ChartNode.ChartType.OI_DELTA)
                {
                    t = 2;
                    return AppUtils.getFormatStringValue(value, t);
                }

                String format = "%." + t + "f";
                return String.format(Locale.ENGLISH,format, value);
            }
        });

        chart.setAutoScaleMinMaxEnabled(true);
    }

    private int red, green, bluecolor, blackgray,black,gray, graydashline, highlightColor, sub_chart_single_color;
    private int ma01color, ma02color, ma03color, ma04color, ma05color, transparentColor;
    private void initChartColors()
    {
        ma01color = getColorById(R.color.blue_ma);
        ma02color = getColorById(R.color.yellow);
        ma03color = getColorById(R.color.purple);
        ma04color = getColorById(R.color.green4C);
        ma05color = getColorById(R.color.redEB);
        transparentColor = getColorById(R.color.transparent_color);

        Config.highlightTextSize = Utils.sp2px(10);

        highlightColor = getColorById(R.color.highlight_line_color);
        sub_chart_single_color = getColorById(R.color.sub_chart_single_line_color);
        graydashline = getColorById(R.color.gray_dashline);
        gray = getColorById(R.color.gray8B);
        black = getColorById(R.color.black3B);
        bluecolor = getColorById(R.color.colorAccent);
        blackgray = getColorById(R.color.blackgray);
        if (Config.getMMKV(this).getBoolean(Config.IS_GREEN_UP, true))
        {
            green = getColorById(R.color.green4C);
            red = getColorById(R.color.redEB);
        }
        else
        {
            green = getColorById(R.color.redEB);
            red = getColorById(R.color.green4C);
        }
    }


    private void initSubChartDataSet(ChartNode node)
    {
        for(int i = 0; i < node.count; i++)
        {
            node.lineDataSet[i] = new LineDataSet(new ArrayList<Entry>(), "sub");
            node.lineDataSet[i].setAxisDependency(YAxis.AxisDependency.LEFT);
            node.lineDataSet[i].setColor(node.lineColors[i]);
            node.lineDataSet[i].setHighLightColor(highlightColor);
            node.lineDataSet[i].setDrawCircles(false);
            node.lineDataSet[i].setDrawValues(false);
            node.lineDataSet[i].setHighlightEnabled(false);
        }

        node.barDataSet = new BarDataSet(new ArrayList<BarEntry>(), "bar");
        node.barDataSet.setHighLightColor(highlightColor);
        node.barDataSet.setDrawValues(false);
        node.barDataSet.setHighlightEnabled(false);

        node.barDataSet2 = new BarDataSet(new ArrayList<BarEntry>(), "bar2");
        node.barDataSet2.setHighLightColor(highlightColor);
        node.barDataSet2.setDrawValues(false);
        node.barDataSet2.setHighlightEnabled(false);

        float highlightWidth = 0.5F;//高亮线的线宽
        //蜡烛图
        node.candleDataSet = new CandleDataSet(new ArrayList<CandleEntry>(), "sub kline");
        node.candleDataSet.setAxisDependency(YAxis.AxisDependency.LEFT);
        node.candleDataSet.setDrawHorizontalHighlightIndicator(false);
        node.candleDataSet.setHighlightLineWidth(highlightWidth);
        node.candleDataSet.setHighLightColor(highlightColor);
        node.candleDataSet.setShadowWidth(0.7f);
        node.candleDataSet.setIncreasingColor(green);//上涨为green
        node.candleDataSet.setIncreasingPaintStyle(Paint.Style.FILL);
        //setKlineStyle();

        node.candleDataSet.setDecreasingColor(red);//下跌为red
        node.candleDataSet.setDecreasingPaintStyle(Paint.Style.FILL);
        node.candleDataSet.setNeutralColor(green);
        node.candleDataSet.setShadowColorSameAsCandle(true);
        node.candleDataSet.setDrawValues(false);
        node.candleDataSet.setHighlightEnabled(false);
        node.candleDataSet.setValueTextColor(ContextCompat.getColor(this, R.color.yellow));

        if ( node.chartType == ChartNode.ChartType.MACD ||
                node.chartType == ChartNode.ChartType.OI_DELTA ||
                node.chartType == ChartNode.ChartType.OI_FR ||
                node.chartType == ChartNode.ChartType.VOL_FR ||
                node.chartType == ChartNode.ChartType.FUNDING_RATE)
        {
            node.barDataSet.setColors(green, red);
        }
        else if (
                node.chartType == ChartNode.ChartType.COIN_LIQUIDATION ||
                node.chartType == ChartNode.ChartType.SYMBOL_LIQUIDATION
        )
        {
            node.barDataSet.setColor(green);
            node.barDataSet2.setColor(red);
        }
        else if (node.chartType == ChartNode.ChartType.OPENINTEREST)
        {
            node.lineDataSet[0].setDrawFilled(true);
            node.lineDataSet[0].setFillColor(sub_chart_single_color);
            node.lineDataSet[0].setFillAlpha(60);
        }

    }

    private void initVolChart() {
        int black = getColorById(R.color.black3B);
        int gray = getColorById(R.color.gray8B);
        //成交量
        mChartVol.setDragOffsetX(mDragOffsetX);
        mChartVol.setDoubleTapToZoomEnabled(false);
        mChartVol.setNoDataTextColor(gray);
        mChartVol.setDescription(null);
        mChartVol.getLegend().setEnabled(false);
        mChartVol.setMinOffset(0);//设置外边缘偏移量
        mChartVol.setDragEnabled(true);
        mChartVol.setScaleEnabled(true);
        mChartVol.setScaleYEnabled(false);
        mChartVol.setDragDecelerationEnabled(true);
        mChartVol.setDragDecelerationFrictionCoef(Config.FrictionCoef);

        //自定义Y轴标签位置
        mChartVol.setRendererRightYAxis(new InBoundYAxisRenderer(mChartVol.getViewPortHandler(),
                mChartVol.getAxisRight(),
                mChartVol.getTransformer(YAxis.AxisDependency.RIGHT)));

        mChartVol.setRendererLeftYAxis(new InBoundYAxisRenderer(mChartVol.getViewPortHandler(),
                mChartVol.getAxisLeft(),
                mChartVol.getTransformer(YAxis.AxisDependency.LEFT)));
        //设置渲染器控制颜色、偏移，以及高亮
       // mChartVol.setRenderer(new OffsetBarRenderer(mChartVol, mChartVol.getAnimator(), mChartVol.getViewPortHandler(), volBarOffset)
        //        .setHighlightWidthSize(highlightWidth, Config.sp8));

        mChartVol.setRenderer(new HighlightCombinedRenderer(mChartVol,
                mChartVol.getAnimator(), mChartVol.getViewPortHandler(), Config.highlightTextSize));
        mChartVol.setDrawOrder(new CombinedChart.DrawOrder[]{CombinedChart.DrawOrder.BAR,
                CombinedChart.DrawOrder.LINE});

        mChartVol.getXAxis().setEnabled(false);

        YAxis yab = mChartVol.getAxisRight();
        yab.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART);//标签显示在内侧
        yab.setDrawAxisLine(false);
        yab.setGridColor(black);
        yab.setTextColor(gray);
        yab.setTextSize(8);
        yab.setLabelCount(2, true);
        yab.setAxisMinimum(Float.MIN_VALUE);
        yab.setSpaceTop(10);
        yab.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {
                //MLog.d("val:" + value);
                //return value == 0 ? "" : value + "";
                if (value == 0)
                    return "";

                return AppUtils.getFormatStringValue(value, 1);
            }
        });

        yab = mChartVol.getAxisLeft();
        yab.setPosition(YAxis.YAxisLabelPosition.INSIDE_CHART);//标签显示在内侧
        yab.setDrawAxisLine(false);
        yab.setGridColor(black);
        yab.setTextColor(gray);
        yab.setTextSize(8);
        yab.setLabelCount(2, true);
        yab.setAxisMinimum(Float.MIN_VALUE);
        yab.setSpaceTop(10);
        yab.setValueFormatter(new IAxisValueFormatter() {
            @Override
            public String getFormattedValue(float value, AxisBase axis) {
                //MLog.d("val:" + value);
                return "";
            }
        });


        //mChartVol.getAxisLeft().setEnabled(false);
        mChartVol.setAutoScaleMinMaxEnabled(true);//自适应最大最小值
    }

    /**
     * 计算value是当前Y轴的第几个
     */
    private int getIndexY(float value, float min, float max) {
        float piece = (max - min) / 4;
        return Math.round((value - min) / piece);
    }

    protected void loadData() {
        mDataParse.pricePrecision = 0;
        strTitle = currSymbol;
        mTitleTextView.setText(strTitle);
        String s = currExchangeName + " " + LanguageUtil.getSwapString(this, currSwapType);
        tv_swap_type.setText(s);
        if (TextUtils.isEmpty(s))
        {
            tv_swap_type.setVisibility(View.GONE);
        }
        else
        {
            tv_swap_type.setVisibility(View.VISIBLE);
        }

        clearChart();
        toLeft = true;
        getData(currPeriod,"" + System.currentTimeMillis());

        getFavoriteList();
        if (favoriteList.contains(getCurrentSymbol()))
        {
            iv_favorite.setImageResource(R.drawable.favorite_sel);
        }
        else
        {
            if (Config.isNightMode)
            {
                iv_favorite.setImageResource(R.drawable.favorite_night);
            }
            else
            {
                iv_favorite.setImageResource(R.drawable.favorite_light);
            }
        }
    }

    private void clearChart() {

        mDataParse.clearData();

        if (xValuesDatetime == null) {
            xValuesDatetime = new HashMap<>();
        } else {
            xValuesDatetime.clear();
        }

        for(int i = 0; i < this.mChartManager.getNodeCount(); i++)
        {
            this.mChartManager.getNode(i).chart.setNoDataText(
                    getResources().getString(R.string.s_loading));
            this.mChartManager.getNode(i).chart.clear();
        }
    }

    //加载vip指标数据，
    private void loadVipIndexData(String period, String currTimesnamp) {
        //加载vip指标数据
        for(int i = 2; i < this.mChartManager.chartsList.size(); i++)
        {
            ChartNode node = mChartManager.getNode(i);
            if (node.chartType == ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO ||
                    node.chartType == ChartNode.ChartType.TOP_POSITION_RATIO ||
                    node.chartType == ChartNode.ChartType.FUNDING_RATE ||
                    node.chartType == ChartNode.ChartType.OI_FR ||
                    node.chartType == ChartNode.ChartType.VOL_FR ||
                    node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE ||
                    node.chartType == ChartNode.ChartType.OI_KLINE ||
                    node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K ||
                    node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K ||
                    node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K ||
                    node.chartType == ChartNode.ChartType.OI_DELTA ||
                    node.chartType == ChartNode.ChartType.COIN_OI_KLINE ||
                    node.chartType == ChartNode.ChartType.OPENINTEREST ||
                    node.chartType == ChartNode.ChartType.SYMBOL_LIQUIDATION ||
                    node.chartType == ChartNode.ChartType.COIN_LIQUIDATION ||
                    node.chartType == ChartNode.ChartType.TOP_ACCOUNT_RATIO )
            {
                String surl = "";
                if (node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE)
                {
                    surl = Config.apiFrKline;
                }
                else if (node.chartType == ChartNode.ChartType.OI_KLINE ||
                        node.chartType == ChartNode.ChartType.OI_DELTA)
                {
                    surl = Config.apiOIKline;
                }
                else if (node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K ||
                        node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K ||
                        node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K)
                {
                    surl = Config.apiGetLongShortRatioK;
                }
                else if (node.chartType == ChartNode.ChartType.COIN_OI_KLINE)
                {
                    surl = Config.apiCoinOIKline;
                }
                else if (node.chartType == ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO)
                {
                    surl = Config.apiGetLongsShortsOIPersonRatio;
                }
                else if (node.chartType == ChartNode.ChartType.TOP_POSITION_RATIO)
                {
                    surl = Config.apiGetLongsShortsTopPositionRatio;
                }
                else if (node.chartType == ChartNode.ChartType.TOP_ACCOUNT_RATIO)
                {
                    surl = Config.apiGetLongsShortsTopAccountRatio;
                }
                else if (node.chartType == ChartNode.ChartType.FUNDING_RATE)
                {
                    surl = Config.apiFundingRateVipIndex;
                }
                else if (node.chartType == ChartNode.ChartType.OI_FR ||
                        node.chartType == ChartNode.ChartType.VOL_FR)
                {
                    surl = Config.apiOIFrVolumeFr;
                }
                else if (node.chartType == ChartNode.ChartType.OPENINTEREST)
                {
                    surl = Config.apiOIVipIndex;
                }
                else if (node.chartType == ChartNode.ChartType.SYMBOL_LIQUIDATION)
                {
                    surl = Config.apiSymbolLiqVipIndex;
                }
                else if (node.chartType == ChartNode.ChartType.COIN_LIQUIDATION)
                {
                    surl = Config.apiCoinLiqVipIndex;
                }

                String url = "";
                if (node.chartType == ChartNode.ChartType.COIN_LIQUIDATION)
                {
                    url = String.format(surl, currBaseCoin, period, currTimesnamp, currExchangeName, currSymbol);
                }
                else if (
                        node.chartType == ChartNode.ChartType.OI_FR ||
                        node.chartType == ChartNode.ChartType.VOL_FR)
                {
                    url = String.format(surl, currBaseCoin, period, currTimesnamp);
                }
                else if (node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE ||
                        node.chartType == ChartNode.ChartType.OI_DELTA ||
                        node.chartType == ChartNode.ChartType.OI_KLINE)
                {
                    url = String.format(surl, currSymbol, currExchangeName, currTimesnamp, period);
                }
                else if (node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K ||
                        node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K ||
                        node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K)
                {
                    String type = "";
                    if (node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K)
                    {
                        type = "longShortPerson";
                    }
                    else if (node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K)
                    {
                        type = "longShortAccount";
                    }
                    else if (node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K)
                    {
                        type = "longShortPosition";
                    }

                    url = String.format(surl, currTimesnamp, period, currExchangeName, currSymbol, type);
                }
                else if (node.chartType == ChartNode.ChartType.COIN_OI_KLINE)
                {
                    url = String.format(surl, currTimesnamp, period, currBaseCoin, currExchangeName, currSymbol);
                }
                else
                {
                    url = String.format(surl, currExchangeName, currSymbol, period, currTimesnamp);
                }

                long ts = System.currentTimeMillis();
                OkHttpUtil.getJSON(url, node.chartType, new OkHttpUtil.OnDataListener() {
                    @Override
                    public void onResponse(String url, Object obj, String json) {
                        hMapSubChartType.remove(node.chartType);
                        long t2 = System.currentTimeMillis() - ts;
                        MLog.d("*****node " + node.chartType + " cost:" + t2);
                        Gson gson = new GsonBuilder().create();
                        JsonVo jsonVo = gson.fromJson(json, new TypeToken<JsonVo>() {}.getType());
                        if (!jsonVo.isSuccess())
                        {
                            MLog.d("#####!!!!!!vip index load data exception");
                            return;
                        }

                        if (ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO == (int)obj)
                        {
                            LongShortRatioVo lspv = KlineUtils.data2LongShortRatio(json);
                            if (toLeft)
                            {
                                //mDataParse.longShortPersonVo.getTss().addAll(0, lspv.getTss());
                                mDataParse.longShortPersonVo.getLongShortRatio().addAll(0, lspv.getLongShortRatio());
                            }
                            else
                            {
                                //mDataParse.longShortPersonVo.getTss().addAll(lspv.getTss());
                                mDataParse.longShortPersonVo.getLongShortRatio().addAll(lspv.getLongShortRatio());
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index json lspv size :" + mDataParse.longShortPersonVo.getLongShortRatio().size());

                        }
                        else if (ChartNode.ChartType.FUNDING_RATE_KLINE == (int)obj)
                        {
                            KlineIndc indc = KlineUtils.data2FundingKline(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.frListK.addAll(0, indc.klines);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.frListK.addAll(indc.klines);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index json size :" + mDataParse.vipIndexObj.frListK.size());

                        }
                        else if (ChartNode.ChartType.OI_KLINE == (int)obj)
                        {
                            KlineIndc indc = KlineUtils.data2OpenKline(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.oiListK.addAll(0, indc.klines);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.oiListK.addAll(indc.klines);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index oikline json size :" + mDataParse.vipIndexObj.oiListK.size());

                        }
                        else if (ChartNode.ChartType.LS_ACCOUNTS_RATIO_K == (int)obj)
                        {
                            KlineIndc indc = KlineUtils.data2OpenKline(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.lsAccountsRatioK.addAll(0, indc.klines);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.lsAccountsRatioK.addAll(indc.klines);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index lsAccountsRatioK json size :" + mDataParse.vipIndexObj.lsAccountsRatioK.size());

                        }
                        else if (ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K == (int)obj)
                        {
                            KlineIndc indc = KlineUtils.data2OpenKline(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.lsTopAccountsRatioK.addAll(0, indc.klines);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.lsTopAccountsRatioK.addAll(indc.klines);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index lsTopAccountsRatioK json size :" + mDataParse.vipIndexObj.lsTopAccountsRatioK.size());

                        }
                        else if (ChartNode.ChartType.TOP_POSITIONS_RATIO_K == (int)obj)
                        {
                            KlineIndc indc = KlineUtils.data2OpenKline(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.lsTopPositionsRatioK.addAll(0, indc.klines);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.lsTopPositionsRatioK.addAll(indc.klines);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index lsTpoPositionsRatioK json size :" + mDataParse.vipIndexObj.lsTopPositionsRatioK.size());

                        }
                        else if (ChartNode.ChartType.OI_DELTA == (int)obj)
                        {
                            KlineIndc indc = KlineUtils.data2OIDelta(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.oiDelta.addAll(0, indc.oiDelta);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.oiDelta.addAll(indc.oiDelta);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index oiDelta json size :" + mDataParse.vipIndexObj.oiDelta.size());

                        }
                        else if (ChartNode.ChartType.COIN_OI_KLINE == (int)obj)
                        {
                            KlineIndc indc = KlineUtils.data2OpenKline(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.coinOIListK.addAll(0, indc.klines);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.coinOIListK.addAll(indc.klines);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index coinOIListK json size :" + mDataParse.vipIndexObj.coinOIListK.size());

                        }
                        else if (ChartNode.ChartType.TOP_POSITION_RATIO == (int)obj)
                        {
                            LongShortRatioVo lspv = KlineUtils.data2LongShortRatio(json);
                            if (toLeft)
                            {
                                //mDataParse.longShortPositionVo.getTss().addAll(0, lspv.getTss());
                                mDataParse.longShortPositionVo.getLongShortRatio().addAll(0, lspv.getLongShortRatio());
                            }
                            else
                            {
                                //mDataParse.longShortPositionVo.getTss().addAll(lspv.getTss());
                                mDataParse.longShortPositionVo.getLongShortRatio().addAll(lspv.getLongShortRatio());
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index json lspv size :" + mDataParse.longShortPositionVo.getLongShortRatio().size());

                        }
                        else if (ChartNode.ChartType.TOP_ACCOUNT_RATIO == (int)obj)
                        {
                            LongShortRatioVo lspv = KlineUtils.data2LongShortRatio(json);
                            if (toLeft)
                            {
                                //mDataParse.longShortAccountVo.getTss().addAll(0, lspv.getTss());
                                mDataParse.longShortAccountVo.getLongShortRatio().addAll(0, lspv.getLongShortRatio());
                            }
                            else
                            {
                                //mDataParse.longShortAccountVo.getTss().addAll(lspv.getTss());
                                mDataParse.longShortAccountVo.getLongShortRatio().addAll(lspv.getLongShortRatio());
                            }

                           // MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index json lspv size :" + mDataParse.longShortAccountVo.getLongShortRatio().size());

                        }
                        else if (node.chartType == ChartNode.ChartType.OI_FR)
                        {
                            KlineIndc klineIndc = KlineUtils.data2OIFr(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.oiWeightFrData.addAll(0,
                                        klineIndc.oiWeightFrData);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.oiWeightFrData.addAll(klineIndc.oiWeightFrData);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip oi fr index json  size :" + mDataParse.vipIndexObj.oiWeightFrData.size());
                        }
                        else if (node.chartType == ChartNode.ChartType.VOL_FR)
                        {
                            KlineIndc klineIndc = KlineUtils.data2VolFr(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.volumeWeightFrData.addAll(0,
                                        klineIndc.volumeWeightFrData);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.volumeWeightFrData.addAll(klineIndc.volumeWeightFrData);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip vol fr index json  size :" + mDataParse.vipIndexObj.volumeWeightFrData.size());
                        }
                        else if (ChartNode.ChartType.FUNDING_RATE == (int)obj)
                        {
                            KlineIndc klineIndc = KlineUtils.data2FundingRate(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.fundingRateList.addAll(0,
                                        klineIndc.fundingRateList);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.fundingRateList.addAll(klineIndc.fundingRateList);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index json  size :" + mDataParse.vipIndexObj.fundingRateList.size());

                        }
                        else if (ChartNode.ChartType.OPENINTEREST == (int)obj)
                        {
                            KlineIndc klineIndc = KlineUtils.data2Open(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.getOiList().addAll(0,
                                        klineIndc.oiList);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.oiList.addAll(klineIndc.oiList);
                            }

                           // MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index json  size :" + mDataParse.vipIndexObj.oiList.size());

                        }
                        else if (ChartNode.ChartType.SYMBOL_LIQUIDATION == (int)obj)
                        {
                            KlineIndc klineIndc = KlineUtils.data2LiqSymbol(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.liqSymbolLongList.addAll(0,
                                        klineIndc.liqSymbolLongList);
                                mDataParse.vipIndexObj.liqSymbolShortList.addAll(0,
                                        klineIndc.liqSymbolShortList);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.liqSymbolLongList.addAll(klineIndc.liqSymbolLongList);
                                mDataParse.vipIndexObj.liqSymbolShortList.addAll(klineIndc.liqSymbolShortList);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index json  size :" + mDataParse.vipIndexObj.liqSymbolLongList.size());

                        }
                        else if (ChartNode.ChartType.COIN_LIQUIDATION == (int)obj)
                        {
                            KlineIndc klineIndc = KlineUtils.data2LiqCoin(json);
                            if (toLeft)
                            {
                                mDataParse.vipIndexObj.liqCoinLongList.addAll(0,
                                        klineIndc.liqCoinLongList);
                                mDataParse.vipIndexObj.liqCoinShortList.addAll(0,
                                        klineIndc.liqCoinShortList);
                            }
                            else
                            {
                                mDataParse.vipIndexObj.liqCoinLongList.addAll(klineIndc.liqCoinLongList);
                                mDataParse.vipIndexObj.liqCoinShortList.addAll(klineIndc.liqCoinShortList);
                            }

                            //MLog.d("***&&&**onResponse obj:" + (int)obj);
                            MLog.d("***&&&**vip index json  size :" + mDataParse.vipIndexObj.liqCoinLongList.size());

                        }

                        //updateNodeChart(node);

                    }//end Resp

                    @Override
                    public void onFailure(String url, String error) {
                        MLog.d("onFailure***");
                    }
                });
            }
        }//end for

    }

    private  HashMap<Integer, Integer> hMapSubChartType = new HashMap<>();
    private void collectVipIndexType()
    {
        for(int i = 2; i < this.mChartManager.chartsList.size(); i++)
        {
            ChartNode node = mChartManager.getNode(i);
            if (node.chartType >= ChartNode.ChartType.SUB_TYPE_MIN &&
                    node.chartType <= ChartNode.ChartType.SUB_TYPE_MAX)
            {
                hMapSubChartType.put(node.chartType, node.chartType);
            }
        }
    }

    /*本方法说明 ，每个vip指标都开启一个服务去请求加载，加载完就报告一下自己正常加载完了
    然后另外开一个服务去加载K线数据，
    在K线数据返回的处理函数里面等待所有vip指标加载完再一并去处理数据并显示数据
     */
    private void getData(String period, String currTimesnamp) {
        //if (!period.equals("1w") &&
         //       !period.equals("1M"))
        {
            collectVipIndexType();//收集vip指标类型
            loadVipIndexData(period, currTimesnamp);
        }

        long ts = System.currentTimeMillis();
        String url = String.format(Config.klineUrl, currExchangeName, currSymbol, period, currTimesnamp);
        OkHttpUtil.getJSON(url, new OkHttpUtil.OnDataListener() {
            @Override
            public void onResponse(String url, Object obj,String json) {
                long t2 = System.currentTimeMillis() - ts;
                MLog.d("K chart cost " + t2);
                //开启线程在此处等待其它指标加载完成
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        int cnt = 0;
                        while (cnt++ <= 200)
                        {
                            try {
                                Thread.sleep(30);
                                if (hMapSubChartType.size() == 0)
                                {
                                    runOnUiThread(new Runnable() {
                                        @Override
                                        public void run() {
                                            //MLog.d("onResponse KLINE json: " + json.substring(0,50));
                                            JSONObject jObj = null;
                                            try {
                                                jObj = new JSONObject(json);
                                                if (mDataParse == null) return;
                                                mDataParse.success = jObj.optBoolean("success", false);
                                            } catch (JSONException e) {
                                                e.printStackTrace();
                                            }

                                            String param = "javascript:changeSymbolInfo('%s')";
                                            marketOrderWebView.changeSymbolInfo(getCurrSymbolJson());

                                            if (mDataParse.success) {
                                                int size = xValuesDatetime.size();
                                                List<KLineItem> lists = mDataParse.parseKLine(jObj, toLeft);
                                                if (lists.size() <= 0) {
                                                    dismissLoading();
                                                    return;
                                                }

                                                if (lists.size() == 1) {
                                                    String x = lists.get(0).date;
                                                    if (!xValuesDatetime.containsValue(x)) {
                                                        MLog.d("xValues.containsValue handleData**&&&");
                                                        handleData(size);
                                                    }
                                                } else {
                                                    //MLog.d("else handleData list size:" + lists.size());
                                                    handleData(size);
                                                }

                                                if (mDataParse != null && mDataParse.kLineList.size() > 0 && vma5set.getEntryCount() > 0)
                                                {
                                                    int count = mDataParse.kLineList.size();
                                                    KLineItem item = mDataParse.kLineList.get(count - 1);
                                                    lastPrice = tv_price.getText().toString();
                                                    tv_price.setText(AppUtils.getFormatStringValue(item.close, mDataParse.pricePrecision));

                                                    if (item.close > Float.valueOf(lastPrice))
                                                    {
                                                        tv_price.setTextColor(green);
                                                    }
                                                    else
                                                    {
                                                        tv_price.setTextColor(red);
                                                    }
                                                }
                                            }

                                            dismissLoading();
                                        }
                                    });
                                    cnt = 999;
                                    break;
                                }
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }).start();

            }

            @Override
            public void onFailure(String url, String error) {
                dismissLoading();
                MLog.d("onFailure***");
                for(int i = 0; i < mChartManager.getNodeCount(); i++)
                {
                    mChartManager.getNode(i).chart.setNoDataText(getResources().getString(R.string.s_load_failure));
                    mChartManager.getNode(i).chart.invalidate();
                }
            }
        });
    }

    @Override
    public void onTabSelected(TabLayout.Tab tab) {
        stopTranslate();//切换不同周期时，必须暂停之前的惯性动画
        klinePeriodIndex = tab.getPosition();
        TextView textView = (TextView) tab.getCustomView();
        textView.setTextColor(getColorById(R.color.colorAccent));
        tabLayout.setSelectedTabIndicatorColor(getColorById(R.color.colorAccent));
        //WebSocketUtils.getInstance().removeSubscribe(getSubscribeArgs());
        WebSocketUtils.getInstance().removeAllSubscribe();
        currPeriod = TAB_KLINE_ARGS[klinePeriodIndex];
        if (klinePeriodIndex == 0)
        {
            Config.getMMKV(this).putBoolean(Config.CONF_IS_MIN_PERIOD, true);
        }
        else
        {
            Config.getMMKV(this).putBoolean(Config.CONF_IS_MIN_PERIOD, false);
        }
        Config.getMMKV(this).putString(Config.CONF_KLINE_PERIOD, currPeriod);
        setPopupBtnColor(-1, false);
        loadData();
        WebSocketUtils.getInstance().addSubscribe(getSubscribeArgs());
    }

    @Override
    public void onTabReselected(TabLayout.Tab tab) {
        onTabSelected(tab);
    }

    @Override
    public void onTabUnselected(TabLayout.Tab tab) {
        TextView textView = (TextView) tab.getCustomView();
        textView.setTextColor(ContextCompat.getColor(this, R.color.blackgray));
        tabLayout.setTabIndicatorFullWidth(true);
        tabLayout.setSelectedTabIndicatorColor(0x00ffffff);
    }

    private void removeTabSelStage()
    {
        for(int i = 0; i < 4; i++)
        {
            MLog.d("removeTabSelStage:" + i);
            TextView textView = (TextView) tabLayout.getTabAt(i).getCustomView();
            textView.setTextColor(getColorById(R.color.blackgray));
            tabLayout.setTabIndicatorFullWidth(true);
            tabLayout.setSelectedTabIndicatorColor(0x00ffffff);
        }
    }

    /**
     * size是指追加数据之前已有的数据个数
     */
    private void handleData(int size) {
        configData();

        for(int i = 0; i < this.mChartManager.getNodeCount(); i++)
        {
            this.mChartManager.getNode(i).chart.setVisibleXRange(maxRange, maxRange);
        }

        if (xValuesDatetime.size() > 0) {
            MLog.d("toLeft:" + toLeft);
            int x = xValuesDatetime.size() - (toLeft ? size : 0);//计算起始显示的X位置
            //如果设置了惯性甩动 moveview方法将会无效
            if (!toLeft && size > 0) {
                //此处代码块逻辑暂时不会执行
                MLog.d("moveViewToAnimated***");
                mChartKline.moveViewToAnimated(x, 0, YAxis.AxisDependency.LEFT, 200);
                mChartVol.moveViewToAnimated(x + volBarOffset, 0, YAxis.AxisDependency.LEFT, 200);
                for(int i = 2; i < this.mChartManager.getNodeCount(); i++)
                {
                    this.mChartManager.getNode(i).chart.moveViewToAnimated(
                            x + volBarOffset, 0, YAxis.AxisDependency.LEFT, 200);
                }
            } else {
                MLog.d("moveViewToX*** " + x);
                mChartKline.moveViewToX(x);

                mChartVol.moveViewToX(x + volBarOffset);
                for(int i = 2; i < this.mChartManager.getNodeCount(); i++)
                {
                    this.mChartManager.getNode(i).chart.moveViewToX(x + volBarOffset);
                }
            }

            for(int i = 0; i < this.mChartManager.getNodeCount(); i++)
            {
                this.mChartManager.getNode(i).chart.notifyDataSetChanged();
                ViewPortHandler vport = this.mChartManager.getNode(i).chart.getViewPortHandler();
                vport.setMinMaxScaleX(1.0F, Float.MAX_VALUE);
            }
        }
    }

    private void configData() {
        long st = System.currentTimeMillis();
        if (mDataParse.kLineList.size() == 0) {
            for(int i = 0; i < this.mChartManager.getNodeCount(); i++)
            {
                this.mChartManager.getNode(i).chart.setNoDataText(
                        getResources().getString(R.string.s_none_data));
                this.mChartManager.getNode(i).chart.clear();
            }
        } else {
            mDataParse.pricePrecision = AppUtils.getPrecision(String.format(Locale.ENGLISH, "%s", mDataParse.kLineList.get(0).close));
            //mDataParse.pricePrecision = AppUtils.getPrecision(getFloatPointLen());
            MLog.d("mDataParse.pricePrecision len " + mDataParse.pricePrecision);

            if (klineCombinedData == null) {
                klineCombinedData = new CombinedData();
            }
            xValuesDatetime.clear();

            candleSet.getEntries().clear();//清空K线数据
            //清空K线主图线条数据
            ma01set.getEntries().clear();
            ma02set.getEntries().clear();
            ma03set.getEntries().clear();
            ma04set.getEntries().clear();
            ma05set.getEntries().clear();

            List<Entry> minValues = lineSetMin.getEntries();
            minValues.clear();

            //解析K线数据
            for (int i = 0; i < mDataParse.kLineList.size(); i++) {
                KLineItem k = mDataParse.kLineList.get(i);
                if (xValuesDatetime.containsValue(k.date)) {
                    //过滤重复时间的K线
                   // MLog.d("repeat kline " + i + " " + AppUtils.timeStamp2DateNow(k.timestamp));
                    mDataParse.kLineList.remove(i);
                    i--;
                } else {
                    xValuesDatetime.put(i, k.date);
                    minValues.add(new Entry(i, k.close, k.date));
                }//end if
            }

            MLog.d("size:" + mDataParse.kLineList.size() + "  " + xValuesDatetime.size());

            //构造K线和成交量数据
            mDataParse.initKLineAndVolDatas(mDataParse.kLineList);

            mainChartIndicIdx = Config.getMMKV(this).
                    getInt(Config.CONF_MAIN_CHART_INDIC, ChartNode.ChartType.CHART_NONE);
            if (mainChartIndicIdx == ChartNode.ChartType.MA)
            {
                //生成MA均线
                mDataParse.initMA(mDataParse.kLineList);
                ma01set.setEntries(mDataParse.getMa01DataL());
                ma02set.setEntries(mDataParse.getMa02DataL());
                ma03set.setEntries(mDataParse.getMa03DataL());
                ma04set.setEntries(mDataParse.getMa04DataL());
                ma05set.setEntries(mDataParse.getMa05DataL());

                ma01set.setColor(ma01color);
                ma02set.setColor(ma02color);
                ma03set.setColor(ma03color);
                ma04set.setColor(ma04color);
                ma05set.setColor(ma05color);
            }
            else if (mainChartIndicIdx == ChartNode.ChartType.BOLL)
            {
                mDataParse.initBOLL(mDataParse.kLineList);
                ma01set.setEntries(mDataParse.getBollDataUP());
                ma02set.setEntries(mDataParse.getBollDataMB());
                ma03set.setEntries(mDataParse.getBollDataDN());

                ma01set.setColor((ma02color));
                ma02set.setColor((ma01color));
                ma03set.setColor((ma03color));
            }
            else if (mainChartIndicIdx == ChartNode.ChartType.EMA)
            {
                //生成EMA均线
                mDataParse.initEXPMA(mDataParse.kLineList);
                ma01set.setEntries(mDataParse.getExpmaData1());
                ma02set.setEntries(mDataParse.getExpmaData2());
                ma03set.setEntries(mDataParse.getExpmaData3());
                ma04set.setEntries(mDataParse.getExpmaData4());
                ma05set.setEntries(mDataParse.getExpmaData5());

                ma01set.setColor(ma01color);
                ma02set.setColor(ma02color);
                ma03set.setColor(ma03color);
                ma04set.setColor(ma04color);
                ma05set.setColor(ma05color);
            }

            candleSet.setEntries(mDataParse.getCandleEntries());
            lineSetMin.setEntries(minValues);

            if (tabLayout.getSelectedTabPosition() == 0 && getCurrPeriodSelIdx() == -1) {
                klineCombinedData.removeDataSet(candleSet);//分时图时移除蜡烛图
                klineCombinedData.setData(new LineData(lineSetMin));
            } else {
                klineCombinedData.setData(new CandleData(candleSet));
                //klineCombinedData.setData(new LineData(ma01set, ma02set, ma03set));
                LineData ldata = new LineData();
                if (mainChartIndicIdx == ChartNode.ChartType.MA)
                {
                    if (mDataParse.indexParamVo.isMa1Toggle()) ldata.addDataSet(ma01set);
                    if (mDataParse.indexParamVo.isMa2Toggle()) ldata.addDataSet(ma02set);
                    if (mDataParse.indexParamVo.isMa3Toggle()) ldata.addDataSet(ma03set);
                    if (mDataParse.indexParamVo.isMa4Toggle()) ldata.addDataSet(ma04set);
                    if (mDataParse.indexParamVo.isMa5Toggle()) ldata.addDataSet(ma05set);
                }
                else if (mainChartIndicIdx == ChartNode.ChartType.EMA)
                {
                    if (mDataParse.indexParamVo.isEma1Toggle()) ldata.addDataSet(ma01set);
                    if (mDataParse.indexParamVo.isEma2Toggle()) ldata.addDataSet(ma02set);
                    if (mDataParse.indexParamVo.isEma3Toggle()) ldata.addDataSet(ma03set);
                    if (mDataParse.indexParamVo.isEma4Toggle()) ldata.addDataSet(ma04set);
                    if (mDataParse.indexParamVo.isEma5Toggle()) ldata.addDataSet(ma05set);
                }
                else if (mainChartIndicIdx == ChartNode.ChartType.BOLL)
                {
                    ldata.addDataSet(ma01set);
                    ldata.addDataSet(ma02set);
                    ldata.addDataSet(ma03set);
                }


                klineCombinedData.setData(ldata);
            }

            mChartKline.setData(klineCombinedData);
            float xMax = xValuesDatetime.size() - 0.5F;//默认X轴最大值是 xValues.size() - 1
            mChartKline.getXAxis().setAxisMaximum(xMax);//使最后一个显示完整

            //处理成交量图表
            vma5set.getEntries().clear();
            vma10set.getEntries().clear();
            volBarSet.getEntries().clear();
            //生成Vol MA均线
            mDataParse.initVolMa(mDataParse.kLineList);
            volBarSet.setEntries(mDataParse.getVolBarEntries());
            vma5set.setEntries(mDataParse.getMa5DataV());
            vma10set.setEntries(mDataParse.getMa10DataV());

            BarData barData = new BarData(volBarSet);
            barData.setBarWidth(1 - candleSet.getBarSpace() * 2);//使Candle和Bar宽度一致

            CombinedData cdata = new CombinedData();
            cdata.setData(barData);
            //cdata.setData(new LineData(vma5set, vma10set));

            mChartVol.setData(cdata);
            mChartVol.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐

            //处理其它图表的数据
            for(int i = 2; i < this.mChartManager.chartsList.size(); i++)
            {
                setSubChartData(this.mChartManager.getNode(i));
            }
        }

    }


    private void setSubChartData(ChartNode node)
    {
        float xMax = xValuesDatetime.size() - 0.5F;//默认X轴最大值是 xValues.size() - 1

        node.barDataSet.getEntries().clear();
        node.barDataSet2.getEntries().clear();
        node.candleDataSet.getEntries().clear();

        for(int i = 0; i < node.count; i++)
        {
            node.lineDataSet[i].getEntries().clear();
        }

        if(node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE ||
                node.chartType == ChartNode.ChartType.OI_KLINE ||
                node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K ||
                node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K ||
                node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K ||
        node.chartType == ChartNode.ChartType.COIN_OI_KLINE
        ){
            if (node.chartType == ChartNode.ChartType.FUNDING_RATE_KLINE)
            {
                mDataParse.initFrKline(mDataParse.vipIndexObj.frListK);
                node.candleDataSet.setEntries(mDataParse.vipIndexObj.candleFrListK);
            }
            else if (node.chartType == ChartNode.ChartType.LS_ACCOUNTS_RATIO_K)
            {
                mDataParse.initLSAccountsRatioK(mDataParse.vipIndexObj.lsAccountsRatioK);
                node.candleDataSet.setEntries(mDataParse.vipIndexObj.candleLsAccountsRatioK);
            }
            else if (node.chartType == ChartNode.ChartType.TOP_ACCOUNTS_RATIO_K)
            {
                mDataParse.initTopTraderAccountsRatioK(mDataParse.vipIndexObj.lsTopAccountsRatioK);
                node.candleDataSet.setEntries(mDataParse.vipIndexObj.candleTopAccountsRatioK);
            }
            else if (node.chartType == ChartNode.ChartType.TOP_POSITIONS_RATIO_K)
            {
                mDataParse.initTopTraderPositionsRatioK(mDataParse.vipIndexObj.lsTopPositionsRatioK);
                node.candleDataSet.setEntries(mDataParse.vipIndexObj.candleTopPostionsRatioK);
            }
            else if (node.chartType == ChartNode.ChartType.COIN_OI_KLINE)
            {
                mDataParse.initCoinOIKline(mDataParse.vipIndexObj.coinOIListK);
                node.candleDataSet.setEntries(mDataParse.vipIndexObj.coinCandleOIListK);
            }
            else
            {
                mDataParse.initOIKline(mDataParse.vipIndexObj.oiListK);
                node.candleDataSet.setEntries(mDataParse.vipIndexObj.candleOIListK);
            }

            CombinedData cdata = new CombinedData();
            cdata.setData(new CandleData(node.candleDataSet));

            node.chart.setData(cdata);
            node.chart.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐
        }
        else if (node.chartType == ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO ||
                node.chartType == ChartNode.ChartType.TOP_POSITION_RATIO ||
                node.chartType == ChartNode.ChartType.OPENINTEREST ||
                node.chartType == ChartNode.ChartType.TOP_ACCOUNT_RATIO )
        {
            if (node.chartType == ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO)
            {
                mDataParse.initLongShortPersonRatio(mDataParse.longShortPersonVo);
                node.barDataSet.setEntries(mDataParse.getBarLsPersonList());
                node.lineDataSet[0].setEntries(mDataParse.getLineLsPersonList());
                List<Integer> colors = new ArrayList<>();
                for (int i = 0; i < mDataParse.getLineLsPersonList().size(); i++)
                {
                    float f = mDataParse.getLineLsPersonList().get(i).getY();
                    if ( f >= 1.0F)
                    {
                        colors.add(green);
                    }
                    else
                    {
                        colors.add(red);
                    }

                    //处理当多空比从1以上突然下降到1以下的的时候，这个地方应该也要显示成red颜色才对
                    if (i >= 1)
                    {
                        float lastVal = mDataParse.getLineLsPersonList().get(i-1).getY();;
                        if (lastVal >= 1.0F && f < 1.0F)
                        {
                            colors.set(i - 1, Integer.valueOf(red));
                        }

                        if (lastVal < 1.0F && f >= 1.0F)
                        {
                            colors.set(i - 1, Integer.valueOf(green));
                        }
                    }
                }

                //MLog.d("color size:" + colors.size() + " node size:" + node.lineDataSet[0].getEntryCount());
                //node.lineDataSet[0].setColor(getColorById(R.color.green4C));
                node.lineDataSet[0].setMulColorParam(green, red,true);//给图表库加了一个函数
                node.lineDataSet[0].setColors(colors);
            }
            else if (node.chartType == ChartNode.ChartType.TOP_POSITION_RATIO)
            {
                mDataParse.initLongShortPositionRatio(mDataParse.longShortPositionVo);
                node.barDataSet.setEntries(mDataParse.getBarLsPositionList());
                node.lineDataSet[0].setEntries(mDataParse.getLineLsPositionList());

                List<Integer> colors = new ArrayList<>();
                for (int i = 0; i < mDataParse.getLineLsPositionList().size(); i++)
                {
                    float f = mDataParse.getLineLsPositionList().get(i).getY();
                    if ( f >= 1.0F)
                    {
                        colors.add(green);
                    }
                    else
                    {
                        colors.add(red);
                    }

                    //处理当多空比从1以上突然下降到1以下的的时候，这个地方应该也要显示成red颜色才对
                    if (i >= 1)
                    {
                        float lastVal = mDataParse.getLineLsPositionList().get(i-1).getY();;
                        if (lastVal >= 1.0F && f < 1.0F)
                        {
                            colors.set(i - 1, Integer.valueOf(red));
                        }

                        if (lastVal < 1.0F && f >= 1.0F)
                        {
                            colors.set(i - 1, Integer.valueOf(green));
                        }
                    }
                }

                //node.lineDataSet[0].setColor(getColorById(R.color.green4C));
                node.lineDataSet[0].setMulColorParam(green, red, true);
                node.lineDataSet[0].setColors(colors);
            }
            else if (node.chartType == ChartNode.ChartType.TOP_ACCOUNT_RATIO)
            {
                mDataParse.initLongShortAccountRatio(mDataParse.longShortAccountVo);
                node.barDataSet.setEntries(mDataParse.getBarLsAccountList());
                node.lineDataSet[0].setEntries(mDataParse.getLineLsAccountList());
                List<Integer> colors = new ArrayList<>();
                for (int i = 0; i < mDataParse.getLineLsAccountList().size(); i++)
                {
                    float f = mDataParse.getLineLsAccountList().get(i).getY();
                    if ( f >= 1.0F)
                    {
                        colors.add(green);
                    }
                    else
                    {
                        colors.add(red);
                    }

                    //处理当多空比从1以上突然下降到1以下的的时候，这个地方应该也要显示成red颜色才对
                    if (i >= 1)
                    {
                        float lastVal = mDataParse.getLineLsAccountList().get(i-1).getY();;
                        if (lastVal >= 1.0F && f < 1.0F)
                        {
                            colors.set(i - 1, Integer.valueOf(red));
                        }

                        if (lastVal < 1.0F && f >= 1.0F)
                        {
                            colors.set(i - 1, Integer.valueOf(green));
                        }
                    }
                }

                //node.lineDataSet[0].setColor(getColorById(R.color.green4C));
                node.lineDataSet[0].setMulColorParam(green, red, true);
                node.lineDataSet[0].setColors(colors);
            }
            else if (node.chartType == ChartNode.ChartType.OPENINTEREST)
            {
                mDataParse.initOIVipIndex(mDataParse.vipIndexObj);
                node.barDataSet.setEntries(mDataParse.vipIndexObj.barOIList);
                node.lineDataSet[0].setEntries(mDataParse.vipIndexObj.lineOIList);
            }

            BarData barData = new BarData(node.barDataSet);
            barData.setBarWidth(1 - candleSet.getBarSpace() * 2);//使Candle和Bar宽度一致

            CombinedData cdata = new CombinedData();
            cdata.setData(barData);//折线图时，此句要加上，即使没有柱状图数据，否则左右滑动会有问题，
            cdata.setData(new LineData(node.lineDataSet[0]));

            node.chart.setData(cdata);
            node.chart.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐
        }
        else if(node.chartType == ChartNode.ChartType.FUNDING_RATE ||
                node.chartType == ChartNode.ChartType.OI_FR ||
                node.chartType == ChartNode.ChartType.VOL_FR)
        {
            if(node.chartType == ChartNode.ChartType.FUNDING_RATE)
            {
                mDataParse.initFundingRateVipIndex(mDataParse.vipIndexObj);
                node.barDataSet.setEntries(mDataParse.vipIndexObj.barFRlist);
            }
            else if(node.chartType == ChartNode.ChartType.OI_FR)
            {
                mDataParse.initOIFundingRateVipIndex(mDataParse.vipIndexObj);
                node.barDataSet.setEntries(mDataParse.vipIndexObj.barOIWeightFrData);
            }
            else if(node.chartType == ChartNode.ChartType.VOL_FR)
            {
                mDataParse.initVolumeFundingRateVipIndex(mDataParse.vipIndexObj);
                node.barDataSet.setEntries(mDataParse.vipIndexObj.barVolumeWeightFrData);
            }

            BarData barData = new BarData(node.barDataSet);
            barData.setBarWidth(1 - candleSet.getBarSpace() * 2);//使Candle和Bar宽度一致

            CombinedData cdata = new CombinedData();
            cdata.setData(barData);

            node.chart.setData(cdata);
            node.chart.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐
        }
        else if(node.chartType == ChartNode.ChartType.KDJ){
            mDataParse.initKDJ(mDataParse.kLineList);
            node.barDataSet.setEntries(mDataParse.getBarDatasKDJ());
            node.lineDataSet[0].setEntries(mDataParse.getkData());
            node.lineDataSet[1].setEntries(mDataParse.getdData());
            node.lineDataSet[2].setEntries(mDataParse.getjData());
            BarData barData = new BarData(node.barDataSet);
            barData.setBarWidth(1 - candleSet.getBarSpace() * 2);//使Candle和Bar宽度一致

            CombinedData cdata = new CombinedData();
            cdata.setData(barData);
            cdata.setData(new LineData(node.lineDataSet[0], node.lineDataSet[1], node.lineDataSet[2]));

            node.chart.setData(cdata);
            node.chart.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐
        }
        else if(node.chartType == ChartNode.ChartType.OI_DELTA){
            mDataParse.initOIDelta(mDataParse.vipIndexObj.oiDelta);
            node.barDataSet.setEntries(mDataParse.vipIndexObj.barOIDelta);
            BarData barData = new BarData(node.barDataSet);
            barData.setBarWidth(1 - candleSet.getBarSpace() * 2);//使Candle和Bar宽度一致

            CombinedData cdata = new CombinedData();
            cdata.setData(barData);

            node.chart.setData(cdata);
            node.chart.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐
        }
        else if(node.chartType == ChartNode.ChartType.MACD){
            mDataParse.initMACD(mDataParse.kLineList);
            node.barDataSet.setEntries(mDataParse.getMacdData());
            node.lineDataSet[0].setEntries(mDataParse.getDifData());
            node.lineDataSet[1].setEntries(mDataParse.getDeaData());
            BarData barData = new BarData(node.barDataSet);
            barData.setBarWidth(1 - candleSet.getBarSpace() * 2);//使Candle和Bar宽度一致

            CombinedData cdata = new CombinedData();
            cdata.setData(barData);
            cdata.setData(new LineData(node.lineDataSet[0], node.lineDataSet[1]));

            node.chart.setData(cdata);
            node.chart.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐
        }
        else if(node.chartType == ChartNode.ChartType.SYMBOL_LIQUIDATION ||
                node.chartType == ChartNode.ChartType.COIN_LIQUIDATION
        ){
            if (node.chartType == ChartNode.ChartType.SYMBOL_LIQUIDATION)
            {
                mDataParse.initSymbolLiq(mDataParse.vipIndexObj);

                node.barDataSet.setEntries(mDataParse.vipIndexObj.barLongSymbolLiqList);
                node.barDataSet2.setEntries(mDataParse.vipIndexObj.barShortSymbolLiqList);
            }
            else if (node.chartType == ChartNode.ChartType.COIN_LIQUIDATION)
            {
                mDataParse.initCoinLiq(mDataParse.vipIndexObj);
                node.barDataSet.setEntries(mDataParse.vipIndexObj.barLongCoinLiqList);
                node.barDataSet2.setEntries(mDataParse.vipIndexObj.barShortCoinLiqList);
            }

            BarData barData = new BarData(node.barDataSet, node.barDataSet2);
            barData.setBarWidth(1 - candleSet.getBarSpace() * 2);//使Candle和Bar宽度一致

            CombinedData cdata = new CombinedData();
            cdata.setData(barData);
            //cdata.setData(new LineData(node.lineDataSet[0], node.lineDataSet[1]));

            node.chart.setData(cdata);
            node.chart.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐
        }
        else if(node.chartType == ChartNode.ChartType.RSI){
            mDataParse.initRSI(mDataParse.kLineList);
            node.barDataSet.setEntries(mDataParse.getBarDatasRSI());
            node.lineDataSet[0].setEntries(mDataParse.getRsiData6());
            node.lineDataSet[1].setEntries(mDataParse.getRsiData12());
            node.lineDataSet[2].setEntries(mDataParse.getRsiData24());
            BarData barData = new BarData(node.barDataSet);
            barData.setBarWidth(1 - candleSet.getBarSpace() * 2);//使Candle和Bar宽度一致

            CombinedData cdata = new CombinedData();
            cdata.setData(barData);
            cdata.setData(new LineData(node.lineDataSet[0], node.lineDataSet[1], node.lineDataSet[2]));

            node.chart.setData(cdata);
            node.chart.getXAxis().setAxisMaximum(xMax + volBarOffset);//保持边缘对齐
        }
    }

    private void dismissLoading() {
        mRefreshLayout.refreshFinish(true);
        changeLoadStatus(false);//取消加载状态
        disableHighlight();
        nothingSelected();
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.tv_more_time) {
            showPopupMenu(tabLayout);
        }
        else if (v.getId() == R.id.iv_mul_kline) {
            Intent intent = new Intent();
            intent.setClass(this, MulKLineActivity.class);
            intent.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_multiple_charts));
            Global.showActivity(this, intent);
            finish();//开启多图模式之后 ，结束本界面
        }
        else if (v.getId() == R.id.iv_favorite) {
            getFavoriteList();
            if (favoriteList.contains(getCurrentSymbol()))
            {
                removeFavoriteSymbol(getCurrentSymbol());
                if (Config.isNightMode)
                {
                    iv_favorite.setImageResource(R.drawable.favorite_night);
                }
                else
                {
                    iv_favorite.setImageResource(R.drawable.favorite_light);
                }
            }
            else
            {
                addFavoriteSymbol(getCurrentSymbol());
                iv_favorite.setImageResource(R.drawable.favorite_sel);
            }
        }
        else if (v.getId() == R.id.rl_title) {
            LeftChooseSymbolDialog leftChooseSymbolDialog = LeftChooseSymbolDialog.newInstance();
            leftChooseSymbolDialog.setListener(new LeftChooseSymbolDialog.OnCallDone() {

                @Override
                public void doEvent() {
                    getFavoriteList();
                    if (favoriteList.contains(getCurrentSymbol()))
                    {
                        iv_favorite.setImageResource(R.drawable.favorite_sel);
                    }
                    else
                    {
                        if (Config.isNightMode)
                        {
                            iv_favorite.setImageResource(R.drawable.favorite_night);
                        }
                        else
                        {
                            iv_favorite.setImageResource(R.drawable.favorite_light);
                        }
                    }
                }

                @Override
                public void openKlineChart(Bundle bundle) {

                }
            });

            leftChooseSymbolDialog.show(this);
        }
        else if (v.getId() == R.id.tv_setting) {
            Intent i = new Intent(this, IndicSettingActivity.class);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_setting));
            Global.showActivity(this, i);
        }
        else if (v.getId() == R.id.tv_indic) {
            showIndicPopupMenu(tabLayout);
        }
        else if (v.getId() == R.id.iv_klBack) {
            onBackPressed();
        }
        else if (v.getId() == R.id.iv_klOrientation) {
            stopTranslate();
            highVisX = mChartKline.getHighestVisibleX();
            setRequestedOrientation(isPort() ? ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE :
                    ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        }
        else
        {
            if (mPeriodPopupMenu !=null && mPeriodPopupMenu.isShowing())
            {
                doKLinePeroidChangeListener(v.getId());
            }
            else if (mIndicPopupMenu != null && mIndicPopupMenu.isShowing())
            {
                doMainIndicClick(v);
                doSubIndicClick(v);
            }
        }
    }

    private float sw, sh;
    private float updateXrange()
    {
        float result = mChartKline.getVisibleXRange();
        CandleData candleData = mChartKline.getCandleData();
        if (candleData != null)
        {
            List<ICandleDataSet> dataSets = candleData.getDataSets();
            if (dataSets != null && dataSets.size() > 0)
            {
                ICandleDataSet dataSet = dataSets.get(0);
                if (dataSet.getEntryCount() > 0)
                {
                    Transformer trans = mChartKline.getTransformer(dataSet.getAxisDependency());
                    float[] positions = trans.generateTransformedValuesCandle(
                            dataSet, mChartKline.getAnimator().getPhaseX(),
                            mChartKline.getAnimator().getPhaseY(),
                            (int)mChartKline.getLowestVisibleX(),
                            (int)mChartKline.getHighestVisibleX());
                    float sw = mChartKline.getWidth();
                    float maxX = positions[positions.length - 2];

                    result = result / (maxX / sw);
                    //MLog.d("result xrange " + result + "  " + maxX);
                }
            }
        }


        Config.getMMKV(this).putFloat(Config.CONF_VISIBLE_XRANGE, result);
        return result;
    }

    @Override
    public void stopTranslate() {
        this.mChartManager.stopTranslate();
    }

    @Override
    public void updateVisibleCount() {

        maxRange = updateXrange();
        if (maxRange <= 10)
        {
            for(int i = 0; i < this.mChartManager.getNodeCount(); i++)
            {
                this.mChartManager.getNode(i).chart.notifyDataSetChanged();
                ViewPortHandler vport = this.mChartManager.getNode(i).chart.getViewPortHandler();
                vport.setMinMaxScaleX(1.0f, vport.getScaleX());
            }
        }
    }

    @Override
    public void changeLoadStatus(boolean b) {
        mChartManager.setLoadStage(b);
    }

    @Override
    public void edgeLoad(float x, boolean left) {
        int v = (int) x;
        if (!left && !xValuesDatetime.containsKey(v) && xValuesDatetime.containsKey(v - 1)) {
            v = v - 1;
        }
        String time = xValuesDatetime.get(v);
        if (!TextUtils.isEmpty(time)) {
            MLog.d("edgeLoad begin 111");
            try {
                long t = sdf.parse(time).getTime();
                if (!left) {//向右获取数据时判断时间间隔
                    return;//向右不加载
                }

                loadingDialog = LoadingDialog.newInstance();
                //loadingDialog.show(this);

                toLeft = left;
                String strTime = "";
                if(mDataParse.kLineList.size() > 0)
                {
                    long ltime = Long.valueOf(mDataParse.kLineList.get(0).timestamp) - 1;
                    strTime = String.valueOf(ltime);
                }
                getData(currPeriod, strTime);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        else
        {
            changeLoadStatus(false);
            MLog.d("edgeLoad begin 0000");
        }
    }

    /**
     * 双击图表，没用到
     */
    private void doubleTapped() {
        if (isPort()) {
            highVisX = mChartKline.getHighestVisibleX();
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        }
    }

    private boolean isHighlight = false;
    @Override
    public void valueSelected(Entry e, float x) {
        isHighlight = true;
        ll_pullview.setPullDownEnable(false);
        float idx = e.getX();
        if (idx < mDataParse.kLineList.size()) {
            updateIndexLastVal((int) idx);
        }
        else
        {
            Global.getAnalytics(this).logEvent("user_action",
                    Global.createBundle("valueSelected idx " + idx + " " + mDataParse.kLineList.size(),
                            getClass().getSimpleName()));
        }

        ll_highlightview.setVisibility(View.VISIBLE);
        if (x > mChartKline.getWidth() / 2)
        {
            Paint paint = new Paint();
            paint.setTextSize(Utils.sp2px(10.0F));
            paint.setStrokeWidth(1.0F);
            float w = Utils.calcTextWidth(paint, tv_price.getText().toString());
            ll_highlightview.setX(Utils.convertDpToPixel(10) + w );
        }
        else
        {
            ll_highlightview.setX(mChartKline.getWidth() - ll_highlightview.getWidth() - Utils.convertDpToPixel(25));
        }
    }

    @Override
    public void nothingSelected() {
        ll_pullview.setPullDownEnable(true);
        isHighlight = false;
        ll_highlightview.setVisibility(View.GONE);
    }

    @Override
    public void enableHighlight() {
        if (!volBarSet.isHighlightEnabled()) {
            candleSet.setHighlightEnabled(true);
            lineSetMin.setHighlightEnabled(true);
            volBarSet.setHighlightEnabled(true);
            this.mChartManager.setHighlightEnable(true);
        }
    }

    @Override
    public void disableHighlight() {
        if (volBarSet.isHighlightEnabled()) {
            candleSet.setHighlightEnabled(false);
            lineSetMin.setHighlightEnabled(false);
            volBarSet.setHighlightEnabled(false);
            this.mChartManager.setHighlightEnable(false);
        }
    }

    @Override
    public void onBackPressed() {
        if (isPort()) {
            super.onBackPressed();
        } else {
            highVisX = mChartKline.getHighestVisibleX();
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        float rightX = mChartKline.getHighestVisibleX();
        if (rightX == mChartKline.getXChartMax()) {//停留在最右端
            edgeLoad(rightX, false);
        }
    }

    @Override
    protected void onDestroy() {
        unregisterBroadcast();
        mHandler.removeMessages(1);
        stopTranslate();
        WebSocketUtils.getInstance().removeSubscribe(getSubscribeArgs());
        WebSocketUtils.getInstance().removeAllSubscribe();
        WebSocketUtils.getInstance().closeWebSocket();
        WebSocketUtils web = WebSocketUtils.getInstance();
        web.setOnMsgListener(null);
        web = null;
        super.onDestroy();
        for(int i = 0; i < this.mChartManager.getNodeCount(); i++)
        {
            this.mChartManager.getNode(i).chart.clearAllViewportJobs();
            this.mChartManager.getNode(i).chart = null;
        }

        mChartManager.chartsList.clear();

        if (xValuesDatetime != null) xValuesDatetime.clear();
        xValuesDatetime = null;
        mDataParse.clearAll();
        mDataParse = null;
        mCot = null;
    }

    /**
     * 横竖屏切换
     */
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        setContentView(R.layout.activity_kline);
        MLog.d("onConfigurationChanged");
        initToolBar();
        initView();
        configData();
        boolean bland = (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE ? true:false);
        if (xValuesDatetime.size() > 0) {
            mChartKline.post(new Runnable() {
                @Override
                public void run() {
                    if (bland)
                    {
                        maxRange = maxRange / (sw/sh);
                    }
                    else
                    {
                        maxRange = maxRange / (sh/sw);
                    }

                    float x = highVisX - maxRange;

                    MLog.d("maxRange:" + maxRange);
                    for (int i = 0; i < mChartManager.getNodeCount(); i++)
                    {
                        mChartManager.getNode(i).chart.setVisibleXRange(maxRange, maxRange);
                    }

                    for (int i = 0; i < mChartManager.getNodeCount(); i++)
                    {
                        mChartManager.getNode(i).chart.moveViewToX(x);
                        mChartManager.getNode(i).chart.notifyDataSetChanged();
                        ViewPortHandler vport = mChartManager.getNode(i).chart.getViewPortHandler();
                        vport.setMinMaxScaleX(1.0F, Float.MAX_VALUE);
                    }

                    //mChartVol.moveViewToX(x + volBarOffset);
                }
            });
        }
    }

    //判断是否竖屏
    public boolean isPort() {
        return getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT;
    }

    public int getColorById(int colorId) {
        return ContextCompat.getColor(this, colorId);
    }


    protected void registerBroadcast()
    {
        IntentFilter filter = new IntentFilter();
        filter.addAction(Config.ACTION_KLINE_ADJUST_HEIGHT);
        filter.addAction(Config.ACTION_KLINE_CHANGE_KLINE_STYLE);
        filter.addAction(Config.ACTION_CHANGE_MA_LINE_WIDTH_);
        registerReceiver(myBroadcast, filter);
    }

    protected void unregisterBroadcast()
    {
        unregisterReceiver(myBroadcast);
    }

    //自定义广播，调整K线主图高度和设置K线是否空心和实心
    private BaseBroadcast myBroadcast = new BaseBroadcast();
    private class BaseBroadcast extends BroadcastReceiver
    {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(Config.ACTION_KLINE_ADJUST_HEIGHT))
            {
                MLog.d("onReceive ACTION_KLINE_ADJUST_HEIGHT");
                Message msg = new Message();
                msg.what = 3;//设置kline chart height
                mHandler.sendMessage(msg);
            }
            else if (intent.getAction().equals(Config.ACTION_KLINE_CHANGE_KLINE_STYLE))
            {
                MLog.d("onReceive ACTION_KLINE_CHANGE_KLINE_STYLE");
                Message msg = new Message();
                msg.what = 4;//设置kline style
                mHandler.sendMessage(msg);
            }
            else if (intent.getAction().equals(Config.ACTION_CHANGE_MA_LINE_WIDTH_))
            {
                MLog.d("onReceive ACTION_CHANGE_MA_LINE_WIDTH_");
                Message msg = new Message();
                msg.what = 5;//设置ma 线宽
                mHandler.sendMessage(msg);
            }
        }
    }


}
