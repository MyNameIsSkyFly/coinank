package com.ank.ankapp.original.widget.refresh;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

/**
 * 支持上下拉刷新的ListView
 * Created by woxingxiao on 2015/11/12.
 */
public class PullListView extends ListView implements Pullable {

    private boolean pullDownEnable = true; //下拉刷新开关
    private boolean pullUpEnable = true; //上拉刷新开关

    public PullListView(Context context) {
        super(context);
    }

    public PullListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public PullListView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public boolean canPullDown() {
        if (!pullDownEnable) {
            return false;
        }
        // 滑到ListView的顶部了
        if (getCount() == 0) {
            // 没有item的时候也可以下拉刷新
            return true;
        } else return getFirstVisiblePosition() == 0 &&
                ((getChildAt(0) != null) && getChildAt(0).getTop() >= 0);
    }

    @Override
    public boolean canPullUp() {
        if (!pullUpEnable) {
            return false;
        }
        if (getCount() == 0) {
            // 没有item的时候也可以上拉加载
            return true;
        } else if (getLastVisiblePosition() == (getCount() - 1)) {
            // 滑到底部了
            return getChildAt(getLastVisiblePosition() - getFirstVisiblePosition()) != null
                    && getChildAt(getLastVisiblePosition() - getFirstVisiblePosition()).getBottom()
                    <= getMeasuredHeight();
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
}
