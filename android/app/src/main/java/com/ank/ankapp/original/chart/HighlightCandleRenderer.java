package com.ank.ankapp.original.chart;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;

import com.ank.ankapp.original.utils.AppUtils;
import com.github.mikephil.charting.animation.ChartAnimator;
import com.github.mikephil.charting.charts.CombinedChart;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.CandleData;
import com.github.mikephil.charting.data.CandleEntry;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.interfaces.dataprovider.CandleDataProvider;
import com.github.mikephil.charting.interfaces.datasets.ICandleDataSet;
import com.github.mikephil.charting.renderer.CandleStickChartRenderer;
import com.github.mikephil.charting.renderer.DataRenderer;
import com.github.mikephil.charting.utils.ColorTemplate;
import com.github.mikephil.charting.utils.MPPointD;
import com.github.mikephil.charting.utils.MPPointF;
import com.github.mikephil.charting.utils.Transformer;
import com.github.mikephil.charting.utils.Utils;
import com.github.mikephil.charting.utils.ViewPortHandler;

import java.text.DecimalFormat;
import java.util.List;

/**
 * 自定义CandleStickChart渲染器 绘制高亮  -- 绘制方式和自定义LineChart渲染器相同
 * 使用方法: 1.先设置渲染器 {@link CombinedChart#setRenderer(DataRenderer)}
 *              传入自定义渲染器 将其中Candle图的渲染器替换成此渲染器
 *           2.设置数据时 调用 {@link CandleEntry#CandleEntry(float, float, float, float, float, Object)}
 *              传入String类型的data 以绘制x的值  -- 如未设置 则只绘制竖线
 */
public class HighlightCandleRenderer extends CandleStickChartRenderer {

    private float highlightSize;//图表高亮文字大小 单位:px
    private final DecimalFormat format = new DecimalFormat("0.0000");
    private Highlight[] indices;

    public HighlightCandleRenderer(CandleDataProvider chart, ChartAnimator animator,
                                   ViewPortHandler viewPortHandler) {
        super(chart, animator, viewPortHandler);
    }

    public HighlightCandleRenderer setHighlightSize(float textSize) {
        highlightSize = textSize;
        return this;
    }

    @Override
    public void drawData(Canvas c) {
        super.drawData(c);
    }

    @Override
    protected void drawDataSet(Canvas c, ICandleDataSet dataSet) {
        Transformer trans = mChart.getTransformer(dataSet.getAxisDependency());

        float phaseY = mAnimator.getPhaseY();
        float barSpace = dataSet.getBarSpace();
        boolean showCandleBar = dataSet.getShowCandleBar();

        mXBounds.set(mChart, dataSet);

        mRenderPaint.setStrokeWidth(dataSet.getShadowWidth());

        // draw the body
        for (int j = mXBounds.min; j <= mXBounds.range + mXBounds.min; j++) {

            // get the entry
            CandleEntry e = dataSet.getEntryForIndex(j);

            if (e == null)
                continue;

            final float xPos = e.getX();

            final float open = e.getOpen();
            final float close = e.getClose();
            final float high = e.getHigh();
            final float low = e.getLow();

            if (showCandleBar) {
                // calculate the shadow

                //上下景线2条线 x坐标，单数为y坐标，
                mShadowBuffers[0] = xPos;
                mShadowBuffers[2] = xPos;
                mShadowBuffers[4] = xPos;
                mShadowBuffers[6] = xPos;

                if (open > close) {
                    mShadowBuffers[1] = high * phaseY;
                    mShadowBuffers[3] = open * phaseY;
                    mShadowBuffers[5] = low * phaseY;
                    mShadowBuffers[7] = close * phaseY;
                } else if (open < close) {
                    mShadowBuffers[1] = high * phaseY;
                    mShadowBuffers[3] = close * phaseY;
                    mShadowBuffers[5] = low * phaseY;
                    mShadowBuffers[7] = open * phaseY;
                } else {
                    mShadowBuffers[1] = high * phaseY;
                    mShadowBuffers[3] = open * phaseY;
                    mShadowBuffers[5] = low * phaseY;
                    mShadowBuffers[7] = mShadowBuffers[3];
                }

                trans.pointValuesToPixel(mShadowBuffers);

                // draw the shadows

                if (dataSet.getShadowColorSameAsCandle()) {

                    if (open > close)
                        mRenderPaint.setColor(
                                dataSet.getDecreasingColor() == ColorTemplate.COLOR_NONE ?
                                        dataSet.getColor(j) :
                                        dataSet.getDecreasingColor()
                        );

                    else if (open < close)
                        mRenderPaint.setColor(
                                dataSet.getIncreasingColor() == ColorTemplate.COLOR_NONE ?
                                        dataSet.getColor(j) :
                                        dataSet.getIncreasingColor()
                        );

                    else
                        mRenderPaint.setColor(
                                dataSet.getNeutralColor() == ColorTemplate.COLOR_NONE ?
                                        dataSet.getColor(j) :
                                        dataSet.getNeutralColor()
                        );

                } else {
                    mRenderPaint.setColor(
                            dataSet.getShadowColor() == ColorTemplate.COLOR_NONE ?
                                    dataSet.getColor(j) :
                                    dataSet.getShadowColor()
                    );
                }

                mRenderPaint.setStyle(Paint.Style.STROKE);

                //画2条影线，mShadowBuffers长度为8，4个点坐标
                c.drawLines(mShadowBuffers, mRenderPaint);

                // calculate the body

                mBodyBuffers[0] = xPos - 0.5f + barSpace;
                mBodyBuffers[1] = close * phaseY;
                mBodyBuffers[2] = (xPos + 0.5f - barSpace);
                mBodyBuffers[3] = open * phaseY;

                trans.pointValuesToPixel(mBodyBuffers);

                // draw body differently for increasing and decreasing entry
                if (open > close) { // decreasing

                    if (dataSet.getDecreasingColor() == ColorTemplate.COLOR_NONE) {
                        mRenderPaint.setColor(dataSet.getColor(j));
                    } else {
                        mRenderPaint.setColor(dataSet.getDecreasingColor());
                    }

                    mRenderPaint.setStyle(dataSet.getDecreasingPaintStyle());

                    RectF rect = new RectF();
                    rect.left = mBodyBuffers[0];
                    rect.top = mBodyBuffers[3];
                    rect.right = mBodyBuffers[2];
                    rect.bottom = mBodyBuffers[1];
//                    c.drawRect(
//                            mBodyBuffers[0], mBodyBuffers[3],
//                            mBodyBuffers[2], mBodyBuffers[1],
//                            mRenderPaint);
                    c.drawRect(rect, mRenderPaint);

                } else if (open < close) {

                    if (dataSet.getIncreasingColor() == ColorTemplate.COLOR_NONE) {
                        mRenderPaint.setColor(dataSet.getColor(j));
                    } else {
                        mRenderPaint.setColor(dataSet.getIncreasingColor());
                    }

                    mRenderPaint.setStyle(dataSet.getIncreasingPaintStyle());

                    c.drawRect(
                            mBodyBuffers[0], mBodyBuffers[1],
                            mBodyBuffers[2], mBodyBuffers[3],
                            mRenderPaint);
                } else { // equal values

                    if (dataSet.getNeutralColor() == ColorTemplate.COLOR_NONE) {
                        mRenderPaint.setColor(dataSet.getColor(j));
                    } else {
                        mRenderPaint.setColor(dataSet.getNeutralColor());
                    }

                    c.drawLine(
                            mBodyBuffers[0], mBodyBuffers[1],
                            mBodyBuffers[2], mBodyBuffers[3],
                            mRenderPaint);
                }
            } else {

                mRangeBuffers[0] = xPos;
                mRangeBuffers[1] = high * phaseY;
                mRangeBuffers[2] = xPos;
                mRangeBuffers[3] = low * phaseY;

                mOpenBuffers[0] = xPos - 0.5f + barSpace;
                mOpenBuffers[1] = open * phaseY;
                mOpenBuffers[2] = xPos;
                mOpenBuffers[3] = open * phaseY;

                mCloseBuffers[0] = xPos + 0.5f - barSpace;
                mCloseBuffers[1] = close * phaseY;
                mCloseBuffers[2] = xPos;
                mCloseBuffers[3] = close * phaseY;

                trans.pointValuesToPixel(mRangeBuffers);
                trans.pointValuesToPixel(mOpenBuffers);
                trans.pointValuesToPixel(mCloseBuffers);

                // draw the ranges
                int barColor;

                if (open > close)
                    barColor = dataSet.getDecreasingColor() == ColorTemplate.COLOR_NONE
                            ? dataSet.getColor(j)
                            : dataSet.getDecreasingColor();
                else if (open < close)
                    barColor = dataSet.getIncreasingColor() == ColorTemplate.COLOR_NONE
                            ? dataSet.getColor(j)
                            : dataSet.getIncreasingColor();
                else
                    barColor = dataSet.getNeutralColor() == ColorTemplate.COLOR_NONE
                            ? dataSet.getColor(j)
                            : dataSet.getNeutralColor();

                mRenderPaint.setColor(barColor);
                c.drawLine(
                        mRangeBuffers[0], mRangeBuffers[1],
                        mRangeBuffers[2], mRangeBuffers[3],
                        mRenderPaint);
                c.drawLine(
                        mOpenBuffers[0], mOpenBuffers[1],
                        mOpenBuffers[2], mOpenBuffers[3],
                        mRenderPaint);
                c.drawLine(
                        mCloseBuffers[0], mCloseBuffers[1],
                        mCloseBuffers[2], mCloseBuffers[3],
                        mRenderPaint);
            }
        }
    }

    @Override
    public void drawValues(Canvas c) {
        //super.drawValues(c);
        // if values are drawn
        //if (isDrawingValuesAllowed(mChart)) //by listen 2022-03-16
        {

            List<ICandleDataSet> dataSets = mChart.getCandleData().getDataSets();

            for (int i = 0; i < dataSets.size(); i++) {

                ICandleDataSet dataSet = dataSets.get(i);

                if (!shouldDrawValues(dataSet) || dataSet.getEntryCount() < 1)
                    continue;

                // apply the text-styling defined by the DataSet
                applyValueTextStyle(dataSet);

                Transformer trans = mChart.getTransformer(dataSet.getAxisDependency());

                mXBounds.set(mChart, dataSet);
                /*
                System.out.println("pos info " + mAnimator.getPhaseX() + " "
                        + mAnimator.getPhaseY() + " "
                        + mXBounds.min + " "
                        + mXBounds.max + " "
                );
                 */
                float[] positions = trans.generateTransformedValuesCandle(
                        dataSet, mAnimator.getPhaseX(), mAnimator.getPhaseY(), mXBounds.min, mXBounds.max);

                int minx = Math.max((int)mChart.getLowestVisibleX(), 0);
                int maxx = Math.min((int)mChart.getHighestVisibleX() + 1, dataSet.getEntryCount());

                float yOffset = Utils.convertDpToPixel(5f);

                MPPointF iconsOffset = MPPointF.getInstance(dataSet.getIconsOffset());
                iconsOffset.x = Utils.convertDpToPixel(iconsOffset.x);
                iconsOffset.y = Utils.convertDpToPixel(iconsOffset.y);
                //System.out.println("len " + positions.length + " " + positions[positions.length - 2]);
                for (int j = 0; j < positions.length; j += 2) {

                    float x = positions[j];
                    float y = positions[j + 1];

                    if (!mViewPortHandler.isInBoundsRight(x))
                        break;

                    if (!mViewPortHandler.isInBoundsLeft(x) || !mViewPortHandler.isInBoundsY(y))
                        continue;

                    CandleEntry entry = dataSet.getEntryForIndex(j / 2 + mXBounds.min);

                    if (dataSet.isDrawValuesEnabled()) {
                        drawValue(c,
                                dataSet.getValueFormatter(),
                                entry.getHigh(),
                                entry,
                                i,
                                x,
                                y - yOffset,
                                dataSet
                                        .getValueTextColor(j / 2));
                    }

                    if (entry.getIcon() != null && dataSet.isDrawIconsEnabled()) {

                        Drawable icon = entry.getIcon();

                        Utils.drawImage(
                                c,
                                icon,
                                (int)(x + iconsOffset.x),
                                (int)(y + iconsOffset.y),
                                icon.getIntrinsicWidth(),
                                icon.getIntrinsicHeight());
                    }
                }

                MPPointF.recycleInstance(iconsOffset);

                //added by listen,K线显示最大最小值
                if(positions.length > 2)
                {
                    mValuePaint.setTextSize(Utils.sp2px(9.F));
                    //计算最大值和最小值
                    float maxValue = 0,minValue = 0;
                    int maxIndex = 0 , minIndex = 0;
                    CandleEntry maxEntry = null, minEntry = null;
                    boolean firstInit = true;
                    for (int j = 0; j < positions.length; j += 2) {

                        float x = positions[j];
                        float y = positions[j + 1];

                        if (!mViewPortHandler.isInBoundsRight(x))
                            break;

                        if (!mViewPortHandler.isInBoundsLeft(x) || !mViewPortHandler.isInBoundsY(y))
                            continue;

                        CandleEntry entry = dataSet.getEntryForIndex(j / 2 + minx);

                        if (firstInit){
                            maxValue = entry.getHigh();
                            minValue = entry.getLow();
                            firstInit = false;
                            maxEntry = entry;
                            minEntry = entry;
                        }else{
                            if (entry.getHigh() > maxValue)
                            {
                                maxValue = entry.getHigh();
                                maxIndex = j;
                                maxEntry = entry;
                            }

                            if (entry.getLow() < minValue){
                                minValue = entry.getLow();
                                minIndex = j;
                                minEntry = entry;
                            }

                        }
                    }

                    //绘制最大值和最小值
                    float x = positions[minIndex];
                    float y = positions[minIndex + 1];
                    if (maxIndex > minIndex){
                        //画右边
                        String highString = "← " + Utils.getFormatStringValue(minValue);

                        //计算显示位置
                        //计算文本宽度
                        int highStringWidth = Utils.calcTextWidth(mValuePaint, highString);
                        int highStringHeight = Utils.calcTextHeight(mValuePaint, highString);

                        float[] tPosition=new float[2];
                        tPosition[1]=minValue;
                        trans.pointValuesToPixel(tPosition);
                        mValuePaint.setColor(dataSet.getValueTextColor(minIndex / 2));
                        c.drawText(highString, x + highStringWidth /2, tPosition[1], mValuePaint);
                    }else{
                        //画左边
                        String highString = Utils.getFormatStringValue(minValue) +" →";

                        //计算显示位置
                        int highStringWidth = Utils.calcTextWidth(mValuePaint, highString);
                        int highStringHeight = Utils.calcTextHeight(mValuePaint, highString);

                    /*mValuePaint.setColor(dataSet.getValueTextColor(minIndex / 2));
                    c.drawText(highString, x-highStringWidth/2, y+yOffset, mValuePaint);*/
                        float[] tPosition=new float[2];
                        tPosition[1]=minValue;
                        trans.pointValuesToPixel(tPosition);
                        mValuePaint.setColor(dataSet.getValueTextColor(minIndex / 2));
                        c.drawText(highString, x - highStringWidth /2, tPosition[1], mValuePaint);
                    }

                    x = positions[maxIndex];
                    y = positions[maxIndex + 1];
                    if (maxIndex > minIndex){
                        //画左边
                        String highString = Utils.getFormatStringValue(maxValue) +" →";

                        int highStringWidth = Utils.calcTextWidth(mValuePaint, highString);
                        int highStringHeight = Utils.calcTextHeight(mValuePaint, highString);

                        float[] tPosition=new float[2];
                        tPosition[0] = maxEntry == null ? 0f:maxEntry.getX();
                        tPosition[1] = maxEntry == null ? 0f:maxEntry.getHigh();
                        trans.pointValuesToPixel(tPosition);

                        mValuePaint.setColor(dataSet.getValueTextColor(maxIndex / 2));
                        //c.drawText(highString, x+highStringWidth , y-yOffset, mValuePaint);
                        c.drawText(highString, tPosition[0] - highStringWidth /2, tPosition[1], mValuePaint);

                    /*mValuePaint.setColor(dataSet.getValueTextColor(maxIndex / 2));
                    c.drawText(highString, x - highStringWidth, y-yOffset, mValuePaint);*/
                    }else{
                        //画右边
                        String highString = "← " + Utils.getFormatStringValue(maxValue);//Float.toString(maxValue);

                        //计算显示位置
                        int highStringWidth = Utils.calcTextWidth(mValuePaint, highString);
                        int highStringHeight = Utils.calcTextHeight(mValuePaint, highString);

                        float[] tPosition=new float[2];
                        tPosition[0] = maxEntry == null ? 0f:maxEntry.getX();
                        tPosition[1] = maxEntry == null ? 0f:maxEntry.getHigh();
                        trans.pointValuesToPixel(tPosition);

                        mValuePaint.setColor(dataSet.getValueTextColor(maxIndex / 2));
                        //c.drawText(highString, x+highStringWidth , y-yOffset, mValuePaint);
                        c.drawText(highString, tPosition[0] +highStringWidth/2, tPosition[1], mValuePaint);

                    }
                }//end if

            }//end for
        }
    }

    @Override
    public void drawHighlighted(Canvas c, Highlight[] indices) {
        this.indices = indices;
    }

    protected float getYPixelForValues(float x, float y) {
        MPPointD pixels = mChart.getTransformer(YAxis.AxisDependency.LEFT).getPixelForValues(x, y);
        return (float) pixels.y;
    }

    @Override
    public void drawExtras(Canvas c) {
        if (indices == null) {
            return;
        }

        CandleData candleData = mChart.getCandleData();
        for (Highlight high : indices) {
            ICandleDataSet set = candleData.getDataSetByIndex(high.getDataSetIndex());
            if (set == null || !set.isHighlightEnabled())
                continue;

            CandleEntry e = set.getEntryForXValue(high.getX(), high.getY());
            if (!isInBoundsX(e, set))
                continue;

            float lowValue = e.getLow() * mAnimator.getPhaseY();
            float highValue = e.getHigh() * mAnimator.getPhaseY();
            MPPointD pix = mChart.getTransformer(set.getAxisDependency())
                    .getPixelForValues(e.getX(), (lowValue + highValue) / 2f);
            float xp = (float) pix.x;

            mHighlightPaint.setColor(set.getHighLightColor());
            mHighlightPaint.setStrokeWidth(set.getHighlightLineWidth());
            mHighlightPaint.setTextSize(highlightSize);

            float xMin = mViewPortHandler.contentLeft();
            float xMax = mViewPortHandler.contentRight();
            float contentBottom = mViewPortHandler.contentBottom();
            //画竖线
            int halfPaddingVer = 5;//竖向半个padding
            int halfPaddingHor = 8;
            float textXHeight = 0;

            String textX;//高亮点的X显示文字
            Object data = e.getData();
            if (data != null && data instanceof String) {
                textX = (String) data;
            } else {
                textX = e.getX() + "";
            }

            if (!TextUtils.isEmpty(textX)) {//绘制x的值
                //先绘制文字框
                //mHighlightPaint.setStyle(Paint.Style.STROKE);
                mHighlightPaint.setStyle(Paint.Style.FILL_AND_STROKE);// BY Listen 0611
                int width = Utils.calcTextWidth(mHighlightPaint, textX);
                int height = Utils.calcTextHeight(mHighlightPaint, textX);
                float left = Math.max(xMin, xp - width / 2F - halfPaddingVer);//考虑间隙
                float right = left + width + halfPaddingHor * 2;
                if (right > xMax) {
                    right = xMax;
                    left = right - width - halfPaddingHor * 2;
                }
                textXHeight = height + halfPaddingVer * 2;
                //RectF rect = new RectF(left, 0, right, textXHeight);
                RectF rect = new RectF(left, contentBottom + halfPaddingVer,
                        right, textXHeight + halfPaddingVer + contentBottom);
                c.drawRect(rect, mHighlightPaint);
                //再绘制文字
                int oldColor = mHighlightPaint.getColor();
                mHighlightPaint.setColor(Color.parseColor("#ffffffff"));
                mHighlightPaint.setStyle(Paint.Style.FILL);
                Paint.FontMetrics metrics = mHighlightPaint.getFontMetrics();
                float baseY = (height + halfPaddingVer * 2 - metrics.top - metrics.bottom) / 2;
                //c.drawText(textX, left + halfPaddingHor, baseY, mHighlightPaint);
                c.drawText(textX, left + halfPaddingHor, halfPaddingHor/2 + baseY + contentBottom, mHighlightPaint);
                mHighlightPaint.setColor(oldColor);
            }
            //绘制竖线
            //c.drawLine(xp, textXHeight, xp, mChart.getHeight(), mHighlightPaint);
            c.drawLine(xp, 0, xp, mChart.getHeight(), mHighlightPaint);

            //判断是否画横线
            float y = high.getDrawY();
            float yMaxValue = mChart.getYChartMax();
            float yMinValue = mChart.getYChartMin();
            float yMin = getYPixelForValues(xp, yMaxValue);
            float yMax = getYPixelForValues(xp, yMinValue);
            if (y >= 0 && y <= contentBottom) {//在区域内即绘制横线
                //先绘制文字框
                mHighlightPaint.setStyle(Paint.Style.STROKE);
                float yValue = (yMax - y) / (yMax - yMin) * (yMaxValue - yMinValue) + yMinValue;
                String text = AppUtils.getFormatStringValue(yValue); //format.format(yValue);
                int width = Utils.calcTextWidth(mHighlightPaint, text);
                int height = Utils.calcTextHeight(mHighlightPaint, text);
                float top = Math.max(0, y - height / 2F - halfPaddingVer);//考虑间隙
                float bottom = top + height + halfPaddingVer * 2;
                if (bottom > contentBottom) {
                    bottom = contentBottom;
                    top = bottom - height - halfPaddingVer * 2;
                }
                //RectF rect = new RectF(xMax - width - halfPaddingHor * 2, top, xMax, bottom);
                RectF rect = new RectF(halfPaddingHor, top, halfPaddingHor*3 + width, bottom);
                mHighlightPaint.setStyle(Paint.Style.FILL_AND_STROKE);//by listen
                c.drawRect(rect, mHighlightPaint);
                //再绘制文字
                mHighlightPaint.setStyle(Paint.Style.FILL);
                Paint.FontMetrics metrics = mHighlightPaint.getFontMetrics();
                float baseY = (top + bottom - metrics.top - metrics.bottom) / 2;
                //c.drawText(text, xMax - width - halfPaddingHor, baseY, mHighlightPaint);
                int oldColor = mHighlightPaint.getColor();
                mHighlightPaint.setColor(Color.parseColor("#ffffffff"));
                c.drawText(text, rect.left + halfPaddingHor, baseY, mHighlightPaint);
                //绘制横线
                //c.drawLine(0, y, xMax - width - halfPaddingHor * 2, y, mHighlightPaint);
                mHighlightPaint.setColor(oldColor);
                c.drawLine(rect.right, y, xMax, y, mHighlightPaint);
            }
        }
        indices = null;
    }
}
