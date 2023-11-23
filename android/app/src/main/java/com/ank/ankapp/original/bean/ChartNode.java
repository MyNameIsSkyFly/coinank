package com.ank.ankapp.original.bean;

import android.content.Context;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.core.content.ContextCompat;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.original.chart.CoupleChartGestureListener;
import com.ank.ankapp.original.chart.CoupleChartValueSelectedListener;
import com.github.mikephil.charting.charts.CombinedChart;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.CandleDataSet;
import com.github.mikephil.charting.data.LineDataSet;

public class ChartNode{
    public int chartIdx;//图表位置
    public RelativeLayout rll;
    public CombinedChart chart;//
    public String subChartTag = "";
    public float chartHeight;
    public int chartType = ChartType.CHART_NONE;
    public CoupleChartGestureListener mGesture;
    public CoupleChartValueSelectedListener mValueSecltedListener;
    public BarDataSet barDataSet;
    public BarDataSet barDataSet2;//爆仓用于空单数据显示
    public CandleDataSet candleDataSet;
    public LineDataSet[] lineDataSet = new LineDataSet[5];
    public int[] lineColors = new int[5];
    public int count = 0;

    public ChartNode(CombinedChart chart)
    {
        chartIdx = 0;
        this.chart = chart;
        chartHeight = chart.getHeight();
    }

    public ChartNode(Context cot, RelativeLayout rll, int type)
    {
        chartIdx = 0;
        this.rll = rll;
        this.chart = rll.findViewById(R.id.sub_chart);
        chartType = type;
        chartHeight = chart.getHeight();

        lineColors[0] = ContextCompat.getColor(cot, R.color.blue_ma);
        lineColors[1] = ContextCompat.getColor(cot, R.color.yellow);
        lineColors[2] = ContextCompat.getColor(cot, R.color.purple);

        if (chartType == ChartType.KDJ)
        {
            subChartTag = "KDJ";
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
        }

        if (chartType == ChartType.RSI)
        {
            subChartTag = "RSI";
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
        }

        if (chartType == ChartType.BOLL || chartType == ChartType.KDJ || chartType == ChartType.RSI
        )
        {
            count = 3;
        }
        else if (chartType == ChartType.MACD)
        {
            subChartTag = "MACD";
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 2;
        }
        else if (chartType == ChartType.LONGSHORT_ACCOUNTS_RATIO)
        {
            subChartTag = cot.getResources().getString(R.string.s_longshort_person);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 1;
            lineColors[0] = ContextCompat.getColor(cot, R.color.sub_chart_single_line_color);
        }
        else if (chartType == ChartType.TOP_POSITION_RATIO)
        {
            subChartTag = cot.getResources().getString(R.string.s_top_trader_position_ratio);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 1;
            lineColors[0] = ContextCompat.getColor(cot, R.color.sub_chart_single_line_color);
        }
        else if (chartType == ChartType.TOP_ACCOUNT_RATIO)
        {
            subChartTag = cot.getResources().getString(R.string.s_top_trader_accounts_ratio);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 1;
            lineColors[0] = ContextCompat.getColor(cot, R.color.sub_chart_single_line_color);
        }
        else if (chartType == ChartType.FUNDING_RATE)
        {
            subChartTag = cot.getResources().getString(R.string.s_funding_rate);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.OI_DELTA)
        {
            subChartTag = cot.getResources().getString(R.string.s_oi_delta);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.OI_FR)
        {
            subChartTag = cot.getResources().getString(R.string.s_oi_fr);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.VOL_FR)
        {
            subChartTag = cot.getResources().getString(R.string.s_vol_fr);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.OPENINTEREST)
        {
            subChartTag = cot.getResources().getString(R.string.s_open_interest);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 1;
            lineColors[0] = ContextCompat.getColor(cot, R.color.sub_chart_single_line_color);
        }
        else if (chartType == ChartType.SYMBOL_LIQUIDATION)
        {
            subChartTag = cot.getResources().getString(R.string.s_symbol_liq);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.COIN_LIQUIDATION)
        {
            subChartTag = cot.getResources().getString(R.string.s_coin_liquidation);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.FUNDING_RATE_KLINE)
        {
            subChartTag = cot.getResources().getString(R.string.s_fr_kline);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.LS_ACCOUNTS_RATIO_K)
        {
            subChartTag = cot.getResources().getString(R.string.s_ls_accounts_k);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.TOP_ACCOUNTS_RATIO_K)
        {
            subChartTag = cot.getResources().getString(R.string.s_ls_top_accounts_k);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.TOP_POSITIONS_RATIO_K)
        {
            subChartTag = cot.getResources().getString(R.string.s_ls_top_positions_ratio_k);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.OI_KLINE)
        {
            subChartTag = cot.getResources().getString(R.string.s_oi_kline);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
        else if (chartType == ChartType.COIN_OI_KLINE)
        {
            subChartTag = cot.getResources().getString(R.string.s_coin_oi_kline);
            ((TextView)rll.findViewById(R.id.tv_chart_info)).setText(subChartTag);
            count = 0;
        }
    }

    public class ChartType {
        public final static int CHART_NONE = 999, KLINE = 1,VOL = 2,
                MA = 0, BOLL = 1, EMA = 2;//主图指标


        public final static int MACD = 0, KDJ = 1, RSI = 2,//副图指标值

        SUB_TYPE_MIN = 3,
                FUNDING_RATE = 3,//资金费率
                OPENINTEREST = 4,//持仓量
                SYMBOL_LIQUIDATION = 5,//交易对爆仓

                FUNDING_RATE_KLINE = 6,//资金费率K线
                        OI_KLINE = 7,//持仓K线
                COIN_LIQUIDATION = 8,//币种爆仓
                LONGSHORT_ACCOUNTS_RATIO = 9,//多空持仓人数比
                TOP_POSITION_RATIO = 10,//大户持仓量多空比
                TOP_ACCOUNT_RATIO = 11,//大户账户数多空比
                COIN_OI_KLINE = 12,
                OI_DELTA = 13,
                OI_FR = 14,//持仓加权FR
                VOL_FR = 15,//成交量加权FR
                LS_ACCOUNTS_RATIO_K = 16,
                TOP_ACCOUNTS_RATIO_K = 17,
                TOP_POSITIONS_RATIO_K = 18,
        SUB_TYPE_MAX = 99;

    }
}
