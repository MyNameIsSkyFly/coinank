package com.ank.ankapp.ank_app.original.widget.refresh;

import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.ScrollView;

import androidx.annotation.RequiresApi;

/**
 * 支持上下拉刷新的ListView
 * Created by woxingxiao on 2015/11/12.
 */
public class PullScrollView extends ScrollView implements Pullable {

    private boolean pullDownEnable = true; //下拉刷新开关
    private boolean pullUpEnable = true; //上拉刷新开关

    public PullScrollView(Context context) {
        super(context);
    }

    public PullScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public PullScrollView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public PullScrollView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    private float mDownX;
    private float mDownY;
    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        final float x = ev.getX();
        final float y = ev.getY();
        final int action = ev.getAction();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                mDownX = x;
                mDownY = y;
                break;
            case MotionEvent.ACTION_MOVE:
                final float deltaX = Math.abs(x - mDownX);
                final float deltaY = Math.abs(y - mDownY);
                // 这里是够拦截的判断依据是左右滑动
                if (deltaX > deltaY) {
                    return false;//如果横向滑动大于垂直滑动，则不拦截,然后子view会响应横向滑动
                }
                break;
            case MotionEvent.ACTION_UP:
                break;
        }

        return super.onInterceptTouchEvent(ev);
    }

    private int dipToPx(int dip){
        float scale = getContext().getResources().getDisplayMetrics().density;
        return (int) (dip * scale + 0.5f * (dip >= 0 ? 1 : -1));//加0.5是为了四舍五入
    }

    @Override
    public boolean canPullDown() {
        if (!pullDownEnable) {
            return false;
        }

        if (getScrollY() == 0) {
            return true;
        }

       return false;
    }

    @Override
    public boolean canPullUp() {
        if (!pullUpEnable) {
            return false;
        }

        return false;
    }

    @Override
    public void setPullDown(boolean b) {
       setPullDownEnable(b);
    }

    @Override
    public void setPullUp(boolean b) {
        setPullUpEnable(b);
    }

    public boolean isPullDownEnable() {
        return pullDownEnable;
    }

    public void setPullDownEnable(boolean pullDownEnable) {
        this.pullDownEnable = pullDownEnable;
    }

    public boolean isPullUpEnable() {
        return pullUpEnable;
    }

    public void setPullUpEnable(boolean pullUpEnable) {
        this.pullUpEnable = pullUpEnable;
    }

    public OnPullDownListener getListener() {
        return listener;
    }

    public void setListener(OnPullDownListener listener) {
        this.listener = listener;
    }

    private OnPullDownListener listener = null;
    public interface OnPullDownListener {
        void doEvent();
    }
}
