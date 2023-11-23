package com.ank.ankapp.original.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import com.ank.ankapp.ank_app.R;
import com.ruffian.library.widget.RRelativeLayout;
import com.ruffian.library.widget.RTextView;

import java.util.List;

public class SearchCoinListAdapter<T> extends BaseAdapter {

    private List<T> data;
    private Context context;

    public SearchCoinListAdapter(List<T> data, Context context) {
        this.data = data;
        this.context = context;
    }

    public List<T> getData() {
        return data;
    }

    public void setData(List<T> data)
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
            view = LayoutInflater.from(context).inflate(R.layout.lv_search_coin_item, parent,false);
            viewHolder.tv_symbol = view.findViewById(R.id.tv_symbol);
            viewHolder.rl_item = view.findViewById(R.id.rl_item);
            view.setTag(viewHolder);
        }else {
            viewHolder = (ViewHolder) view.getTag();
        }

        String s = (String)data.get(position);
        viewHolder.tv_symbol.setText(s);
        return view;
    }

    private final class ViewHolder{
        RTextView tv_symbol;
        RRelativeLayout rl_item;
    }

}
