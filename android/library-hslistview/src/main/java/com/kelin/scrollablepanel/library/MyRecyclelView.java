package com.kelin.scrollablepanel.library;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;

import androidx.recyclerview.widget.RecyclerView;

public class MyRecyclelView extends RecyclerView {
    public MyRecyclelView(Context context) {
        super(context);
    }

    public MyRecyclelView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public MyRecyclelView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

//    public MyRecyclelView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
//        super(context, attrs, defStyleAttr);
//    }




    private float mDownPosX;
    private float mDownPosY;
    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {

        final float x = ev.getX();
        final float y = ev.getY();
        final int action = ev.getAction();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                mDownPosX = x;
                mDownPosY = y;
                break;
            case MotionEvent.ACTION_MOVE:
                final float deltaX = Math.abs(x - mDownPosX);
                final float deltaY = Math.abs(y - mDownPosY);
                // 这里是够拦截的判断依据是左右滑动
                if (deltaX > deltaY) {
                    return false;//如果横向滑动大于垂直滑动，则不拦截,然后子view会响应横向滑动
                }
        }

        return super.onInterceptTouchEvent(ev);
    }
}
