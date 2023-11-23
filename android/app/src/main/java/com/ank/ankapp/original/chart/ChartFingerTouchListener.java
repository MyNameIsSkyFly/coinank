package com.ank.ankapp.original.chart;

import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;

import com.github.mikephil.charting.charts.BarLineChartBase;
import com.github.mikephil.charting.charts.CombinedChart;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.CandleData;
import com.github.mikephil.charting.data.CandleDataSet;
import com.github.mikephil.charting.highlight.Highlight;

/**
 * 图表长按及滑动手指监听
 */
public class ChartFingerTouchListener implements View.OnTouchListener {

    private BarLineChartBase mChart;
    private GestureDetector mDetector;
    private HighlightListener mListener;
    private boolean mIsLongPress = false;

    public ChartFingerTouchListener(BarLineChartBase chart, HighlightListener listener) {
        mChart = chart;
        mListener = listener;
        mDetector = new GestureDetector(mChart.getContext(), new GestureDetector.SimpleOnGestureListener() {
            @Override
            public void onLongPress(MotionEvent e) {
                super.onLongPress(e);
                mIsLongPress = true;
                if (mListener != null) {
                    mListener.enableHighlight();
                }

                Highlight h = mChart.getHighlightByTouchPoint(e.getX(), e.getY());
                if (h != null) {
                    h.setDraw(e.getX(), e.getY());
                    mChart.highlightValue(h, true);
                    mChart.disableScroll();
                }
            }

            @Override
            public boolean onSingleTapUp(MotionEvent e) {
                if (!isHightlightStatus())
                {
                    if (mListener != null) {
                        mListener.enableHighlight();
                    }

                    Highlight h = mChart.getHighlightByTouchPoint(e.getX(), e.getY());
                    if (h != null) {
                        h.setDraw(e.getX(), e.getY());
                        mChart.highlightValue(h, true);
                    }
                }
                else
                {
                    mIsLongPress = false;

                    mChart.highlightValue(null, true);
                    if (mListener != null) {
                        mListener.disableHighlight();
                    }

                    mChart.enableScroll();
                }

                return super.onSingleTapUp(e);
            }
        });
    }


    float lastX = 0, lastY = 0;
    @Override
    public boolean onTouch(View v, MotionEvent event) {
        mDetector.onTouchEvent(event);
        boolean result = false;
        float x = event.getRawX();
        float y = event.getRawY();
        switch (event.getAction())
        {
            case MotionEvent.ACTION_DOWN:
                lastX = x;
                lastY = y;
                break;
            case MotionEvent.ACTION_MOVE:
                if (mIsLongPress && isHightlightStatus()) {
                    if (mListener != null) {
                        mListener.enableHighlight();
                    }

                    Highlight h = mChart.getHighlightByTouchPoint(event.getX(), event.getY());
                    if (h != null) {
                        h.setDraw(event.getX(), event.getY());
                        mChart.highlightValue(h, true);
                        mChart.disableScroll();
                    }

                    result = true;
                }
                else
                {
                    if (Math.abs(x - lastX) > 5 ||
                            Math.abs(y - lastY) > 5
                    )
                    {
                        mIsLongPress = false;

                        mChart.highlightValue(null, true);
                        if (mListener != null) {
                            mListener.disableHighlight();
                        }

                        mChart.enableScroll();
                        result = false;//不拦截
                    }
                }
                break;
            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_UP:
                if (isHightlightStatus())
                {
                    result = true;//拦截
                }

                if (mIsLongPress && isHightlightStatus())
                {
                    mIsLongPress = false;

                    mChart.highlightValue(null, true);
                    if (mListener != null) {
                        mListener.disableHighlight();
                    }

                    mChart.enableScroll();
                    result = false;
                }


                break;
        }

        return result;
    }

    private boolean isHightlightStatus()
    {
        boolean b = false;
        CandleData cdata = ((CombinedChart)mChart).getCandleData();
        if (cdata == null)
        {
            BarData barData = ((CombinedChart)mChart).getBarData();
            if (barData != null)
            {
                BarDataSet barDataSet = (BarDataSet)barData.getDataSetByIndex(0);
                if (barDataSet != null)
                {
                    b = barDataSet.isHighlightEnabled();
                }
            }
        }
        else
        {
            CandleDataSet cdset = (CandleDataSet)cdata.getDataSetByIndex(0);
            if (cdset != null)
            {
                b = cdset.isHighlightEnabled();
            }
        }

        return b;
    }

    public interface HighlightListener {
        void enableHighlight();
        void disableHighlight();
    }
}
