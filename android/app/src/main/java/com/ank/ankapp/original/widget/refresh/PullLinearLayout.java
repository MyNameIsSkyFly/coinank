package com.ank.ankapp.original.widget.refresh;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;

/**
 * 支持上下拉刷新的LinearLayout
 * Created by woxingxiao on 2015/11/12.
 */
public class PullLinearLayout extends LinearLayout implements Pullable {
    private boolean pullDownEnable = true; //下拉刷新开关
    private boolean pullUpEnable = true; //上拉刷新开关

    public PullLinearLayout(Context context) {
        super(context);
    }

    public PullLinearLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public PullLinearLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    public boolean canPullDown() {
        return pullDownEnable;
    }

    @Override
    public boolean canPullUp() {
        return pullUpEnable;
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
}
