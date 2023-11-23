package com.ank.ankapp.original.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.core.content.ContextCompat;


import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.bean.LiquidationVo;
import com.ank.ankapp.original.bean.LongShortTakerBuySellVo;
import com.ank.ankapp.original.bean.OIVo;
import com.ank.ankapp.original.bean.OldHomePageFundingVo;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.utils.AppUtils;
import com.ank.ankapp.original.widget.MyProgressBar;

import java.util.List;

public class HomeAdapter<T> extends BaseAdapter {

    private List<T> data;
    private Context context;
    private int blackgray;
    private Object obj;

    public void setExtData(Object obj)
    {
        this.obj = obj;
    }

    public HomeAdapter(List<T> data, Context context) {
        this.data = data;
        this.context = context;

        blackgray = ContextCompat.getColor(context, R.color.blackgray);
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
        //return data.size() >= 6? 6:data.size();
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


        if (data.get(position) instanceof OIVo)
        {
            if (view == null){
                viewHolder = new ViewHolder();
                view = LayoutInflater.from(context).inflate(R.layout.lv_home_oi_item, parent,false);
                viewHolder.tv_01 = view.findViewById(R.id.tv_01);
                viewHolder.tv_02 = view.findViewById(R.id.tv_02);
                viewHolder.tv_03 = view.findViewById(R.id.tv_03);
                viewHolder.tv_021 = view.findViewById(R.id.tv_021);
                viewHolder.tv_04 = view.findViewById(R.id.tv_04);
                viewHolder.tv_progress = view.findViewById(R.id.tv_progress);
                viewHolder.iv_exchange = view.findViewById(R.id.iv_exchange);
                view.setTag(viewHolder);
            }else {
                viewHolder = (ViewHolder) view.getTag();
            }
        }
        else if (data.get(position) instanceof LongShortTakerBuySellVo)
        {
            if (view == null){
                viewHolder = new ViewHolder();
                view = LayoutInflater.from(context).inflate(R.layout.lv_home_longshort_item, parent,false);
                viewHolder.tv_01 = view.findViewById(R.id.tv_01);
                viewHolder.tv_progress = view.findViewById(R.id.tv_progress);
                viewHolder.tv_long_val = view.findViewById(R.id.tv_long_val);
                viewHolder.tv_short_val = view.findViewById(R.id.tv_short_val);
                viewHolder.iv_exchange = view.findViewById(R.id.iv_exchange);
                view.setTag(viewHolder);
            }else {
                viewHolder = (ViewHolder) view.getTag();
            }
        }
        else
        {
            if (view == null){
                viewHolder = new ViewHolder();
                view = LayoutInflater.from(context).inflate(R.layout.lv_home_item, parent,false);
                viewHolder.tv_01 = view.findViewById(R.id.tv_01);
                viewHolder.tv_02 = view.findViewById(R.id.tv_02);
                viewHolder.tv_03 = view.findViewById(R.id.tv_03);
                viewHolder.iv_exchange = view.findViewById(R.id.iv_exchange);
                view.setTag(viewHolder);
            }else {
                viewHolder = (ViewHolder) view.getTag();
            }
        }

        String sLocal = LanguageUtil.getShortLanguageName(context);

        if (data.get(position) instanceof  OIVo)
        {
            OIVo oivo = (OIVo)data.get(position);
            viewHolder.tv_01.setText(oivo.getExchangeName());
            viewHolder.tv_02.setText("$" + AppUtils.getLargeFormatString(AppUtils.getFormatStringValue(oivo.getCoinValue(),2), sLocal));
            viewHolder.tv_021.setText("≈" + AppUtils.getLargeFormatString(
                    AppUtils.getFormatStringValue(oivo.getCoinCount(),2), sLocal) + " " + String.valueOf(obj));

            viewHolder.tv_04.setText(AppUtils.getFormatStringValue(oivo.getRate()*100, 2) + "%");

            viewHolder.tv_progress.setBgColor(ContextCompat.getColor(context, R.color.oi_progressbar_bg_color));
            viewHolder.tv_progress.setProgressColor(ContextCompat.getColor(context, R.color.oi_progressbar_color));
            viewHolder.tv_progress.setMaxCount(100);
            viewHolder.tv_progress.setCurrentCount(oivo.getRate()*100);

            viewHolder.iv_exchange.setImageResource(
                    context.getResources().getIdentifier(oivo.getExchangeName().toLowerCase(), "drawable", context.getPackageName()));


            String s = AppUtils.getFormatStringValue(oivo.getChange24H()*100, 2);
            if (Float.valueOf(s) > 0)
            {
                viewHolder.tv_03.setTextColor(Config.greenColor);
            }
            else {
                viewHolder.tv_03.setTextColor(Config.redColor);
            }

            viewHolder.tv_03.setText(s + "%");
        }
        else if (data.get(position) instanceof LongShortTakerBuySellVo)
        {
            LongShortTakerBuySellVo longShortTakerBuySellVo = (LongShortTakerBuySellVo)data.get(position);
            viewHolder.tv_01.setText(longShortTakerBuySellVo.getExchangeName());
            viewHolder.tv_long_val.setText(AppUtils.getFormatStringValue(longShortTakerBuySellVo.getLongRatio()*100, 2) + "%");
            viewHolder.tv_short_val.setText(AppUtils.getFormatStringValue(longShortTakerBuySellVo.getShortRatio()*100, 2) + "%");

            viewHolder.tv_progress.setBgColor(Config.redColor);
            viewHolder.tv_progress.setProgressColor(Config.greenColor);
            viewHolder.tv_progress.setMaxCount(100);
            viewHolder.tv_progress.setCurrentCount(longShortTakerBuySellVo.getLongRatio()*100);

            viewHolder.iv_exchange.setImageResource(
                    context.getResources().getIdentifier(longShortTakerBuySellVo.getExchangeName().toLowerCase(),
                            "drawable", context.getPackageName()));

        }
        else if (data.get(position) instanceof OldHomePageFundingVo)
        {
            OldHomePageFundingVo oldHomePageFundingVo = (OldHomePageFundingVo)data.get(position);
            viewHolder.tv_01.setText(oldHomePageFundingVo.getExchangeName());
            viewHolder.iv_exchange.setImageResource(
                    context.getResources().getIdentifier(oldHomePageFundingVo.getExchangeName().toLowerCase(),
                            "drawable", context.getPackageName()));

            String s = AppUtils.getFormatStringValue(oldHomePageFundingVo.getUfundingRate()*100,4);
            viewHolder.tv_02.setText(s + "%");
            if (Float.valueOf(s) > 0.01F)
            {
                viewHolder.tv_02.setTextColor(Config.greenColor);
            }
            else if (Float.valueOf(s) < 0.01F){
                viewHolder.tv_02.setTextColor(Config.redColor);
            }
            else if (Float.valueOf(s) == 0.01F){
                viewHolder.tv_02.setTextColor(blackgray);
            }

            if (s.equals("0.0000")){
                viewHolder.tv_02.setTextColor(blackgray);
                viewHolder.tv_02.setText("--");
            }

            s = AppUtils.getFormatStringValue(oldHomePageFundingVo.getCfundingRate()*100, 4);
            viewHolder.tv_03.setText(s + "%");

            if (Float.valueOf(s) > 0.01F)
            {
                viewHolder.tv_03.setTextColor(Config.greenColor);
            }
            else if (Float.valueOf(s) < 0.01F){
                viewHolder.tv_03.setTextColor(Config.redColor);
            }
            else if (Float.valueOf(s) == 0.01F){
                viewHolder.tv_03.setTextColor(blackgray);
            }

            if (s.equals("0.0000")){
                viewHolder.tv_03.setTextColor(blackgray);
                viewHolder.tv_03.setText("--");
            }

        }
        else if (data.get(position) instanceof LiquidationVo)
        {
            LiquidationVo liquidationVo = (LiquidationVo)data.get(position);
            viewHolder.tv_01.setText("" + liquidationVo.getInterval());
            viewHolder.tv_02.setText("$" + AppUtils.getLargeFormatString(AppUtils.getFormatStringValue(liquidationVo.getTotalTurnover(),2), sLocal));
            String s = AppUtils.getFormatStringValue(
                    100*liquidationVo.getLongTurnover()/liquidationVo.getTotalTurnover(), 2);
            if (Float.valueOf(s) >= 50F)
            {
                viewHolder.tv_03.setTextColor(Config.greenColor);
            }
            else {
                viewHolder.tv_03.setTextColor(Config.redColor);
            }


            viewHolder.tv_03.setText(s  + "%");
        }

        return view;
    }

    private final class ViewHolder{
        TextView tv_01;
        TextView tv_02;
        TextView tv_03;

        TextView tv_long_val;
        TextView tv_short_val;

        MyProgressBar tv_progress;

        TextView tv_021, tv_04, tv_041;
        ImageView iv_exchange;
    }

}
