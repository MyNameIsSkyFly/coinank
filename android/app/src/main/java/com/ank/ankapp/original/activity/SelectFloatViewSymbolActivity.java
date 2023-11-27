package com.ank.ankapp.original.activity;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

import androidx.core.content.ContextCompat;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.adapter.SelectSymbolAdapter;
import com.ank.ankapp.original.bean.ResponseSymbolVo;
import com.ank.ankapp.original.bean.SymbolVo;
import com.ank.ankapp.original.utils.ListUtils;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.OkHttpUtil;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class SelectFloatViewSymbolActivity extends BaseActivity implements View.OnClickListener {

    protected ResponseSymbolVo mData = new ResponseSymbolVo();
    protected SelectSymbolAdapter mAdapter;
    protected ListView mListView;
    private List<String> listExchangeName = new ArrayList<>();
    private EditText et_search;

    private RadioButton rb_all, rb_binance, rb_okx, rb_ftx, rb_bitget, rb_bybit, rb_bitmex, rb_gate, rb_kraken, rb_huobi;
    private RadioButton []rBtns = new RadioButton[]{rb_all, rb_binance, rb_okx, rb_ftx, rb_bitget, rb_bybit, rb_bitmex, rb_gate, rb_kraken, rb_huobi};
    private int []res_id = new int[]{R.id.rb_all, R.id.rb_binance, R.id.rb_okx, R.id.rb_ftx, R.id.rb_bitget, R.id.rb_bybit,
            R.id.rb_bitmex, R.id.rb_gate, R.id.rb_kraken, R.id.rb_huobi};

    private RadioGroup main_exchange;
    private String currFilterExchangeName = "";
    private String currSymbol = "";//表示所有

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_floatview_symbol);
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
                setAdapterExchangeSymbol();
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        main_exchange = (RadioGroup)findViewById(R.id.main_exchange);
        int len = res_id.length;
        for (int i = 0; i < len; i++)
        {
            rBtns[i] = (RadioButton)findViewById(res_id[i]);
        }

        changeRbColor(R.id.rb_all);

        main_exchange.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                changeRbColor(checkedId);
                currFilterExchangeName = ((RadioButton)findViewById(checkedId)).getText().toString();
                MLog.d("exchangename:" + currFilterExchangeName);
                if (currFilterExchangeName.equalsIgnoreCase("Okx"))
                {
                    currFilterExchangeName = "Okex";
                }
                else if (currFilterExchangeName.equalsIgnoreCase(getResources().getString(R.string.s_all)))
                {
                    currFilterExchangeName = "";
                }

                setAdapterExchangeSymbol();
            }
        });

        mListView = (ListView) this.findViewById(R.id.lv_floatview_ticker);
        mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                if (mAdapter.getData().get(position).isbSel())
                {
                    mAdapter.getData().get(position).setbSel(false);
                }
                else
                {
                    int cnt = 0;
                    int size = mData.getData().size();
                    for (int i = 0; i < size; i++)
                    {
                        if (mData.getData().get(i).isbSel())
                        {
                            cnt++;
                            if (cnt >= 6)
                            {
                                Toast.makeText(getApplicationContext(), getResources().getString(R.string.s_add_up_6), Toast.LENGTH_SHORT).show();
                                return;
                            }
                        }
                    }

                    mAdapter.getData().get(position).setbSel(true);
                }

                mAdapter.notifyDataSetChanged();
                saveSelSymbolInfo();
                Global.notifyMsg(SelectFloatViewSymbolActivity.this, 1);
            }
        });

        initData();
    }

    private void changeRbColor(int checkId)
    {
        int len = rBtns.length;
        for (int i = 0; i < len; i++)
        {
            if (checkId == rBtns[i].getId())
            {
                rBtns[i].setTextColor(ContextCompat.getColor(this, R.color.blue_color));
            }
            else
            {
                rBtns[i].setTextColor(ContextCompat.getColor(this, R.color.blackgray));
            }
        }
    }

    private void saveSelSymbolInfo()
    {
        List<SymbolVo> symbols = new ArrayList<>();
        int cnt = 0;
        int size = mData.getData().size();
        for (int i = 0; i < size; i++)
        {
            if (mData.getData().get(i).isbSel())
            {
                symbols.add(mData.getData().get(i));
                cnt++;
                if (cnt >= 6)  break;
            }
        }

        Gson gson = new GsonBuilder().create();
        String s = gson.toJson(symbols);
        MLog.d("sel symbols:" + s);
        Config.getMMKV(getApplicationContext()).putString(Config.FLOAT_VIEW_TICKERS_JSON, s);
    }

    private void initData()
    {
        mAdapter = new SelectSymbolAdapter(mData.getData(), SelectFloatViewSymbolActivity.this);
        mListView.setAdapter(mAdapter);
        loadData();
    }

    private void setAdapterExchangeSymbol()
    {
        List<SymbolVo> list;
        list = ListUtils.filter(mData.getData(), currFilterExchangeName, currSymbol);
        mAdapter.setData(list);
        mAdapter.notifyDataSetChanged();
        if (list.size() > 0)
        {
            mListView.setSelection(0);
        }
    }

    private List<String> getAllExchangeName()
    {
        if (listExchangeName.size() == 0)
        {
            listExchangeName.add("Binance");
            listExchangeName.add("Okex");
            listExchangeName.add("FTX");
            listExchangeName.add("Bitget");
            listExchangeName.add("Gate");
            listExchangeName.add("Bitmex");
            listExchangeName.add("Huobi");
        }

        return listExchangeName;
    }

    private void initSelStatus()
    {
        if (mData == null) return;
        HashMap<String, Integer> map = new HashMap<>();
        String json = Config.getMMKV(this).getString(Config.FLOAT_VIEW_TICKERS_JSON, "");
        Gson gson = new GsonBuilder().create();
        List<SymbolVo> list = gson.fromJson(json, new TypeToken<List<SymbolVo>>() {}.getType());
        //把本地配置保存到map里面
        if (list != null)
        {
            for (int i = 0; i < list.size(); i++)
            {
                map.put(list.get(i).getKey(), i);
            }
        }

        HashMap<String, SymbolVo> mapData = new HashMap<>();
        for (int i = 0; i < mData.getData().size(); i++)
        {
            //mapData.put(mData.getData().get(i).getKey(), mData.getData().get(i));
        }

        //过滤重复的
        //mData.getData().clear();
        for(String key : mapData.keySet()) {
            //mData.getData().add(mapData.get(key));
        }

        //根据本地配置map，显示是否已经是添加到悬浮窗
        for (int i = 0; i < mData.getData().size(); i++)
        {
            if (map.containsKey(mData.getData().get(i).getKey()))
            {
                mData.getData().get(i).setbSel(true);
                //MLog.d("key sel true:" + mData.getData().get(i).toString());
            }
        }
    }

    private void loadData()
    {
        OkHttpUtil.initOkHttp();
        OkHttpUtil.getJSON(Config.apiGetAllSymbol, new OkHttpUtil.OnDataListener() {
            @Override
            public void onResponse(String url, Object obj,String json) {
                if (TextUtils.isEmpty(json)) return;

                if(mData != null)
                {
                    mData.getData().clear();
                    mData = null;
                }

                Gson gson = new GsonBuilder().create();
                mData = gson.fromJson(json, new TypeToken<ResponseSymbolVo>() {}.getType());
                //MLog.d("get symbols:" + mData.getData().size());
                initSelStatus();
                setAdapterExchangeSymbol();
            }

            @Override
            public void onFailure(String url, String error) {

            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId())
        {
            case R.id.rl_add_market:
                break;
        }
    }

}
