package com.ank.ankapp.ank_app.original.chart;

import com.ank.ankapp.ank_app.original.bean.ChartManager;
import com.github.mikephil.charting.charts.BarLineChartBase;
import com.github.mikephil.charting.charts.Chart;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.listener.OnChartValueSelectedListener;

/**
 * 图表联动高亮监听
 */
public class CoupleChartValueSelectedListener implements OnChartValueSelectedListener {

    private BarLineChartBase srcChart;
    private Chart[] dstCharts;
    private int selfCahrtIdx = 0;
    private ChartManager mChartManager;

    private ValueSelectedListener mListener;

    public CoupleChartValueSelectedListener(BarLineChartBase srcChart, Chart... dstCharts) {
        this(null, null, srcChart, dstCharts);
    }

    public CoupleChartValueSelectedListener(ValueSelectedListener mListener, ChartManager chartManager,
                                            BarLineChartBase srcChart, Chart... dstCharts) {
        this.mListener = mListener;
        this.srcChart = srcChart;
        this.dstCharts = dstCharts;
        mChartManager = chartManager;
    }

    public CoupleChartValueSelectedListener(ValueSelectedListener mListener, int idx, ChartManager chartManager,
                                            BarLineChartBase srcChart, Chart... dstCharts) {
        this.mListener = mListener;
        this.srcChart = srcChart;
        this.dstCharts = dstCharts;
        selfCahrtIdx = idx;
        mChartManager = chartManager;
    }

    @Override
    public void onValueSelected(Entry e, Highlight h) {

        if (dstCharts != null) {
            int cnt = mChartManager.getNodeCount();
            //MLog.d("onValueSelected cnt " + " " + cnt);
            mChartManager.calcuHeight();//计算各图表的高度
            for(int i = 0; i < cnt; i++)
            {
                float touchY = h.getDrawY();//手指接触点在srcChart上的Y坐标，即手势监听器中保存数据
                float y = h.getY();
                //MLog.d("touchY:" + touchY);
                if(i != selfCahrtIdx)//如果不是自己
                {
                    if(i < selfCahrtIdx)
                    {
                        float sum = 0.0F;
                        for(int j = i; j < selfCahrtIdx; j++)
                        {
                            sum += this.mChartManager.chartsList.get(j).chartHeight;
                        }

                        y = touchY + sum;
                    }
                    else{
                        float sum = 0.0F;
                        for(int j = selfCahrtIdx; j < i; j++)
                        {
                            sum += this.mChartManager.chartsList.get(j).chartHeight;
                        }

                        y = touchY - sum;
                    }

                    Highlight hl = new Highlight(h.getX(), Float.NaN, h.getDataSetIndex());
                    hl.setDraw(h.getX(), y);
                    this.mChartManager.chartsList.get(i).chart.highlightValues(new Highlight[]{hl});
                }//end if
            }
        }

        if (mListener != null) {
            mListener.valueSelected(e, h.getDrawX());
        }
    }

    @Override
    public void onNothingSelected() {
        if (dstCharts != null) {
            for (Chart chart : dstCharts) {
                chart.highlightValues(null);
            }
        }
        if (mListener != null) {
            mListener.nothingSelected();
        }
    }

    public interface ValueSelectedListener {
        void valueSelected(Entry e, float x);
        void nothingSelected();
    }
}
