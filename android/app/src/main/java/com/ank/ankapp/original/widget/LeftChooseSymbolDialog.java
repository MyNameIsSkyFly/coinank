package com.ank.ankapp.original.widget;

import android.app.Dialog;
import android.app.DialogFragment;
import android.app.FragmentManager;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.FragmentActivity;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.activity.KLineActivity;
import com.ank.ankapp.original.adapter.SelectSymbolAdapter;
import com.ank.ankapp.original.bean.ResponseSymbolVo;
import com.ank.ankapp.original.bean.SymbolVo;
import com.ank.ankapp.original.utils.ListUtils;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.OkHttpUtil;
import com.github.mikephil.charting.utils.Utils;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class LeftChooseSymbolDialog extends DialogFragment implements View.OnClickListener {

    protected ResponseSymbolVo mData = new ResponseSymbolVo();
    protected SelectSymbolAdapter mAdapter;
    protected ListView mListView;
    private List<String> listExchangeName = new ArrayList<>();
    private EditText et_search;

    private RadioButton rb_favorite, rb_all, rb_binance, rb_okx, rb_ftx, rb_bitget, rb_bybit, rb_bitmex, rb_gate, rb_kraken, rb_huobi;
    private RadioButton []rBtns = new RadioButton[]{rb_favorite, rb_all, rb_binance, rb_okx, rb_ftx, rb_bitget, rb_bybit, rb_bitmex, rb_gate, rb_kraken, rb_huobi};
    private int []res_id = new int[]{R.id.rb_favorite, R.id.rb_all, R.id.rb_binance, R.id.rb_okx, R.id.rb_ftx, R.id.rb_bitget, R.id.rb_bybit,
            R.id.rb_bitmex, R.id.rb_gate, R.id.rb_kraken, R.id.rb_huobi};

    private RadioGroup main_exchange;
    private String currFilterExchangeName = "";
    private String currSymbol = "";//表示所有
    private int tabIdx = 0;
    private int type = 0;

    public static LeftChooseSymbolDialog newInstance() {
        return new LeftChooseSymbolDialog();
    }

    //0为K线界面左侧菜单，1为多屏K线界面菜单
    public void setType(int type)
    {
        this.type = type;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        View contentView = inflater.inflate(R.layout.dialog_left, container, false);

        getDialog().setCanceledOnTouchOutside(true);//对话框外可取消
        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);//取消标题显示
        Window window = getDialog().getWindow();
        window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        window.setGravity(Gravity.LEFT|Gravity.TOP);

        window.setWindowAnimations(R.style.dlg_anim);

        // 设置宽度,未用到
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
        OkHttpUtil.initOkHttp();
        initView(view);
    }

    private void initView(View v)
    {
        et_search = (EditText)v.findViewById(R.id.et_search);
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

        main_exchange = (RadioGroup)v.findViewById(R.id.main_exchange);
        int len = res_id.length;
        for (int i = 0; i < len; i++)
        {
            rBtns[i] = (RadioButton)v.findViewById(res_id[i]);
        }

        tabIdx = Config.getMMKV(getActivity()).getInt(Config.CONF_FAVORITE_TAB_IDX, 1);
        currFilterExchangeName = ((RadioButton)v.findViewById(res_id[tabIdx])).getText().toString();
        MLog.d("exchangename:" + currFilterExchangeName);
        if (currFilterExchangeName.equalsIgnoreCase("Okx"))
        {
            currFilterExchangeName = "Okex";
        }
        else if (currFilterExchangeName.equalsIgnoreCase(getResources().getString(R.string.s_all)))
        {
            currFilterExchangeName = "";
        }

        changeRbColor(res_id[tabIdx]);

        main_exchange.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                changeRbColor(checkedId);
                for (int i = 0; i < res_id.length; i++)
                {
                    if (checkedId == res_id[i])
                    {
                        tabIdx = i;
                        break;
                    }
                }

                Config.getMMKV(getActivity()).putInt(Config.CONF_FAVORITE_TAB_IDX, tabIdx);
                currFilterExchangeName = ((RadioButton)v.findViewById(checkedId)).getText().toString();
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

        mListView = (ListView) v.findViewById(R.id.lv_floatview_ticker);
        mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                SymbolVo symbol = (SymbolVo) mAdapter.getItem(position);
                MLog.d("args:" + symbol.getSubscribeArgs());
                if (type == 0)
                {
                    Intent intent = new Intent(getActivity(), KLineActivity.class);
                    //intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.putExtra(Config.TYPE_EXCHANGENAME, symbol.getExchangeName());
                    intent.putExtra(Config.TYPE_SYMBOL, symbol.getSymbol());
                    intent.putExtra(Config.TYPE_TITLE, symbol.getSymbol());
                    intent.putExtra(Config.TYPE_BASECOIN, symbol.getBaseCoin());
                    intent.putExtra(Config.TYPE_SWAP, symbol.getDeliveryType());
                    Global.showActivity(getActivity(), intent);
                }
                else
                {
                    Bundle intent = new Bundle();
                    intent.putString(Config.TYPE_EXCHANGENAME, symbol.getExchangeName());
                    intent.putString(Config.TYPE_SYMBOL, symbol.getSymbol());
                    //intent.putString(Config.TYPE_TITLE, getResources().getString(R.string.app_name));
                    intent.putString(Config.TYPE_BASECOIN, symbol.getBaseCoin());
                    intent.putString(Config.TYPE_SWAP, symbol.getDeliveryType());

                    if (listener != null)
                        listener.openKlineChart(intent);
                }

                dismiss();
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
                rBtns[i].setTextColor(ContextCompat.getColor(getActivity(), R.color.blue_color));
            }
            else
            {
                rBtns[i].setTextColor(ContextCompat.getColor(getActivity(), R.color.blackgray));
            }
        }
    }

    List<SymbolVo> favoriteList = null;
    private void getFavoriteList()
    {
        String json = Config.getMMKV(getActivity()).getString(Config.CONF_KLINE_FAVORITE_SYMBOL, "");
        Gson gson = new GsonBuilder().create();

        if (favoriteList != null)
        {
            favoriteList.clear();
            favoriteList = null;
        }

        favoriteList = gson.fromJson(json, new TypeToken<List<SymbolVo>>() {}.getType());
        if (favoriteList == null) favoriteList = new ArrayList<>();
    }

    private void removeFavoriteSymbol(SymbolVo symbolVo)
    {
       if (favoriteList.contains(symbolVo))
       {
           favoriteList.remove(symbolVo);
           saveFavoriteList();
       }
    }

    private void addFavoriteSymbol(SymbolVo symbolVo)
    {
        if (!favoriteList.contains(symbolVo))
        {
            favoriteList.add(symbolVo);
            saveFavoriteList();
        }
    }

    private void saveFavoriteList()
    {
        Gson gson = new GsonBuilder().create();
        String s = gson.toJson(favoriteList);
        Config.getMMKV(getActivity()).putString(Config.CONF_KLINE_FAVORITE_SYMBOL, s);

        if (listener != null)
            listener.doEvent();
    }

    private void initSelStatus()
    {
        HashMap<String, Integer> map = new HashMap<>();
        //把本地配置保存到map里面
        if (favoriteList != null)
        {
            for (int i = 0; i < favoriteList.size(); i++)
            {
                map.put(favoriteList.get(i).getKey(), i);
            }
        }

        //根据本地配置map，显示是否已经是添加到悬浮窗
        for (int i = 0; i < mData.getData().size(); i++)
        {
            if (map.containsKey(mData.getData().get(i).getKey()))
            {
                mData.getData().get(i).setbSel(true);
            }
        }
    }

    private int getSymbolIdx(SymbolVo vo)
    {
        if (mData == null || mData.getData() == null) return -1;

        for (int i = 0; i < mData.getData().size(); i++)
        {
            if (mData.getData().get(i).getKey().equals(vo.getKey()))
            {
                return i;
            }
        }

        return -1;
    }

    private void initData()
    {
        getFavoriteList();//加载自选
        mAdapter = new SelectSymbolAdapter(mData.getData(), getActivity());
        mListView.setAdapter(mAdapter);
        mAdapter.setType(1);//K线界面symbol列表
        setAdapterExchangeSymbol();
        mAdapter.setListener(new SelectSymbolAdapter.OnFavoriteClick() {
            @Override
            public void doFavoriteClick(int i, View view) {
                if (favoriteList != null && mAdapter.getData().get(i).isbSel())
                {
                    SymbolVo vo = mAdapter.getData().get(i);

                    if (mData!= null && mData.getData() != null && mData.getData().contains(vo))
                    {
                        int idx = getSymbolIdx(vo);
                        mData.getData().get(idx).setbSel(false);
                    }

                    vo.setbSel(false);
                    removeFavoriteSymbol(vo);
                }
                else if (favoriteList != null && !mAdapter.getData().get(i).isbSel())
                {
                    SymbolVo vo = mAdapter.getData().get(i);

                    if (mData!= null && mData.getData() != null && mData.getData().contains(vo))
                    {
                        int idx = getSymbolIdx(vo);
                        mData.getData().get(idx).setbSel(true);
                    }

                    vo.setbSel(true);
                    addFavoriteSymbol(vo);
                }

                mAdapter.notifyDataSetChanged();
            }
        });

        loadData();
    }

    private void setAdapterExchangeSymbol()
    {
        //判断是否自选标签
        if (currFilterExchangeName.equals(getResources().getString(R.string.s_favorite)))
        {
            mAdapter.setData(favoriteList);
            mAdapter.notifyDataSetChanged();
            if (favoriteList.size() > 0)
            {
                mListView.setSelection(0);
            }
            return;
        }

        List<SymbolVo> list;
        list = ListUtils.filter(mData.getData(), currFilterExchangeName, currSymbol);
        mAdapter.setData(list);
        mAdapter.notifyDataSetChanged();
        if (list.size() > 0)
        {
            mListView.setSelection(0);
        }
    }

    private void loadData()
    {
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
                Config.getMMKV(getActivity()).putString(Config.CONF_ALL_SYMBOLS, json);
                initSelStatus();
                setAdapterExchangeSymbol();
            }

            @Override
            public void onFailure(String url, String error) {

            }
        });
    }

    public LeftChooseSymbolDialog show(FragmentActivity context) {
        return show(context.getFragmentManager());
    }

    public LeftChooseSymbolDialog show(FragmentManager manager) {
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

    public OnCallDone getListener() {
        return listener;
    }

    public void setListener(OnCallDone listener) {
        this.listener = listener;
    }

    private OnCallDone listener = null;
    public interface OnCallDone {
        void doEvent();
        void openKlineChart(Bundle bundle);
    }

}
