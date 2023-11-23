package com.ank.ankapp.original.widget;

import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.LinearLayout;

import androidx.annotation.RequiresApi;

public class MyFloatView extends LinearLayout {
    public MyFloatView(Context context) {
        super(context);
    }

    public MyFloatView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public MyFloatView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public MyFloatView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }


    float lastX = 0, lastY = 0;
    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        boolean bIntercept = false;
        final int action = ev.getAction();
        float x = ev.getRawX();
        float y = ev.getRawY();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                lastX = x;
                lastY = y;
                break;
            case MotionEvent.ACTION_MOVE:
                //必须这样判断，不然在手机上的时候点击事件容易当做滑动事件
                if (Math.abs(x - lastX) > 5 ||
                        Math.abs(y - lastY) > 5
                )
                {
                    bIntercept = true;//悬浮窗，说明手指在滑动
                }
                break;
            case MotionEvent.ACTION_UP:
                break;
        }

        //MLog.d("onInterceptTouchEvent:" + bIntercept + action);
        return bIntercept;
        //return super.onInterceptTouchEvent(ev);
    }
}
