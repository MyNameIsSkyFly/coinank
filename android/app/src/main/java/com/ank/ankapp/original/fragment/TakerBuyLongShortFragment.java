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
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.activity.SearchBaseCoinListActivity;
import com.ank.ankapp.original.adapter.ChooserBaseCoinAdapter;
import com.ank.ankapp.original.adapter.HomeAdapter;
import com.ank.ankapp.original.bean.BaseCoinVo;
import com.ank.ankapp.original.bean.JsonVo;
import com.ank.ankapp.original.bean.LongShortTakerBuySellVo;
import com.ank.ankapp.original.bean.OIChartMenuParamVo;
import com.ank.ankapp.original.dialog.MenuDialog;
import com.ank.ankapp.original.dialog.base.BaseDialog;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.language.PrefUtils;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.OkHttpUtil;
import com.ank.ankapp.original.widget.HomeListView;
import com.ank.ankapp.original.widget.refresh.PullScrollView;
import com.ank.ankapp.original.widget.refresh.PullToRefreshLayout;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.ruffian.library.widget.RLinearLayout;
import com.ruffian.library.widget.RTextView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class TakerBuyLongShortFragment extends Fragment implements View.OnClickListener {

    public static TakerBuyLongShortFragment getInstance(Bundle bundle) {

        TakerBuyLongShortFragment fragment = new TakerBuyLongShortFragment();
        if (bundle != null) {
            fragment.setArguments(bundle);
        }

        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        LanguageUtil.changeAppLanguage(getContext(), PrefUtils.getLanguage(getContext()));
        return inflater.inflate(R.layout.fragment_takerbuy_longshort, container, false);
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
    private HomeListView mListView;
    private RecyclerView symbolHListview;
    private ChooserBaseCoinAdapter<BaseCoinVo> coinsAdapter;
    protected JsonVo<List<String>> dataCoins = new JsonVo();
    protected List<BaseCoinVo> baseCoinList;

    private PullScrollView ll_pullview;
    private HomeAdapter<LongShortTakerBuySellVo> mAdapter;
    protected JsonVo<List<LongShortTakerBuySellVo>> mData = new JsonVo();
    protected EmbedWebviewFragment webFragment;

    protected RLinearLayout ll_search;
    protected RTextView chart_title, tv_exchange, tv_interval, tv_type;
    protected RTextView tv_longshort_chart_title, tv_exchange_chart_interval;
    protected OIChartMenuParamVo menuParamVo;
    private String jsonData = null;


    protected void initView(View view) {

        tv_longshort_chart_title = view.findViewById(R.id.chart_title01);
        tv_exchange_chart_interval = view.findViewById(R.id.tv_interval01);
        tv_exchange_chart_interval.setOnClickListener(this);

        chart_title = view.findViewById(R.id.chart_title02);
        tv_exchange = view.findViewById(R.id.tv_exchange);
        tv_exchange.setOnClickListener(this);
        tv_interval = view.findViewById(R.id.tv_interval02);
        tv_interval.setOnClickListener(this);
        tv_type = view.findViewById(R.id.tv_type);
        tv_type.setOnClickListener(this);



        ll_search = (view.findViewById(R.id.ll_search));
        ll_search.setOnClickListener(this);

        symbolHListview = (RecyclerView) view.findViewById(R.id.hlistview);
        symbolHListview.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        symbolHListview.setLayoutManager(linearLayoutManager);

        mListView = (HomeListView) view.findViewById(R.id.lv_oi);

        ll_pullview = (PullScrollView) view.findViewById(R.id.ll_pullscrollview);
        ll_pullview.setPullUpEnable(false);
        //ll_pullview.setPullDownEnable(false);

        mRefreshLayout = (PullToRefreshLayout) view.findViewById(R.id.pullToRefreshLayout);
        mRefreshLayout.getRefreshFooterView().setVisibility(View.GONE);
        //mRefreshLayout.setShowRefreshResultEnable(true);
        mRefreshLayout.setOnRefreshListener(new PullToRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
                loadData(0);//合约
                loadAllBaseCoins();
            }

            @Override
            public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
            }
        });

        mRefreshLayout.postDelayed(new Runnable() {
            @Override
            public void run() {
                mHandler.sendEmptyMessageDelayed(0, 50);
            }
        }, 100);

        mFragmentManager = getChildFragmentManager();
        FragmentTransaction ft = mFragmentManager.beginTransaction();
        Bundle mBundle = new Bundle();
        String url = Config.urlCommonChart;
        mBundle.putString(AgentWebFragment.URL_KEY, url);
        webFragment = EmbedWebviewFragment.getInstance(mBundle);
        ft.add(R.id.fg_chart, webFragment, EmbedWebviewFragment.class.getName());
        ft.commit();
    }

    private void updateChart()
    {
        chart_title.setText(getContext().getResources().getString(R.string.s_takerbuy_longshort_ratio_chart)
                + "(" + menuParamVo.baseCoin + ")");
        if (!menuParamVo.type.equalsIgnoreCase("USD"))
        {
            menuParamVo.type = menuParamVo.baseCoin;
            tv_type.setText(menuParamVo.baseCoin);
        }

        String exchange = menuParamVo.exchange;
        if (menuParamVo.exchange.equalsIgnoreCase("ALL"))
        {
            exchange = "";
        }

        Map<String, String> map = new HashMap<>();
        map.put("exchangeName", exchange);
        map.put("interval", menuParamVo.interval);
        map.put("baseCoin", menuParamVo.baseCoin);
        map.put("locale",LanguageUtil.getShortLanguageName(getContext()));
        map.put("price",getContext().getResources().getString(R.string.s_price));
        map.put("seriesLongName",getContext().getResources().getString(R.string.s_longs));
        map.put("seriesShortName",getContext().getResources().getString(R.string.s_shorts));
        map.put("ratioName",getContext().getResources().getString(R.string.s_longshort_ratio));

        Gson gson = new GsonBuilder().create();
        String options = gson.toJson(map);

        webFragment.mAgentWeb.getJsAccessEntrace().quickCallJs("setChartData",
                jsonData, "android", "realtimeLongShort", options);
    }

    public void loadTakerBuyRatioChartData()
    {
        long t1 = System.currentTimeMillis();
        String url = String.format(Config.apiGetTakerBuyRatioChartData,
                menuParamVo.interval, menuParamVo.baseCoin);
        OkHttpUtil.getJSON(url, new OkHttpUtil.OnDataListener() {
            @Override
            public void onResponse(String url, Object obj,String json) {
                if (TextUtils.isEmpty(json)) return;
                MLog.d("json:" + json.substring(0, 20));
                jsonData = json;
                updateChart();
                MLog.d("t1:" + (System.currentTimeMillis() - t1));
            }

            @Override
            public void onFailure(String url, String error) {
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
            mHandler.sendEmptyMessageDelayed(1, 5000);
        }
    }

    private Handler mHandler;
    private boolean bPause = false;

    private void tickPro() {
        mHandler = new Handler(new Handler.Callback() {
            @Override
            public boolean handleMessage(Message msg) {
                if (msg.what == 0) {
                    loadTakerBuyRatioChartData();
                    mRefreshLayout.autoRefresh();
                    return false;
                }

                if (!bPause) {
                    loadData(0);//加密货币合约行情数据
                    mHandler.sendEmptyMessageDelayed(1, 5000);
                }

                return false;
            }
        });

        //mHandler.sendEmptyMessageDelayed(1, 5000);
    }

    private void initData() {
        menuParamVo = new OIChartMenuParamVo();
        menuParamVo.baseCoin = "BTC";
        menuParamVo.exchange = "";
        menuParamVo.type = "";
        menuParamVo.interval = "5m";
        menuParamVo.interval2 = "5m";

        tv_exchange.setText(menuParamVo.exchange);
        tv_interval.setText(menuParamVo.interval);
        tv_exchange_chart_interval.setText(menuParamVo.interval2);
        tv_type.setText(menuParamVo.type);

        mAdapter = new HomeAdapter(mData.getData(), getContext());
        mListView.setAdapter(mAdapter);

        coinsAdapter = new ChooserBaseCoinAdapter<>(null, getContext());
        symbolHListview.setAdapter(coinsAdapter);
        coinsAdapter.setItemClickListener(new ChooserBaseCoinAdapter.OnItemClickListener() {
            @Override
            public void onClick(View v, int pos) {
                for (int i = 0; i < baseCoinList.size(); i++) {
                    if (menuParamVo.baseCoin.equalsIgnoreCase(baseCoinList.get(i).baseCoin)) {
                        baseCoinList.get(i).isSel = false;
                    }
                }

                BaseCoinVo vo = (BaseCoinVo) baseCoinList.get(pos);
                vo.isSel = true;
                menuParamVo.baseCoin = vo.baseCoin;
                symbolHListview.scrollToPosition(pos);
                coinsAdapter.notifyDataSetChanged();

                MLog.d("click item:" + menuParamVo.baseCoin);
                loadData(0);
                loadTakerBuyRatioChartData();
            }
        });
    }

    private List<BaseCoinVo> convertData() {
        if (baseCoinList == null) {
            baseCoinList = new ArrayList<>();
        } else {
            baseCoinList.clear();
        }

        for (int i = 0; i < dataCoins.getData().size(); i++) {
            BaseCoinVo vo = new BaseCoinVo();
            vo.baseCoin = dataCoins.getData().get(i);
            vo.isSel = false;
            if (menuParamVo.baseCoin.equalsIgnoreCase(vo.baseCoin)) {
                vo.isSel = true;
            }

            baseCoinList.add(vo);
        }

        return baseCoinList;
    }

    private void loadAllBaseCoins() {
        OkHttpUtil.getJSON(Config.apiGetAllBaseCoins, new OkHttpUtil.OnDataListener() {
            @Override
            public void onResponse(String url, Object obj, String json) {
                if (TextUtils.isEmpty(json)) return;
                Config.getMMKV(getActivity()).putString(Config.CONF_BASE_COINS, json);
                if (dataCoins != null) {
                    if (dataCoins.getData() != null)
                        dataCoins.getData().clear();

                    dataCoins = null;
                }

                Gson gson = new GsonBuilder().create();
                dataCoins = gson.fromJson(json, new TypeToken<JsonVo<List<String>>>() {
                }.getType());
                MLog.d("dataCoins data size:" + dataCoins.getData().size());
                coinsAdapter.setData(convertData());
                coinsAdapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(String url, String error) {

            }
        });
    }

    private void loadData(int type) {
        mAdapter.setExtData(menuParamVo.baseCoin);
        String url = Config.apiGetTakerBuyLongShortRatio;
        url = String.format(url, menuParamVo.interval2, menuParamVo.baseCoin);

        Global.getAnalytics(getActivity()).logEvent("user_action",
                Global.createBundle("takerbuy ls loadData url:" + url, getClass().getSimpleName()));

        OkHttpUtil.getJSON(url, new OkHttpUtil.OnDataListener() {
            @Override
            public void onResponse(String url, Object obj, String json) {
                mRefreshLayout.refreshFinish(true);
                if (TextUtils.isEmpty(json)) return;

                if (mData != null) {
                    if (mData.getData() != null)
                        mData.getData().clear();

                    mData = null;
                }

                Gson gson = new GsonBuilder().create();
                mData = gson.fromJson(json, new TypeToken<JsonVo<List<LongShortTakerBuySellVo>>>() {
                }.getType());
                MLog.d("data size:" + mData.getData().size());
                mAdapter.setData(mData.getData());
                mAdapter.notifyDataSetChanged();
                tv_longshort_chart_title.setText(getContext().getResources().getString(R.string.s_buysel_longshort_ratio)
                        + "(" + menuParamVo.baseCoin + ")");
            }

            @Override
            public void onFailure(String url, String error) {
                mRefreshLayout.refreshFinish(true);
            }
        });
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
                            if (!arrs[which].equalsIgnoreCase(menuParamVo.interval))
                            {
                                menuParamVo.interval = arrs[which];
                                tv_interval.setText(menuParamVo.interval);
                                loadTakerBuyRatioChartData();
                            }
                        }

                        @Override
                        public void onCancel(BaseDialog dialog) {
                        }
                    })
                    .show();
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
                            if (!arrs[which].equalsIgnoreCase(menuParamVo.interval2))
                            {
                                menuParamVo.interval2 = arrs[which];
                                tv_exchange_chart_interval.setText(menuParamVo.interval2);
                                loadData(0);
                            }
                        }

                        @Override
                        public void onCancel(BaseDialog dialog) {
                        }
                    })
                    .show();
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1 && data != null) {
            String baseCoin = data.getStringExtra("coin");
            MLog.d("baseCoin:" + baseCoin);
            int pos = 0;
            if (menuParamVo.baseCoin.equalsIgnoreCase(baseCoin)) {
                return;//相等则返回
            }

            if (baseCoinList == null) return;

            for (int i = 0; i < baseCoinList.size(); i++) {
                if (menuParamVo.baseCoin.equalsIgnoreCase(baseCoinList.get(i).baseCoin)) {
                    baseCoinList.get(i).isSel = false;//取消之前的选中状态
                    break;
                }
            }

            for (int i = 0; i < baseCoinList.size(); i++) {
                if (baseCoin.equalsIgnoreCase(baseCoinList.get(i).baseCoin)) {
                    pos = i;
                    baseCoinList.get(i).isSel = true;//设置选中状态
                    break;
                }

            }

            menuParamVo.baseCoin = baseCoin;

            if (pos > 5 && pos <= baseCoinList.size() - 3) {
                pos = pos + 3;
            }
            symbolHListview.scrollToPosition(pos);
            coinsAdapter.notifyDataSetChanged();

            MLog.d("click:" + menuParamVo.baseCoin);
            loadData(0);
            loadTakerBuyRatioChartData();
        }

        MLog.d("onActivityResult " + requestCode + " " + resultCode);
    }
}
