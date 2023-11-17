package com.ank.ankapp.ank_app.original.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.bean.MarkerTickerVo;
import com.ank.ankapp.ank_app.original.bean.SortVo;
import com.ank.ankapp.ank_app.original.language.LanguageUtil;
import com.ank.ankapp.ank_app.original.utils.AppUtils;
import com.kelin.scrollablepanel.library.PanelAdapter;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.ArrayList;
import java.util.List;

import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

/**
 * Created by kelin on 16-11-25.
 */

public class OIChgScrollAdapter extends PanelAdapter {
    private static final int TOP_LEFT_TITLE_TYPE = 4;
    private static final int FIRST_COL_TYPE = 0;
    private static final int ROW_CONTENT_TYPE = 1;
    private static final int TITLE_WITH_SORT_TYPE = 2;
    private static final int TITLE_EMPTY = 80;
    private static final int ROW_EMPTY = 90;


    private  List<MarkerTickerVo> data = new ArrayList<>();
    private  List<String> titleList = new ArrayList<>();
    private SortVo sortVo = new SortVo();
    private DisplayImageOptions options;

    public OIChgScrollAdapter()
    {

    }

    public OIChgScrollAdapter(Context cot, List<MarkerTickerVo> data)
    {
        this.data = data;
    }

    public OIChgScrollAdapter(Context cot, List<MarkerTickerVo> data, List<String> titleList)
    {
        this.data = data;
        this.titleList = titleList;

        options = new DisplayImageOptions.Builder()
                .showImageOnLoading(null)
                .showImageForEmptyUri(null)
                .showImageOnFail(null)
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .considerExifParams(true)
                .resetViewBeforeLoading(true)
                //.displayer(new CircleBitmapDisplayer(Color.WHITE, 5))
                .build();
    }

    public void setExtData(SortVo sortVo)
    {
        this.sortVo = sortVo;
    }

    public List<MarkerTickerVo> getData()
    {
        return data;
    }

    public void setData(List<MarkerTickerVo> data){
        this.data = data;
    }

    public void setTitleList(List<String> list)
    {
        this.titleList = list;
    }



    @Override
    public int getRowCount() {
        if (data == null)
            return 0;

        return data.size() + 1;
    }

    @Override
    public int getColumnCount() {
        if (data == null)
            return 0;
        return titleList.size();
    }

    @Override
    public int getItemViewType(int row, int column) {
        if (row == 0 && column == 1) return TITLE_EMPTY;
        if (row > 0 && column == 1) return ROW_EMPTY;

        if (row == 0 && column == 0) return TOP_LEFT_TITLE_TYPE;
        if (row == 0 && column >= 2) return TITLE_WITH_SORT_TYPE;
        if (row > 0 && column >= 2) return ROW_CONTENT_TYPE;
        if (row > 0 && column == 0) return FIRST_COL_TYPE;

        return -1;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int row, int column) {
        int viewType = getItemViewType(row, column);

        switch (viewType) {
            case ROW_EMPTY:
            case TITLE_EMPTY:
                //留空，解决左滑刷新回弹的问题
                break;
            case TOP_LEFT_TITLE_TYPE:
                setTopLeftTitle((TopLeftHolder)holder, row, column);
                break;
            case FIRST_COL_TYPE:
                setFirstColContent((FirstColHolder)holder, row, column);
                break;
            case ROW_CONTENT_TYPE:
                setRowContent((ContentHolder)holder, row, column);
                break;
            case TITLE_WITH_SORT_TYPE:
                setTitleWithSort((TitleWithSortHolder)holder, row, column);
                break;
            default:
                break;
        }
    }

    private void setTopLeftTitle(TopLeftHolder holder, int row, int col)
    {
        holder.tv_title.setText(titleList.get(col));
    }

    private void setRowContent(ContentHolder holder, int row, int col)
    {
        MarkerTickerVo vo = data.get(row - 1);
        if (col == 2)
        {
            holder.tv_content.setText(AppUtils.getFormatStringValue(vo.price));
            holder.tv_content.setTextColor(ContextCompat.getColor(
                    holder.tv_content.getContext(), R.color.black_white));

        }
        else if (col == 3)
        {
            String sLocal = LanguageUtil.getShortLanguageName(holder.itemView.getContext());
            String s = AppUtils.getFormatStringValue(vo.openInterest, 2);
            s = AppUtils.getLargeFormatString(s, sLocal);
            holder.tv_content.setText(s);
            holder.tv_content.setTextColor(ContextCompat.getColor(
                    holder.tv_content.getContext(), R.color.black_white));
        }
        else if (col == 4)
        {
            String sLocal = LanguageUtil.getShortLanguageName(holder.itemView.getContext());
            String s = AppUtils.getFormatStringValue(vo.openInterestCh1*100, 2) + "%";
            holder.tv_content.setText(s);
            if (vo.openInterestCh1 >= 0)
            {
                holder.tv_content.setTextColor(Config.greenColor);
            }
            else
            {
                holder.tv_content.setTextColor(Config.redColor);
            }
        }
        else if (col == 5)
        {
            String sLocal = LanguageUtil.getShortLanguageName(holder.itemView.getContext());
            String s = AppUtils.getFormatStringValue(vo.openInterestCh4*100, 2) + "%";
            holder.tv_content.setText(s);
            if (vo.openInterestCh4 >= 0)
            {
                holder.tv_content.setTextColor(Config.greenColor);
            }
            else
            {
                holder.tv_content.setTextColor(Config.redColor);
            }
        }
        else if (col == 6)
        {
            String sLocal = LanguageUtil.getShortLanguageName(holder.itemView.getContext());
            String s = AppUtils.getFormatStringValue(vo.openInterestCh24*100, 2) + "%";
            holder.tv_content.setText(s);
            if (vo.openInterestCh24 >= 0)
            {
                holder.tv_content.setTextColor(Config.greenColor);
            }
            else
            {
                holder.tv_content.setTextColor(Config.redColor);
            }
        }
        else
        {
            holder.tv_content.setText("");
        }
    }

    private void setTitleWithSort(TitleWithSortHolder holder, int row, int col)
    {
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (itemClickListener != null)
                {
                    itemClickListener.onClick(v, row, col);
                }
            }
        });

        holder.tv_title.setText(titleList.get(col));
        //第0行，处理排序状态
        if (row == 0 && col >= 2)
        {
            ImageView iv_sort = holder.iv_sort;
            if (sortVo.col == col)
            {
                if (sortVo.sortType == 0)
                {
                    iv_sort.setImageResource(R.drawable.sort_default);
                }
                else if (sortVo.sortType == 1)
                {
                    iv_sort.setImageResource(R.drawable.sort_asc_icon);
                }
                else if (sortVo.sortType == 2)
                {
                    iv_sort.setImageResource(R.drawable.sort_desc_icon);
                }
            }
            else
            {
                iv_sort.setImageResource(R.drawable.sort_default);
            }
        }
    }

    private void setFirstColContent(FirstColHolder holder, int row, int col)
    {
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (itemClickListener != null)
                {
                    itemClickListener.onClick(v, row, col);
                }
            }
        });

        //左边第一列需要显示交易所logo和交易对
        if (col == 0 && row > 0)
        {
            ImageLoader.getInstance().displayImage(data.get(row-1).coinImage, holder.iv_exchange, options);

            holder.tv_exchange.setText(data.get(row-1).baseCoin);
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        switch (viewType) {
            case TITLE_EMPTY:
                return new ContentHolder(LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_empty_col_title, parent, false));
            case ROW_EMPTY:
                return new ContentHolder(LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_empty_row_content, parent, false));
            case TOP_LEFT_TITLE_TYPE:
                return new TopLeftHolder(LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_top_left, parent, false));
            case FIRST_COL_TYPE:
                return new FirstColHolder(LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_chg_first_col, parent, false));
            case ROW_CONTENT_TYPE:
                return new ContentHolder(LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_row_content, parent, false));
            case TITLE_WITH_SORT_TYPE:
                return new TitleWithSortHolder(LayoutInflater.from(parent.getContext())
                        .inflate(R.layout.item_title_with_sort, parent, false));
            default:
                break;
        }

        return new TitleWithSortHolder(LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_title_with_sort, parent, false));

    }

    private static class TitleWithSortHolder extends RecyclerView.ViewHolder {
        public TextView tv_title;
        public ImageView iv_sort;

        public TitleWithSortHolder(View view) {
            super(view);
            this.tv_title = (TextView) view.findViewById(R.id.tv_title);
            this.iv_sort = (ImageView) view.findViewById(R.id.iv_sort);
        }
    }

    private static class FirstColHolder extends RecyclerView.ViewHolder {
        public TextView tv_exchange;
        public ImageView iv_exchange;

        public FirstColHolder(View view) {
            super(view);
            this.tv_exchange = (TextView) view.findViewById(R.id.tv_exchange);
            this.iv_exchange = (ImageView) view.findViewById(R.id.iv_exchange);
        }
    }

    private static class ContentHolder extends RecyclerView.ViewHolder {
        public TextView tv_content;

        public ContentHolder(View view) {
            super(view);
            this.tv_content = (TextView) view.findViewById(R.id.tv_content);
        }
    }

    private static class TopLeftHolder extends RecyclerView.ViewHolder {
        public TextView tv_title;

        public TopLeftHolder(View view) {
            super(view);
            this.tv_title = (TextView) view.findViewById(R.id.tv_title);
        }
    }

    public void setItemClickListener(OnItemClickListener listener)
    {
        itemClickListener = listener;
    };

    private OnItemClickListener itemClickListener;
    public interface OnItemClickListener{
        void onClick(View v, int pos, int col);
    }
}
