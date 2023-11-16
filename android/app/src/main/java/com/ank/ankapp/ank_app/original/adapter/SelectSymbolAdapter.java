package com.ank.ankapp.ank_app.original.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.bean.SymbolVo;
import com.ank.ankapp.ank_app.original.language.LanguageUtil;

import java.util.List;


public class SelectSymbolAdapter extends BaseAdapter {

    private List<SymbolVo> data;
    private Context context;
    private int type = 0;//0正常，1为K线界面交易对列表

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public SelectSymbolAdapter(List<SymbolVo> data, Context context) {
        this.data = data;
        this.context = context;
    }

    public List<SymbolVo> getData() {
        return data;
    }

    public void setData(List<SymbolVo> data)
    {
        this.data = data;
    }

    @Override
    public int getCount() {
        if (data == null)
            return 0;
        return data.size();
    }

    @Override
    public Object getItem(int position) {
        if (data == null) return null;
        return data.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View view, ViewGroup parent) {
        ViewHolder viewHolder = null;

        if (view == null){
            viewHolder = new ViewHolder();
            view = LayoutInflater.from(context).inflate(R.layout.lv_select_symbol_item, parent,false);
            viewHolder.tv_symbol = view.findViewById(R.id.tv_symbol);
            viewHolder.tv_symbol_ext_info = view.findViewById(R.id.tv_symbol_ext_info);
            viewHolder.tv_exchange = view.findViewById(R.id.tv_exchange);
            viewHolder.iv_cksel = view.findViewById(R.id.iv_cksel);
            view.setTag(viewHolder);
        }else {
            viewHolder = (ViewHolder) view.getTag();
        }

        viewHolder.tv_symbol.setText(data.get(position).getSymbol());

        viewHolder.tv_symbol_ext_info.setText(LanguageUtil.
                getSwapString(context, data.get(position).getDeliveryType()));
        viewHolder.tv_exchange.setText(data.get(position).getExchangeName());

        if (type == 1)
        {
            if (data.get(position).isbSel())
            {
                viewHolder.iv_cksel.setImageResource(R.drawable.favorite_sel);
            }
            else if (Config.isNightMode)
            {
                viewHolder.iv_cksel.setImageResource(R.drawable.favorite_night);
            }
            else
            {
                viewHolder.iv_cksel.setImageResource(R.drawable.favorite_light);
            }

            viewHolder.iv_cksel.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (listener != null)
                    {
                        if (data.get(position).isbSel())
                        {
                            ((ImageView)v).setImageResource(R.drawable.favorite_sel);
                        }
                        else if (Config.isNightMode)
                        {
                            ((ImageView)v).setImageResource(R.drawable.favorite_night);
                        }
                        else
                        {
                            ((ImageView)v).setImageResource(R.drawable.favorite_light);
                        }
                        listener.doFavoriteClick(position, v);
                    }
                }
            });
        }
        else
        {
            if (data.get(position).isbSel())
            {
                viewHolder.iv_cksel.setVisibility(View.VISIBLE);
            }
            else
            {
                viewHolder.iv_cksel.setVisibility(View.GONE);
            }

            if (data.get(position).isbSel())
            {
                viewHolder.iv_cksel.setImageResource(R.drawable.favorite_sel);
            }
            else if (Config.isNightMode)
            {
                viewHolder.iv_cksel.setImageResource(R.drawable.favorite_night);
            }
            else
            {
                viewHolder.iv_cksel.setImageResource(R.drawable.favorite_light);
            }
        }

        return view;
    }


    private final class ViewHolder{
        TextView tv_symbol;
        TextView tv_symbol_ext_info;
        TextView tv_exchange;
        ImageView iv_cksel;
    }

    public OnFavoriteClick getListener() {
        return listener;
    }

    public void setListener(OnFavoriteClick listener) {
        this.listener = listener;
    }

    private OnFavoriteClick listener = null;
    public interface OnFavoriteClick {
        void doFavoriteClick(int i, View view);
    }

}
