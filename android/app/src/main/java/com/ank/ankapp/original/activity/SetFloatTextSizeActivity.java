package com.ank.ankapp.original.activity;

import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;


import androidx.annotation.RequiresApi;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;

public class SetFloatTextSizeActivity extends BaseActivity implements View.OnClickListener {

    protected RelativeLayout rl_small,rl_middle, rl_large;
    protected ImageView iv_small,iv_middle, iv_large;
    protected TextView tv01,tv_04,  tv02, tv03, tv_ko;
    private final RelativeLayout[] languageArr = {rl_small,rl_middle, rl_large};
    private final ImageView[] ivCkboxArr = {iv_small, iv_middle, iv_large};

    private final int[] resid = {R.id.rl_small,R.id.rl_middle, R.id.rl_large};
    private final int[] ivResid = {R.id.iv_small, R.id.iv_middle, R.id.iv_large};

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_set_float_text_size);

        int textSizeIdx = Config.getMMKV(this).getInt(Config.CONF_FLOATING_TEXT_SIZE, 0);
        for(int i = 0; i < languageArr.length; i++)
        {
            ivCkboxArr[i] = this.findViewById(ivResid[i]);
            languageArr[i] = this.findViewById(resid[i]);
            languageArr[i].setOnClickListener(this);

            if(textSizeIdx == i)
            {
                ivCkboxArr[i].setVisibility(View.VISIBLE);
            }
        }

        initToolBar();
    }

    void hideAllCkbox()
    {
        for(int i = 0; i < languageArr.length; i++)
        {
            ivCkboxArr[i].setVisibility(View.GONE);
        }
    }

    @Override
    public void onClick(View v) {
        for (int i = 0; i < languageArr.length; i++)
        {
            if(v.getId() == resid[i])
            {
                hideAllCkbox();
                Config.getMMKV(this).putInt(Config.CONF_FLOATING_TEXT_SIZE, i);
                ivCkboxArr[i].setVisibility(View.VISIBLE);
                Global.notifyMsg(this, 4);
                break;
            }
        }
    }

}
