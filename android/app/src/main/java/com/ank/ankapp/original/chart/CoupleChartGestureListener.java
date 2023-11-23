package com.ank.ankapp.original.chart;

import android.graphics.Matrix;
import android.view.MotionEvent;

import com.ank.ankapp.original.utils.MLog;
import com.github.mikephil.charting.charts.BarLineChartBase;
import com.github.mikephil.charting.charts.Chart;
import com.github.mikephil.charting.listener.BarLineChartTouchListener;
import com.github.mikephil.charting.listener.ChartTouchListener;
import com.github.mikephil.charting.listener.OnChartGestureListener;

/**
 * 图表联动交互监听
 */
public class CoupleChartGestureListener implements OnChartGestureListener {

    private BarLineChartBase srcChart;
    private Chart[] dstCharts;

    private OnDoSomething doListener;//滑动到边缘的监听器
    private boolean isLoadMore, isHighlight;//是否加载更多、是否高亮  -- 高亮时不再加载更多
    private boolean canLoad;//K线图手指交互已停止，正在惯性滑动
    private boolean isLoadding = false;//正在加载

    public CoupleChartGestureListener(BarLineChartBase srcChart, Chart... dstCharts) {
        this.srcChart = srcChart;
        this.dstCharts = dstCharts;
        isLoadMore = true;
        isLoadding = false;
    }

    public CoupleChartGestureListener(OnDoSomething doSomethingListener, BarLineChartBase srcChart,
                                      Chart... dstCharts) {
        this.doListener = doSomethingListener;
        this.srcChart = srcChart;
        this.dstCharts = dstCharts;
        isLoadMore = true;
        isLoadding = false;
    }

    @Override
    public void onChartGestureStart(MotionEvent me, ChartTouchListener.ChartGesture lastPerformedGesture) {
        if(doListener != null)
        {
            doListener.stopTranslate();
        }
        canLoad = false;
        //图表有数据才联动
        if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
            syncCharts();
        chartGestureStart(me, lastPerformedGesture);
    }

    @Override
    public void onChartTranslate(MotionEvent me, float dX, float dY) {
        //如果onChartGestureEnd里面已经在加载了，那么这里就立即停止惯性滑动
        if(isLoadding)
        {
            ((BarLineChartTouchListener)srcChart.getOnTouchListener()).stopDeceleration();
            MLog.e("***isLoadding onChartTranslate return");
            //图表有数据才联动
            if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
                 syncCharts();
            return;
        }

        if (canLoad && !isLoadding) {
            //MLog.d("onChartTranslate load left data*******");
            float leftX = srcChart.getLowestVisibleX();
            float rightX = srcChart.getHighestVisibleX();
            if (leftX == srcChart.getXChartMin()) {//滑到最左端
                canLoad = false;
                if (doListener != null) {
                    MLog.e("onChartTranslate load left data");
                    ((BarLineChartTouchListener)srcChart.getOnTouchListener()).stopDeceleration();
                    doListener.changeLoadStatus(true);//正在加载状态
                    doListener.edgeLoad(leftX, true);
                }
            } else if (rightX == srcChart.getXChartMax()) {//滑到最右端
                canLoad = false;
                if (doListener != null) {
                    //doListener.edgeLoad(rightX, false);
                }
            }
        }

        //图表有数据才联动
        if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
            syncCharts();
        chartTranslate(me, dX, dY);
    }

    @Override
    public void onChartGestureEnd(MotionEvent me, ChartTouchListener.ChartGesture lastPerformedGesture) {
        //MLog.e("onChartGestureEnd");
        if(doListener != null)
        {
            //doListener.updateVisibleCount();
        }

        if (isLoadding)
        {
            //图表有数据才联动
            if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
                syncCharts();
            MLog.e("isLoadding onChartGestureEnd return");
            return;
        }

        if (isHighlight) {
            isHighlight = false;
        } else {
            if (isLoadMore && !isLoadding)
            {
                float leftX = srcChart.getLowestVisibleX();
                float rightX = srcChart.getHighestVisibleX();
                if (leftX == srcChart.getXChartMin()) {//滑到最左端
                    canLoad = false;
                    if (doListener != null) {
                        MLog.e("****onChartGestureEnd load left data");
                        ((BarLineChartTouchListener)srcChart.getOnTouchListener()).stopDeceleration();
                        doListener.changeLoadStatus(true);//正在加载状态
                        MLog.d("onChartGestureEnd load left 2222");
                        doListener.edgeLoad(leftX, true);
                        MLog.d("onChartGestureEnd load left 3333");
                    }
                } else if (rightX == srcChart.getXChartMax()) {//滑到最右端
                    canLoad = false;
                    if (doListener != null) {
                        //doListener.edgeLoad(rightX, false);
                    }
                } else {
                    canLoad = true;
                }
            }
        }

        //图表有数据才联动
        if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
            syncCharts();
        chartGestureEnd(me, lastPerformedGesture);
    }

    @Override
    public void onChartLongPressed(MotionEvent me) {
        //MLog.d("onChartLongPressed");
        //图表有数据才联动
        if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
            syncCharts();
        chartLongPressed(me);
    }

    @Override
    public void onChartDoubleTapped(MotionEvent me) {
        //图表有数据才联动
        if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
            syncCharts();
        chartDoubleTapped(me);
    }

    @Override
    public void onChartSingleTapped(MotionEvent me) {
        //图表有数据才联动
        if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
            syncCharts();
        //MLog.d("onChartSingleTapped");
        chartSingleTapped(me);
    }

    @Override
    public void onChartFling(MotionEvent me1, MotionEvent me2, float velocityX, float velocityY) {
        //图表有数据才联动
        if (srcChart.getData().getEntryCount() > 0)
            syncCharts();
    }

    @Override
    public void onChartScale(MotionEvent me, float scaleX, float scaleY) {
        //MLog.d("onChartScale sx sy:" + scaleX + " " + scaleY);
        if(doListener != null)
        {
            doListener.updateVisibleCount();
        }

        //图表有数据才联动
        if (srcChart != null && srcChart.getData() != null && srcChart.getData().getEntryCount() > 0)
            syncCharts();
    }

    private void syncCharts() {
        if(dstCharts == null) return;
        Matrix srcMatrix;
        float[] srcVals = new float[9];
        Matrix dstMatrix;
        float[] dstVals = new float[9];
        // get src chart translation matrix:
        srcMatrix = srcChart.getViewPortHandler().getMatrixTouch();
        srcMatrix.getValues(srcVals);
        // apply X axis scaling and position to dst charts:
        for (Chart dstChart : dstCharts) {
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
    }

    public void chartGestureStart(MotionEvent me, ChartTouchListener.ChartGesture lastPerformedGesture) {}
    public void chartGestureEnd(MotionEvent me, ChartTouchListener.ChartGesture lastPerformedGesture) {}
    public void chartLongPressed(MotionEvent me) {}
    public void chartDoubleTapped(MotionEvent me) {}
    public void chartSingleTapped(MotionEvent me) {}
    public void chartTranslate(MotionEvent me, float dX, float dY) {}

    public void setHighlight(boolean highlight) {
        //isHighlight = highlight;
    }
    public void setLoadStage(boolean b) {
        isLoadding = b;
        //MLog.d("setLoadStage:" + b);
    }

    public interface OnDoSomething {
        void edgeLoad(float x, boolean left);
        void stopTranslate();
        void updateVisibleCount();
        void changeLoadStatus(boolean b);
    }
}