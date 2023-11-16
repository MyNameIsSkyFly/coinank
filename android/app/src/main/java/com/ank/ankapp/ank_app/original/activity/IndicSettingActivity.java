package com.ank.ankapp.ank_app.original.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.Global;


public class IndicSettingActivity extends BaseActivity implements View.OnClickListener {

    protected RelativeLayout rl_ma, rl_boll, rl_ema, rl_kchart_height;
    protected RelativeLayout rl_macd, rl_kdj, rl_rsi;
    protected RadioGroup main_group, line_group;
    protected RadioButton rb_solid, rb_hollow;
    protected RadioButton rb_small, rb_middle, rb_large;
    private String cfg_prefix = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_indic_setting);
        cfg_prefix = getIntent().getStringExtra(Config.TYPE_CFG_PREFIX);
        if (cfg_prefix == null)
            cfg_prefix = "";
        initToolBar();
        initView();
    }

    private void initView()
    {
        line_group = (RadioGroup)findViewById(R.id.line_group);
        rb_small = (RadioButton)findViewById(R.id.rb_small);
        rb_middle = (RadioButton)findViewById(R.id.rb_middle);
        rb_large = (RadioButton)findViewById(R.id.rb_large);
        line_group.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                rb_small.setChecked(false);
                rb_middle.setChecked(false);
                rb_large.setChecked(false);
                RadioButton rb = (RadioButton)findViewById(checkedId);
                rb.setChecked(true);

                if (checkedId == R.id.rb_small)
                {
                    Config.getMMKV(getApplicationContext()).putFloat(Config.CONF_MA_LINE_WIDTH,
                            Config.line_width_small);
                }
                else if (checkedId == R.id.rb_middle)
                {
                    Config.getMMKV(getApplicationContext()).putFloat(Config.CONF_MA_LINE_WIDTH,
                            Config.line_width_middle);
                }
                else if (checkedId == R.id.rb_large)
                {
                    Config.getMMKV(getApplicationContext()).putFloat(Config.CONF_MA_LINE_WIDTH,
                            Config.line_width_large);
                }

                Global.broadcastMsg(IndicSettingActivity.this, Config.ACTION_CHANGE_MA_LINE_WIDTH_);
            }
        });

        float line_width = Config.getMMKV(this).getFloat(Config.CONF_MA_LINE_WIDTH, Config.line_width_small);
        if (line_width == Config.line_width_small)
        {
            rb_small.setChecked(true);
            rb_middle.setChecked(false);
            rb_large.setChecked(false);
        }
        else if (line_width == Config.line_width_middle)
        {
            rb_small.setChecked(false);
            rb_middle.setChecked(true);
            rb_large.setChecked(false);
        }
        else if (line_width == Config.line_width_large)
        {
            rb_small.setChecked(false);
            rb_middle.setChecked(false);
            rb_large.setChecked(true);
        }

        main_group = (RadioGroup)findViewById(R.id.main_group);
        rb_solid = (RadioButton)findViewById(R.id.rb_solid);
        rb_hollow = (RadioButton)findViewById(R.id.rb_hollow);
        main_group.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                rb_hollow.setChecked(false);
                rb_solid.setChecked(false);
                RadioButton rb = (RadioButton)findViewById(checkedId);
                rb.setChecked(true);

                if (checkedId == R.id.rb_solid)
                {
                    Config.getMMKV(getApplicationContext()).putInt(Config.CONF_UP_CANDLE_STYLE, 1);
                }
                else
                {
                    Config.getMMKV(getApplicationContext()).putInt(Config.CONF_UP_CANDLE_STYLE, 0);
                }

                Global.broadcastMsg(IndicSettingActivity.this, Config.ACTION_KLINE_CHANGE_KLINE_STYLE);
            }
        });

        int up_candle_style = Config.getMMKV(this).getInt(Config.CONF_UP_CANDLE_STYLE, 1);
        if (up_candle_style == 1)
        {
            rb_hollow.setChecked(false);
            rb_solid.setChecked(true);
        }
        else
        {
            rb_solid.setChecked(false);
            rb_hollow.setChecked(true);
        }

        rl_kchart_height = this.findViewById(R.id.rl_adjust_kchart_height);
        rl_kchart_height.setOnClickListener(this);

        rl_ma = this.findViewById(R.id.rl_ma);
        rl_ma.setOnClickListener(this);

        rl_boll = this.findViewById(R.id.rl_boll);
        rl_boll.setOnClickListener(this);

        rl_ema = this.findViewById(R.id.rl_ema);
        rl_ema.setOnClickListener(this);

        rl_macd = this.findViewById(R.id.rl_macd);
        rl_macd.setOnClickListener(this);

        rl_kdj = this.findViewById(R.id.rl_kdj);
        rl_kdj.setOnClickListener(this);

        rl_rsi = this.findViewById(R.id.rl_rsi);
        rl_rsi.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        Intent i = new Intent();
        i.putExtra(Config.TYPE_CFG_PREFIX, cfg_prefix);
        switch (v.getId())
        {
            case R.id.rl_adjust_kchart_height:
                rl_kchart_height.setEnabled(false);//不可用，防止多次點擊
                finish();
                Global.broadcastMsg(this, Config.ACTION_KLINE_ADJUST_HEIGHT + cfg_prefix);
                break;
            case R.id.rl_ma:
                i.setClass(this, CommonFragmentActivity.class);
                i.putExtra(Config.INDEX_TYPE, Config.INDEX_MA);
                i.putExtra(Config.TYPE_TITLE, "MA");
                Global.showActivity(this, i);
                break;
            case R.id.rl_ema:
                i.setClass(this, CommonFragmentActivity.class);
                i.putExtra(Config.INDEX_TYPE, Config.INDEX_EMA);
                i.putExtra(Config.TYPE_TITLE, "EMA");
                Global.showActivity(this, i);
                break;
            case R.id.rl_rsi:
                i.setClass(this, CommonFragmentActivity.class);
                i.putExtra(Config.INDEX_TYPE, Config.INDEX_RSI);
                i.putExtra(Config.TYPE_TITLE, "RSI");
                Global.showActivity(this, i);
                break;
            case R.id.rl_kdj:
                i.setClass(this, CommonFragmentActivity.class);
                i.putExtra(Config.INDEX_TYPE, Config.INDEX_KDJ);
                i.putExtra(Config.TYPE_TITLE, "KDJ");
                Global.showActivity(this, i);
                break;
            case R.id.rl_boll:
                i.setClass(this, CommonFragmentActivity.class);
                i.putExtra(Config.INDEX_TYPE, Config.INDEX_BOLL);
                i.putExtra(Config.TYPE_TITLE, "BOLL");
                Global.showActivity(this, i);
                break;
            case R.id.rl_macd:
                i.setClass(this, CommonFragmentActivity.class);
                i.putExtra(Config.INDEX_TYPE, Config.INDEX_MACD);
                i.putExtra(Config.TYPE_TITLE, "MACD");
                Global.showActivity(this, i);
                break;
        }
    }

}
