package com.ank.ankapp.original.activity;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.adapter.OIChgScrollAdapter;
import com.ank.ankapp.original.bean.JsonVo;
import com.ank.ankapp.original.bean.MarkerTickerVo;
import com.ank.ankapp.original.bean.SortVo;
import com.ank.ankapp.original.bean.TickersDataVo;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.OkHttpUtil;
import com.ank.ankapp.original.widget.LoadingDialog;
import com.ank.ankapp.original.widget.refresh.PullScrollPannelView;
import com.ank.ankapp.original.widget.refresh.PullToRefreshLayout;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.MediaType;
import okhttp3.RequestBody;


public class OIChgActivity extends BaseActivity implements View.OnClickListener{

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_price_chg);
        OkHttpUtil.initOkHttp();
        tickPro();
        initView(this);
        initData();
        initToolBar();
        Global.getAnalytics(this).logEvent("user_action",
                Global.createBundle("oncreate", getClass().getSimpleName()));
    }


    private PullToRefreshLayout mRefreshLayout;
    private LoadingDialog loadingDialog;
    private PullScrollPannelView mListView;
    private boolean isFirst = true;

    protected void initView(Activity view) {
        mListView = view.findViewById(R.id.scrollable_panel);
//        loadingDialog = LoadingDialog.newInstance();
//        loadingDialog.show(this);

        mListView.setPullUp(false);
        mRefreshLayout = (PullToRefreshLayout)view.findViewById(R.id.pullToRefreshLayout);
        mRefreshLayout.getRefreshFooterView().setVisibility(View.GONE);

        mRefreshLayout.setOnRefreshListener(new PullToRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
                MLog.d("onRefresh");
                loadData();
            }

            @Override
            public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
            }
        });

        mListView.postDelayed(new Runnable() {
            @Override
            public void run() {
                mHandler.sendEmptyMessageDelayed(0, 50);
            }
        }, 100);
    }

    protected JsonVo<TickersDataVo> mData = new JsonVo();
    private void loadData()
    {
        String sortType = "";
        if (sortVo.sortType == 1)
        {
            sortType = "ascend";
        }
        else if (sortVo.sortType == 2)
        {
            sortType = "descend";
        }
        else
        {
            sortVo.col = 0;
        }

        String url = String.format(Config.apiGetFuturesBigData, 1, 100,
                sortParamMap.get(sortVo.col),sortType);
        HashMap<String, String> map = new HashMap<>();
        map.put("openInterest", "3000000~");
        String sJson = new GsonBuilder().create().toJson(map);
        RequestBody body = RequestBody.create(MediaType.parse("application/json"), sJson);
        OkHttpUtil.postJson(url, body, new OkHttpUtil.OnDataListener() {
            @Override
            public void onResponse(String url, Object obj,String json) {
                mRefreshLayout.refreshFinish(true);
                //loadingDialog.dismiss();
                if (TextUtils.isEmpty(json)) return;
                if (mData != null && mData.getData() != null && mData.getData().list.size() > 0)
                {
                    mData.getData().list.clear();
                }

                Gson gson = new GsonBuilder().create();
                mData = gson.fromJson(json, new TypeToken<JsonVo<TickersDataVo>>() {}.getType());
                MLog.d("data size:" + mData.getData().list.size());

                setAdapterExchangeSymbol();
            }

            @Override
            public void onFailure(String url, String error) {
                mRefreshLayout.refreshFinish(true);
            }
        });
    }

    private void setAdapterExchangeSymbol()
    {
        if (mData.getData() == null ||
                mData.getData().list.size() <= 0)
        {
            return;
        }

        //sortData();
        mAdapter.setData(mData.getData().list);
        mListView.notifyDataSetChanged();
        //if (mData.getData().size() > 0)
        {
            //mListView.setSelection(0);
        }
    }

    private void updateSortStatus(int col)
    {
        if (col == sortVo.col)
        {
            sortVo.sortType++;
            sortVo.sortType %= 3;
        }
        else
        {
            sortVo.col = col;
            sortVo.sortType = 1;
        }
    }

    private HashMap<Integer, String> sortParamMap = new HashMap<>();
    private SortVo sortVo;
    private OIChgScrollAdapter mAdapter;
    private void initData() {
        sortVo = new SortVo();
        sortVo.sortType = 0;
        sortVo.col = 0;



        sortParamMap.put(0, "");
        sortParamMap.put(1, "");
        sortParamMap.put(2, "price");
        sortParamMap.put(3, "openInterest");
        sortParamMap.put(4, "openInterestCh1");
        sortParamMap.put(5, "openInterestCh4");
        sortParamMap.put(6, "openInterestCh24");

        List<String> title = new ArrayList<>();
        title.add("Coin");
        title.add("");//留 空列
        title.add(getResources().getString(R.string.s_price)+"($)");
        title.add(getResources().getString(R.string.s_oi)+"($)");
        title.add(getResources().getString(R.string.s_oi_chg_short)+"(1H)");
        title.add(getResources().getString(R.string.s_oi_chg_short)+"(4H)");
        title.add(getResources().getString(R.string.s_oi_chg_short)+"(24H)");
        mAdapter = new OIChgScrollAdapter(getApplication(), null, title);


        mAdapter.setExtData(sortVo);
        mListView.setPanelAdapter(mAdapter);


        mAdapter.setItemClickListener(new OIChgScrollAdapter.OnItemClickListener() {
            @Override
            public void onClick(View v, int pos, int col) {


                //MLog.d("onClick:" + pos + " " + col);
                if (pos == 0)
                {
                    if (col >= 1 && col <= 8)
                    {
                        updateSortStatus(col);
                        setAdapterExchangeSymbol();
                        loadData();
                        mHandler.removeMessages(1);
                        mHandler.sendEmptyMessageDelayed(1, 5000);
                        //MLog.d("sortvo:" + sortVo.col + " " + sortVo.sortType);
                        return;
                    }
                }

                if (pos > 0 && col == 0)
                {
                    MarkerTickerVo vo = (MarkerTickerVo)mAdapter.getData().get(pos - 1);

                    Intent i = new Intent();
                    i.setClass(getApplication(), KLineActivity.class);
                    i.putExtra(Config.TYPE_EXCHANGENAME, vo.exchangeName);
                    i.putExtra(Config.TYPE_SYMBOL, vo.symbol);
                    i.putExtra(Config.TYPE_SWAP, "SWAP");
                    i.putExtra(Config.TYPE_BASECOIN, vo.baseCoin);
                    Global.showActivity(OIChgActivity.this, i);
                }
            }
        });

        //loadData();
    }

    public boolean isbPause() {
        return bPause;
    }

    public void setbPause(boolean bPause) {
        this.bPause = bPause;
        if (mHandler == null) return;
        if (bPause)
        {

            mHandler.removeMessages(1);
        }
        else
        {
            mHandler.sendEmptyMessageDelayed(1, 5000);
        }
    }

    private Handler mHandler;
    private boolean bPause = false;
    private void tickPro()
    {
        mHandler = new Handler(new Handler.Callback() {
            @Override
            public boolean handleMessage(Message msg) {
                if (msg.what == 0)
                {
                    mRefreshLayout.autoRefresh();
                    return false;
                }

                if (!bPause)
                {
                    loadData();
                    mHandler.sendEmptyMessageDelayed(1, 5000);
                }

                return false;
            }
        });

        //mHandler.sendEmptyMessageDelayed(1, 5000);
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

    }
}
