package com.ank.ankapp.original.activity;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.View;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.adapter.FloatViewAdapter;
import com.ank.ankapp.original.bean.ResponseSymbolVo;
import com.ank.ankapp.original.bean.SymbolVo;
import com.ank.ankapp.original.service.FloatViewService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.util.List;

public class SetFloatViewActivity extends BaseActivity implements View.OnClickListener {

    protected RelativeLayout rlDisplay, rlAddMarket, rlFloatViewLock, rl_text_size, rl_bg_alpha;
    protected ImageView ivToggleDisplay, ivFloatViewLock;
    protected ResponseSymbolVo mData = new ResponseSymbolVo();
    protected FloatViewAdapter mAdapter;
    protected ListView mListView;
    private boolean isFirst = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_floatview_setting);
        initToolBar();
        initView();
    }

    private void initView() {
        rl_bg_alpha = (RelativeLayout) this.findViewById(R.id.rl_bg_alpha);
        rl_bg_alpha.setOnClickListener(this);
        rl_text_size = (RelativeLayout) this.findViewById(R.id.rl_text_size);
        rl_text_size.setOnClickListener(this);
        rlDisplay = (RelativeLayout) this.findViewById(R.id.rl_floatview_display);
        rlDisplay.setOnClickListener(this);
        rlAddMarket = (RelativeLayout) this.findViewById(R.id.rl_add_market);
        rlAddMarket.setOnClickListener(this);
        rlFloatViewLock = (RelativeLayout) this.findViewById(R.id.rl_floatview_lock);
        rlFloatViewLock.setOnClickListener(this);

        ivFloatViewLock = (ImageView) this.findViewById(R.id.togle_floatview_lock);
        ivToggleDisplay = (ImageView) this.findViewById(R.id.toggle_display_floatview);
        setChecked(ivFloatViewLock,
                Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_LOCK, false));
        setChecked(ivToggleDisplay,
                Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_SHOW, false));

        mListView = (ListView) this.findViewById(R.id.lv_floatview_ticker);
        initData();
    }

    private void initData() {
        mAdapter = new FloatViewAdapter(mData.getData(), SetFloatViewActivity.this);
        mListView.setAdapter(mAdapter);
    }

    @Override
    protected void onResume() {
        super.onResume();
        String json = Config.getMMKV(this).getString(Config.FLOAT_VIEW_TICKERS_JSON, "");
        //MLog.d("json:" + json);
        Gson gson = new GsonBuilder().create();
        mAdapter.setData(gson.fromJson(json, new TypeToken<List<SymbolVo>>() {
        }.getType()));
        mAdapter.notifyDataSetChanged();
        //非首次resume, 发通知消息
        if (!isFirst) {
            Global.notifyMsg(this, 1);
        }

        if (isFirst) {
            isFirst = false;
        }
    }

    private void setChecked(ImageView v, boolean checked) {
        if (checked) {
            v.setImageResource(R.drawable.toggle_on);
        } else {
            v.setImageResource(R.drawable.toggle_off);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!Settings.canDrawOverlays(this)) {
                    Toast.makeText(this, R.string.s_auth_failure, Toast.LENGTH_SHORT).show();
                    return;
                }
            }

            {
                Toast.makeText(this, R.string.s_auth_success, Toast.LENGTH_SHORT).show();

                startFloating();
                setChecked(ivToggleDisplay,
                        Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_SHOW, false));
                startService(new Intent(SetFloatViewActivity.this, FloatViewService.class));
            }
        }
    }

    public void startFloating() {
        //MLog.d("startFloating startservice");

        if (Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_SHOW, false)) {
            Config.getMMKV(this).putBoolean(Config.IS_FLOAT_VIEW_SHOW, false);//hide
            Config.getMMKV(this).putBoolean(Config.CONF_STOP_STATUS, true);//
            stopService(new Intent(SetFloatViewActivity.this, FloatViewService.class));
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                Toast.makeText(this, R.string.s_auth_none, Toast.LENGTH_SHORT);
                startActivityForResult(new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + getPackageName())), 1);
                return;
            }
        }

        {
            Config.getMMKV(this).putBoolean(Config.IS_FLOAT_VIEW_SHOW, true);//show
            startService(new Intent(SetFloatViewActivity.this, FloatViewService.class));
        }
    }

    @Override
    public void onClick(View v) {
        Intent i;
        switch (v.getId()) {
            case R.id.rl_bg_alpha:
                i = new Intent(this, SetFloatingBgAlphaActivity.class);
                i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_bg_alpha));
                Global.showActivity(this, i);
                break;
            case R.id.rl_text_size:
                i = new Intent(this, SetFloatTextSizeActivity.class);
                i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_text_size));
                Global.showActivity(this, i);
                break;
            case R.id.rl_floatview_display:
                startFloating();
                setChecked(ivToggleDisplay,
                        Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_SHOW, false));
                break;
            case R.id.rl_add_market:
                i = new Intent(this, SelectFloatViewSymbolActivity.class);
                i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_add_market));
                Global.showActivity(this, i);
                break;
            case R.id.rl_floatview_lock:
                if (Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_LOCK, false)) {
                    Config.getMMKV(this).putBoolean(Config.IS_FLOAT_VIEW_LOCK, false);
                } else {
                    Config.getMMKV(this).putBoolean(Config.IS_FLOAT_VIEW_LOCK, true);
                }

                setChecked(ivFloatViewLock,
                        Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_LOCK, false));
                break;
        }
    }

}
