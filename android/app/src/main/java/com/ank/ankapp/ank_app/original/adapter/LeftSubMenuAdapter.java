package com.ank.ankapp.ank_app.original.adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.ank_app.original.bean.NavMenuBean;
import com.ank.ankapp.ank_app.original.callback.OnExpandListViewClickListener;
import com.ank.ankapp.ank_app.original.utils.MLog;
import com.ruffian.library.widget.RTextView;

import java.util.List;

public class LeftSubMenuAdapter extends BaseExpandableListAdapter {

    private List<NavMenuBean> data;
    private Context context;
    private OnExpandListViewClickListener listener;

    public void setListener(OnExpandListViewClickListener listener)
    {
        this.listener = listener;
    }

    public LeftSubMenuAdapter(List<NavMenuBean> data, Context context) {
        this.data = data;
        this.context = context;
    }

    public List<NavMenuBean> getData() {
        return data;
    }

    public void setData(List<NavMenuBean> data)
    {
        this.data = data;
    }

    @Override
    public int getGroupCount() {
        if (data == null)
            return 0;

        return data.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        if (data == null || data.get(groupPosition) == null)
            return 0;

        NavMenuBean navMenuBean = data.get(groupPosition);
        if (navMenuBean.subs == null || navMenuBean.subs.size() <= 0)
            return 0;

        return navMenuBean.subs.size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return data.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        NavMenuBean navMenuBean = data.get(groupPosition);
        return navMenuBean.subs.get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return groupPosition*10000+childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(
                    R.layout.nav_menu_group, null);
            holder = new ViewHolder();
            holder.tv_menu = (RTextView) convertView
                    .findViewById(R.id.tv_menu);
            holder.tv_more = (TextView) convertView
                    .findViewById(R.id.tv_more);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }


        NavMenuBean group = data.get(groupPosition);
        holder.tv_menu.setText(group.title);
        if (isExpanded)
        {
            holder.tv_menu.setTextColor(convertView.getContext().getResources().
                    getColor(R.color.colorAccent));
        }
        else
        {
            holder.tv_menu.setTextColor(convertView.getContext().getResources().
                    getColor(R.color.blackgray));
        }

        NavMenuBean navMenuBean = data.get(groupPosition);
        if (navMenuBean.subs == null || navMenuBean.subs.size() <= 0)
        {
            holder.tv_more.setVisibility(View.GONE);
            convertView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    MLog.d("groupPosition:" + groupPosition);
                    if (listener != null)
                        listener.onClick(groupPosition, -1, navMenuBean.path);
                }
            });
        }
        else
        {
            holder.tv_more.setVisibility(View.VISIBLE);
        }


        return convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(
                    R.layout.nav_menu_child, null);
            holder = new ViewHolder();
            holder.tv_menu = (RTextView) convertView
                    .findViewById(R.id.tv_menu);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        NavMenuBean group = data.get(groupPosition);
        NavMenuBean subMenu = group.subs.get(childPosition);
        holder.tv_menu.setText(subMenu.title);

        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null)
                    listener.onClick(groupPosition, childPosition, subMenu.path);
            }
        });

        return convertView;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }

    private final class ViewHolder{
        public RTextView tv_menu;
        public TextView tv_more;
    }

}
