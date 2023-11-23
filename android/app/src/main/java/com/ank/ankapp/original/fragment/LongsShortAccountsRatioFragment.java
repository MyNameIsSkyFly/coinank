package com.ank.ankapp.original.fragment;


import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.activity.SearchBaseCoinListActivity;
import com.ank.ankapp.original.bean.OIChartMenuParamVo;
import com.ank.ankapp.original.dialog.MenuDialog;
import com.ank.ankapp.original.dialog.base.BaseDialog;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.language.PrefUtils;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.OkHttpUtil;
import com.ank.ankapp.original.widget.refresh.PullScrollView;
import com.ank.ankapp.original.widget.refresh.PullToRefreshLayout;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.ruffian.library.widget.RLinearLayout;
import com.ruffian.library.widget.RTextView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class LongsShortAccountsRatioFragment extends Fragment implements View.OnClickListener {

    public static LongsShortAccountsRatioFragment getInstance(Bundle bundle) {

        LongsShortAccountsRatioFragment fragment = new LongsShortAccountsRatioFragment();
        if (bundle != null) {
            fragment.setArguments(bundle);
        }

        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        LanguageUtil.changeAppLanguage(getContext(), PrefUtils.getLanguage(getContext()));
        return inflater.inflate(R.layout.fragment_longsshorts_accounts, container, false);
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        OkHttpUtil.initOkHttp();
        tickPro();
        initView(view);
        initData();
        Global.getAnalytics(getActivity()).logEvent("user_action",
                Global.createBundle("oncreate", getClass().getSimpleName()));
    }


    private FragmentManager mFragmentManager;//fragment管理者
    private FragmentTransaction mFragmentTransaction;//fragment事务

    private boolean isFirst = true;
    private PullToRefreshLayout mRefreshLayout;

    private PullScrollView ll_pullview;
    protected EmbedWebviewFragment chart01, chart02;

    protected RLinearLayout ll_search;
    protected RTextView chart_title01, chart_title02, tv_interval01, tv_type;
    protected RTextView tv_interval02;
    protected OIChartMenuParamVo menuParamVo;
    private String jsonData01 = null;
    private String jsonData02 = null;


    protected void initView(View view) {

        chart_title01 = view.findViewById(R.id.chart_title01);
        chart_title02 = view.findViewById(R.id.chart_title02);
        tv_interval01 = view.findViewById(R.id.tv_interval01);
        tv_interval01.setOnClickListener(this);
        tv_interval02 = view.findViewById(R.id.tv_interval02);
        tv_interval02.setOnClickListener(this);

        ll_pullview = (PullScrollView) view.findViewById(R.id.ll_pullscrollview);
        ll_pullview.setPullUpEnable(false);

        mRefreshLayout = (PullToRefreshLayout) view.findViewById(R.id.pullToRefreshLayout);
        mRefreshLayout.getRefreshFooterView().setVisibility(View.GONE);
        //mRefreshLayout.setShowRefreshResultEnable(true);
        mRefreshLayout.setOnRefreshListener(new PullToRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
                loadChartData01();//合约
                loadChartData02();
            }

            @Override
            public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
            }
        });

        mFragmentManager = getChildFragmentManager();
        FragmentTransaction ft = mFragmentManager.beginTransaction();
        Bundle mBundle = new Bundle();
        String url = Config.urlCommonChart;
        mBundle.putString(AgentWebFragment.URL_KEY, url);
        chart01 = EmbedWebviewFragment.getInstance(mBundle);
        chart02 = EmbedWebviewFragment.getInstance(mBundle);
        ft.add(R.id.fg_chart01, chart01, EmbedWebviewFragment.class.getName());
        ft.add(R.id.fg_chart02, chart02, EmbedWebviewFragment.class.getName());
        ft.commit();

        mRefreshLayout.postDelayed(new Runnable() {
            @Override
            public void run() {
                loadChartData01();
                loadChartData02();
            }
        }, 500);//此处延时500ms,再去加载数据，webview初始化显示需要一些时间，
          // 在某些配置低的手机上，会出现数据先到，webview还没加载完的情况，导致webview 图表无数据
        //如果要彻底解决这个问题，可以在webivew加载完成后设置一个状态，http拿到数据后判断webview加载完了再去用js把数据传进去
    }

    private void updateChart()
    {
        Map<String, String> map = new HashMap<>();
        map.put("exchangeName", menuParamVo.exchange);
        map.put("interval", menuParamVo.interval);
        map.put("baseCoin", menuParamVo.baseCoin);
        map.put("locale",LanguageUtil.getShortLanguageName(getContext()));
        map.put("price",getContext().getResources().getString(R.string.s_price));
        map.put("seriesLongName",getContext().getResources().getString(R.string.s_longs));
        map.put("seriesShortName",getContext().getResources().getString(R.string.s_shorts));
        map.put("ratioName",getContext().getResources().getString(R.string.s_longshort_ratio));

        Gson gson = new GsonBuilder().create();
        String options = gson.toJson(map);

        int progress = chart01.mAgentWeb.getWebCreator().getWebView().getProgress();
        MLog.d("chart01 load progress:" + progress);
        chart01.mAgentWeb.getJsAccessEntrace().quickCallJs("setChartData",
                jsonData01, "android", "longShortChart", options);

//        map.put("exchangeName", menuParamVo.exchange);
//        map.put("interval", menuParamVo.interval);
//        map.put("baseCoin", menuParamVo.baseCoin);
//        map.put("locale","zh");//en ko ja 这种
//        map.put("price","价格");//多国语言字符串
//        map.put("seriesLongName","多");//多国语言字符串
//        map.put("seriesShortName","空");//多国语言字符串
//        map.put("ratioName","多空比");//多国语言字符串
//
//        optionsJson = map.toJson()
//        setChartData(jsonData01, "ios", "longShortChart", optionsJson);
    }

    private void updateChart02()
    {
        Map<String, String> map = new HashMap<>();
        map.put("exchangeName", menuParamVo.exchange);
        map.put("interval", menuParamVo.interval2);
        map.put("baseCoin", menuParamVo.baseCoin);
        map.put("locale",LanguageUtil.getShortLanguageName(getContext()));
        map.put("price",getContext().getResources().getString(R.string.s_price));
        map.put("seriesLongName",getContext().getResources().getString(R.string.s_longs));
        map.put("seriesShortName",getContext().getResources().getString(R.string.s_shorts));
        map.put("ratioName",getContext().getResources().getString(R.string.s_longshort_ratio));

        Gson gson = new GsonBuilder().create();
        String options = gson.toJson(map);

        int progress = chart02.mAgentWeb.getWebCreator().getWebView().getProgress();
        MLog.d("chart01 load progress:" + progress);

        chart02.mAgentWeb.getJsAccessEntrace().quickCallJs("setChartData",
                jsonData02, "android", "longShortChart", options);
    }

    public void loadChartData02()
    {
        long t1 = System.currentTimeMillis();
        String url = String.format(Config.apiGetLongShortAccountsRatioChartData,
                menuParamVo.exchange2, menuParamVo.interval2, menuParamVo.baseCoin,"", "");
        OkHttpUtil.getJSON(url, new OkHttpUtil.OnDataListener() {
            @Override
            public void onResponse(String url, Object obj,String json) {
                mRefreshLayout.refreshFinish(true);
                if (TextUtils.isEmpty(json)) return;
                MLog.d("json:" + json.substring(0, 20));
                jsonData02 = json;
                updateChart02();
                MLog.d("t1:" + (System.currentTimeMillis() - t1));
            }

            @Override
            public void onFailure(String url, String error) {
                mRefreshLayout.refreshFinish(true);
            }
        });
    }

    public void loadChartData01()
    {
        long t1 = System.currentTimeMillis();
        String url = String.format(Config.apiGetLongShortAccountsRatioChartData,
                menuParamVo.exchange,menuParamVo.interval, menuParamVo.baseCoin,"USDT", "USDT");
        OkHttpUtil.getJSON(url, new OkHttpUtil.OnDataListener() {
            @Override
            public void onResponse(String url, Object obj,String json) {
                mRefreshLayout.refreshFinish(true);
                if (TextUtils.isEmpty(json)) return;
                MLog.d("json:" + json.substring(0, 20));
                jsonData01 = json;
                updateChart();
                MLog.d("t1:" + (System.currentTimeMillis() - t1));
            }

            @Override
            public void onFailure(String url, String error) {
                mRefreshLayout.refreshFinish(true);
            }
        });
    }

    public boolean isbPause() {
        return bPause;
    }

    public void setbPause(boolean bPause) {
        this.bPause = bPause;
        if (mHandler == null) return;
        if (bPause) {
            mHandler.removeMessages(1);
        } else {
            mHandler.sendEmptyMessageDelayed(1, 2000);
        }
    }

    private Handler mHandler;
    private boolean bPause = false;

    private void tickPro() {
        mHandler = new Handler(new Handler.Callback() {
            @Override
            public boolean handleMessage(Message msg) {
                if (!bPause) {
                    loadChartData01();//加密货币合约行情数据
                    loadChartData02();
                    //mHandler.sendEmptyMessageDelayed(1, 10000);
                }

                return false;
            }
        });

        //mHandler.sendEmptyMessageDelayed(1, 5000);
    }

    private void initData() {
        menuParamVo = new OIChartMenuParamVo();
        menuParamVo.baseCoin = "BTC";
        menuParamVo.exchange = "Binance";
        menuParamVo.exchange2 = "Okex";
        menuParamVo.type = "";
        menuParamVo.interval = "1h";
        menuParamVo.interval2 = "1h";

        chart_title01.setText("Binance " + menuParamVo.baseCoin + " " +
                getContext().getResources().getString(R.string.s_longshort_person));
        chart_title02.setText("Okx " + menuParamVo.baseCoin + " " +
                getContext().getResources().getString(R.string.s_longshort_person));

        tv_interval01.setText(menuParamVo.interval);
        tv_interval02.setText(menuParamVo.interval2);
    }

    @Override
    public void onPause() {
        super.onPause();
        setbPause(true);
    }

    @Override
    public void onResume() {
        super.onResume();
        setbPause(false);

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        setbPause(true);
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.ll_search) {
            Intent i = new Intent();
            i.setClass(getActivity(), SearchBaseCoinListActivity.class);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_search));
            startActivityForResult(i, 1);
            //Global.showActivity(getActivity(), i);
        }
        else  if (v.getId() == R.id.tv_interval01) {
            String arrs[] = new String[]{"5m","15m","30m", "1h", "2h", "4h", "12h","1d"};

            List<String> data = new ArrayList<>();
            for (int i = 0; i < arrs.length; i++)
            {
                data.add(arrs[i]);
            }

            // 底部选择框
            new MenuDialog.Builder(getContext())
                    // 设置 null 表示不显示取消按钮
                    //.setCancel(getString(R.string.common_cancel))
                    // 设置点击按钮后不关闭对话框
                    //.setAutoDismiss(false)
                    //.setGravity(Gravity.CENTER)
                    .setList(data)
                    .setListener(new MenuDialog.OnListener<String>() {

                        @Override
                        public void onSelected(BaseDialog dialog, int which, String string) {
                            if (!arrs[which].equalsIgnoreCase(menuParamVo.interval))
                            {
                                menuParamVo.interval = arrs[which];
                                tv_interval01.setText(menuParamVo.interval);
                                loadChartData01();
                            }
                        }

                        @Override
                        public void onCancel(BaseDialog dialog) {
                        }
                    })
                    .show();
        }
        else  if (v.getId() == R.id.tv_interval02) {
            String arrs[] = new String[]{"5m","15m","30m", "1h", "2h", "4h", "12h","1d"};
            List<String> data = new ArrayList<>();
            for (int i = 0; i < arrs.length; i++)
            {
                data.add(arrs[i]);
            }

            // 底部选择框
            new MenuDialog.Builder(getContext())
                    // 设置 null 表示不显示取消按钮
                    //.setCancel(getString(R.string.common_cancel))
                    // 设置点击按钮后不关闭对话框
                    //.setAutoDismiss(false)
                    //.setGravity(Gravity.CENTER)
                    .setList(data)
                    .setListener(new MenuDialog.OnListener<String>() {

                        @Override
                        public void onSelected(BaseDialog dialog, int which, String string) {
                            if (!arrs[which].equalsIgnoreCase(menuParamVo.interval2))
                            {
                                menuParamVo.interval2 = arrs[which];
                                tv_interval02.setText(menuParamVo.interval2);
                                loadChartData02();
                            }
                        }

                        @Override
                        public void onCancel(BaseDialog dialog) {
                        }
                    })
                    .show();
        }
    }

}
