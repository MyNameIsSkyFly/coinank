package com.ank.ankapp.original.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.bean.SymbolVo;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.utils.MLog;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.ArrayList;
import java.util.List;

public class FloatViewAdapter extends BaseAdapter {

    private List<SymbolVo> data;
    private final Context context;

    public FloatViewAdapter(List<SymbolVo> data, Context context) {
        this.data = data;
        this.context = context;
    }

    public void setData(List<SymbolVo> data)
    {
        if (this.data != null)
        {
            this.data.clear();
            this.data = null;
            this.data = data;
        }
    }

    @Override
    public int getCount() {
        if (data == null)
            return 0;
        return data.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    private void saveSelSymbolInfo()
    {
        List<SymbolVo> symbols = new ArrayList<>();
        int size = data.size();
        for (int i = 0; i < size; i++)
        {
            if (data.get(i).isbSel())
            {
                symbols.add(data.get(i));
            }
        }

        Gson gson = new GsonBuilder().create();
        String s = gson.toJson(symbols);
        MLog.d("sel symbols:" + s);
        Config.getMMKV(context).putString(Config.FLOAT_VIEW_TICKERS_JSON, s);
    }

    @Override
    public View getView(int position, View view, ViewGroup parent) {
        ViewHolder viewHolder = null;

        if (view == null){
            viewHolder = new ViewHolder();
            view = LayoutInflater.from(context).inflate(R.layout.lv_ticker_item, parent,false);
            viewHolder.tv_symbol = view.findViewById(R.id.tv_symbol);
            viewHolder.tv_symbol_ext_info = view.findViewById(R.id.tv_symbol_ext_info);
            viewHolder.tv_exchange = view.findViewById(R.id.tv_exchange);
            viewHolder.iv_delete = view.findViewById(R.id.iv_delete);
            view.setTag(viewHolder);
        }else {
            viewHolder = (ViewHolder) view.getTag();
        }

        viewHolder.tv_symbol.setText(data.get(position).getSymbol());
        viewHolder.tv_symbol_ext_info.setText(LanguageUtil.
                getSwapString(context, data.get(position).getDeliveryType()));
        viewHolder.tv_exchange.setText(data.get(position).getExchangeName());
        viewHolder.iv_delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (position >= data.size()) return;
                data.remove(position);
                notifyDataSetChanged();
                saveSelSymbolInfo();

                Global.notifyMsg(context, 1);
            }
        });

        return view;
    }

    private final class ViewHolder{
        TextView tv_symbol;
        TextView tv_symbol_ext_info;
        TextView tv_exchange;
        ImageView iv_delete;
    }

}
