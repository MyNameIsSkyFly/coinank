package com.ank.ankapp.ank_app.original.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.ank_app.original.bean.BaseCoinVo;
import com.ruffian.library.widget.RRelativeLayout;
import com.ruffian.library.widget.RTextView;

import java.util.List;

public class ChooserBaseCoinAdapter<T> extends RecyclerView.Adapter<ChooserBaseCoinAdapter<T>.MyViewHolder> {

    private List<T> data;
    private Context context;

    public ChooserBaseCoinAdapter(List<T> data, Context context) {
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

    public Object getItem(int position) {
        if (data == null) return null;
        return data.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public int getItemCount() {
        if (data == null)
            return 0;
        return data.size();
    }

    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        View view = inflater.inflate(R.layout.lv_symbol_item, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MyViewHolder viewHolder, int position) {
        BaseCoinVo vo = (BaseCoinVo)data.get(position);
        viewHolder.tv_symbol.setText(vo.baseCoin);
        if (vo.isSel)
        {
            viewHolder.rl_item.setSelected(true);
        }
        else
        {
            viewHolder.rl_item.setSelected(false);
        }

        viewHolder.rl_item.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (itemClickListener != null)
                    itemClickListener.onClick(v, viewHolder.getBindingAdapterPosition());
            }
        });
    }

    public class MyViewHolder extends RecyclerView.ViewHolder {
        RTextView tv_symbol;
        RRelativeLayout rl_item;

        public MyViewHolder(View itemVieww) {
            super(itemVieww);
            tv_symbol = itemView.findViewById(R.id.tv_symbol);
            rl_item = itemView.findViewById(R.id.rl_item);
        }
    }

    public void setItemClickListener(OnItemClickListener listener)
    {
        itemClickListener = listener;
    };

    private OnItemClickListener itemClickListener;
    public interface OnItemClickListener{
        void onClick(View v, int pos);
    }

}
