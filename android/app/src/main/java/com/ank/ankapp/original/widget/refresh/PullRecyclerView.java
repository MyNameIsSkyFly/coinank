package com.ank.ankapp.original.widget.refresh;

import android.content.Context;
import android.util.AttributeSet;

import androidx.recyclerview.widget.RecyclerView;

/**
 * 支持上下拉刷新的ListView
 */
public class PullRecyclerView extends RecyclerView implements Pullable {

    private boolean pullDownEnable = true; //下拉刷新开关
    private boolean pullUpEnable = true; //上拉刷新开关

    public PullRecyclerView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public PullRecyclerView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    private int dipToPx(int dip){
        float scale = getContext().getResources().getDisplayMetrics().density;
        return (int) (dip * scale + 0.5f * (dip >= 0 ? 1 : -1));//加0.5是为了四舍五入
    }

    public boolean isScrollTop()
    {
        //MLog.d("top");
        return !canScrollVertically(-1);//顶部

        //MLog.d("not top");
//非顶部
    }

    @Override
    public boolean canPullDown() {
        if (!pullDownEnable) {
            return false;
        }

        return isScrollTop();
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
