package com.ank.ankapp.ank_app.original.widget;

import android.app.Dialog;
import android.app.DialogFragment;
import android.app.FragmentManager;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ExpandableListView;

import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.Global;
import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.ank_app.original.activity.CommonWebActivity;
import com.ank.ankapp.ank_app.original.adapter.LeftNavMenuAdapter;
import com.ank.ankapp.ank_app.original.bean.JsonVo;
import com.ank.ankapp.ank_app.original.bean.NavMenuBean;
import com.ank.ankapp.ank_app.original.callback.OnExpandListViewClickListener;
import com.ank.ankapp.ank_app.original.utils.MLog;
import com.github.mikephil.charting.utils.Utils;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.util.List;

public class LeftNavMenuDialog extends DialogFragment implements View.OnClickListener {

    protected LeftNavMenuAdapter mAdapter;
    protected ExpandableListView mListView;
    private JsonVo<List<NavMenuBean>> mData;

    public static LeftNavMenuDialog newInstance() {
        return new LeftNavMenuDialog();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View contentView = inflater.inflate(R.layout.left_nav_menu, container, false);

        getDialog().setCanceledOnTouchOutside(true);//对话框外可取消
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);//取消标题显示
        Window window = getDialog().getWindow();
        window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        window.setGravity(Gravity.LEFT|Gravity.TOP);

        window.setWindowAnimations(R.style.dlg_anim);

        // 设置宽度
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = (int)Utils.convertDpToPixel(300);
        params.height = WindowManager.LayoutParams.MATCH_PARENT;
        //params.gravity = Gravity.TOP | Gravity.LEFT;
        //params.windowAnimations = android.R.style.Animation;
        //getDialog().getWindow().setAttributes(params);

        return contentView;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initView(view);
        initData();
    }

    private void initView(View v)
    {
        mListView = (ExpandableListView) v.findViewById(R.id.ex_lv);
    }

    private void initData()
    {
        mAdapter = new LeftNavMenuAdapter(null, getActivity());
        mListView.setAdapter(mAdapter);

        mAdapter.setListener(new OnExpandListViewClickListener() {
            @Override
            public void onClick(int groupPos, int childPos, String url) {
                MLog.d("menu url:" + url);
                Intent i = new Intent();
                i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
                i.setClass(getActivity(), CommonWebActivity.class);
                i.putExtra(Config.TYPE_URL, Config.h5Prefix + url);
                i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_chart));
                Global.showActivity(getActivity(), i);

                dismiss();
            }
        });

        loadData();
    }

    private void setAdapterExchangeSymbol()
    {
        if(mData != null)
        {
            mAdapter.setData(mData.getData());
        }

        mAdapter.notifyDataSetChanged();

    }

    private void loadData()
    {
        if(mData != null)
        {
            mData = null;
        }

        String json = Config.getMMKV(getActivity()).getString(Config.CONF_LEFT_NAV_MENU_JSON, "");
        Gson gson = new GsonBuilder().create();
        mData = gson.fromJson(json, new TypeToken<JsonVo<List<NavMenuBean>>>() {}.getType());
        //MLog.d("get symbols:" + mData.getData().size());


        setAdapterExchangeSymbol();
    }

    public LeftNavMenuDialog show(FragmentActivity context) {
        return show(context.getFragmentManager());
    }

    public LeftNavMenuDialog show(FragmentManager manager) {
        Dialog dialog = getDialog();
        if (dialog == null || !dialog.isShowing()) {
            show(manager, "dialog");
        }
        return this;
    }

    @Override
    public void dismiss() {
        super.dismiss();
    }

    @Override
    public void onClick(View v) {
    }
}
