package com.ank.ankapp.original.activity;

import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.SeekBar;

import androidx.annotation.RequiresApi;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.utils.MLog;


public class SetFloatingBgAlphaActivity extends BaseActivity implements View.OnClickListener {

    protected SeekBar seekbar;


    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_set_float_bg_alpha);
        initToolBar();
        seekbar = this.findViewById(R.id.seekbar);
        int iAlpha = Config.getMMKV(this).getInt(Config.CONF_FLOATING_BG_ALPHA, 0xaf);
        seekbar.setProgress(iAlpha);

        seekbar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                MLog.d("onProgressChanged:" + seekBar.getProgress() + " " + progress);
                Config.getMMKV(getApplicationContext()).putInt(Config.CONF_FLOATING_BG_ALPHA, progress);
                Global.notifyMsg(getApplicationContext(), 5);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                MLog.d(" onStopTrackingTouch:" + seekBar.getProgress());
                Config.getMMKV(getApplicationContext()).putInt(Config.CONF_FLOATING_BG_ALPHA, seekBar.getProgress());
                Global.notifyMsg(getApplicationContext(), 5);
            }
        });
    }


    @Override
    public void onClick(View v) {
    }
}
