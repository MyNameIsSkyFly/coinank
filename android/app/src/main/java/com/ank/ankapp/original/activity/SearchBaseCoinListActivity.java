package com.ank.ankapp.original.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.adapter.SearchCoinListAdapter;
import com.ank.ankapp.original.bean.JsonVo;
import com.ank.ankapp.original.utils.ListUtils;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.OkHttpUtil;
import com.ank.ankapp.original.widget.refresh.PullListView;
import com.ank.ankapp.original.widget.refresh.PullToRefreshLayout;
import com.ank.ankapp.original.widget.refresh.ResourceConfig;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.util.List;

public class SearchBaseCoinListActivity extends BaseActivity implements View.OnClickListener {

    private SearchCoinListAdapter<String> mAdapter;
    private PullToRefreshLayout mRefreshLayout;
    private PullListView mListView;
    private EditText et_search;

    private String currSymbol = "";//表示所有

    protected JsonVo<List<String>> mData = new JsonVo();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search_basecoins);
        OkHttpUtil.initOkHttp();
        initToolBar();
        initView();
    }

    private void initView()
    {
        et_search = (EditText)findViewById(R.id.et_search);
        et_search.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                currSymbol = s.toString();
                MLog.d("search token:" + currSymbol);
                setAdapterExchangeSymbol();
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        mListView = (PullListView) this.findViewById(R.id.lv_floatview_ticker);
        mListView.setPullUpEnable(false);
        mListView.setPullDownEnable(false);
        mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String vo = (String)mAdapter.getItem(position);
                MLog.d("click:" + vo);

                Intent i = new Intent();
                i.putExtra("coin", vo);
                setResult(RESULT_OK, i);
                SearchBaseCoinListActivity.this.finish();
            }
        });

        ResourceConfig resourceConfig = new ResourceConfig() {

            @Override
            public int[] configImageResIds() {
                return null;
            }

            @Override
            public int[] configTextResIds() {
                return new int[]{R.string.pull_to_refresh, R.string.release_to_refresh, R.string.refreshing,
                        R.string.refresh_succeeded, R.string.refresh_failed, R.string.pull_up_to_load,
                        R.string.release_to_load, R.string.loading, R.string.load_succeeded,
                        R.string.load_failed};
            }
        };

        mRefreshLayout = (PullToRefreshLayout) this.findViewById(R.id.pullToRefreshLayout);
        mRefreshLayout.setResourceConfig(resourceConfig);
        mRefreshLayout.setOnRefreshListener(new PullToRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh(PullToRefreshLayout pullToRefreshLayout) {
                loadData();//tickers
            }

            @Override
            public void onLoadMore(PullToRefreshLayout pullToRefreshLayout) {
            }
        });

        initData();
    }


    private void initData()
    {
        mAdapter = new SearchCoinListAdapter<>(null, this);
        mListView.setAdapter(mAdapter);
        loadLocalData();
    }

    private void setAdapterExchangeSymbol()
    {
        if (mData.getData() == null ||
                mData.getData().size() <= 0)
        {
            return;
        }

        List<String> list;
        list = ListUtils.filterListString(mData.getData(), currSymbol);
        mAdapter.setData(list);
        mAdapter.notifyDataSetChanged();
        if (list.size() > 0)
        {
            mListView.setSelection(0);
        }
    }

    private void loadLocalData()
    {
        String json = Config.getMMKV(getApplicationContext()).
                getString(Config.CONF_BASE_COINS, "");
        if (TextUtils.isEmpty(json)) return;

        if(mData != null)
        {
            if (mData.getData()!= null && mData.getData() != null)
                mData.getData().clear();

            mData = null;
        }

        Gson gson = new GsonBuilder().create();
        mData = gson.fromJson(json, new TypeToken<JsonVo<List<String>>>() {}.getType());
        MLog.d("data size:" + mData.getData().size());
        mAdapter.setData(mData.getData());
        setAdapterExchangeSymbol();
    }

    private void loadData()
    {
    }

    @Override
    public void onClick(View v) {
    }

}
