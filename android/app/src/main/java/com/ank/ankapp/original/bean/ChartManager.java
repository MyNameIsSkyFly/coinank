package com.ank.ankapp.original.bean;

import android.widget.RelativeLayout;

import com.ank.ankapp.original.activity.KLineActivity;
import com.ank.ankapp.original.chart.ChartFingerTouchListener;
import com.ank.ankapp.original.chart.CoupleChartGestureListener;
import com.ank.ankapp.original.chart.CoupleChartValueSelectedListener;
import com.ank.ankapp.original.fragment.CominedKLineFragment;
import com.github.mikephil.charting.charts.Chart;
import com.github.mikephil.charting.listener.BarLineChartTouchListener;

import java.util.ArrayList;

public class ChartManager {
    public ArrayList<ChartNode> chartsList = new ArrayList<>();
    public Object activity;

    public ChartManager(Object activity) {
        this.activity = activity;
    }

    //add之后，会自动全部重新刷新手势监听和高亮监听
    public void addNode(ChartNode node)
    {
        if (activity instanceof  KLineActivity)
        {
            node.chart.setOnTouchListener(new ChartFingerTouchListener(node.chart, (KLineActivity)activity));
        }
        else
        {
            node.chart.setOnTouchListener(new ChartFingerTouchListener(node.chart, (CominedKLineFragment)activity));
        }

        chartsList.add(node);
        node.chartIdx = chartsList.size() - 1;

        if(chartsList.size() >=2)
        {
            setGestureListener();
            setValueSelectedListener();
        }
    }

    public void removeAllNode()
    {
        chartsList.clear();
    }

    //移除后，需要更新idx和重新设置手势和高亮监听
    public void removeNode(int idx)
    {
        chartsList.remove(idx);
        for(int i = 0; i < chartsList.size(); i++)
        {
            chartsList.get(i).chartIdx = i;
        }

        setGestureListener();
        setValueSelectedListener();
    }

    public void setHighlightEnable(boolean b)
    {
        for(int i = 2; i < chartsList.size(); i++)
        {
            ChartNode node = chartsList.get(i);
            node.barDataSet.setHighlightEnabled(b);
            if (node.candleDataSet != null)
                node.candleDataSet.setHighlightEnabled(b);

            if(node.chartType == ChartNode.ChartType.KDJ ||
                    node.chartType == ChartNode.ChartType.RSI ||
                    node.chartType == ChartNode.ChartType.OPENINTEREST ||
                    node.chartType == ChartNode.ChartType.LONGSHORT_ACCOUNTS_RATIO ||
                    node.chartType == ChartNode.ChartType.TOP_POSITION_RATIO ||
                    node.chartType == ChartNode.ChartType.TOP_ACCOUNT_RATIO
            )
            {
                node.barDataSet.setHighlightEnabled(b);
                //只设置一条线允许高亮即可
                //for (int j = 0; j < node.count; j++)
                for (int j = 0; j < 1; j++)
                {
                    node.lineDataSet[j].setHighlightEnabled(b);
                }
            }

        }
    }

    public void calcuHeight()
    {
        for(int i = 0; i < chartsList.size(); i++)
        {
            chartsList.get(i).chartHeight =  chartsList.get(i).chart.getHeight();
            //MLog.d("height:" + chartsList.get(i).chartHeight);
        }
    }

    public void setLoadStage(boolean b)
    {
        for(int i = 0; i < chartsList.size(); i++)
        {
            chartsList.get(i).mGesture.setLoadStage(b);
        }
    }

    public void stopTranslate()
    {
        for(int i = 0; i < chartsList.size(); i++)
        {
            ((BarLineChartTouchListener)(chartsList.get(i).chart.getOnTouchListener())).stopDeceleration();
        }
    }

    public int getNodeCount()
    {
        return chartsList.size();
    }

    public ChartNode getNode(int i)
    {
        return chartsList.get(i);
    }

    public ChartNode getNodeByType(int chartType)
    {
        for (int i = 0; i < chartsList.size(); i++)
        {

            if (chartsList.get(i).chartType == chartType)
            {
                return chartsList.get(i);
            }
        }

        return null;
    }

    public RelativeLayout getChartByType(int chartType)
    {
        for (int i = 0; i < chartsList.size(); i++)
        {

            if (chartsList.get(i).chartType == chartType)
            {
                return chartsList.get(i).rll;
            }
        }

        return null;
    }

    public void setGestureListener(){
        int size = chartsList.size();
        for(int i = 0; i < size; i++)
        {
            if(chartsList.get(i).mGesture != null){
                chartsList.get(i).mGesture = null;//回收
            }

            if (activity instanceof  KLineActivity)
            {
                chartsList.get(i).mGesture = new CoupleChartGestureListener((KLineActivity)activity,
                        chartsList.get(i).chart, getDstCharts(i));
            }
            else
            {
                chartsList.get(i).mGesture = new CoupleChartGestureListener((CominedKLineFragment)activity,
                        chartsList.get(i).chart, getDstCharts(i));
            }

            chartsList.get(i).chart.setOnChartGestureListener(chartsList.get(i).mGesture);
        }
    }

    public void setValueSelectedListener(){
        int size = chartsList.size();
        for(int i = 0; i < size; i++)
        {
            if(chartsList.get(i).mValueSecltedListener != null){
                chartsList.get(i).mValueSecltedListener = null;//回收
            }

            if (activity instanceof  KLineActivity)
            {
                chartsList.get(i).mValueSecltedListener = new CoupleChartValueSelectedListener((KLineActivity)activity, i,this,
                        chartsList.get(i).chart, getDstCharts(i));
            }
            else
            {
                chartsList.get(i).mValueSecltedListener = new CoupleChartValueSelectedListener((CominedKLineFragment)activity, i,this,
                        chartsList.get(i).chart, getDstCharts(i));
            }

            chartsList.get(i).chart.setOnChartValueSelectedListener(chartsList.get(i).mValueSecltedListener);
        }
    }

    public Chart[] getDstCharts(int exceptIdx)
    {
        int dstCnt = chartsList.size() - 1;
        Chart[] charts = new Chart[dstCnt];
        int currpos = 0;
        for(int i = 0; i < chartsList.size(); i++)
        {
            if(exceptIdx != chartsList.get(i).chartIdx){
                charts[currpos++] = chartsList.get(i).chart;
            }
        }

        return charts;
    }
}
